clc;clear all;close all;
%%
N = 1000;   % nombre de points
% lire les images
%original1 = imread('Ty.jpg');
original1 = imread('PCBSMD3.jpg');
%imshow(original1);
%distorted1 = imread('Tym2.jpg');
distorted1 = imread('PCBSMD32.jpg');
% conversion en niveaux de gris
original = rgb2gray(original1);
distorted = rgb2gray(distorted1);
%% Correction et Alignement
ptsOriginal = detectSURFFeatures(original);
ptsDistorted = detectSURFFeatures(distorted);
ptsOriginal = ptsOriginal.selectStrongest(N);
ptsDistorted = ptsDistorted.selectStrongest(N);
% descripteurs SURF
[featuresOriginal, validPtsOriginal] = extractFeatures(original, ptsOriginal);
[featuresDistorted, validPtsDistorted] = extractFeatures(distorted, ptsDistorted);
% correspondance
indexPairs = matchFeatures(featuresOriginal, featuresDistorted);
%
matchedOriginal = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));
%  
figure();
showMatchedFeatures(original,distorted,matchedOriginal,matchedDistorted);

[tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform( matchedDistorted, matchedOriginal, 'similarity');
figure();
showMatchedFeatures(original,distorted, inlierOriginal, inlierDistorted);

%%
Tinv = tform.invert.T;
ss = Tinv(2,1);
sc = Tinv(1,1);
scale_recovered = sqrt(ss*ss + sc*sc);
theta_recovered = atan2(ss,sc)*180/pi;

% transformation
outputView = imref2d(size(original));
recovered = imwarp(distorted1,tform,'OutputView',outputView);

figure, imshowpair(distorted1,recovered,'montage');
figure;imshow(distorted1);
figure;imshow(recovered);