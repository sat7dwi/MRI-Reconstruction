% input: x(real image), patchwidth(width of square patch)
% output: P(all the patches), width(width of image), height(height of image)

function [P, w, h] = create_patches(x_0, pw, stride)

   [h, w] = size(x_0);

    x_0 = [x_0; x_0(1:pw,:)];
	x_0 = [x_0 x_0(:, 1:pw)];

    P = [];
    
    for i = 1:stride:h
        for j = 1:stride:w
            tmp = x_0(i:i+pw-1, j:j+pw-1);
            P = [P tmp(:)];
        end
    end
    
end