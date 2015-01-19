function [val, varargout] = localSNR( I, type, kernelSize, varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if any([strcmpi(type, 'mean') strcmpi(type, 'median')]) == 0
    error('Argument ''type'' must be either ''mean'' or ''median''')
    
elseif strcmpi(type, 'mean')
    Isnr = snrFilt(I, kernelSize);
    val = mean( Isnr(~isnan(Isnr)) );
    
elseif strcmpi(type, 'median')
    Isnr = snrFilt(I, kernelSize);
    val = median( Isnr(~isnan(Isnr)) );
    
end

if nargout == 2
    varargout{1} = Isnr;
end

if nargin >= 4 && varargin{1} == 1
    figure; hist(Isnr(~isnan(Isnr)), 30);
    title(['SNR Histogram, kernelSize = [' num2str(kernelSize) ']'])
end

end

