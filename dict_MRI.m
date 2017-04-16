%%%%%%%%% load the dataset %%%%%%%%%

load brain;
im_abs = abs(im);
% W=Wavelet;

%%%%%%%%% Random UnderSampling: %%%%%%%%%%%

M = fft2c(im); %random uniform
Mu = (M.*mask_unif)./pdf_unif;
imu = abs(ifft2c(Mu));

M = fft2c(im); %random vardens
Mv = (M.*mask_vardens)./pdf_vardens;
imv = abs(ifft2c(Mv));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here will be the dict algorithm 
% i/p : y (undersampled K-Space data) o/p: x (reconstructed image)

%initialisation
x0 = imv;
y0 = Mv;
x = x0;
nu = 100;
patchwidth = 6;
stride = 3;
%iteration
for l=1:1:15
   %Create patches of size 6x6, (i,j)th patch will be Patch{(i-1)*Width + (j-1) + 1}
   x_real = abs(x);
   x_real = x_real / max(max(abs(x_real))) ; % normalize the image
   [X_real, width, height] = create_patches(x_real, patchwidth, stride);
   % Learn Dictionary and Sparse representations of patches for x
   [D, alphas] = Learn_D_and_alphas(X_real, patchwidth, stride);
   % Reconstruct patches using their alpha values
   P_rec = D*alphas;
   % Create a new x (image) by adding all reconstructed patches 
   x_new = add_rec_patches(P_rec, width, height, patchwidth, stride);
   x_new = x_new / max(max(abs(x_new))) ; % normalize the image
   % Take FFT and restore sample frequencies as given in question
   x_new_cplx = complex(x_new);
   y = fft2c(x_new_cplx);
   y_new = restore_frequencies(nu,y0,y);
   % final reconstructed image
   x = ifft2c(y_new);
   im_fin = abs(x) / max(max(abs(x)));
   ssim_u = ssim(im_fin, im_abs);
   rmse = sum(sum((im_fin-im_abs).^2))/512/512;
   %diff_v = sum(sum(abs(im_hat-im)))/10000;
   disp(strcat('ITR', num2str(l), '; ssim: ',num2str(ssim_u),' , rmse: ',num2str(rmse)));

   
end


