function Ilum = lumFilt( I, kernelSize )
% Calculate coefficient of varation 
% can either calculate on a moving window or the whole image
if isempty(kernelSize) % whole image
    Ilum = luminance(I);
else % moving window
    warning('luminance only defined pixel-by-pixel, returning zeros')
    Ilum=zeros(size(I));
end