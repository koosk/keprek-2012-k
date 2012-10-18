function [beta, gamma] = calc_beta_gamma(W,k)
    d = size(W,1)/k;
    n = size(W,2);
    beta = zeros(d,k);
%     beta2 = zeros(d,k);
    gamma = zeros(d,n);
    for t = 1:d
        gamma(t,:) = sum(W( (t-1)*k+1:(t-1)*k+k, :), 'double');
        beta(t,:)  = sum(W( (t-1)*k+1:(t-1)*k+k, :) , 2, 'double');%ez nem a keplet szerint van? az alabbi teszt pedig jo
%         for i=1:k
%             beta2(t,i) = sum(W( (t-1)*k+i,: ));
%         end
    end
%     isequal(beta,beta2)
    beta(beta==0) = 1;%A SART algoritmusban osztani kell vele es a 0 problemat okozhat. Ilyen esetben viszont a projekcios matrix megfelelo erteke is 0, tehat az eredmeny ugyanaz marad.
end
