function [response, varargout] = extractResponseFromDatasetDescriptors( DatasetDescriptorCell, imMethodInd, descriptorInd )
%UNTITLED3 Summary of this function goes here
%   response = extractResponseFromDatasetDescriptors( DatasetDescriptorCell, imMethodInd, descriptorInd )
%   [response, imageMethodName, datasetDescriptorName] = extractResponseFromDatasetDescriptors( DatasetDescriptorCell, imMethodInd, descriptorInd )

NDatasets = length(DatasetDescriptorCell);
response = nan(NDatasets,1);

for k = 1:NDatasets
    response(k) = DatasetDescriptorCell{k}.imMethod(imMethodInd).descriptor(descriptorInd).value;
end

if nargout > 1
    varargout{1} = DatasetDescriptorCell{1}.imMethod(imMethodInd).name;
    varargout{2} = DatasetDescriptorCell{1}.imMethod(imMethodInd).descriptor(descriptorInd).name;
end

end

