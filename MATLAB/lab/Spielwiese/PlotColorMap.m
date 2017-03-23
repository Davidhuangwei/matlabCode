function c=PlotColorMap(varargin)
%%
%% function PlotColorMap(varargin)
%%   [mode,code] = DefaultArgs(varargin,{'default',[]});
%%
%% INPUT
%%   mode: name of color sheme. default is 'default'
%%   code: numbers from 1 to 64. prints the rgb values for each 
%%   
%% OUTPUT
%%   c: rgb values for all numbers in code
%%
[mode,code] = DefaultArgs(varargin,{'default',[]});


colormap(mode);
cc = colormap;

figure(4738);clf
hold on
for n=1:size(cc,1)
  plot([0 1],[n n],'color',cc(n,:),'LineWidth',5);
  text(-0.05,n-0.25,num2str(n),'FontSize',10)
end
title(mode,'FontSize',16)
axis tight
ylim([0 65]) 
axis off
box off

if ~isempty(code)
  for n=1:length(code)
    fprintf(['color code for color no.' num2str(code(n)) ':  ' num2str(cc(code(n),:)) '\n'])
  end
end

c = cc(code,:);

colormap('default');

return;
