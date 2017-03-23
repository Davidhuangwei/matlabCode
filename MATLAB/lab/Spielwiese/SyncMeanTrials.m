function trial = SyncMeanTrials(FileBase,trial,whl,varargin)
[overwrite] = DefaultArgs(varargin,{0});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Synchronize direction

if  ~isfield(trial,'sync') | overwrite; 
  
  %% plot traces
  figure
  pos = whl.ctr(find(WithinRanges(find(whl.ctr(:,1)),trial.itv)),:);
  %pos = whl.ctr(find(WithinRanges(find(whl.ctr(:,1)),trial.itv(find(trial.dir>1),:))),:);
  XBin = [min(pos(:,1)):(max(pos(:,1))-min(pos(:,1)))/100:max(pos(:,1))];
  YBin = [min(pos(:,2)):(max(pos(:,2))-min(pos(:,2)))/100:max(pos(:,2))];
  hh = hist2(pos,XBin,YBin);
  shh = mySmooth(hh,[1 1],1);
  
  xbin = XBin(1:end-1)+mean(diff(XBin))/2;
  ybin = YBin(1:end-1)+mean(diff(YBin))/2;
  imagesc(xbin,ybin,shh');
  caxis(prctile(shh(:),[0 99]));
  title('mark JOINT path');
  hold on;
  for n=unique(trial.dir)'
    if n>1
      trace = trial.mean(n).mean;
      plot(trace(:,1),trace(:,2),'ro-','markersize',10,'markeredgecolor','none','markerfacecolor',[1 0 0]);
    else
      continue;
    end
  end
  
  %keyboard
  
  %% mark synchronization-points
  tt=1;
  while tt
    %% good='left'; bad='right'; cut='mid';
    [px,py,button]=PointInput;
    switch button
     case 1  % left -- good
      syncevt(tt,:) = [px py];
      plot(px,py,'ro-','markersize',20,'markeredgecolor','none','markerfacecolor',[0 0 1]);
      tt = tt+1;
     case 2  % right -- stop
      break
     case 3  % mid -- go back
      tt = tt-1;
      delete(gco)
    end
  end
  
  % number of points
  numsync = size(syncevt,1);
  
  %% get linearized positions of synchronization-points
  for n=unique(trial.dir)'
    if n>1
      syncpnts(:,n) = GetSpikeLinPos(syncevt,trial.mean(n).mean,trial.mean(n).lin);
    else
      continue;
    end
  end
  trial.sync.lin = syncpnts;
  
  
  %% scale traces such that the marking points are the same in all traces.
  %%
  %% translate all to common beginning:
  for n=unique(trial.dir)'
    if n>1
      newt(n).trans = trial.mean(n).lin(:,1) - syncpnts(1,n);
      %% adjust syncpoints
      syncpnts = syncpnts - ones(size(syncpnts,1),1)*syncpnts(1,:);
    else
      continue;
    end
  end
  
  %% loop through marking points and scale distance
  for nn=2:numsync
    
    %% get mean distance between nth and n-1st point
    avdist = mean(syncpnts(nn,[2:end]));
    
    %% loop through traces
    for n=unique(trial.dir)'
      if n>1
	%% rescale
	inx = find(newt(n).trans>syncpnts(nn-1,n) & newt(n).trans<=syncpnts(nn,n));
	newt(n).trans(inx) =  syncpnts(nn-1,n)+(newt(n).trans(inx)-syncpnts(nn-1,n))*avdist/syncpnts(nn,n);
	
	%% translate rest
	inx = find(newt(n).trans>syncpnts(nn,n));
	newt(n).trans(inx) =  newt(n).trans(inx) + (avdist-syncpnts(nn,n));
	
	syncpnts(nn:numsync,n) = syncpnts(nn:numsync,n) + ones(size(syncpnts(nn:numsync,n),1),1)*(avdist-syncpnts(nn,n));
	
	trial.mean(n).sclin = newt(n).trans;
	%newlint = nnewlint;
      else
	continue;
      end
    end
  end
  
  trial.sync.xy = syncevt;
  trial.sync.sclin = syncpnts;

  %save([FileBase '.trials'],'trial');
  
end
  
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% make event file:
trial.evt.pos(:,[1 2]) = syncevt;
trial.evt.pos(:,3) = avdist; %%<<<<<<<<<<<<<<< ACHTUNG

trial.evt.scpt(2) = [0:tt-1];

nextevt = tt+1;

imagesc(xbin,ybin,shh');
caxis(prctile(shh(:),[0 99]));
title('mark events');
hold on;

for n=unique(trial.dir)'
  if n>1
    trace = trial.mean(n).mean;
    plot(trace(:,1),trace(:,2),'ro-','markersize',10,'markeredgecolor','none','markerfacecolor',[1 0 0]);
    
    event = input('Which event (give ID; no argument for stop)? ');
    while event
      [evtx evty] = ginput(1);
      levt = GetSpikeLinPos([evtx evty],trial.mean(n).mean,trial.mean(n).lin);
      
      trial.evt.pos(nextevt,:) = [evtx evty levt];
      trial.evt.scpt(nextevt) = event;
      
      nextevt = nextevt+1;
      event = input('Which event (give ID; no argument for stop)? ');
    end
  else
    continue;
  end
end
%% add maze trajectory
if ~isfield(trial,'maze');
  if ~FileExists('Umaze.dat');
    %trial = setfield(trial,'maze',[]);
    indx = find(whl.ctr(:,1)>-1 & whl.ctr(:,2)>-1);
    [trial.maze trial.lmaze] = FindMainTrajNEW([1 length(whl.ctr(indx,:))],whl.ctr(indx,:));
    save([FileBase '.trials'],'trial');
  else
    Maze = load('Umaze.dat');
    trial.maze = Maze(:,[1 2]);
    trial.lmaze = Maze(:,[3 4]);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return;