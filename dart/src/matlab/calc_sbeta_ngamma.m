function [sbeta, ngamma] = calc_sbeta_ngamma(W,k,lambda)
    d = size(W,1)/k;
    n = size(W,2);
    sbeta = zeros(d,k);
%     beta2 = zeros(d,k);
    ngamma = zeros(d,n);
    for t = 1:d
        ngamma(t,:) = sum(W( (t-1)*k+1:(t-1)*k+k, :), 'double');
        sbeta(t,:)  = sum(W( (t-1)*k+1:(t-1)*k+k, :) , 2, 'double');%ez nem a keplet szerint van? az alabbi teszt pedig jo
%         for i=1:k
%             beta2(t,i) = sum(W( (t-1)*k+i,: ));
%         end
    end
%     isequal(beta,beta2)
    sbeta(sbeta==0) = 1;%A SART algoritmusban osztani kell vele es a 0 problemat okozhat. Ilyen esetben viszont a projekcios matrix megfelelo erteke is 0, tehat az eredmeny ugyanaz marad.
    sbeta = sparse(1:k*d,repmat(1:k,1,d),(1./sbeta)');
    ngamma = lambda./ngamma;
end
