x = [[1:5]/5 zeros(1,128-5)];
x = x(randperm(128));
%[0.01 0.05 0.1 0.2];

X = fftshift(fft(x));

figure
stem(x);
figure
stem(abs(X));

%periodic downsampled samples
Xu = zeros(1,128);
Xu(1:4:128) = X(1:4:128);

%random samples
Xr = zeros(1,128);
prm = randperm(128);
Xr(prm(1:32)) = X(prm(1:32));
xr = ifft(ifftshift(Xr))*4;

%part d
lambda = 0.1;
Y = Xr;
X_hat = Y; %initialise
x_hat = ifft(ifftshift(X_hat));
figure
hold on
h=plot(abs(x_hat));
for i=1:1:300
    %h=stem(x_hat);
    
    for i=1:1:128
        x_hat(i) = SoftThresh(x_hat(i),lambda);
    end
    X_hat = fftshift(fft(x_hat));
    X_hat = X_hat.*(Y==0) + Y;
    %stem(x_hat) drawnow;
    x_hat = ifft(ifftshift(X_hat));
    pause(0.1);
    delete(h);
    h = plot(abs(x_hat)); 
    drawnow;
end
