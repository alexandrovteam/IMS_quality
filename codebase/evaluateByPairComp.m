function CompResults = evaluateByPairComp( ImPairs, MethodResults, chosenLR, varargin  )
%UNTITLED Summary of this function goes here
%   CompResults = evaluateByPairComp( ImPairs, MethodResults, chosenLR)
%   CompResults = evaluateByPairComp( ImPairs, MethodResults, chosenLR, 'noDisp' )
%   CompResults = evaluateByPairComp( ImPairs, MethodResults, chosenLR, MethodsToDisplay )

NPairs = size(ImPairs,1);
Nmethods = length(MethodResults.method);

isLeftBest_human = descisionListFromHumanComp(chosenLR);

IsLeftBest_method = cell(Nmethods,1);
for m = 1:Nmethods
    leftValues = MethodResults.method(m).values( ImPairs(:,1) );
    rightValues = MethodResults.method(m).values( ImPairs(:,2) );
    if strcmpi(MethodResults.method(m).bestValue, 'high')
        IsLeftBest_method{m} = leftValues > rightValues;
        
    elseif strcmpi(MethodResults.method(m).bestValue, 'low')
        IsLeftBest_method{m} = leftValues < rightValues;
        
    else
        error('Corrupt input: MethodResults')
    end
    
    unison = isLeftBest_human == IsLeftBest_method{m};
    CompResults.method(m).name = MethodResults.method(m).name;
    CompResults.method(m).accuracy = sum(unison)./NPairs;
    CompResults.method(m).methodFavoured = [IsLeftBest_method{m} not(IsLeftBest_method{m})];
    CompResults.method(m).imageValues = [leftValues rightValues];
   
%     rows = find( not(unison) );
    NonUnisonPairs = ImPairs(not(unison),:);
%     for k = 1:length(rows)
%         if ~IsLeftBest_method{m}(rows(k))
%             NonUnisonPairs(k,:) = NonUnisonPairs(k,[2 1]);
%         end
%     end
    diffsUni = abs( diff( MethodResults.method(m).values(ImPairs(unison,:)), 1,2 ) );
    diffsNonUni = abs( diff( MethodResults.method(m).values(NonUnisonPairs), 1,2 ) );
    
    CompResults.method(m).unisonPairs = ImPairs(unison,:);
    CompResults.method(m).unisonInd = find(unison);
    CompResults.method(m).medianDiff_Unison = median(diffsUni);
    CompResults.method(m).meanDiff_Unison = mean(diffsUni);
    
    CompResults.method(m).nonUnisonPairs = NonUnisonPairs;
    CompResults.method(m).nonUnisonInd = find(not(unison));
    CompResults.method(m).medianDiff_NonUnison = median(diffsNonUni);
    CompResults.method(m).meanDiff_NonUnison = mean(diffsNonUni);

end
CompResults.imPairs = ImPairs;
CompResults.chosenLR_human = chosenLR;

if nargin > 3 && strcmpi(varargin{1},'noDisp')
    % Do nothing
else
    ind = cellfun(@isnumeric,varargin);
    if sum(ind) >= 1
        printCompResults(CompResults, varargin{ind});
    else
        printCompResults( CompResults );
    end
end

end

