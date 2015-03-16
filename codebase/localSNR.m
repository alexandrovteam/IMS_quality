function [val, varargout] = localSNR( I, type, kernelSize, varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if ~isa(type, 'function_handle')
     error('argument type should be a function handle')
end

Isnr = snrFilt(I, kernelSize);
val = feval(type, Isnr(~isnan(Isnr)) );

if nargout == 2
    varargout{1} = Isnr;
end

if nargin >= 4 && varargin{1} == 1
    figure; hist(Isnr(~isnan(Isnr)), 30);
    title(['SNR Histogram, kernelSize = [' num2str(kernelSize) ']'])
end

end

