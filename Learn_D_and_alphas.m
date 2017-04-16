function [D, alphas] = Learn_D_and_alphas(Img, patchwidth, stride)
    ind_nz = sum(Img,1)>0.001*patchwidth*patchwidth; %<10
    img = Img(:, ind_nz);
    N = 4000;
    indices = randperm(size(img,2), N);
    X = img(:, indices);
    
    delta = patchwidth*patchwidth*2;
    indices = randperm(N, delta);
    D = normc(img(:, indices)); %Normalize the Dictionary!
    
    K = floor(0.03*delta);

    param.L = 2;%K;   % number of elements in each linear combination.
    param.K = delta; % number of dictionary elements
    param.numIteration = 50; % number of iteration to execute the K-SVD algorithm.
    param.initialDictionary = D; %Initialise the Dictionary
    param.errorFlag = 0; % decompose signals until a certain error is reached. do not use fix number of coefficients.
    %param.errorGoal = sigma;
    param.preserveDCAtom = 0;

    %%%%%%%% initial dictionary: Dictionary elements %%%%%%%%
    param.InitializationMethod =  'GivenMatrix';
    param.displayProgress = 1;
    [D,~]  = KSVD(X,param);
    alphas_nz = full(OMP(D,img, param.L));
    alphas = zeros(delta, size(Img, 2));
    alphas(:, ind_nz) = alphas_nz;
end

% (9,3) (pw*pw*2, 2)
% ssims
% Columns 1 through 11
% 
%     0.4853    0.5322    0.5190    0.4859    0.5268    0.5065    0.5094    0.5175    0.5119    0.5143    0.5159
% 
%   Columns 12 through 15
% 
%     0.5117    0.5235    0.5032    0.5095
% rmse
% Columns 1 through 11
% 
%     0.0034    0.0021    0.0023    0.0035    0.0022    0.0027    0.0026    0.0024    0.0025    0.0024    0.0024
% 
%   Columns 12 through 15
% 
%     0.0025    0.0022    0.0028    0.0026
