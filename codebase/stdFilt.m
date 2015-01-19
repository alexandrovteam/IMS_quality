function Istd = stdFilt( I, kernelSize )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if any(I(:)>1)
    error('function requires data scaled [0 1]')
end
ImCube = shiftIm(I, kernelSize);

Istd = 2*std(ImCube,0,3);
% Remove pixels at the border to correct for overlap caused by shiftIm
Istd = skipBorder(Istd, kernelSize);

end