function SurveyStruct_upd = findAndAddToSurveyStruct( SearchIn, SearchFor, ExtractFrom, SurveyStruct, structPlace, varnames ) %#ok<INUSL>
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Nitems = length(SearchFor);
info = cell(Nitems,1);
varnames = genvarname(varnames);
SurveyStruct_upd = SurveyStruct;

for k = 1:Nitems
    ind = find(strcmpi(SearchIn,SearchFor{k}));
    foundValue = ExtractFrom{ind};
    
    % If foundValue = "-oth-" then search for "other"-alterantive
    if strcmpi(foundValue,'-oth-')
        info{k} = ExtractFrom{ind + 1};
    else
        info{k} = foundValue;
    end
    
    % add to struct
    if ischar(info{k});
        aposInd = find(info{k} == '''');
        
        if ~isempty(aposInd)
            for m = 1:length(aposInd);
                info{k} = [ info{k}(1:aposInd(m)-1) '''''' info{k}(aposInd(m)+1:end) ];
            end
        end
        
        info{k} = ['''' info{k} ''''];
        
    else
        info{k} = num2str(info{k});
    end
    eval([ 'SurveyStruct_upd.User(structPlace).' varnames{k} '=' info{k} ';']);
    
end

end

