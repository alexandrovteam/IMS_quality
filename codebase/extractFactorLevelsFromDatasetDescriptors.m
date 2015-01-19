function factorLevelsCell = extractFactorLevelsFromDatasetDescriptors( DatasetDescriptorCell )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

NDatasets = length(DatasetDescriptorCell);
NFactors = length(DatasetDescriptorCell{1}.factor);
factorLevels = cell(NDatasets, NFactors);

for k = 1:NDatasets
    for m = 1:NFactors
        factorLevels{k,m} = DatasetDescriptorCell{k}.factor(m).level;
    end
end

factorLevelsCell = cell(1,NFactors);
for k = 1:NFactors
    factorLevelsCell{k} = factorLevels(:,k);
end

end

