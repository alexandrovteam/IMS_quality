function ScanOutput_replaced = replaceOutputNaN( ScanOutput )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

empty = cellfun(@isempty,ScanOutput);

ScanOutput_replaced = ScanOutput;
ScanOutput_replaced(empty) = {NaN};

end

