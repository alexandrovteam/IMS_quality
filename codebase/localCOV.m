function [val, varargout] = localCOV( I, type, kernelSize, varargin )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if any([strcmpi(type, 'mean') strcmpi(type, 'median')]) == 0
    error('Argument ''type'' must be either ''mean'' or ''median''')
end
switch type
    case  'mean'
    Istd = covFilt(I, kernelSize);
    val = mean(Istd(~isnan(Istd)));
    
    case 'median'
    Istd = covFilt(I, kernelSize);
    val = median(Istd(~isnan(Istd)));
    
end

if nargout == 2
    varargout{1} = Istd;
end

if nargin >= 4 && varargin{1} == 1
    figure; hist(Istd(~isnan(Istd)), 30);
    title(['Standard deviation Histogram, kernelSize = [' num2str(kernelSize) ']'])
end

end

