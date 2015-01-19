function ResultCell = calculateImageDescriptorsForAllInDir( dataDir, window, saveDir)
%   Evaluate the proposed image descriptors for all the image cubes in
%   directory dataDir. Then save the results as separate mat-files in 
%   directory saveDir. window is a 1x2 array specifying the size of the 
%   window that should be used by some of the image descriptors.
%
%   dataDir must contain mat-files that each holds 1 image cube and 1
%   corresponding array of mz values. These must also be named according to
%   the follwing rule:
%       If the file name of a mat-file is 'name' then the variables within
%       must be called ImCube_name and mz_name
%

% Find mat-files
FileNameCell = findAllMatFiles( dataDir );
NFiles = length(FileNameCell);

% Loop through files
ResultCell = cell(NFiles,1);
for k = 1:NFiles
    % for time estimation printout
    tic;
    
    disp(['Starting with ' FileNameCell{k}])
    
    % Load variables
    load(fullfile(dataDir,FileNameCell{k}))
    eval(['ImCube = ImCube_' FileNameCell{k}(1:end-4) ';']);
    eval(['mz = mz_' FileNameCell{k}(1:end-4) ';']);
    
    % Calculate decriptors
    ResultFromImcube = calculateImageDescriptors(ImCube, mz, window);
    ResultCell{k} = ResultFromImcube;
    
    % Save
    save(fullfile(saveDir,['MethodResult_' FileNameCell{k}]), 'ResultFromImcube');
    
    % Clear initially loaded variables for memory concerns
    eval(['clear ImCube_' FileNameCell{k}(1:end-4) 'mz_' FileNameCell{k}(1:end-4)])
    
    disp([FileNameCell{k} ' Finished!'])
    
    % for time estimation printout
    t(k) = toc;
    timeLeft = mean(t)*(NFiles-k);
    disp(['---------- Estimated time remaining: ' num2str(round(timeLeft/60)) ' minutes ----------'])
    
end
% Create a renamed version of the cell array.
windowStr = [num2str(window(1)) 'x' num2str(window(2))];
eval(['ResultCell_' windowStr '= ResultCell;'])

% Save cell with results
eval( 'save(fullfile(saveDir, ''All.mat''), [''ResultCell_'' windowStr])' )


end

