function SaveFigure(figureHandle,saveFileName)
if ~isempty(figureHandle)
    saveFileName = Dot2Underscore(saveFileName);
    n = find(saveFileName == '/',1,'last');
    saveDir = saveFileName(1:n);
    if exist(saveDir)~=7
        mkdir(saveDir);
    end
    saveFileName
    saveas(figureHandle,saveFileName,'fig')
else
    fprintf('\n\nERROR: NO FIGURE HANDLE SPECIFIED\n\n')
end
