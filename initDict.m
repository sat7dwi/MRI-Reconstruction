function D = initDict(img, d_sz)
    sz = size(img);
    D = zeros(sz(1), d_sz);
    
    l = 1 - 4/d_sz;
    idx = ones(1,sz(2));

    for i = 1:d_sz
        while 1
            k = randi([1 sz(2)],1,1);
            if idx(k) == 1
                break;
            end
        end
        cor = idx .* (img(:,k)'*img);            
        idx(cor > max(cor)*l) = 0;
        D(:,i) = img(:,k);
    end

end