function [D, alphas] = Learn_D_and_alphas(Img)
    
    img = Img(:, sum(Img,1)~=0);
    N = 5000;
    indices = randperm(size(img,2), N);
    X = img(:, indices);
    
    delta = 36;
    indices = randperm(N, delta);
    D = img(:, indices);
    K = 5;
    
    it = 0;
    while it < 10
        alphas = omp(D, X, K);
        E = X - D*alphas;
        disp(norm(E(:)));
        for i = 1 : delta
           E = X(:,(alphas(i,:)~=0)&((1:N)~=i)) - D(:,1:end~=i) * alphas(1:end~=i, (alphas(i,:)~=0)&((1:N)~=i));
           [U,S,V] = svd(E);
           D(:,i) = U(:,1);
           alphas(i, (alphas(i,:)~=0)&((1:N)~=i)) = S(1,1) * V(:,1)';
        end
        it = it + 1;
    end    
    alphas = omp(D, X, K);
end