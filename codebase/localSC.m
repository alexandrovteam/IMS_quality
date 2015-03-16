function [val, varargout] = localSC( I, type, kernelSize, varargin )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if ~isa(type, 'function_handle')
     error('argument type should be a function handle')
end
% compute metric and return value
Isc = mocFilt(I, kernelSize);
val = feval(type,Isc(~isnan(Isc)));

if nargout == 2
    varargout{1} = Isc;
end

if nargin >= 4 && varargin{1} == 1
    figure; hist(Icov(~isnan(Icov)), 30);
    title(['CoV deviation Histogram, kernelSize = [' num2str(kernelSize) ']'])
end

end

