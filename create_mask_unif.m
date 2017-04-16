function [M, pdf_unif] = create_mask_unif(Side, DSFactor)
    pdf_unif = ones(Side, Side)*(1.0/DSFactor);
    Full = ones(Side, Side);
    M = binornd(Full, pdf_unif);
end
