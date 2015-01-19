function sliderValue_signAdjusted = adjustSliderSign( sliderValue, LRFlipValue )
%UNTITLED2 Summary of this function goes here
%   Change the sign of the slider value if corresponding flip value is true

sliderValue_signAdjusted = sliderValue;
sliderValue_signAdjusted(LRFlipValue) = -1 * sliderValue_signAdjusted(LRFlipValue);


end

