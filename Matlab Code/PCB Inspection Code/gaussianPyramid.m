function [ image_out ] = gaussianPyramid( image , steps )
%GAUSSIANPYRAMID Summary of this function goes here
%   Detailed explanation goes here

[width height] = size(image);

G = fspecial('gaussian',[5 5],1);

%image_array = zeros(width,height,steps);


%image_array(:,:,1)=image;
image_out=image;

for i = 2:steps %later as far as possible
    %image_step = imfilter(image_array(:,:,i-1),G,'same');
    %image_array(:,:,i) = imresize(image_step,0.5);  
    image_step = imfilter(image_out,G,'same','replicate');
    image_out = imresize(image_step,0.5);  
    
end

%mat_array= image_array;


end