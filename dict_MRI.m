%%%%%%%%% load the dataset %%%%%%%%%

load brain;
im_abs = abs(im);
W=Wavelet;

%%%%%%%%% Random UnderSampling: %%%%%%%%%%%

M = fft2c(im); %random uniform
Mu = (M.*mask_unif)./pdf_vardens;
imu = abs(ifft2c(Mu));

M = fft2c(im); %random vardens
Mv = (M.*mask_vardens)./pdf_vardens;
imv = abs(ifft2c(Mv));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here will be the dict algorithm 
% i/p : y (undersampled K-Space data) o/p: x (reconstructed image)

%initialisation
x0 = imu;
y0 = Mu;
x = x0;
nu = 100;

%iteration
for l=1:1:15
   %Create patches of size 6x6, (i,j)th patch will be Patch{(i-1)*Width + (j-1) + 1}
   P, width = create_patches(x);
   % Learn Dictionary and Sparse representations of patches for x
   D, alphamat = Learn_D_and_alphas(x,P);
   % Reconstruct patches using their alpha values
   P_rec = reconstructed_patches(D,P);
   % Create a new x (image) by adding all reconstructed patches 
   x_new = add_rec_patches(P_rec, width);
   % Take FFT and restore sample frequencies as given in question
   y = fft2c(x_new);
   y_new = restore_frequencies(nu,y0,y);
   % final reconstructed image
   x = ifft2c(y_new);
end

