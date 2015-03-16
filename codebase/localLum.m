function [val, varargout] = localLum( I, type, kernelSize, varargin )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if ~isa(type, 'function_handle')
     error('argument type should be a function handle')
end
% compute metric and return value
Ilum = lumFilt(I, kernelSize);
val = feval(type,Ilum(~isnan(Ilum)));

if nargout == 2
    varargout{1} = Ilum;
end

if nargin >= 4 && varargin{1} == 1
    figure; hist(Icov(~isnan(Icov)), 30);
    title(['CoV deviation Histogram, kernelSize = [' num2str(kernelSize) ']'])
end

end

