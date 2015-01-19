function FullSurveyStruct = mergeToFullSurveyStruct( SurveyStructCell, FileNames, SurveyPairList, FullPairList )
%   Merge the individual Survey structs in SurveyStructCell into a 
%   FullSurveyStruct.
%   
%   NOTE: SurveyID will only be correct as long as the number of surveys in
%   SurveyStructCell <= 99
%
%   -   FileNames is a cell array containing the names of the files that
%       were used to create SurveyStructCell.
%   -   SurveyPairList is a Nx1 cell array, where N is the number of
%       individual surveys that make up the full survey. Each cell contains
%       the Mx2 list of pairs identifiers that belong to that survey, M is 
%       the number of image pairs in each survey.
%   -   FullPairList is a Zx2 pair list that holds all the image pair
%       identifiers in the whole survey, Z is the total number of pairs in
%       the full survey.

NSurveys = length(SurveyStructCell);

if length(FileNames) ~= NSurveys
    error('SurveyStructCell & FileNames must have same length')
end

%% Loop surveys
for k = 1:NSurveys
    beginInd = strfind(FileNames{k}, '100');
    SurveyID = str2double(FileNames{k}(beginInd + 3: beginInd + 4));
    
    tmpStruct = SurveyStructCell{k}.User;
    tmpStruct = rmfield(tmpStruct, 'id');
    
    %% Flip Impairs and slider values according to LRFlip. Also scale the slider values.
    sliderValue_plan = adjustSliderSign(tmpStruct.sliderValue_survey, ...
        tmpStruct.LRFlipValue);
    repSliderVal_plan = adjustSliderSign(tmpStruct.repPairSliderValue_survey, ...
        tmpStruct.repPairLRFlipValue);
    [sliderValue_planScaled, repSliderVal_planScaled] = scaleSliderValue( ...
        sliderValue_plan, repSliderVal_plan);
    
    ImPairs_plan = SurveyPairList{SurveyID};
    ImPairs_survey = adjustImPairFlip( ImPairs_plan, tmpStruct.LRFlipValue );
    
    %% Add to struct
    tmpStruct.sliderValue_plan = sliderValue_plan;
    tmpStruct.sliderValue_planScaled = sliderValue_planScaled;
    tmpStruct.repPairSliderValue_plan = repSliderVal_plan;
    tmpStruct.repPairSliderValue_planScaled = repSliderVal_planScaled;
    
    tmpStruct.SurveyID = SurveyID;
    tmpStruct.ImPairs_plan = ImPairs_plan;
    tmpStruct.ImPairs_survey = ImPairs_survey;
    
    FullSurveyStruct.Response(k) = tmpStruct;
end

FullSurveyStruct.AllImPairs_plan = FullPairList;
end



