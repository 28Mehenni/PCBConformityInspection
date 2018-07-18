function output = separate (img, seuil)
output = double(img);
R = output(:,:,1);
G = output(:,:,2);
B = output(:,:,3); 
moy = (R + G + B)/3;

R(abs(output(:,:,1) - moy)>seuil) = 0; 
G(abs(output(:,:,2) - moy)>seuil) = 0;
B(abs(output(:,:,3) - moy)>seuil) = 0;
Value = R.*G.*B; 
Value(Value > 0) = 1;
output(:,:,1) = Value .* output(:,:,1);
output(:,:,2) = Value .* output(:,:,2);
output(:,:,3) = Value .* output(:,:,3);
figure;imshow(output);
end

