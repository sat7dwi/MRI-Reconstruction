function [D, alphas] = Learn_D_and_alphas(Img)
    ind_nz = sum(Img,1)~=0;
    img = Img(:, ind_nz);
    N = 5000;
    indices = randperm(size(img,2), N);
    X = img(:, indices);
    
    delta = 36;
    indices = randperm(N, delta);
    D = img(:, indices);
    K = 5;

    param.L = K;   % number of elements in each linear combination.
    param.K = delta; % number of dictionary elements
    param.numIteration = 50; % number of iteration to execute the K-SVD algorithm.
    param.initialDictionary = D; %Initialise the Dictionary
    param.errorFlag = 0; % decompose signals until a certain error is reached. do not use fix number of coefficients.
    %param.errorGoal = sigma;
    param.preserveDCAtom = 0;

    %%%%%%%% initial dictionary: Dictionary elements %%%%%%%%
    param.InitializationMethod =  'GivenMatrix';
    param.displayProgress = 1;
    %[D,~]  = KSVD(X,param);
    alphas_nz = full(OMP(D,img, param.L));
    alphas = zeros(36, size(Img));
    alphas(:, ind_nz) = alphas_nz;
end