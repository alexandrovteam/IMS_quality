function DatasetDescriptors = calculateDatasetDescriptors( MethodResultStruct, dataBlock, dataSection, factorNames, factorLevels )
%   Calculate dataset descriptors for a dataset that has been evaluated by
%   the function calculateImageDescriptorsForImCube. Also store information
%   about the DoE (Design of experiments) that was used.
%
%   The 4 last input parameters are for the DoE
%   -   dataSection = The Section that this dataset belongs to. A section
%       is one combination of factorLevels.
%   -   dataBlock = The Block that this dataset belongs to. Blocks consist of
%       multiple Sections. All Blocks are identical with regards to the
%       factorNames and factorLevels included.
%   -   factorNames = Cell with names of the factors (parameters) in the 
%       Design of Experiments that was used.
%   -   factorLevels = Cell with levels for the factors in this dataset.

NImMethods = length(MethodResultStruct.method);
DatasetDescriptors.dataBlock = dataBlock;
DatasetDescriptors.dataSection = dataSection;

NFactors = length(factorNames);
if NFactors ~= length(factorLevels)
    error('size of factorNames must be the same as factorLevels')
end

% Store factor information
for k = 1:NFactors
    DatasetDescriptors.factor(k).name = factorNames{k};
    DatasetDescriptors.factor(k).level = factorLevels{k};
end

%% Loop through the data from the different image descriptors
for m = 1:NImMethods
    DatasetDescriptors.imMethod(m).name = ...
        MethodResultStruct.method(m).name;
    DatasetDescriptors.imMethod(m).windowUsed = ...
        MethodResultStruct.method(m).window;
    
    %% Mean
    DatasetDescriptors.imMethod(m).descriptor(1).name = 'Mean';
    DatasetDescriptors.imMethod(m).descriptor(1).description = 'Mean of all mz-image values';
    
    DatasetDescriptors.imMethod(m).descriptor(1).value = ...
        mean(MethodResultStruct.method(m).values);
    
    %% Median
    DatasetDescriptors.imMethod(m).descriptor(2).name = 'Median';
    DatasetDescriptors.imMethod(m).descriptor(2).description = 'Median of all mz-image values';
    
    DatasetDescriptors.imMethod(m).descriptor(2).value = ...
        median(MethodResultStruct.method(m).values);
    
    %% Variance
    DatasetDescriptors.imMethod(m).descriptor(3).name = 'Variance';
    DatasetDescriptors.imMethod(m).descriptor(3).description = 'Variance of all mz-image values';
    
    DatasetDescriptors.imMethod(m).descriptor(3).value = ...
        var(MethodResultStruct.method(m).values);
    
    %% Quantiles
    qToUse = [0.05 0.25 0.5 0.75 0.95];
    NQuant = length(qToUse);
    for k = 1:NQuant
        DatasetDescriptors.imMethod(m).descriptor(k+3).name = ['Quantile ' num2str(qToUse(k))];
        DatasetDescriptors.imMethod(m).descriptor(k+3).description = ['The ' num2str(qToUse(k)) '-quantile'];
        
        DatasetDescriptors.imMethod(m).descriptor(k+3).value = ...
            quantile(MethodResultStruct.method(m).values, qToUse(k));
    end
    
    %% Range (max - min)
    DatasetDescriptors.imMethod(m).descriptor(NQuant+4).name = 'Range';
    DatasetDescriptors.imMethod(m).descriptor(NQuant+4).description = 'The difference between the max and min of all mz-image values';
    
    DatasetDescriptors.imMethod(m).descriptor(NQuant+4).value = ...
        max(MethodResultStruct.method(m).values) - min(MethodResultStruct.method(m).values);
    
    %% Area under curve
    DatasetDescriptors.imMethod(m).descriptor(NQuant+5).name = 'CurveArea';
    DatasetDescriptors.imMethod(m).descriptor(NQuant+5).description = 'The area under the curve. (Integration is done on the sorted curve)';
    
    DatasetDescriptors.imMethod(m).descriptor(NQuant+5).value = ...
        trapz(sort(MethodResultStruct.method(m).values));
    
    %% MAD (Median Absolute Deviation)
    DatasetDescriptors.imMethod(m).descriptor(NQuant+6).name = 'MAD';
    DatasetDescriptors.imMethod(m).descriptor(NQuant+6).description = 'Median Absolute Deviation of all mz-image values';
    
    DatasetDescriptors.imMethod(m).descriptor(NQuant+6).value = ...
        mad(MethodResultStruct.method(m).values, 1);
    
end

end