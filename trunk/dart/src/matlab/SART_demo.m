%I = im2double(imread('../images/64/phantom1.png'));
I = phantom(128);
angles = 0:15:180;
W = buildRadonMatrix(size(I,1),angles);
p = W*I(:);
guess = repmat(0.5, 1, size(I,1)*size(I,2));%guess = I(:)';%initial guess
x = SART(W,p,size(W,1)/size(angles,2),guess, 1:size(W,2));%az utolso elotti parameter egy tipp
x2 = reshape(x,size(I,1),size(I,1));%1 vagy 2 nem szamit, mert ugyanaz
figure, imshow(I)
figure, imshow(x2);