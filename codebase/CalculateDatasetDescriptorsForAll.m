%   Script for calculating the dataset descriptors for all datasets and 
%   pairing that information with information about the DoE (design of
%   experiments).
%
%   Calculations are based on the values from the image descriptors for the
%   datasets. These calculations should be stored in a cell array called
%   MethodResultCell. Each cell in MethodResultCell should contain image
%   descriptor results from one of the datasets.
%
%   The MethodResultsCell is automatically created and saved after running 
%   the function calculateAllImCubesInDir.m
%
%   The results are stored in a cell array called DatasetDescriptorCell. 
%   DatasetDescriptorCell{k} is calculated on MethodResultsCell{k}.

%% Script is currently configured for 36 datasets (3 blocks, 12 sections each)
% This is what was used in the 3DMassomics Survey
%  NDatasets = 36;
function DatasetDescriptorCell = CalculateDatasetDescriptorsForAll(MethodResultCell,NBlocks,NSections)
NDatasets = NSections*NBlocks;
factorNames =               {'Washing', 'Matrix application', 'Laser shots', 'Laser size'};
factorLevelsForSection{1} =     {'Low',         'Low',          'Low',          'High'};
factorLevelsForSection{2} =     {'Low',         'Low',          'High',         'Low'};
factorLevelsForSection{3} =     {'High',        'Low',          'Low',          'Low'};
factorLevelsForSection{4} =     {'High',        'Low',          'High',         'High'};
factorLevelsForSection{5} =     {'Low',         'High',         'Low',          'Low'};
factorLevelsForSection{6} =     {'Low',         'High',         'High',         'High'};
factorLevelsForSection{7} =     {'High',        'High',         'Low',          'High'};
factorLevelsForSection{8} =     {'High',        'High',         'High',         'Low'};
%factorLevelsForSection{9} =     {'Low',         'Low',          'High',         'Low'};
%factorLevelsForSection{10} =    {'Low',         'Low',          'High',         'Low'};
%factorLevelsForSection{11} =    {'High',        'High',         'Low',          'High'};
%factorLevelsForSection{12} =    {'High',        'High',         'Low',          'High'};

%% Check MethodResultsCell
varNames = who;
found = strcmp(varNames, 'MethodResultCell');
if sum(found) == 0
    error(['The image descriptor results for the datasets must be stored in a variable named ''MethodResultsCell'' prior to running the script'])
end

if length(MethodResultCell) ~= NDatasets;
    error(['Number of datasets in MethodResultCell must be: ' num2str(NDatasets)])
end

%% Print info
disp(' ')
disp(['Number of Datasets: ' num2str(NDatasets)])
disp(['Number of Blocks: ' num2str(NBlocks)])
disp(['Number of Sections: ' num2str(NSections)])
disp('Factor Names:')
disp(factorNames')
disp(' ')

%% Calculate
DatasetDescriptorCell = cell(NDatasets,1);
count = 0;
for b = 1:NBlocks
    for s  = 1:NSections
        count = count + 1;
        DatasetDescriptorCell{count} = calculateDatasetDescriptors( ...
            MethodResultCell{count}, b, s, factorNames, factorLevelsForSection{s});
    end
end

% Clear clutter
clear varNames found count b s

disp('Finished!')
disp('Results stored in variable: DatasetDescriptorCell')
