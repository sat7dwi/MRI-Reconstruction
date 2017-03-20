load brain;
im_abs = abs(im);
W=Wavelet;
%imshow(im_R,'DisplayRange',[]);
% im_W = W*im;
% im_R = W'*im_W;

%thresholding the coefficients
% m = sort(abs(im_W(:)),'descend');
% f=0.02;
% ndx = floor(length(m)*f);
% thresh = m(ndx); %0.0613 for 10%, 0.0811 for 5%, 0.1498 for 2%
% im_W_th = im_W .* (abs(im_W) > thresh);
% im_rec = W'*im_W_th;
% im_rec_R = abs(im_rec);
%imshow(im_rec_R,'DisplayRange',[]);
%checked the ifft2c and fft2c both are working as expected and so can be
%used.

%Random UnderSampling:
M = fft2c(im); %random uniform
Mu = (M.*mask_unif)./pdf_vardens;
imu = abs(ifft2c(Mu));

M = fft2c(im); %random vardens
Mv = (M.*mask_vardens)./pdf_vardens;
imv = abs(ifft2c(Mv));

ssim_u = ssim(imu/max(max(imu)), im_abs);
ssim_v = ssim(imv/max(max(imv)), im_abs);
rmse_u = sum(sum((abs(imu/max(imu(:))-im_abs).^2)))/512/512;
rmse_v = sum(sum((abs(imv/max(imv(:))-im_abs).^2)))/512/512;

%POCS Algorithm

%part d

lambda = 0.08; %0.05; %set lambda

IM_hat = Mu; %initialise as undersampled data
im_hat = ifft2c(IM_hat);
% figure
% hold on
% h=imshow(abs(im_hat));

for i=1:1:85
    %h=stem(x_hat);

    %thresholding in Wavelet Domain
    im_W = W*im_hat;
    im_W = SoftThresh2D(im_W, lambda);
    im_hat = W'*im_W;
    
    IM_hat = fft2c(im_hat);
    IM_hat = IM_hat.*(Mu==0) + Mu;
    %stem(x_hat) drawnow;
    im_hat = ifft2c(IM_hat);
 %   imwrite(abs(im_hat)/max(max(abs(im_hat))), strcat('unif/im_',num2str(i), '.jpg'));
%     pause(0.2);
%     delete(h);
%     h=imshow(abs(im_hat));
%     drawnow;
    ssim_u = ssim(abs(im_hat)/max(max(abs(im_hat))), im_abs);
    rmse = sum(sum((abs(abs(im_hat)/max(max(abs(im_hat)))-im_abs).^2)))/512/512;
    %diff_v = sum(sum(abs(im_hat-im)))/10000;
    disp(strcat('ssim: ',num2str(ssim_u),' , rmse: ',num2str(rmse)));
end

% Result: For Var Case:
% thresh = 0.12 
% Orig ssim: 0.5777; rmse: 0.0018 
% POCS ssim:0.67854; rmse: 0.0062 (15 iter)
% SparseMRI ssim: 0.7441; rmse: 0.00056374

% Result: For Unif Case: 
% thresh=0.08 
% Orig ssim: 0.2571; rmse: 0.0232
% POCS, ssim: 0.34983; rmse: 0.0187 (80 iter)
% SparseMRI ssim: 0.4466; rmse: 0.0168 
