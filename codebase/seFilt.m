function Ise = seFilt( I, kernelSize )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if isempty(kernelSize)
    ImedGauss = I;
else
    % Gauss filtering
    gaussKernel = fspecialIM('gaussian',kernelSize);
    ImedGauss = conv2(I, gaussKernel, 'same');
end
% Calculate MSE
Ise = (I - ImedGauss).^2;
