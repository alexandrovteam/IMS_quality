function [ hasParallelToolbox, version ] = getVersionInfoForParallel()
%   Function for fetching version information about the Parallel Computing 
%   Toolbox.

versionInfo = ver;
versionNames = {versionInfo.Name};

parallelInd = findStringInCell(versionNames, 'Parallel');

hasParallelToolbox = any(parallelInd);

if hasParallelToolbox
    version = str2double(versionInfo(parallelInd).Version);
else
    version = [];
end

end

