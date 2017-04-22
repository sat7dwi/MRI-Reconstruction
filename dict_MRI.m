%%%%%%%%% load the dataset %%%%%%%%%

clear; close all;

load brain;
% load mask_8_5;
% load pdf_8_5;
% 
% mask_vardens = M2;
% pdf_vardens = pdf2;

im_abs = abs(im)/max(max(abs(im)));

% W=Wavelet;

%%%%%%%%% Random UnderSampling: %%%%%%%%%%%

M = fft2c(im); %random uniform
Mu = (M.*mask_unif)./pdf_unif;
imu = abs(ifft2c(Mu));

M = fft2c(im); %random vardens
y0 = (M.*mask_vardens);
Mv = y0 ./ pdf_vardens;
imv = ifft2c(Mv);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here will be the dict algorithm 
% i/p : y (undersampled K-Space data) o/p: x (reconstructed image)

%initialisation
x0 = imv;
% y0 = Mv;% .* pdf_vardens;
x = x0;
nu = 2000;
patchwidth = 6;
stride = 3;
ssims = [];
rmss = [];
snrs = [];
%First Results:
   im_fin = abs(x) / max(max(abs(x)));
   ssims = [ssims, ssim(im_fin, im_abs)];
   rmss = [rmss, sum(sum((im_fin-im_abs).^2))/512/512];
   snrs = [snrs, snr(im_fin, im_fin - im_abs)];
   disp('ssim vals:');
   disp(ssims);
   disp('rmse vals:');
   disp(rmss);
   disp('snr vals:');
   disp(snrs);

%iteration
for l=1:1:15
   %Create patches of size 6x6, (i,j)th patch will be Patch{(i-1)*Width + (j-1) + 1}
   x_real = abs(x);
   x_real = x_real / max(max(abs(x_real))) ; % normalize the image
   [X_real, width, height] = create_patches(x_real, patchwidth, stride);
   % Learn Dictionary and Sparse representations of patches for x
   [D, alphas] = Leearn_D_and_alphas(X_real, patchwidth);
   % Reconstruct patches using their alpha values
   P_rec = D*alphas;
   % Create a new x (image) by adding all reconstructed patches 
   x_new = add_rec_patches(P_rec, width, height, patchwidth, stride);
   x_new = x_new / max(max(abs(x_new))) ; % normalize the image
   % Take FFT and restore sample frequencies as given in question
   %x_new_cplx = complex(x_new);
   y = fft2c(x_new);
   y_new = restore_frequencies(nu,y0,y);
   % final reconstructed image
   x = ifft2c(y_new);
   im_fin = abs(x) / max(max(abs(x)));
   ssims = [ssims, ssim(im_fin, im_abs)];
   rmss = [rmss, sum(sum((im_fin-im_abs).^2))/512/512];
   snrs = [snrs, snr(im_fin, im_fin - im_abs)];
   disp('ssim vals:');
   disp(ssims);
   disp('rmse vals:');
   disp(rmss);
   disp('snr vals:');
   disp(snrs);
   subplot(1,2,1);
   imshow(abs(imv));
   subplot(1,2,2);
   imshow(im_fin);
   drawnow;
end

figure;
plot(1:16, 10*ssims, 1:16, 1000*rmss, 1:16, snrs);
legend('10xSSIM', '1000xRMSE', 'SNR');
title('Performance with iterations');
xlabel('Iterations'); ylabel('Performance');
grid on; grid minor;



