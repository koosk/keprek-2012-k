% Calculates RME. The first parameter should be the original image.
function err = calc_rme(x,y)
    err = sum(abs(x(:)-y(:))) / sum(x);
end