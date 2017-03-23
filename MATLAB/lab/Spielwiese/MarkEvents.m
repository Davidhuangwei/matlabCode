function trial = MarkEvents(FileBase,trial,whl,varargin)
[overwrite] = DefaultArgs(varargin,{0});
%%
%% mark and describe events
%%
%% 

if  ~isfield(trial,'evtind') | overwrite; 
  
  k=1;
  for n=1:size(trial.mean,2)
    if ismember(n,unique(trial.dir)); %%Corrected by david
      if n>1
  
	%% plot traces
	pos = whl.ctr(find(WithinRanges(find(whl.ctr(:,1)),trial.itv)),:);
      %pos = whl.ctr(find(WithinRanges(find(whl.ctr(:,1)),trial.itv(find(trial.dir>1),:))),:);
      XBin = [min(pos(:,1)):(max(pos(:,1))-min(pos(:,1)))/100:max(pos(:,1))];
      YBin = [min(pos(:,2)):(max(pos(:,2))-min(pos(:,2)))/100:max(pos(:,2))];
      hh = hist2(pos,XBin,YBin);
      shh = mySmooth(hh,[1 1],1);
      xbin = XBin(1:end-1)+mean(diff(XBin))/2;
      ybin = YBin(1:end-1)+mean(diff(YBin))/2;
      
      figure
      imagesc(xbin,ybin,shh');
      caxis(prctile(shh(:),[0 99]));
      title('mark events and give them numbers for identification (e.g. beginning=1, end=100, corners=50)');
      hold on;
      
      trace = trial.mean(n).mean;
      plot(trace(:,1),trace(:,2),'ro-','markersize',10,'markeredgecolor','none','markerfacecolor',[1 0 0]);
  
      %% plot syncronization point and ask for event
      m=1;
      if isfield(trial,'sync')
	syncpnt = trial.sync.xy;
	for m=1:size(syncpnt,1)
	  plot(syncpnt(m,1),syncpnt(m,2),'ro-','markersize',20,'markeredgecolor','none','markerfacecolor',[0 0 1]);
	  
	  trial.evtxy(k,:) = syncpnt(m,:);
	  kind = input('what kind of event is this (give a number)? ');
	  trial.evtind(k,:) = [n kind];
	  k=k+1;
	end
      end
      
      %keyboard;
      
      %% more events
      
      if (trial.OneMeanTrial & n==unique(trial.dir)) | ~trial.OneMeanTrial
	while k
	  %% good='left'; bad='right'; cut='mid';
	  [px,py,button]=PointInput;
	  switch button
	   case 1  % left -- good
	    trial.evtxy(k,:) = [px py];
	    plot(px,py,'ro-','markersize',20,'markeredgecolor','none','markerfacecolor',[0 0 1]);
	    trial.evtind(k,:) = [n input('what kind of event is this (give a number)? ')];
	    k = k+1;
	   case 2  % mid -- stop
	    break
	   case 3  % right -- go back
	    k = k-1;
	    delete(gco)
	  end
	end
	kcount = k-1;
	%keyboard
      else
	trial.evtxy((n-2)*kcount+1:(n-1)*kcount,:) = trial.evtxy(1:kcount,:);
	trial.evtind((n-2)*kcount+1:(n-1)*kcount,:) = [n*ones(kcount,1) trial.evtind(1:kcount,2)];
      end
      
      %% linearize events:
      %for m=2:size(trial.mean,2)
      %trial.evtlin(find(trial.evtind(:,1)==n),1) = GetSpikeLinPos(trial.evtxy,trial.mean(n).mean,trial.mean(n).sclin);
      trial.evtlin(find(trial.evtind(:,1)==n),1) = GetSpikeLinPos(trial.evtxy(find(trial.evtind(:,1)==n),:),trial.mean(n).mean,trial.mean(n).sclin);
      %end
      
    else
      continue;
      end
    end
  end
end

save([FileBase '.trials'],'trial');

return;
