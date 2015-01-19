function sliderValues_merged = mergeSliderValuesForAllPairs( SliderTable )
%UNTITLED8 Summary of this function goes here
%   Merge a table of slider values into one slider value/pair
%   SliderTable is a NxM matrix where N is the number of pairs and M is 
%   the number of slider values/pair.

% Mean
sliderValues_merged = mean(SliderTable,2);

end

