function X = fft2c(x)
    X = fftshift(fft(ifftshift(x)));
end