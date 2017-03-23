% function PrintSaveFig(saveBaseName,varargin)
% figNums = DefaultArgs(varargin,{gcf});
% 
% for h=figNums
%     SetFigPos(h)
%     saveas(h,saveBaseName)
%     print(h,'-depsc2',saveBaseName)
%     print(h,'-dpng',saveBaseName)
% end

function PrintSaveFig(saveBaseName,varargin)
figNums = DefaultArgs(varargin,{gcf});

for h=figNums
    SetFigPos(h)
    saveas(h,saveBaseName)
    print(h,'-depsc2',saveBaseName)
    print(h,'-dpng',saveBaseName)
end
