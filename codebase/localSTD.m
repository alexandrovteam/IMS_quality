function [val, varargout] = localSTD( I, type, kernelSize, varargin )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if any([strcmpi(type, 'mean') strcmpi(type, 'median')]) == 0
    error('Argument ''type'' must be either ''mean'' or ''median''')
    
elseif strcmpi(type, 'mean')
    Istd = stdFilt(I, kernelSize);
    val = mean(Istd(~isnan(Istd)));
    
elseif strcmpi(type, 'median')
    Istd = stdFilt(I, kernelSize);
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

