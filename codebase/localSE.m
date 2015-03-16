function [val,Ise] = localSE(I,report_func,kernelSize, varargin )
%NOISEMSE Summary of this function goes here
%   Detailed explanation goes here

if ~isa(report_func, 'function_handle')
     error('argument type should be a function handle')
end
% compute metric and return value
Ise = seFilt(I, kernelSize);
val = feval(report_func,Ise(~isnan(Ise)));

if nargout == 2
    varargout{1} = Ise;
end

if nargin >= 4 && varargin{1} == 1
    figure; hist(Icov(~isnan(Icov)), 30);
    title(['CoV deviation Histogram, kernelSize = [' num2str(kernelSize) ']'])
end

end



