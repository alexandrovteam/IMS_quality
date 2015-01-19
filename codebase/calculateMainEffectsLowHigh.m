function [lowValues, highValues] = calculateMainEffectsLowHigh( response, factorLevels )
%UNTITLED3 Summary of this function goes here
%   Calculate the Low and High values of the main effects.
%
%   response is a vector.
%   factorLevels is a 1xN cell-array with the levels of the factors. The values
%   can be either 'High' or 'Low'. N is the number of factors. Each cell
%   contains another cell-array of size Mx1 where M is the number of data
%   points
%
%   Returns Low values for all factors (lowValues) and High values for all
%   factors (highValues)

NFactors = length(factorLevels);
NData = length(response);

if NData ~= length(factorLevels{1})
    error('Number of data entries in input does no match')
end

highValues = nan(NFactors,1);
lowValues = nan(NFactors,1);
for f = 1:NFactors
    indHigh = find(strcmpi(factorLevels{f}, 'High'));
    indLow = find(strcmpi(factorLevels{f}, 'Low'));
    
    if (length(indHigh) + length(indLow)) ~= NData
        error('input factorLevels must only contain ''High'' or ''Low''')
    end
    
    highValues(f) = mean(response(indHigh));
    lowValues(f) = mean(response(indLow));
end

end

