function x = DART(p, R, W, numberOfProjections, ~)
% Ellenorzesi lehetosegek:
% 1. ellenorizni, hogy p es R dimenzioja megfelelo, vagyis p oszlop, R
% pedig sorvektor
% 2. ellenorizni, hogy R oszlopainak szama legalabb 2
    FIX_PROBABILITY=0.15;
    n = size(W,2);
    ALL_PIXELS = true(1,n);
    isAdaptive = 0;
    if nargin==5
        isAdaptive = 1;
    end
    [beta, gamma] = calc_beta_gamma(W, numberOfProjections);

    dim = sqrt(n);
    %x0 = SART(W, p, numberOfProjections, repmat(0.5, 1, n),true(1,n), beta, gamma,1);
    x0 = SART_mex(W, p, numberOfProjections, repmat(0.5, 1, n),ALL_PIXELS, beta, gamma, 1);
%asdf = reshape(x0,64,64);
%figure, imshow(asdf)

    tau = buildTau(R);
    t = 0;
    %projErr = 1000000;
    prevProjErr = 1000001;
    %---------STEP1-----------------
    xt = x0;
    for adaptiveCounter=0:7
        adaptiveCounter
        projErr = prevProjErr;
        prevProjErr = prevProjErr+1;
        while (projErr<prevProjErr) && (t<500)
        %while (t<30)
        %t
           %'step1'
           %tic
            xt1 = xt;
            t = t+1;
            if t==1
                s = tresholdImage(xt1,tau,R,ALL_PIXELS);
            else
                s = tresholdImage(xt1,tau,R,U);
            end
           %toc
            %---------STEP2-----------------
           %'step2'
           %tic
            B = determineBoundaryPixels(s,adaptiveCounter,dim);%masodik parameter, hogy mennyi terhet max el, hogy ne legyen boundary

            randomFreePixels = find(rand(1,n)>(1-FIX_PROBABILITY));
            %U = union(B,randomFreePixels);
                U = B;
                for i=size(randomFreePixels,2)
                    U(randomFreePixels(i)) = true;
                end
           %toc
            %---------STEP3-----------------
           %'step3'
           %tic
            y = s;
            for i=1:n
                if U(i)
                    y(i) = xt1(i);
                end
            end
            %xt = SART(W, p, numberOfProjections,y,U, beta, gamma,10);
            xt = SART_mex(W, p, numberOfProjections,y,U, beta, gamma,10);
           %toc
            %---------STEP4-----------------simitas
           %'step4'
           %tic
            %0.0375 0.0375 0.0375
            %0.0375 0.7    0.0375
            %0.0375 0.0375 0.0375
            y = xt;
            if U(1) % contains helyett
                y(1) = 0.7*xt(1) + 0.1*(xt(2)+xt(dim+1)+xt(dim+2));%egyszerusitve
            end
            if U(dim)
                y(dim) = 0.7*xt(dim) + 0.1*(xt(dim-1)+xt(2*dim-1)+xt(2*dim));%egyszerusitve
            end
            if U(n-dim+1)%bal also
                y(n-dim+1) = 0.7*xt(n-dim+1) + 0.1*(xt(n-2*dim+1)+xt(n-2*dim+2)+xt(n-dim+2));%egyszerusitve
            end
            if U(n)
                y(n) = 0.7*xt(n) + 0.1*(xt(n-1)+xt(n-dim)+xt(n-dim-1));%egyszerusitve
            end
            for i=2:dim-1
                if U(i)%fent
                    y(i) = 0.7*xt(i) + 0.06*(xt(i-1)+xt(i+1)+xt(i+dim-1)+xt(i+dim)+xt(i+dim+1));%egyszerusitve
                end
                j = n-dim+i;%lent
                if U(j)
                    y(j) = 0.7*xt(j) + 0.06*(xt(j-1)+xt(j+1)+xt(j-dim-1)+xt(j-dim)+xt(j-dim+1));%egyszerusitve
                end
                j = (i-1)*dim+1;%bal
                if U(j)
                    y(j) = 0.7*xt(j) + 0.06*(xt(j-dim)+xt(j-dim+1)+xt(j+1)+xt(j+dim)+xt(j+dim+1));
                end
                j = i*dim;%jobb
                if U(j)
                    y(j) = 0.7*xt(j) + 0.06*(xt(j-dim-1)+xt(j-dim)+xt(j-1)+xt(j+dim-1)+xt(j+dim));
                end
            end
            for i=2:dim-1
                for j=2:dim-1
                    k = (i-1)*dim+j;
                    if U(k)
                        y(k) = 0.7*xt(k) + 0.0375*(xt(k-dim-1)+xt(k-dim)+xt(k-dim+1)+xt(k-1)+xt(k+1)+xt(k+dim-1)+xt(k+dim)+xt(k+dim+1));
                    end
                end
            end
            xt = y;
           %toc
             %---------STEP5-----------------
           %'step5'
           %tic
            if mod(t,3)==0 || t==1
                prevProjErr = projErr;
                projErr = norm(W*xt'-p,2);%%%
            end
           %toc
        end
        
        if ~isAdaptive
            break;
        end
    end
    t
    prevProjErr
    projErr
    x = tresholdImage(xt,tau,R,U);
end

function tau = buildTau(R)
    tau = zeros(1,size(R,2)-1);
    for i=1:size(R,2)-1
        tau(i) = (R(i)+R(i+1))/2;
    end
end

function v = treshold(v,tau,R)
    if v<tau(1)
        v = R(1);
        return
    end
    for i=1:size(tau,2)-1
        if (v>=tau(i)) && (v<tau(i+1))
            v = R(i+1);
            return
        end
    end
    v = R(size(R,2));
end

function x = tresholdImage(x,tau,R,freePixels)
    for i=1:size(x,2)
        if freePixels(i)
            x(i) = treshold(x(i),tau,R);
        end
    end
end

function B = determineBoundaryPixels(s,maxDistinctPixels,dim)
    B = false(1,dim*dim);
    for i=1:dim
        for j=1:dim
            distinct = 0;
            current = s( (i-1)*dim+j );
            %felette
            if (i>1)
                if current~=s( (i-2)*dim+j )
                    distinct = distinct+1;
                end
                if (j>1) && ( current~=s( (i-2)*dim+j-1 ) )
                    distinct = distinct+1;
                end
                if (j<dim) && ( current~=s( (i-2)*dim+j+1 ) )
                    distinct = distinct+1;
                end
            end
            %mellette
            if (j>1) && ( current~=s( (i-1)*dim+j-1 ) )
                distinct = distinct+1;
            end
            if (j<dim) && ( current~=s( (i-1)*dim+j+1 ) )
                distinct = distinct+1;
            end
            %alatta
            if (i<dim)
                if current~=s( i*dim+j )
                    distinct = distinct+1;
                end
                if (j>1) && ( current~=s( i*dim+j-1 ) )
                    distinct = distinct+1;
                end
                if (j<dim) && ( current~=s( i*dim+j+1 ) )
                    distinct = distinct+1;
                end
            end
            
            if distinct>maxDistinctPixels
                B((i-1)*dim+j) = true;% add fgv helyett
            end
        end
    end
end