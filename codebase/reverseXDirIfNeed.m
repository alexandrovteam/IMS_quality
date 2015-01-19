function indToReverse = reverseXDirIfNeed( factorLevels )
%UNTITLED2 Summary of this function goes here
% check for special case where levels are High or Low. Change is only
% needed if levels starts with High

NFactors = length(factorLevels);

firstLevels = cell(1,NFactors);
for k = 1:NFactors
    firstLevels{k} = factorLevels{k}{1};
end

highCheck = strcmpi(firstLevels, 'High');
if sum(highCheck) >= 1
    indToReverse = find(highCheck);
else
    indToReverse = [];
end
    
end