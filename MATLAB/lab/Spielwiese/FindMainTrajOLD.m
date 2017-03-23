function [smpos lin] = FindMainTrajOLD(trials,whl,varargin)
[xyRatio,overwrite] = DefaultArgs(varargin,{1.13,0});
%%
%% finds the average trace of mny traces
%%
%% input: whl file (nx2)
%%        beginning and end of trials in whl sampling (mx2)
%%
%% output: smpos = smoothed average trace
%%         lin = linearized position

%% scale the ydirection:
whl(:,2) = xyRatio*whl(:,2);

%% trial lengths
ltrial = trials(:,2)-trials(:,1);

%% resample to shortest trial
for ntr = 1:length(trials)
  pos = whl(find(WithinRanges(find(whl),trials(ntr,:))),:);
  newposx(:,ntr) = resample(pos(:,1),min(ltrial),length(pos));
  newposy(:,ntr) = resample(pos(:,2),min(ltrial),length(pos));
end

%keyboard

mpos(:,1) = mean(newposx,2);
mpos(:,2) = mean(newposy,2);

%% Get rid of outlyers (IMPROVE: ALLOW MORE THAN ONE REDUCTION!!!!!)
figure
allpos = whl(find(WithinRanges(find(whl),trials)),:);
plot(allpos(:,1),allpos(:,2),'o','markersize',5,'markeredgecolor','none','markerfacecolor',[0.9 0.9 0.9]);
hold on
plot(mpos(:,1),mpos(:,2),'ro-','markersize',10,'markeredgecolor','none','markerfacecolor',[1 0 0]);
ask = input('do you want to get rid of points? (1/0): ');
if ask
  [infield ply] = myClusterPoints(mpos,0); 
  gpos = mpos(find(~infield),:);
else
  gpos=mpos;
end

%% Add points
clf
plot(allpos(:,1),allpos(:,2),'o','markersize',5,'markeredgecolor','none','markerfacecolor',[0.9 0.9 0.9]);
hold on
plot(gpos(:,1),gpos(:,2),'ro-','markersize',10,'markeredgecolor','none','markerfacecolor',[1 0 0]);
ask = input('do you want to add points? (n/0): ');
if ask
  [apos(:,1) apos(:,2)] = ginput(ask);
  gpos(end+1:end+ask,:) = apos;
end

%% Get points into order!
ggpos = SortPoints(gpos);

%% Smooth
smpos(:,1) = mySmooth(ggpos(:,1),3,1);
smpos(:,2) = mySmooth(ggpos(:,2),3,1); 

smpos(1,:) = ggpos(1,1:2);
smpos(end,:) = ggpos(end,1:2);

clf
plot(allpos(:,1),allpos(:,2),'o','markersize',5,'markeredgecolor','none','markerfacecolor',[0.9 0.9 0.9]);
hold on
plot(ggpos(:,1),ggpos(:,2),'ro-','markersize',10,'markeredgecolor','none','markerfacecolor',[1 0 0]);
plot(smpos(:,1),smpos(:,2),'go-','markersize',10,'markeredgecolor','none','markerfacecolor',[0 1 0]);

%% Linerarize
lin(1,1)=0;
lin(2:length(smpos),1)=cumsum(abs(diff(smpos(:,1))+i*diff(smpos(:,2))));

return;
