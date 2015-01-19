function ScanOutput_fixed = fixStringsWithCommas( ScanOutput )
%UNTITLED Summary of this function goes here
%   Merge strings iff odd number of citations until another odd is found

NStr = length(ScanOutput);

k = 1;
ScanOutput_fixed = {};
while k <= NStr
    outputStr = ScanOutput{k};
    Ncit = length(strfind(outputStr, '"'));
    
    if iseven(Ncit)
        ScanOutput_fixed{ length(ScanOutput_fixed)+1, 1} = outputStr;
        k = k + 1;
        
    else
        endNotFound = 1;
        count = 1;
        while endNotFound
            nextStr = ScanOutput{k+count};
            Ncit = length(strfind(nextStr, '"'));
            
            if isodd(Ncit)
                mergeStr = '';
                for m = 1:count
                    mergeStr = [mergeStr ',' ScanOutput{k+m}];
                end
                ScanOutput_fixed{ length(ScanOutput_fixed)+1, 1} = [ outputStr mergeStr ];
                endNotFound = 0;
                
            else
                count = count+1;
            end
            
            if (k + count) > NStr
                error('Could not find end of user entered string')
            end
            
        end
        
        k = k + 1 + count;
    end
end

end


% %Old solution based on ending & starting citation
%
% while k <= NStr
%     outputStr = ScanOutput{k};
%     
%     if strcmp(outputStr(end),'"') && length(outputStr) > 1
%         ScanOutput_fixed{ length(ScanOutput_fixed)+1, 1} = outputStr;
%         k = k + 1;
%         
%     else
%         endNotFound = 1;
%         count = 1;
%         while endNotFound
%             tmp1 = ScanOutput{k+count};
%             tmp2 = ScanOutput{k+count+1};
%             
%             if strcmp(tmp1(end),'"') && strcmp(tmp2(1),'"')
%                 mergeStr = '';
%                 for m = 1:count
%                     mergeStr = [mergeStr ',' ScanOutput{k+m}];
%                 end
%                 ScanOutput_fixed{ length(ScanOutput_fixed)+1, 1} = [ outputStr mergeStr ];
%                 endNotFound = 0;
%                 
%             else
%                 count = count+1;
%             end
%             
%         end
%         k = k + 1 + count;
%         
%     end
%     
% end