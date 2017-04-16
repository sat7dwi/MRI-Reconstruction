function P_rec = reconstructed_patches(D,alphas)
alphaf = full(alphas);
P_rec = D*alphaf;
end