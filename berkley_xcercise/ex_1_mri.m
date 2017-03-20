im_R = abs(im);
%imshow(im_R,'DisplayRange',[]);
W=Wavelet;
im_W = W*im;
% figure
% imshowWAV(im_W);

%thresholding the coefficients
m = sort(abs(im_W(:)),'descend');
f=0.02;
ndx = floor(length(m)*f);
thresh = m(ndx); %0.0613 for 10%, 0.0811 for 5%, 0.1498 for 2%
im_W_th = im_W .* (abs(im_W) > thresh);

% figure
% imshowWAV(im_W_th);
im_rec = W'*im_W_th;
im_rec_R = abs(im_rec);
%imshow(im_rec_R,'DisplayRange',[]);

%checked the ifft2c and fft2c both are working as expected and so can be
%used.

%POCS Reconstruction:




