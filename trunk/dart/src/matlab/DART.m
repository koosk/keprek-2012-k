function [x_dart t_dart time_dart x t time] = DART(p, R, W, numberOfProjections, C, FREE_PROBABILITY, LAMBDA, numIter)
    tic
    n = size(W,2);
    if size(C,1)~=size(C,2)
        throw(MException('InputChk:BadInput','The given convolution matrix is not square!'));
    end
    c = ceil(size(C,1)/2);
    ALL_PIXELS = true(1,n);
    isAdaptive = 0;
    if nargout==6
        isAdaptive = 1;
    end
    exactNumIter = 0;
    if nargin==8
        exactNumIter = 1;
    end
    
    [sbeta, ngamma] = calc_sbeta_ngamma(W, numberOfProjections,LAMBDA);

    dim = sqrt(n);
    %x0 = SART_mex(W, p, numberOfProjections, repmat(0.5, 1, n),ALL_PIXELS, beta, gamma, 10, LAMBDA);
    x0 = SART(W, p, numberOfProjections, repmat(0.0, 1, n), ALL_PIXELS, sbeta, ngamma, 10);

    tau = buildTau(R);
    t = 0;
    prevProjErr = 1000001;
    %---------STEP1-----------------
    xt = x0;
    clear x0;
    for adaptiveCounter=0:7
        projErr = prevProjErr;
        prevProjErr = prevProjErr+1;
        %terminalas vagy parameterben beallitott iteracioszam alapjan vagy hiba es maximalis iteracioszam alapjan
        while (exactNumIter && adaptiveCounter==0 && t<numIter) || ((~exactNumIter || adaptiveCounter~=0) && (projErr<prevProjErr) && (t<500))
            xt1 = xt;
            t = t+1;
            if t==1
                s = tresholdImage(xt1,tau,R,ALL_PIXELS);
            else
               s = tresholdImage(xt1,tau,R,U);
            end
            %---------STEP2-----------------
            B = determineBoundaryPixels(s,adaptiveCounter,dim);%masodik parameter, hogy mennyi terhet max el, hogy ne legyen boundary

            U = B;
            if adaptiveCounter==0
                randomFreePixels = find(rand(1,n)>(1-FREE_PROBABILITY));
                for i=1:size(randomFreePixels,2)
                    U(randomFreePixels(i)) = true;
                end
            end
            %---------STEP3-----------------
            y = s;
            for i=1:n
                if U(i)
                    y(i) = xt1(i);
                end
            end
            %xt = SART_mex(W, p, numberOfProjections,y,U, beta, gamma, 10, LAMBDA);
            xt = SART(W, p, numberOfProjections,y,U, sbeta, ngamma, 3);
            %---------STEP4-----------------simitas
            y = xt;
            y = imcomplement(U) .* xt + U .* reshape(conv2(reshape(xt,dim,dim),C,'same'),1,n);
            xt = y;
            s = tresholdImage(xt1,tau,R,U);
            %---------STEP5-----------------
            if mod(t,3)==0 || t==1
                prevProjErr = projErr;
                %projErr = norm(W*tresholdImage(xt,tau,R,U)'-p,2);
                projErr = norm(W*xt'-p,2);
                %projErr = norm(W*s'-p,2);
            end
        end
        
        if adaptiveCounter==0
            x_dart = tresholdImage(xt,tau,R,U);
            t_dart = t;
            time_dart = toc;
        end
        if ~isAdaptive
            break;
        end
    end
    if isAdaptive
        x = tresholdImage(xt,tau,R,U);
        time = toc;
    end
end

%A kuszoboleshez szukseges tau fuggvenyt allitja elo.
function tau = buildTau(R)
    tau = zeros(1,size(R,2)-1);
    for i=1:size(R,2)-1
        tau(i) = (R(i)+R(i+1))/2;
    end
end

%Kuszoboli a a kepen a megadott szabad pixeleket a megadott kuszobolesi
%ertekekkel.
function x = tresholdImage(x,tau,R,freePixels)
    for i=1:size(x,2)
        if freePixels(i)
            %x(i) = treshold(x(i),tau,R);
            if x(i)<tau(1)
                x(i) = R(1);
                continue
            end
            b = 1; %boolean, hogy a legnagyobb intenzitast kell-e neki ertekul adni.
            for j=1:size(tau,2)-1
                if (x(i)>=tau(j)) && (x(i)<tau(j+1))
                    x(i) = R(j+1);
                    b = 0;
                    break
                end
            end
            if b==1
                x(i) = R(size(R,2));
            end
        end
    end
end

%Hatarpixelek meghatarozasa. Az tartozik ebbe a halmazba, melynek 8
%szomszedai kozul legalabb maxDistinctPixels szamu eltero intenzitasu.
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
                B((i-1)*dim+j) = true;
            end
        end
    end
end

%Egy olyan indexet ad vissza, ami mindenkepp a kepre hivatkozik. Abban az
%esetben, ha a megadott index kilogna a kepbol, visszahelyezi azt a kepbe
%ugy, mintha sokszor egymas melle lenne masolva ugyanaz a kep es a mellette
%levobe lenne hivatkozva.
%A getValidIndex roviditese a gvi nev.
function j = gvi(i,n)
    if (i<1)
        j = i+n;
        return
    else if (i>n)
        j = i-n;
        return
        end
    end
    j = i;
end