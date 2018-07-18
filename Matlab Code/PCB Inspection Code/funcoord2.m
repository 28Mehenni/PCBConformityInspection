function [recovered, coord, mybox, points] = funcoord2(distorted1,original1)
%%
%THRESHOOD = 0.04;
N = 1500;   % nombre de points
% lire les images
% original1 = imread('Ty.jpg');
% %imshow(original1);
% distorted1 = imread('Tym3.jpg');
% conversion en niveaux de gris
original = rgb2gray(original1);
distorted = rgb2gray(distorted1);
%% Correction et Alignement
ptsOriginal = detectSURFFeatures(original);
ptsDistorted = detectSURFFeatures(distorted);
ptsOriginal = ptsOriginal.selectStrongest(N);
ptsDistorted = ptsDistorted.selectStrongest(N);
% Extract feature descriptors. 
[featuresOriginal, validPtsOriginal] = extractFeatures(original, ptsOriginal);
[featuresDistorted, validPtsDistorted] = extractFeatures(distorted, ptsDistorted);
% Faites correspondre les points d'interets en utilisant leurs descripteurs
indexPairs = matchFeatures(featuresOriginal, featuresDistorted);
% Récupérer les emplacements des points correspondants pour chaque image.
matchedOriginal = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));
% Afficher les correspondances de points. Notez la présence de valeurs aberrantes. 
%figure();
%showMatchedFeatures(original,distorted,matchedOriginal,matchedDistorted);
% title('Putatively matched points (including outliers)');

[tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform( matchedDistorted, matchedOriginal, 'similarity');
%figure();
%showMatchedFeatures(original,distorted, inlierOriginal, inlierDistorted);
% title('Matching points (inliers only)');
%%
Tinv = tform.invert.T;
ss = Tinv(2,1);
sc = Tinv(1,1);
% scale_recovered = sqrt(ss*ss + sc*sc);
% theta_recovered = atan2(ss,sc)*180/pi;

% Recover the original image by transforming the distorted image.
outputView = imref2d(size(original));
recovered = imwarp(distorted1,tform,'OutputView',outputView);
% Compare recovered to original by looking at them side-by-side in a montage.
%figure, imshowpair(distorted1,recovered,'montage');
%figure;imshow(recovered);

%%
%MYTHRESHOLD = 0.10;     % seuil de binaraisation 
%Icompare=abs(rgb2gray(original1)-rgb2gray(recovered))
%imshow(Icompare)
Icompare = abs(double(original1) - double(recovered));  % différence entre l'image de référence et l'image capturée
% result=scale_space_conversion( Icompare );
Icompare = uint8(Icompare);
%figure
%imshow(Icompare);

result = im2bw(Icompare,0.04);
% figure
% imshow(result);title('image différence binaraisée') % afficher l'image binaraisée
%
%se1 = strel('square',18);    % matrice carrée ALL ONES
se2 = strel('square',9);
% dilatation et erosion

result2 = imerode(result,se2);
result2 = imdilate(result2,se2);
% figure
% imshow(result2); % afficher l'image après opérations de dilatation et erosion

[mybox,result2] = bwboundaries(result2);
result3 = bwmorph(result2,'shrink',inf);
result3 = imregionalmax(result3);
points=0;
for i=1:size(result3,1)
    for j=1:size(result3,2)
        if (result3(i,j)==1)
            points=points+1;
        end
    end
end
if ( points == size(result3,1)*size(result3,2))
    points = 0;
    coord=zeros(1,points*2);
else
    coord=zeros(1,points*2);
%posYY=zeros(1,10);
s=1;
for i=1:size(result3,1)
    for j=1:size(result3,2)
        if (result3(i,j)==1)
            coord(s)=j;
            coord(s+1)=i;
            s=s+2;
        end
    end
end
end 
end
