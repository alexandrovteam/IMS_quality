function factorNames = extractFactorNamesFromDatasetDescriptors( DatasetDescriptorCell )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

NFactors = length(DatasetDescriptorCell{1}.factor);
factorNames = cell(1, NFactors);

for k = 1:NFactors
    factorNames{k} = DatasetDescriptorCell{k}.factor(k).name;
end

end

