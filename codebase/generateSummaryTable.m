function [response,factorLevels,descriptorNames,factorNames,imMethodNames] = generateSummaryTable( DatasetDescriptorCell, mode, varargin )
%   Function for ploting the main effects of the DoE factors in
%   DatasetDescriptorCell.
%
%   Uses:
%   plotMainEffectsForDatasets( DatasetDescriptorCell, 'all')
%   plotMainEffectsForDatasets( DatasetDescriptorCell, 'single', nameOfImMethod, nameOfDescriptor)
%   plotMainEffectsForDatasets( DatasetDescriptorCell, 'fixedDescriptor', nameOfDescriptor)
%   plotMainEffectsForDatasets( DatasetDescriptorCell, 'fixedImMethod', nameOfImMethod)
%
%   Input:
%   -   DatasetDescriptorCell is a cell array where each cell represents a
%       MALDI dataset. Each cell contains a struct with information on the
%       DoE and the values of the Dataset descriptors. This variable is
%       created by the script CalculateDatasetDescriptorsForAll.
%   -   The second input paramter 'mode' specifies which data you want to
%       plot the main effects for:
%       *   mode = 'all'                All combinations.
%       *   mode = 'single'             Single combination of Image
%                                       descriptor and Dataset descriptor.
%       *   mode = 'fixedDescriptor'    All Image descriptors for a given
%                                       Dataset descriptor.
%       *   mode = 'fixedImMethod'      All Dataset descriptors for a given
%                                       Image descriptor.
%   -   nameOfImMethod is the exact name of the wanted Image descriptor.
%   -   nameOfDescriptor is the exact name of the wanted Dataset descriptor.

savePlot = 0;

NImMethods = length(DatasetDescriptorCell{1}.imMethod);
NDescriptors = length(DatasetDescriptorCell{1}.imMethod(1).descriptor);
NDatasets = length(DatasetDescriptorCell);

% Get names of all image descriptors
imMethodNames = cell(NImMethods,1);
for k = 1:NImMethods
    imMethodNames{k} = DatasetDescriptorCell{1}.imMethod(k).name;
end

% Get names of all dataset descriptors
descriptorNames = cell(NDescriptors,1);
for k = 1:NDescriptors
    descriptorNames{k} = DatasetDescriptorCell{1}.imMethod(1).descriptor(k).name;
end

if (nargin == 2 && ~strcmpi(mode, 'all')) || nargin < 4 && strcmpi(mode, 'single')
    error('Not enough input arguments for selected mode')
end

% Handle different modes determined by input 'mode'
if strcmpi(mode, 'all')
    %% All
    imMethLoop = 1:NImMethods;
    descriptorLoop = 1:NDescriptors;
    
elseif strcmpi(mode, 'single')
    %% Single
    indMeth = find(strcmpi(imMethodNames, varargin{1}));
    indDescr = find(strcmpi(descriptorNames, varargin{1}));
    
    if (isempty(indMeth) && isempty(indDescr)) || (~isempty(indMeth) && ~isempty(indDescr))
        error('Invalid string for varargin{1}')
    else
        if isempty(indMeth)
            descriptorLoop = indDescr;
            indMeth = find(strcmpi(imMethodNames, varargin{2}));
            
            if ~isempty(indMeth)
                imMethLoop = indMeth;
            else
                error('Invalid string for varargin{2}')
            end
            
        else
            imMethLoop = indMeth;
            indDescr = find(strcmpi(descriptorNames, varargin{2}));
            
            if ~isempty(indDescr)
                descriptorLoop = indDescr;
            else
                error('Invalid string for varargin{2}')
            end
        end
    end
    
elseif strcmpi(mode, 'fixedDescriptor')
    %% Fixed Descriptor
    indDescr = find(strcmpi(descriptorNames, varargin{1}));
    
    if ~isempty(indDescr)
        descriptorLoop = indDescr;
        imMethLoop = 1:NImMethods;
    else
        error('Invalid string for varargin{1}')
    end
    
elseif strcmpi(mode, 'fixedImMethod')
    %% Fixed Image method
    indMeth = find(strcmpi(imMethodNames, varargin{1}));
    
    if ~isempty(indMeth)
        imMethLoop = indMeth;
        descriptorLoop = 1:NDescriptors;
    else
        error('Invalid string for varargin{1}')
    end
    
else
    error('Unknown string for input ''mode''')
end


%% Loop through and plot
% Get Names and levels of factors used for the datasets
factorLevels = extractFactorLevelsFromDatasetDescriptors( DatasetDescriptorCell );
factorNames = extractFactorNamesFromDatasetDescriptors( DatasetDescriptorCell );

for n=1:length(factorNames)
    factorLabels(:,n) = cellfun(@(x,y) strcat(x,strrep(y,' ','')),factorLevels(:,n),factorNames(n),'UniformOutput',false);
end

% Fix for case when factor levels are either 'High' or 'Low'. If first entry is
% 'High' for any factor then reverse the x-axis to prevent
% confusing labeling of x-axis
indToReverse = reverseXDirIfNeed(factorLevels);

figHand = [];
count = 1;
response = cell(length(descriptorLoop),1);

for d = descriptorLoop
    response{d} = zeros(NDatasets,1);

    for im = imMethLoop
         response{d,im} = extractResponseFromDatasetDescriptors(DatasetDescriptorCell, im, d);
    end
end

if nargout > 0
    varargout{1} = figHand;
end

end

