function ScanOutput_new = removeCitationWrap( ScanOutput_commaFixed )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

for k = 1:length(ScanOutput_commaFixed)
    if length(ScanOutput_commaFixed{k}) == 2
        ScanOutput_new{k,1} = [];
    else
        ScanOutput_new{k,1} = ScanOutput_commaFixed{k}(2:end-1);
    end
end

end

