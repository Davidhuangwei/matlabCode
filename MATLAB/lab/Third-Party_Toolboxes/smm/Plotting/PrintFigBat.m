function PrintFigBat(figNums,printOptions,saveBaseName)
% function PrintFigBat(figNums,printOptions,saveBaseName)
for j=1:length(figNums)
    figure(figNums(j))
    eval(['print ' printOptions ' ' saveBaseName num2str(j)]);
end