function wasFound = findStringInCell( CellStr, pattern, varargin )
%UNTITLED Summary of this function goes here
%   Find occurences of pattern string in a cell array of strings
%   Case-insensitive

if nargin > 2 
    if strcmpi(varargin{1}, 'caseSensitive')
        ind = strfind(CellStr, pattern);
    else
        error('Unknown input string')
    end
else
    ind = strfind(upper(CellStr), upper(pattern));
end

wasFound = ~cellfun(@isempty, ind);

end

