function [SurveyStructCell, varargout] = importCsvFiles( directory, varargin)
%   Import all LimeSurvey exported csv-files in the directory and store
%   them in a cell array called SurveyStructCell. Each cell holds a struct
%   representing one file.
%
%   Uses:
%   SurveyStructs = importCsvFiles( directory )
%   SurveyStructs = importCsvFiles( directory, NInfoStrings, endString )
%   [SurveyStructs, FileNames] = importCsvFiles( directory, NInfoStrings, endString )
%
%   Input:
%   -   directory is a string with the path to the folder where the files
%       are.
%   -   NInfoString is a survey parameter that says how many initial 
%       fields the csv-files have before the custom fields start appearing.
%       DEFAULT value is set to 6 (3DMassomics survey)
%   -   endString is a survey specific paramter that says what the field
%       name is in the csv-files.
%       DEFAULT value is set to 'QEval_CommentTime' (3DMassomics survey)

if nargin == 1
    NInfoStrings = 6;
    endString = 'QEval_CommentTime';
elseif nargin == 2
    error('Must be either 1 or 3 input paramters')
else
    if isnumeric(varargin{1}) && ischar(varargin{2})
        NInfoStrings = varargin{1};
        endString = varargin{2};
    else
        error('Input ''NInfoStrings'' must be numeric and ''endString'' must be a string')
    end
end

FileNames = findAllCsvFiles( directory );
NFiles = length(FileNames);

if NFiles == 0
    SurveyStructCell = {};
    
else
    for k = 1:NFiles
        SurveyStructCell{k,1} = importSurveyResults(fullfile(directory, FileNames{k}), ...
            NInfoStrings, endString );
    end
end

if nargout > 1
    varargout{1} = FileNames;
end

end

