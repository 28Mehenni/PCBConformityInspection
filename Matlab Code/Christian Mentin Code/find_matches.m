function [ matches_found, Input_Image_removed_features ] = find_matches( Input_Image, Element_of_Interest, type, tolerance,plot_ON )

tic
% Initiation---------------------------------------------------------------
matches_found = zeros(size(Input_Image));
Input_Image = double(Input_Image); 
Input_Image_removed_features = Input_Image;
% Traitement du l'image de composant modèle--------------------------------
Element_of_Interest = im2bw(Element_of_Interest,0.75);
Element_of_Interest = double(Element_of_Interest);
% Find matching------------------------------------------------------------
maximum_convolution_value = max(max(conv2(Element_of_Interest, Element_of_Interest,'same')))
 
for rotation = 1:1:2;
    %Rotation
    Element_of_Interest = imrotate(Element_of_Interest,90*(rotation-1));
    %convolute with Element_of_Interest
    convolution_mtx = conv2(double(Input_Image),double(Element_of_Interest),'same');
    %figure;surf(convolution_mtx);shading flat,title('convolution 1');
     
    %maximum matching value
    detected_global_maximum = max(max(convolution_mtx(:)));
    %filter best convolution fittings
    convolution_mtx(convolution_mtx<(maximum_convolution_value  - maximum_convolution_value*tolerance)) = 0;   
    %figure;surf(convolution_mtx);shading flat;title('convolution 2');
    %figure;imshow(convolution_mtx);title('convolution 3');
    %
    % convolution_mtx = bwmorph(convolution_mtx,'shrink',inf); % en noir et blanc
    maxima = bwmorph(convolution_mtx,'shrink',inf); 
 %-------------------------------------------------------------------------
    % maxima = imregionalmax(convolution_mtx); % convertir en un seul point 
    %figure;imshow(maxima);title('maxima');
    toc  
    sizemaxima=size(maxima) % ca peut éliminer la condition
    if (size(maxima) ~= 0 );
        if(min(min(maxima)) == 0);
            for x = 1:1:size(maxima,1);
                for y = 1:1:size(maxima,2);
                    if maxima(x,y) > 0 % juste un point 
                        matches_found(x,y) = type+rotation-1;
                        for x1 = 1:1:size(Element_of_Interest,1);
                          for y1 = 1:1:size(Element_of_Interest,2);
                            %remove found Elements from Image 
                             x2 = abs(x+x1-(floor(size(Element_of_Interest,1)./2)));
                             if x2 == 0
                                 x2 = 1;
                             end
                             y2 = abs(y+y1-(floor(size(Element_of_Interest,2)./2)));
                             
                             if y2 == 0
                                 y2 = 1;
                             end
                            Input_Image_removed_features(x2,y2,:) = 0;
                          end
                        end
                    end
                end
            end
        end
    end
end
% Only for visualization---------------------------------------------------
if(strcmp(plot_ON,'plot_ON') == 1)
    
    figure;
    imshow(Input_Image);
    hold on

    for x = 1:1:size(matches_found,1);
        for y = 1:1:size(matches_found,2);
            if matches_found(x,y) == 1
                plot(y,x,'Marker','s','MarkerFaceColor','b','Markersize',3,'MarkerEdgeColor','none');
                text(y,x,'\color{blue} 0°');
            end
            if matches_found(x,y) == 2
                plot(y,x,'Marker','s','MarkerFaceColor','r','Markersize',3,'MarkerEdgeColor','none');
                text(y,x,'\color{red} 90°');
            end
        end
    end
    
end

end