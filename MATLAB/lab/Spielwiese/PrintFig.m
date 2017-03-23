function PrintFig(FileName,varargin)
% function PrintFig(FileBase,varargin)
% [yesno] = DefaultArngs(varagin,{0});
[yesno] = DefaultArgs(varargin,{0});

if yesno
  
  print('-r200','-depsc2',[FileName '.eps'])
  fprintf(['printing figure to file ' FileName '.eps \n']);

  saveas(gcf,[FileName '.fig'], 'fig');
  fprintf(['save figure as ' FileName '.fig \n']);
  
end

return;