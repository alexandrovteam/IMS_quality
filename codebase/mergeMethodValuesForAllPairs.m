function methodValues_merged = mergeMethodValuesForAllPairs( MethodValueTable, bestValueStr )
%UNTITLED9 Summary of this function goes here
%   Merge a table of method values into one value/pair
%   MethodValueTable is a Nx2 matrix where N is the number of pairs
%
%   bestValueStr is the string 'High' or 'Low' and it describes if a low or
%   high numeric value represents the better image quality.

if strcmpi('High', bestValueStr )
    % Right - Left
    methodValues_merged = MethodValueTable(:,2) - MethodValueTable(:,1);
    
elseif strcmpi('Low', bestValueStr)
    % Left - Right
    methodValues_merged = MethodValueTable(:,1) - MethodValueTable(:,2);
    
else
    error('unrecognised input ''bestValueStr''')
end

end

