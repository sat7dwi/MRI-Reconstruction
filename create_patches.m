% input: x(real image), patchwidth(width of square patch)
% output: P(all the patches), width(width of image)

function [P, width] = create_patches(x_0, patchwidth)

    width = size(x_0,2);
    height = size(x_0,1);
    x = zeros(height+patchwidth, width+patchwidth);
    x(1:height,1:width) = x_0(1:height,1:width);
    for i=height+1:1:height+patchwidth
        x(i,:) = x(mod(i,height),:);
    end
    for j=width+1:1:width+patchwidth
        x(:,j) = x(:,mod(j,width));    
    end
    P = {};
    for i=1:1:height
        for j=1:1:width
            patch = x(i:i+patchwidth-1,j:j+patchwidth-1);
            P{(i-1)*width + (j-1) + 1} = patch;
        end
    end
    
end