%I = im2double(imread('../images/256/phantom1.png'));
%I = im2double(imread('../images/64/phantom2_2_linear.png'));
%I = im2double(imread('../images/128/phantom2_linear.png'));
%I = im2double(imread('../images/128/phantom3_linear.png'));
%I = im2double(imread('../images/256/phantom3.png'));
%I = im2double(imread('../images/64/phantom8.png'));
%I = im2double(imread('../images/64/bullseye_linear.png'));
%I = im2double(imread('../images/other/joint_J6.tif'));
I = phantom(128);
R = unique(I(:))';
numAngles=32;
angles = linspace(0,180-180/numAngles,numAngles);
W = buildRadonMatrix(size(I,1),angles);
p = W*I(:);
numberOfProjections = size(W,1)/size(angles,2);
%x = DART(p, R, W, numberOfProjections);
%x = DART(p, R, W, numberOfProjections,'adaptive');
%[beta, gamma] = calc_beta_gamma(W, numberOfProjections);

% default
C = [0.0375 0.0375 0.0375;
     0.0375 0.7000 0.0375;
     0.0375 0.0375 0.0375];
tic
%[x x2] = DART_cimpl(p,R,W,numberOfProjections,beta,gamma);
[x x2] = DART(p, R, W, numberOfProjections, C, 0.05, 0.3);
toc
RME = calc_rme(I(:),x)
pixelError = pixel_error(I(:),x)
x = reshape(x,size(I,1),size(I,1));
figure, imshow(I)
figure, imshow(x);
clear I R angles W p numberOfProjections RME pixelError