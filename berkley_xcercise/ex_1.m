x = [[1:5]/5 zeros(1,128-5)];
x = x(randperm(128));
y = x + 0.05*randn(1,128);
xb = [1:1:128];
lambda = [0.01 0.05 0.1 0.2];
x_hat = [y;y;y;y];
for j=1:1:4
    for i=1:1:128
        x_hat(j,i) = SoftThresh(y(1,i),lambda(j));
    end
end

% y2=[-10:0.1:10];
% o2=y2;
% for i=1:1:201
% o2(1,i)=SoftThresh(y2(1,i),2);
% end

figure
scatter(xb,y);
hold on
scatter(xb,x_hat(3,:));

%a and b are done

X = fftshift(fft(x));
%plot(X);
Xu = zeros(1,128);
Xu(1:4:128) = X(1:4:128);
xu = ifft(ifftshift(Xu))*4;

Xr = zeros(1,128);
prm = randperm(128);
Xr(prm(1:32)) = X(prm(1:32));
xr = ifft(ifftshift(Xr))*4;

%part d
Y = Xr;
X_hat = Y; %initialise
for i=1:1:300
    x_hat = ifft(ifftshift(X_hat));
    for i=1:1:128
        x_hat(i) = SoftThresh(x_hat(i),lambda);
    end
    X_hat = fftshift(fft(x_hat));
    X_hat = X_hat.*(Y==0) + Y;
end

