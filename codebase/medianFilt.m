function Imed = medianFilt( I, kernelSize )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

ImCube = shiftIm(I, kernelSize);

Imed = median(ImCube,3);
% Remove pixels at the border to correct for overlap caused by shiftIm
Imed = skipBorder(Imed, kernelSize);
    
end

