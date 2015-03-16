function Ilum = luminance(rgb_im)
%Compute luminance from RGB
if size(rgb_im,3) ~= 3
    error('image should be rgb')
end

Ilum = 0.2126*rgb_im(:,:,1) + 0.7152*rgb_im(:,:,2) +0.0722*rgb_im(:,:,3);

