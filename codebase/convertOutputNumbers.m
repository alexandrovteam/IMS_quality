function ScanOutput_replaced = convertOutputNumbers( ScanOutput )
%UNTITLED Summary of this function goes here
%   Convert all "numeric strings" in cell to double

numbers = cellfun(@str2double,ScanOutput);
numberBool = ~isnan(numbers);

ScanOutput_replaced = ScanOutput;
ScanOutput_replaced(numberBool) = num2cell(numbers(numberBool));

end

