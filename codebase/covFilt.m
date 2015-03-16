function Icov = covFilt( I, kernelSize )
% Calculate coefficient of varation 
% can either calculate on a moving window or the whole image

if isempty(kernelSize) % whole image
    im_px = ~isnan(I);
    n=sum(im_px(:));
    Icov =  (1/sqrt(n-1))*(std(I(im_px)) ./ mean(I(im_px)));
else % moving window
    ImCube = shiftIm(I, kernelSize);
    n=kernelSize(1)*kernelSize(2);
    Icov = (1/sqrt(n-1))*(std(ImCube,0,3) ./ mean(ImCube,3));
    % Remove pixels at the border to correct for overlap caused by shiftIm
   % Icov = skipBorder(Icov, kernelSize);
end