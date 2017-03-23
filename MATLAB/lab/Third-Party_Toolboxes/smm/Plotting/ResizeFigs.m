function ResizeFigs(figNums,plotSize)
for j=1:length(figNums)
        if exist('plotSize','var') & ~isempty(plotSize)
        set(figNums(j),'PaperPosition',[0,0.5,plotSize(1),plotSize(2)]);
        set(figNums(j), 'Units', 'inches')
        set(figNums(j), 'Position', [0,0.5,plotSize(1),plotSize(2)])
        end
end