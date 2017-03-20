function X_th = SoftThresh2D(X, lambda)
    X_th = (abs(X)-lambda)./abs(X).*X.*(abs(X) > lambda);
