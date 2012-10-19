%I = im2double(imread('../images/64/phantom1.png'));
I = phantom(128);
numAngles=10;
angles = linspace(0,180-180/numAngles,numAngles);
W = buildRadonMatrix(size(I,1),angles);
p = W*I(:);
numberOfProjections = size(W,1)/size(angles,2);
LAMBDA=0.99;
[beta, gamma] = calc_sbeta_ngamma(W, numberOfProjections, LAMBDA);
guess = repmat(0.5, 1, size(I,1)*size(I,2));%guess = I(:)';%initial guess
tic
x = SART(W, p, size(W,1)/size(angles,2), guess, ones(1,size(W,2)), beta, gamma, 10);
toc
x2 = reshape(x,size(I,1),size(I,1));%1 vagy 2 nem szamit, mert ugyanaz
figure, imshow(I)
figure, imshow(x2);
