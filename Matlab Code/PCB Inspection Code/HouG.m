clc;clear all;close all;
% Get the image
I = imread('pi1.jpg');
imshow(I);
%I2 = imrotate(I,30);
I2=imread('pi2.jpg');
I2=rgb2gray(I2);
figure;
imshow(I2)
% Find all the edges in the image
BW = edge(I2,'canny');
% Find the Hough information about the lines
[H, theta, rho] = hough(BW);
% Get the strongest line
% First column is rho index, second is theta index
P = houghpeaks(H,1)
% Find out how much it needs to rotate
thetaPeak = theta(P(1,2));
% Fix the image
I3 = imrotate(I2,thetaPeak+360,'crop');
%%
figure(), imshowpair(I2,I3,'montage');
rect_board = [960 240 1735 1605 ];
original = imcrop(rgb2gray(I),rect_board);
recovered = imcrop(I3,rect_board);
Icompare = abs(double(original)- double(recovered));  % différence entre l'image de référence et l'image capturée
% result=scale_space_conversion( Icompare );
Icompare = uint8(Icompare);
figure
imshow(Icompare);