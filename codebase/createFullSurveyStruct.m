function FullSurveyStruct = createFullSurveyStruct( directory, SurveyPairList, FullPairList, varargin )
%   Creates a struct called FullSurveyStruct by merging individual survey 
%   responses in the directory. The FullSurveyStruct contains all the 
%   information from the finished survey.
%
%   Uses:
%       FullSurveyStruct = createFullSurveyStruct( directory, SurveyPairList, FullPairList )
%       FullSurveyStruct = createFullSurveyStruct( directory, SurveyPairList, FullPairList, NInfoString, endString )
%
%   Input:
%   -   directory is a string with the path to the folder where the files
%       are.
%   -   SurveyPairList is a Nx1 cell array, where N is the number of
%       individual surveys that make up the full survey. Each cell contains
%       the Mx2 list of pairs identifiers that belong to that survey, M is 
%       the number of image pairs in each survey.
%   -   FullPairList is a Zx2 pair list that holds all the image pair
%       identifiers in the whole survey, Z is the total number of pairs in
%       the full survey.
%
%   -   NInfoString is a survey parameter that says how many initial 
%       fields the csv-files have before the custom fields start appearing.
%       DEFAULT value is set to 6 (3DMassomics survey)
%   -   endString is a survey specific paramter that says what the field
%       name is in the csv-files.
%       DEFAULT value is set to 'QEval_CommentTime' (3DMassomics survey)

%% Input Check
if nargin == 3
    NInfoStrings = 6;
    endString = 'QEval_CommentTime';
elseif nargin == 4
    error('Must be either 3 or 5 input paramters')
else
    if isnumeric(varargin{1}) && ischar(varargin{2})
        NInfoStrings = varargin{1};
        endString = varargin{2};
    else
        error('Input ''NInfoStrings'' must be numeric and ''endString'' must be a string')
    end
end

if ~iscell(SurveyPairList)
    error('Input SureyPairList should be a cell array')
end

if size(FullPairList,2) ~= 2 || size(SurveyPairList{1},2) ~= 2
    error('Pair information in input must have 1 pair/row')
end

test = [SurveyPairList{:}];
if max(test(:)) ~= max(FullPairList(:))
    error('Image reference in pair input does not match')
end

%% Create FullSurveyStruct
% Import all csv-files in the directory. Each file produced a SurveyStruct
% that is stored in the cell array SurveyStructCell.
[SurveyStructCell, FileNames] = importCsvFiles(directory, NInfoStrings, endString);

% Merge the individual SurveyStructs into a FullSurveyStruct
FullSurveyStruct = mergeToFullSurveyStruct(SurveyStructCell, FileNames, SurveyPairList, FullPairList);

end
