function FileNameCell = findAllMatFiles( directory )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

content = dir(directory);
fileInd = find(not([content.isdir]));
NFiles = length(fileInd);

fileNames = cell(NFiles,1);
fileNames(:) = {content(fileInd).name};

strPos = strfind(fileNames,'.mat');
csvFiles = not(cellfun(@isempty, strPos));

FileNameCell = fileNames(csvFiles);

end

