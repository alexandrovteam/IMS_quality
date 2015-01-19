function ScanOutput_fixed = fixDoubleCitation( ScanOutput )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

NStr = length(ScanOutput);

for k = 1:NStr
    citMarks = strfind(ScanOutput{k},'"');
    NCit = length(citMarks);
    
    if NCit > 0
        if isodd(NCit)
            error('Odd number of citations marks in string!')
        end
        
        indDiff = diff(citMarks);
        firstMarks = indDiff == 1;
        fixedStr = ScanOutput{k};
        fixedStr(citMarks(firstMarks)) = [];
        ScanOutput_fixed{k} = fixedStr;
        
    else
        ScanOutput_fixed{k} = ScanOutput{k};
    end
end


end

