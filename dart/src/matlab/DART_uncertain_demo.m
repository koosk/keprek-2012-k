%I = im2double(imread('../../resources/img/256/phantom1.png'));
%I = im2double(imread('../../resources/img/64/phantom2_2_linear.png'));
%I = im2double(imread('../../resources/img/256/phantom7.png'));
%I = im2double(imread('../../resources/img/phantom3_linear.png'));
%I = im2double(imread('../../resources/img/256/phantom3.png'));
%I = im2double(imread('../../resources/img/64/phantom8.png'));
%I = im2double(imread('../../resources/img/64/bullseye_linear.png'));
%I = im2double(imread('../../resources/img/phantom256.png'));
I = im2double(imread('D:\programs\matlab\resources\img\64\phantom8.png'));
%I = im2double(imread('../../resources/img/other/joint_J6.tif'));
%I = phantom(128);
global glob_W;
glob_W=W64;

R = unique(I(:))';
numAngles=10;
angles = round(linspace(0,180-180/numAngles,numAngles))
tic

%W = buildRadonMatrix(size(I,1),angles);
W = assemble_proj_mtx(glob_W,size(I,1),angles);
toc
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
%[x t time] = DART(p, R, W, numberOfProjections, C, 0.05, 0.3);

[x t time] = DART_uncertain(p, R, W, angles, C, 0.05, 0.3, 200, size(I,1));
%function [x_dart t_dart time_dart x t time] = DART(p, R, W, projections, C, FREE_PROBABILITY, LAMBDA, numIter, pictureSize)
toc
RME = calc_rme(I(:),x)
pixelError = pixel_error(I(:),x)
x = reshape(x,size(I,1),size(I,1));
figure, imshow(I)
figure, imshow(x);
clear I R angles W p numberOfProjections RME pixelError