function alphas = omp(dict, X, sparsity)

[var, obs] = size(dict);
alphas = zeros(obs, size(X,2));
for j = 1 : size(X,2)
    inputSig = X(:,j);
    sup = [];        %support
    res = inputSig;
    
    for i = 1 : sparsity
        [~, idx] = max(abs(res'*dict(:,1:obs)));
        sup(i) = idx;
        temp = (dict(:,sup)'*dict(:,sup));
        tmpdict = dict;
        while det(temp) == 0
            tmpdict(:, idx) = 0;
            if tmpdict == 0
                alphas(sup, j) = 0;
                break;
            end
            [~, idx] = max(abs(res'*tmpdict(:,1:obs)));
            sup(i) = idx;
            temp = (dict(:,sup)'*dict(:,sup));
        end
        if tmpdict == 0
            continue;
        end
        P = dict(:,sup)*(temp\dict(:,sup)');
        res = (eye(var) - P)*inputSig;
    end
    
    alphas(sup, j) = ((dict(:,sup)'*dict(:,sup))\dict(:,sup)') * inputSig;
    if sum(isnan(alphas(sup, j))) > 0
        alphas(sup, j) = 0;
    end        
end