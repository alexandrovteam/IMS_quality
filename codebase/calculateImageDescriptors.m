function ResultsFromImcube = calculateImageDescriptors( ImCube, mz, window )
%   Wrapper function for calculating the image descriptors for a given 
%   Image cube.
%       - mzVals is the mz values for the images in ImCube.
%       - window is the window size that should be used for some of the image

% Check if user has parallel computing capabillities
[hasParallelToolbox, version] = getVersionInfoForParallel();
if hasParallelToolbox
    useParallel = true;
    if version >= 6.3
        parpool;
    else
        if matlabpool('size') == 0;
            matlabpool open;
        end
    end
    
else
    useParallel = false;
end
ImCube = normaliseScaleImCube(ImCube);
% Use appropriate function to calculate the image decriptors
if useParallel
    fprintf('parallel methods need updating to current set \n')
%     ResultsFromImcube = evaluateMethodsParallel(ImCube, mz, window);
else
    ResultsFromImcube = evaluateMethods(ImCube, mz, window);
end

end