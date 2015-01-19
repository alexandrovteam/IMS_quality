function printCompResults( CompResults, varargin )
%UNTITLED Summary of this function goes here
%   printCompResults( CompResults, selectedMethod )

Nmethods = length(CompResults.method);

if nargin > 1 && isnumeric(varargin{1})
    methodsToDisplay = varargin{1};
else
    methodsToDisplay = 1:Nmethods;
end

dispCell = cell(length(methodsToDisplay),2);
for m = 1:length(methodsToDisplay)
    dispCell{m, 1} = CompResults.method(methodsToDisplay(m)).name;
    dispCell{m ,2} = CompResults.method(methodsToDisplay(m)).accuracy;
end
disp(' ')
disp(dispCell)

end

