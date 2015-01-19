function printSummarySpectra(ResultCell, output_dir, nBlocks, nSections)
scrsize=get(0,'MonitorPositions');  
n_results = length(ResultCell);
n_method = length(ResultCell{1}.method);
if nBlocks*nSections ~= n_results
    error('number of blocks and sections don''t equal ResultsCell length')
end
for r=1:n_results
    block = ceil(r/nSections);
    section = r-((block-1)*nSections);
    for m=1:n_method
        
        figure('Position',[1,1,scrsize(3),scrsize(4)]);
        if strcmp(ResultCell{r}.method(m).bestValue,'High')
            plot(ResultCell{r}.method(m).mz,ResultCell{r}.method(m).values)
            ylabel(ResultCell{r}.method(m).name)
        else
            plot(ResultCell{r}.method(m).mz,1-ResultCell{r}.method(m).values)
            ylabel(['1 - ' ResultCell{r}.method(m).name])
        end
        xlabel('m/z')
        set(gca,'xlim',[ResultCell{r}.method(m).mz(1),ResultCell{r}.method(m).mz(end)])
        title(['Quality Spectrum from ' ResultCell{r}.method(m).name])
        saveas(gcf,[output_dir filesep 'quality_spectrum_' ResultCell{r}.method(m).name '_' num2str(block) '_' num2str(section) '.png'])
        close
    end
   
end