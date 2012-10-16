function [beta, gamma] = calc_beta_gamma(W,k)
    d = size(W,1)/k;
    n = size(W,2);
    beta = zeros(d,k);
    gamma = zeros(d,n);
    for t = 1:d
        gamma(t,:) = sum(W( (t-1)*k+1:(t-1)*k+k, :), 'double');
        for i=1:k
            beta(t,i) = sum(W( (t-1)*k+i,: ));
        end
    end
end
