close all;
clc;

%%
filename = 'Platine_1_ausschnitt.jpg';
Image = im2double(imread(strcat('..\Beispielbilder\',filename)));
imDOG = scale_space_conversion(Image);
imwrite(imDOG,strcat('results\DoG_',filename));
%

%search for SOIC_08 style Parts
Element_of_Interest =  rgb2gray(imread('..\Beispielbilder\EOI\SOIC_8.png'));
[SOIC08_found, new_Input_Image_1] = find_matches( imDOG, Element_of_Interest, 1, 0.01, 'plot_OFF' );
elements_found = SOIC08_found;
%figure;
%imshow(new_Input_Image_1);
 
% %search for 0805 style Parts
Element_of_Interest =  rgb2gray(imread('..\Beispielbilder\EOI\rectangle_style0805_withpads.png'));
[rect_0805_found, new_Input_Image_2] = find_matches( new_Input_Image_1, Element_of_Interest, 3, 0.005, 'plot_OFF' );
elements_found = elements_found + rect_0805_found;
%elements_found = rect_0805_found;
%figure;
%imshow(new_Input_Image_2);

%search for 0603 style Parts
new_Input_Image = Input_Image;
Element_of_Interest =  rgb2gray(imread('..\Beispielbilder\EOI\rectangle_style0603_withpads_2.png'));
[rect_0603_found, new_Input_Image_3] = find_matches( new_Input_Image_2, Element_of_Interest, 5, 0, 'plot_OFF' );
elements_found = elements_found + rect_0603_found;
%elements_found = rect_0603_found;
figure;
imshow(new_Input_Image_3);


%strcat('found - ' , ' ', num2str(sum(sum(SOIC08_found))) ,'  SOIC 08 Parts')
%strcat('found - ' , ' ', num2str(sum(sum(rect_0805_found))) ,'  0805 Parts')
%strcat('found - ' , ' ', num2str(sum(sum(rect_0603_found))) ,'  0603 Parts')
%%
figure;
imshow(Image);
hold on
for x = 1:1:size(elements_found,1);
    for y = 1:1:size(elements_found,2);
        if elements_found(x,y) == 1 || elements_found(x,y) == 2
            plot(y,x,'Marker','s','MarkerFaceColor','b','Markersize',5,'MarkerEdgeColor','none');
        end
        if elements_found(x,y) == 3 || elements_found(x,y) == 4
            plot(y,x,'Marker','s','MarkerFaceColor','m','Markersize',5,'MarkerEdgeColor','none');
        end
        if elements_found(x,y) == 5 || elements_found(x,y) == 6
            plot(y,x,'Marker','s','MarkerFaceColor','g','Markersize',5,'MarkerEdgeColor','none');
        end
    end
end

print( '-dpng', strcat('results\estimated_positions_',filename));
    
%{

figure;
subplot(2,2,1); imshow(dog(I,2,4,0));
subplot(2,2,2); imshow(dog(I,3,5,0));
subplot(2,2,3); imshow(dog(I,5,10,0));
subplot(2,2,4); imshow(dog(I,9,10,0));

%%
figure;
BW = edge(I,'canny');

subplot(2,2,1); imshow(edge(I,'canny'));
subplot(2,2,2); imshow(edge(I,'canny',0.1,3));
subplot(2,2,3); imshow(edge(I,'canny',0.5,3));
subplot(2,2,4); imshow(edge(I,'canny',0.5,10));
%%
imDOG = dog(I,9,10,0);
imCANNY = edge(I,'canny');

imDOG(imDOG<0.8) = 0; % Alle Werte < 0.5 auf 0 setzen
imDOG(imDOG>=0.8) = 1; % Alle Werte > 0.5 auf 1 setzen

figure; imshow(imDOG+imCANNY);

%%

%figure;
DoG = dog(I,1,5,0);
SE = ones(3,3);
SE(3,3) = 0;
%ErodedIMG = imerode(DoG,SE); 
%morphedIMG = imdilate(DoG,SE); 
%morphedIMG = imerode(morphedIMG,SE); 

%morphedIMG = bwmorph(DoG,'close');
%imshow(morphedIMG);

%%
figure; 
imshow(dog(I,9,10,0)*0.1+F);
%figure; 
%imshow(dog(I,9,10,0)*0.1+ErodedIMG);
%}