clc;clear all;close all;
THRESHOOD = 0.04;
N = 1500;   % nombre de points
% lire les images
original1 = imread('scan1.jpg');
original1=im2double(original1);
%original1 = imread('Ty.jpg');
imshow(original1);
distorted1 = imread('scan3.jpg');
distorted1=im2double(distorted1);
figure;imshow(distorted1)
%distorted1 = imread('Tym2.jpg');
% conversion en niveaux de gris
original = rgb2gray(original1);
figure;imshow(original);
distorted = rgb2gray(distorted1);
%% Correction et Alignement
ptsOriginal = detectSURFFeatures(original);
ptsDistorted = detectSURFFeatures(distorted);
ptsOriginal = ptsOriginal.selectStrongest(N);
ptsDistorted = ptsDistorted.selectStrongest(N);
% Extract feature descriptors. 
[featuresOriginal, validPtsOriginal] = extractFeatures(original, ptsOriginal);
[featuresDistorted, validPtsDistorted] = extractFeatures(distorted, ptsDistorted);
% Match features by using their descriptors.
indexPairs = matchFeatures(featuresOriginal, featuresDistorted);
% Retrieve locations of corresponding points for each image. 
matchedOriginal = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));
% Show point matches. Notice the presence of outliers. 
figure();
showMatchedFeatures(original,distorted,matchedOriginal,matchedDistorted);
title('Putatively matched points (including outliers)');

[tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform( matchedDistorted, matchedOriginal, 'similarity');
figure();
showMatchedFeatures(original,distorted, inlierOriginal, inlierDistorted);
title('Matching points (inliers only)');
%%
% Tinv = tform.invert.T;
% ss = Tinv(2,1);
% sc = Tinv(1,1);
% scale_recovered = sqrt(ss*ss + sc*sc);
% theta_recovered = atan2(ss,sc)*180/pi;

% Recover the original image by transforming the distorted image.
outputView = imref2d(size(original));
recovered = imwarp(distorted1,tform,'OutputView',outputView);
% Compare recovered to original by looking at them side-by-side in a montage.
figure, imshowpair(distorted1,recovered,'montage');
figure, imshowpair(original1,recovered,'montage');
%%
MYTHRESHOLD = 0.40;     % seuil de binaraisation 
Icompare = abs(double(original1) - double(recovered));
imshow(Icompare)
%original=im2bw(original,0.1);
%imshow(original);
Icompare = uint8(Icompare);
figure
imshow(Icompare);
result = im2bw(Icompare,0.04);
figure
imshow(result);title('image différence binaraisée') % afficher l'image binaraisée

%
se1 = strel('square',9);    % matrice carrée ALL ONES
se2 = strel('square',9);
% dilatation et erosion
result2 = imerode(result,se2);
result2 = imdilate(result2,se1);
% se1 = strel('square',3);    % matrice carrée ALL ONES
% se2 = strel('square',9);
% % dilatation et erosion
% result2 = imdilate(result,se2);
% result2 = imerode(result2,se1);
figure
imshow(result2); % afficher l'image après opérations de dilatation et erosion
imagesize = size(result2);
maxright = imagesize(2); % nombre de colonnes
maxbottom = imagesize(1);% nombre de lignes
minboxsize = uint16(min(maxright,maxbottom) /50);

%% bwboundaries de l'image binaraisée
[mybox,LL] = bwboundaries(result2);
pointMis = recovered;
%------------
% result3 = bwmorph(LL,'shrink',inf);
% result3 = imregionalmax(result3);
% figure;imshow(result3)
%------------
%% bloc pour encadrer les défauts extraits sur l'image capturé RGB
for i = 1:length(mybox)
 mleft(i) = uint16(min(mybox{i}(:,2)));
 mright(i) = uint16(max(mybox{i}(:,2)));
 mtop(i) = uint16(min(mybox{i}(:,1)));
 mbottom(i) = uint16(max(mybox{i}(:,1)));
 left(i) = max(mleft(i) - minboxsize, 1);
 right(i) = min(mright(i) + minboxsize, maxright);
 top(i) = max(mtop(i) - minboxsize, 1);
 bottom(i) = min(mbottom(i) + minboxsize, maxbottom);

 pointMis(top(i),left(i):right(i),1)=255; pointMis(top(i)+1,left(i):right(i),1)=255; pointMis(top(i)+2,left(i):right(i),1)=255;
 pointMis(top(i),left(i):right(i),2)=0; pointMis(top(i)+1,left(i):right(i),2)=0;pointMis(top(i)+2,left(i):right(i),2)=0;
 pointMis(top(i),left(i):right(i),3)=0; pointMis(top(i)+1,left(i):right(i),3)=0; pointMis(top(i)+2,left(i):right(i),3)=0;

 pointMis(bottom(i),left(i):right(i),1)=255;pointMis(bottom(i)+1,left(i):right(i),1)=255;pointMis(bottom(i)+2,left(i):right(i),1)=255;
 pointMis(bottom(i),left(i):right(i),2)=0; pointMis(bottom(i)+1,left(i):right(i),2)=0; pointMis(bottom(i)+2,left(i):right(i),2)=0;
 pointMis(bottom(i),left(i):right(i),3)=0;pointMis(bottom(i)+1,left(i):right(i),3)=0;pointMis(bottom(i)+2,left(i):right(i),3)=0;

 pointMis(top(i):bottom(i),left(i),1)=255;pointMis(top(i):bottom(i),left(i)+1,1)=255;pointMis(top(i):bottom(i),left(i)+2,1)=255;
 pointMis(top(i):bottom(i),left(i),2)=0;pointMis(top(i):bottom(i),left(i)+1,2)=0;pointMis(top(i):bottom(i),left(i)+2,2)=0;
 pointMis(top(i):bottom(i),left(i),3)=0;pointMis(top(i):bottom(i),left(i)+1,3)=0;pointMis(top(i):bottom(i),left(i)+2,3)=0;

 pointMis(top(i):bottom(i),right(i),1)=255;pointMis(top(i):bottom(i),right(i)+1,1)=255;pointMis(top(i):bottom(i),right(i)+2,1)=255;
 pointMis(top(i):bottom(i),right(i),2)=0;pointMis(top(i):bottom(i),right(i)+1,2)=0;pointMis(top(i):bottom(i),right(i)+2,2)=0;
 pointMis(top(i):bottom(i),right(i),3)=0;pointMis(top(i):bottom(i),right(i)+1,3)=0;pointMis(top(i):bottom(i),right(i)+2,3)=0;
end
figure
imshow(pointMis)
length(mybox) %% nombre de défauts trouvés