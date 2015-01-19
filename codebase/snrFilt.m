function Isnr = snrFilt( I, kernelSize )
%UNTITLED3 Summary of this function goes here
%   SNR filter that works by creating an image cube of shifted images and
%   then calulates the snr along the 3:rd dimension instead of using
%   for-loops. This speeds up the filter.

ImCube = shiftIm(I, kernelSize);

Istd = std(ImCube,0,3);
Imean = mean(ImCube,3);
n=kernelSize(1)*kernelSize(2);
Isnr = (1/sqrt(n-1))*(Imean./Istd);

% Set NaN:s from 0/0 division = 0
NaNbefore = isnan(Istd);
SampleAfter = ~isnan(Isnr);
Isnr( (NaNbefore+SampleAfter)==0 ) = 0;

% Remove pixels at the border to correct for overlap caused by shiftIm
Isnr = skipBorder(Isnr, kernelSize);


end