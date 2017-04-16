function y_new = restore_frequencies(nu,y0,y)
    y_new = (y0==0).*y + ((y0~=0).*(y + nu*y0)) / (1.0 + nu); 
end
