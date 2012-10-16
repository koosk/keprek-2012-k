%
% Does a SART iteration.
%
function x = SART(W, p, k, x, freePixels, beta, gamma, numIters)
    LAMBDA = 0.99;
    d = size(W,1)/k;
    m = size(W,1);
    n = size(W,2);
    %gamma = zeros(d,n);
    %beta  = zeros(d,k);% d,m? keplet hiba
    %'s1'
    %tic
    %for t = 1:d
    %    gamma(t,:) = sum(W( (t-1)*k+1:(t-1)*k+k, :), 'double');
    %    beta(t,:)  = sum(W( (t-1)*k+1:(t-1)*k+k, :) , 2, 'double');%ez nem a keplet szerint van
    %end
    sigma = randomPermutation(d);
    %toc
    
    %'sart iteration'
    %tic
    summatomb = zeros(1,n);
    xnew = x;%guess
    for iterCounter=1:numIters
        for s = 1:d
            %'s2'
            %tic
            r = p( (sigma(s)-1)*k+1:(sigma(s)-1)*k+k );
            www = W( (sigma(s)-1)*k+1:(sigma(s)-1)*k+k,:)*(xnew');
            r = r-www;
            %toc
            %'s3'
            %tic
            for j = 1:n
                if ~freePixels(j)
                    continue
                end    
                summa = 0;
                for i = 1:k
                    if beta(sigma(s),i)==0
                        continue
                    end
                    summa = summa + W((sigma(s)-1)*k+i,j) * r(i) / beta(sigma(s),i);
                end
                %xnew(j) = x(j) + LAMBDA*1/gamma(sigma(s),j)* (W( (sigma(s)-1)*k+1:(sigma(s)-1)*k+k,j ));
                if sigma(s)==1
                    summatomb(j) = summa;
                end
                xnew(j) = xnew(j) + LAMBDA/gamma(sigma(s),j) * summa;
            end
            %toc
            x = xnew;
        end
    end
    %toc
end