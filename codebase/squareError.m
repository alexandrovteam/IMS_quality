function [MSE, varargout] = squareError( I, varargin )
%NOISEMSE Summary of this function goes here
%   Detailed explanation goes here

% Median filtering
Imed = medianFilt(I, [3 3]);

% Gauss fitlering
gaussKernel = fspecialIM('gaussian',5);

ImedGauss = conv2(Imed, gaussKernel, 'same');

% Skip border values of gauss
ImedGauss = skipBorder(ImedGauss, [5 5]);

% Remove border values of original image for comparison
Iskipped = skipBorder(I,[7 7]);

% Calculate MSE
SE = (Iskipped - ImedGauss).^2;
MSE = mean(SE(~isnan(SE)));

if nargout == 2
    varargout{1} = SE;
end

if nargin >= 2 && varargin{1} == 1
    figure; hist(SE);
    title(['Square Error Histogram'])
end

end

