function x = ifft2c(X)
    x = fftshift(ifft(ifftshift(X)));
end