function Istd = covFilt( I, kernelSize )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

ImCube = shiftIm(I, kernelSize);
n=kernelSize(1)*kernelSize(2);
Istd = (1/sqrt(n-1))*(std(ImCube,0,3) ./ mean(ImCube,3));
% Remove pixels at the border to correct for overlap caused by shiftIm
Istd = skipBorder(Istd, kernelSize);
end