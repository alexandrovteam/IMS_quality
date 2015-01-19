function [ratings, timings, rawdata] = generateDataTables(data_struct,categoryFunction)
% loads a survey struct and outputs tables of values for analysis

% number of raters
nRaters = length(data_struct.Response); 
% Get the number of pairs assesed from the data
nObjects = length(data_struct.AllImPairs_plan);

ratings = nan + zeros(nObjects,nRaters);
timings = nan + zeros(nObjects,nRaters);        

for r = 1 : nRaters
    for n = 1 : size(data_struct.Response(r).ImPairs_plan,1)
        [v,pairNumber] = min(sum(abs( bsxfun(@minus,data_struct.AllImPairs_plan, data_struct.Response(r).ImPairs_plan(n,:))  ),2));
        if ~(v==0)
            warning('entry not matched')
        end
        % get ratings value from slider
        ratings(pairNumber,r) = data_struct.Response(r).sliderValue_planScaled(n);    
        timings(pairNumber,r) = data_struct.Response(r).timings(n);
    end
end


rawdata=ratings;
%turn slider values into a category
ratings = arrayfun(@(x) categoryFunction(x),ratings);
% if sum(ratings(~isnan(ratings(:))) - ratings(~isnan(ratings(:)))) 
%     error('calcKripAlpha:badInputFunction','categoriesation function should produce an integer labelling')
% end


