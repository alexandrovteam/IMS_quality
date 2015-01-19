function varargout = plotMainEffectsForDatasets( DatasetDescriptorCell, mode, varargin )
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

savePlot = 1;

NImMethods = length(DatasetDescriptorCell{1}.imMethod);
NDescriptors = length(DatasetDescriptorCell{1}.imMethod(1).descriptor);

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

%% Check and prepare for special case when Quantiles should be plotted
indQuantile = find(findStringInCell(descriptorNames, 'Quantile'));
firstQuantInd = [];
if ~isempty(indQuantile)
    indToUse = intersect(indQuantile, descriptorLoop);
    % Remove all the quantile indices except the first. And create a flag
    % with that first index.
    if ~isempty(indToUse)
        descriptorLoop(indToUse(2:end)) = [];
        firstQuantInd = indToUse(1);
    end
end

%% Loop through and plot
% Get Names and levels of factors used for the datasets
factorLevels = extractFactorLevelsFromDatasetDescriptors( DatasetDescriptorCell );
factorNames = extractFactorNamesFromDatasetDescriptors( DatasetDescriptorCell );

% Fix for case when factor levels are either 'High' or 'Low'. If first entry is
% 'High' for any factor then reverse the x-axis to prevent
% confusing labeling of x-axis
indToReverse = reverseXDirIfNeed(factorLevels);

figHand = [];
count = 1;
for im = imMethLoop
    for d = descriptorLoop
        
        if ~isempty(firstQuantInd) && d == firstQuantInd
            %% Special plot case for quantiles
            figHand(count) = figure;
            
            % loop quantiles
            lowValues = nan(length(factorLevels), length(indToUse));
            highValues = nan(length(factorLevels), length(indToUse));
            NQuant = length(indToUse);
            legendCell = cell(NQuant,1);
            for q = 1:NQuant
                response = extractResponseFromDatasetDescriptors(DatasetDescriptorCell, im, d+q-1);
                [lowValues(:,q), highValues(:,q)] = calculateMainEffectsLowHigh(response, factorLevels);
                legendCell{q} = descriptorNames{indToUse(q)};
            end
            
            for f = 1:length(factorLevels)
                subplot(1,length(factorLevels),f)
                boxplot([lowValues(f,:) highValues(f,:)], [(1+zeros(size(lowValues(f,:)))) (2+zeros(size(highValues(f,:))))])
%                 hold all
%                 plot([lowValues(f,:); highValues(f,:)],'b')
                if f == 1
                    ylabel({'Mean' ['Image Desc. = ' imMethodNames{im} ', Dataset Desc. = Quantiles' ]})
                    
                end
                set(gca,'XTick',[1 2],'XTickLabel',{'High','Low'})
                xlabel(factorNames{f})
            end
            legend(legendCell, 'Location', 'NorthOutside')
            set(figHand(count), 'Name', ['Image Desc. = ' imMethodNames{im} ', Dataset Desc. = ' 'Quantiles'])

        else
            %% Normal plot case
            response = extractResponseFromDatasetDescriptors(DatasetDescriptorCell, im, d);
            figHand(count) = figure;
            [~,AXESH] = maineffectsplot(response, factorLevels, 'varnames', factorNames);
            set(figHand(count), 'Name', ['Image Desc. = ' imMethodNames{im} ', Dataset Desc. = ' descriptorNames{d}])
            
            % Use ylabel of leftmost plot as "title"
            axes(AXESH(1));
            ylabel({'Mean' ['ImMethod = ' imMethodNames{im} ', Descriptor = ' descriptorNames{d}]})
            
            if ~isempty(indToReverse)
                set(AXESH(indToReverse),'XDir','Reverse')
            end
        end
        count = count + 1;
        if savePlot
            save_str = ['main_effects_images' filesep get(gcf, 'Name')];
            save_str = strrep(save_str,'=','_');
            save_str = strrep(save_str,' ','');
            save_str = strrep(save_str,'.','');
            save_str = strrep(save_str,',','');

           saveas(gcf,[save_str '.png']) 
        end
    end
end

if nargout > 0
    varargout{1} = figHand;
end

end

