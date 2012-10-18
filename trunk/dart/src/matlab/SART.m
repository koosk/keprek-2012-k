%
% Does a SART iteration.
%
function x = SART(W, p, k, x, freePixels, beta, gamma, numIters, LAMBDA)
    d = size(W,1)/k;
    m = size(W,1);
    n = size(W,2);
    [idx_i, idx_j, vals] = find(freePixels);
    sdfp = sparse(idx_j,idx_j,vals);%sparse diagonal matrix of free pixels
    clear idx_i idx_j vals;
    sigma = randomPermutation(d);
    xnew = x;%guess
    for iterCounter=1:numIters
        for s = 1:d
            r = p( (sigma(s)-1)*k+1:(sigma(s)-1)*k+k ) - W( (sigma(s)-1)*k+1:(sigma(s)-1)*k+k,:)*(xnew');
%             for j = 1:n
%                 if ~freePixels(j)
%                     continue
%                 end    
% %                 summa = 0;
% %                 for i = 1:k
% % %                     if beta(sigma(s),i)==1 && W((sigma(s)-1)*k+i,j)~=0
% % %                         W((sigma(s)-1)*k+i,j)
% % %                     end
% %                     summa = summa + W((sigma(s)-1)*k+i,j) * r(i) / beta(sigma(s),i);
% %                 end
% 
%                 summa = sum(W((sigma(s)-1)*k+1:(sigma(s)-1)*k+k,j) .* r(:) ./ beta(sigma(s),:)');
%                 xnew(j) = xnew(j) + LAMBDA/gamma(sigma(s),j) * summa;
%             end


            %'valami'
            %summa = sum( diag(1./beta(sigma(s),:)') * diag(r) * (W((sigma(s)-1)*k+1:(sigma(s)-1)*k+k,:)), 1);
            summa = sum( sparse(1:k,1:k,1./beta(sigma(s),:)') * sparse(1:k,1:k,r) * (W((sigma(s)-1)*k+1:(sigma(s)-1)*k+k,:) * sdfp'), 1);
            %'masvalami'
%             size(freePixels)
%             size(summa)
%             size(LAMBDA./gamma(sigma(s),:))
%             size(summa)
%             size(xnew)
%             'szorzat:'
%             size(LAMBDA./gamma(sigma(s),:) .* (summa))
%             elso = LAMBDA./gamma(sigma(s),:);
%             masodik = summa;
            xnew = xnew + (LAMBDA./gamma(sigma(s),:) .* (summa));
            
            x = xnew;
        end
    end
end