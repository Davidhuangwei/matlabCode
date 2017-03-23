function PlotTrials(whl,trials,varargin)

[Press] = DefaultArgs(varargin,{1});

for seg=1:size(trials,1)
  
  %% positions in trial
  whlseg = whl(trials(seg,1):trials(seg,2),:);
  
  %% PLOT
  clf;
  plot(whl(1:100:end,1),whl(1:100:end,2),'o','markersize',5,'markeredgecolor','none','markerfacecolor',[0.7 0.7 0.7]);
  hold on
  plot(whlseg(:,1),whlseg(:,2),'o','markersize',5,'markeredgecolor','none','markerfacecolor',[0 0 0.6]);
  %plot(whlsegint(:,1),whlsegint(:,2),'go');%,'markersize',5,'markeredgecolor','none','markerfacecolor',[0 0.5 0]);
  
  if Press
    waitforbuttonpress;
  end
    
end
    