function PairSliderValueTable = createPairSliderValueTable( FullSurveyStruct, varargin )
%   Creates a table for comparison between how humans and algorithms rated
%   image pairs. Returns a Mx(2+N) matrix, where M is the total number of pairs
%   available in FullSurveyStruct and N is the total number of responses 
%   each image pair has got.
%
%   Input
%   -   FullSurveyStruct is a struct containing all survey responses for
%       the finished survey. This variable is created using the function 
%       createFullSurveyStruct().
%   -   responsesPerPair is the number of responses/pair in
%       FullSurveyStruct.
%       Default value is 3 (3DMassomics Survey)

%% Input check
if nargin == 1
    responsesPerPair = 3;
else
    if isnumeric(varargin{1})
        responsesPerPair = varargin{1};
    else
        error('Input ''responsesPerPair'' must be numeric.')
    end
end

%% Calculate
NSurveys = length(FullSurveyStruct.Response);
AllImPairs_plan = FullSurveyStruct.AllImPairs_plan;
NTotalPairs = size(FullSurveyStruct.AllImPairs_plan, 1);
NUserPairs = size(FullSurveyStruct.Response(1).ImPairs_plan, 1);

Responses = nan(NTotalPairs, responsesPerPair);
respCounter = zeros(NTotalPairs,1);

% Loop through all survey responses and add the responses to the correct place
% in the matrix Responses
for s = 1:NSurveys
    userPairs = FullSurveyStruct.Response(s).ImPairs_plan;
    sliderVal_planScaled = FullSurveyStruct.Response(s).sliderValue_planScaled;

    for p = 1:NUserPairs
        currentPair = userPairs(p,:);
        foundRow = and(AllImPairs_plan(:,1) == currentPair(1), AllImPairs_plan(:,2) == currentPair(2));
        
        % Increase size of Response matrix to avoid zeros where there
        % should be NaN
        if respCounter(foundRow) == responsesPerPair
            Responses = [Responses nan(NTotalPairs, 1)];
            responsesPerPair = responsesPerPair + 1;
        end
        
        Responses(foundRow, respCounter(foundRow) + 1) = sliderVal_planScaled(p);
        respCounter(foundRow) = respCounter(foundRow) + 1;
        
    end
end
PairSliderValueTable = nan(NTotalPairs, 2+responsesPerPair);
PairSliderValueTable(:,1:2) = AllImPairs_plan;
PairSliderValueTable(:, 3:3+responsesPerPair-1) = Responses(:,1:responsesPerPair);

if ~isempty(find(isnan(PairSliderValueTable(:,3:end) ), 1) )
    warning(['Data does not meet requirement: ' num2str(responsesPerPair) ' responses/pair'])
end


end
