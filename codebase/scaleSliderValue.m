function [sliderValue_scaled, repSliderValue_scaled] = scaleSliderValue( sliderValue, repSliderValue )
%UNTITLED2 Summary of this function goes here
% Scale rater slider values
%  sliderValue - question pair slider values
%  repPairSliderValue - consistency check pair slider values

all_slider_values = [sliderValue; repSliderValue];
%   Scale slider values so that the maximum magnitude = 1
% maxMagnitude = max(abs([sliderValue; repSliderValue]));
% 
% sliderValue_scaled = sliderValue./maxMagnitude;
% repSliderValue_scaled = repSliderValue./maxMagnitude;


% warning('Scaling has been modified!')
% Interquartile scaling
%offset = median([sliderValue; repSliderValue]);
%scale =  iqr([sliderValue; repSliderValue])*0.75;
%sliderValue_scaled = (sliderValue - offset).*scale;
%repSliderValue_scaled = (repSliderValue - offset).*scale;

offset = min(abs(all_slider_values)); % make every user choose a zero values
scaling = std(all_slider_values - offset);% scale by the standard deviation

sliderValue_scaled = (sliderValue - offset)./scaling;
repSliderValue_scaled = (repSliderValue - offset)./scaling;

end
