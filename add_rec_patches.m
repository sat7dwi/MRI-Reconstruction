% input: P_rec(reconstructed patches), width(width of image), 
% height(height of image), patchwidth(width of square patch)
% output: P(all the patches), width(width of image)

function x = add_rec_patches(P_rec, width, height, patchwidth, stride)
    x_exp = zeros(height+patchwidth, width+patchwidth);
    x = zeros(height, width);
    for i=1:stride:height
        for j=1:stride:width
            patch = reshape(P_rec(:,floor(i/stride)*width + floor(j/stride) + 1),[patchwidth,patchwidth]);
           x_exp(i:i+patchwidth-1,j:j+patchwidth-1) = x_exp(i:i+patchwidth-1,j:j+patchwidth-1) + patch; 
        end
    end
    for i=height+1:1:height+patchwidth
        x_exp(mod(i,height),:) = x_exp(i,:) + x_exp(mod(i,height),:);
    end
    for j=width+1:1:width+patchwidth
        x_exp(:,mod(j,width)) = x_exp(:,j) + x_exp(:,mod(j,width));
    end
    x(1:height,1:width) = x_exp(1:height,1:width);
end
