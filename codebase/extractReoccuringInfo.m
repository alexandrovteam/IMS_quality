function varargout = extractReoccuringInfo( CellToSearchIn, CellToExtractFrom, SearchFor, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

NOut = length(SearchFor);
varargout = cell(NOut,1);

ind = cell(NOut,1);
for k = 1:NOut
    nonEmpty = not( cellfun(@isempty, strfind(upper(CellToSearchIn),upper(SearchFor{k}))) );
    ind{k} = find(nonEmpty);
    foundValues = CellToExtractFrom(nonEmpty);
    
    if sum(strcmpi(varargin,'NonNaN')) >= 1
        nonNaN = not(cellfun(@isnan,foundValues));
        varargout{k} = foundValues( nonNaN );
        ind{k} = ind{k}(nonNaN);
    else
        varargout{k} = foundValues;
    end
    
    if sum(strcmpi(varargin,'cell2mat'))
        varargout{k} = cell2mat(varargout{k});
    end
end

if sum(strcmpi(varargin,'returnInd')) >= 1
    if nargout == NOut+1
        varargout{NOut+1} = ind;
    else
        error('Too few output arguments')
    end
end

end

