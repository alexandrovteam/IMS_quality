function repInd = extractRepeatInd( SearchIn, repeatCode, Nrep )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

repInd = zeros(Nrep,1);
for k = 1:Nrep
    if iscell(repeatCode) && length(repeatCode) == 2
        searchString = [repeatCode{1} num2str(k) repeatCode{2}];
    elseif Nrep == 1
        searchString = repeatCode;
    else
        searchString = [repeatCode num2str(k)];
    end
    
    repInd(k) = find(strcmpi(SearchIn, searchString));
end

end

