%
% Does a SART iteration.
%
function x = SART(W, p, k, x, freePixels, sbeta, ngamma, numIters)
    d = size(W,1)/k;
    m = size(W,1);
    n = size(W,2);
    [~, idx_j, vals] = find(freePixels);
    sdfp = sparse(idx_j,idx_j,vals,n,n);%sparse diagonal matrix of free pixels
    clear idx_i idx_j vals;
    sigma = randomPermutation(d);
    for iterCounter=1:numIters
        for s = 1:d
            r = p( (sigma(s)-1)*k+1:(sigma(s)-1)*k+k ) - W( (sigma(s)-1)*k+1:(sigma(s)-1)*k+k,:)*(x');
            summa = sum( sbeta((sigma(s)-1)*k+1:(sigma(s)-1)*k+k,:) * sparse(1:k,1:k,r) * (W((sigma(s)-1)*k+1:(sigma(s)-1)*k+k,:) * sdfp'), 1);
            x = x + (ngamma(sigma(s),:) .* (summa));
        end
    end
end