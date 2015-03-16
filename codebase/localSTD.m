function [val, varargout] = localSTD( I, type, kernelSize, varargin )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if ~isa(type, 'function_handle')
     error('argument type should be a function handle')
end
% compute metric and return value
Istd = stdFilt(I, kernelSize);
val = feval(type,Istd(~isnan(Istd)));

if nargout == 2
    varargout{1} = Istd;
end

if nargin >= 4 && varargin{1} == 1
    figure; hist(Istd(~isnan(Istd)), 30);
    title(['Standard deviation Histogram, kernelSize = [' num2str(kernelSize) ']'])
end

end

