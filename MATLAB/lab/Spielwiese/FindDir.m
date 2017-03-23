function [trdir trdirix] = FindDir(whl,trin,varargin)
[overwrite] = DefaultArgs(varargin,{0});

%% input:
%%   whl - nx4 matrix 
%%   trin - beginning and end for trials (in whl samples)
%% input (optional):
%%   dir - trial direction (or classification)
%%   stim - stimulation (in whl samples)
%%
%% output: 
%%   ntrials - corrected trials
%%   

if 1
  %whlctr(:,1) = (whl(:,1)+whl(:,3))/2; 
  %whlctr(:,2) = (whl(:,2)+whl(:,4))/2; 
  whlctr(:,1) = whl(:,1);
  whlctr(:,2) = whl(:,2);
  %% print position
  whlplot = whlctr(whlctr(:,1)>0,:);

  figure
  %% plot trials and select beginning and ends
  plot(whlplot(1:100:end,1),whlplot(1:100:end,2),'o','markersize',5,'markeredgecolor','none','markerfacecolor',[0.9 0.9 0.9]);
  hold on
  plot(whlctr(trin(:,1),1),whlctr(trin(:,1),2),'o','markersize',10,'markeredgecolor','none','markerfacecolor',[0 1 0]);
  plot(whlctr(trin(:,2),1),whlctr(trin(:,2),2),'o','markersize',10,'markeredgecolor','none','markerfacecolor',[1 0 0]);
  
  title('select [(1) beginning (green)] and [(2) end (red)] of trials');
  %% select beginning/end
  [infield1 ply1] = myClusterPoints(whlctr(trin(:,1),:),0); 
  [infield2 ply2] = myClusterPoints(whlctr(trin(:,2),:),0); 
  
  trdirix = infield1&infield2;
  trdir = trin(trdirix,:);
  
end

return;
