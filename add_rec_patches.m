% input: P_rec(reconstructed patches), width(width of image), 
% height(height of image), patchwidth(width of square patch)
% output: P(all the patches), width(width of image)

function x = add_rec_patches(P, h, w, pw, stride)
    x = zeros(h+pw,w+pw);
    n = zeros(h+pw,w+pw);
    
    w0 = floor((w-1)/stride)+1;
    
    for j = 1:size(P,2)
        r = floor((j-1)/w0)*stride + 1;
        c = mod((j-1), w0)*stride;        
        for i = 1:pw
            x(r:r+pw-1,c+i) = x(r:r+pw-1,c+i) + P((i-1)*pw+1:i*pw,j);
            n(r:r+pw-1,c+i) = n(r:r+pw-1,c+i) + 1;
        end
    end
    
    x(1:pw,:) = x(1:pw,:) + x(h+1:h+pw,:);
    n(1:pw,:) = n(1:pw,:) + n(h+1:h+pw,:);
    x(:,1:pw) = x(:,1:pw) + x(:,w+1:w+pw);
    n(:,1:pw) = n(:,1:pw) + n(:,w+1:w+pw);
    x = x(1:h, 1:w)./n(1:h, 1:w);
    
end
