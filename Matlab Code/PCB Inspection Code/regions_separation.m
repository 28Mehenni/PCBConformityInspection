function [ imDOG, imBlob ] = regions_separation( Input_Image )

% Effacer la couleur d'arrière plan et séparation de composants  ----------
Input_Image = double(Input_Image); 
Original = Input_Image;

I1 = Input_Image(:,:,1);
I2 = Input_Image(:,:,2);
I3 = Input_Image(:,:,3);
thresh = 0.07;
% discovery2 thresh=0.07

% concernant les composants (résistances, condensateurs, pic...)
% les intensités d'un pixel(i,j) dans les 3 bandes sont autour d'une 
% valeur moyenne pixel(i,j)- mean <= thresh 
% (un seul défini après plusieur test, dépend du type de la carte)   

Input_Image_mean = (I1 + I2 + I3)/3;

I1(abs(Input_Image(:,:,1) - Input_Image_mean)>thresh) = 0; 
I2(abs(Input_Image(:,:,2) - Input_Image_mean)>thresh) = 0;
I3(abs(Input_Image(:,:,3) - Input_Image_mean)>thresh) = 0;
% assigner la valeur 0 si la condition est vraie, arrière plan tout noir
I = I1.*I2.*I3; 
I(I > 0) = 1;  % 1 pour garder la couleur des composants
Input_Image(:,:,1) = I .* Input_Image(:,:,1);
Input_Image(:,:,2) = I .* Input_Image(:,:,2);
Input_Image(:,:,3) = I .* Input_Image(:,:,3);

I1_grey = rgb2gray(Input_Image);
%imwrite(I1_grey,'C:\Users\Maestro\Documents\MATLAB\results\grayscaled_image.png');
%Fin

%image binaraisé ------------------------------------
bild_grau = I1_grey;
var_start=1; 
var_stop=6; 
array_groesse=(var_stop - var_start) + 1;
scale_space_array=[];

% générer une image flou pour différents échelles, gaussian blur
% masque idéal égal à (6*sigma+1) * (6*sigma+1)
for n=var_start:1:var_stop 
    maskengroesse=ceil(6*n+1); 
    maske = fspecial('gaussian',[maskengroesse maskengroesse],n); 
    bild_scale_space = imfilter(bild_grau,maske,'replicate'); 
    scale_space_array=cat(4,scale_space_array,bild_scale_space); 
end
%     subplot(231);
%     imshow(scale_space_array(:,:,:,1));
%     subplot(232);
%     imshow(scale_space_array(:,:,:,2));
%     subplot(233);
%     imshow(scale_space_array(:,:,:,3));
%     subplot(234);
%     imshow(scale_space_array(:,:,:,4));
%     subplot(235);
%     imshow(scale_space_array(:,:,:,5));
%     subplot(236);
%     imshow(scale_space_array(:,:,:,6));
%    figure;imshow(scale_space_array(:,:,:,1));
%    figure;imshow(scale_space_array(:,:,:,3));
% mathworks Gaussian Smoothing Filters
% I1_grey = imgaussfilt(I1_grey,2);
% figure;imshow(I1_grey);
% I1_grey = im2bw(I1_grey,0.15);

% binaraisation 
% figure;imshow(scale_space_array(:,:,:,1));title('scale');
I1_grey = im2bw(scale_space_array(:,:,:,3),0.15);
% zz9 thresh 0.15
imBlob = I1_grey;
% figure;subplot(131);imshow(im2bw(scale_space_array(:,:,:,1),0.15));
% subplot(132);imshow(im2bw(scale_space_array(:,:,:,2),0.15));
% subplot(133);imshow(imBlob);
% figure;imshow(im2bw(scale_space_array(:,:,:,1),0.15));title('sigma trop petit = 1')
% figure;imshow(im2bw(scale_space_array(:,:,:,6),0.15));title('sigma trop grand = 6')
% figure;imshow(imBlob);

% figure;
% % different thresholds for analysis
% subplot(2,4,1); imshow(im2bw(scale_space_array(:,:,:,3),0.02));
% subplot(2,4,2); imshow(im2bw(scale_space_array(:,:,:,3),0.2));
% subplot(2,4,3); imshow(im2bw(scale_space_array(:,:,:,3),0.3));
% subplot(2,4,4); imshow(im2bw(scale_space_array(:,:,:,3),0.35));
% subplot(2,4,5); imshow(im2bw(scale_space_array(:,:,:,3),0.4));
% subplot(2,4,6); imshow(im2bw(scale_space_array(:,:,:,3),0.45));

% detection de contour en utilisant la fonction dog.m
imDOG = dog(I1_grey,2,3.75,0); %% 3.75
imDOG2 = dog(I1_grey,2,2.5,0);
% imCanny = edge(I1_grey,'canny');
% figure();imshow(imCanny);title('canny');
% imSobel = edge(I1_grey,'sobel');
% figure();imshow(imSobel);title('sobel');
% 2, 3.75
figure;
subplot(1,2,1); imshow(Input_Image);
subplot(1,2,2); imshow(imDOG);

% figure;
% subplot(1,2,1); imshow(im2bw(imDOG2,0.9));
% subplot(1,2,2); imshow(im2bw(imDOG,0.9));

% figure;
% subplot(1,3,1); imshow(im2bw(imDOG2,0.9));title('Différence de gaussiennne');
% subplot(1,3,2); imshow(imCanny);title('Canny');
% subplot(1,3,3); imshow(imSobel);title('Sobel');


% encore une binaraisation apres la detection de contour
imDOG = im2bw(imDOG,0.9);
figure;imshow(imDOG);
end
% c'est fait