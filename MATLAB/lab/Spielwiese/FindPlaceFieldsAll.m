function PlaceCellAll = FindPlaceFieldsAll(FileBase, spike, whl, trial, states, varargin)
[overwrite,session] = DefaultArgs(varargin,{0,[]});
%%
%% returns structure with one entry per place field (PF). 
%%
%% PlaceCell.ind = [cell cluster electrode dir celltype]; cell identification for each (PF)
%% PlaceCell.lfield = [begin end]; beginning and and of PFs in linearized coordinates.
%% PlaceCell.trials = [neuron begin end]; beginning and and of PFs in whl samples.

fprintf('  find place fields....\n');

RateFactor = 20000/whl.rate;
EegWhlRate = 1250/whl.rate;

if ~FileExists([FileBase '.PlaceCellAll']) | overwrite

  figure(123);clf;
  
  %% loop through cells
  count = 0;                     %% count place fields
  neurons = unique(spike.ind);   %% neuron numbers
  direct = unique(spike.dir);    %% direction numbers
  field = 0;                     %% counts place fields
  atrials = [];

  load([FileBase '.elc'],'-MAT');
  
  sts = 0;
  visited = [];
  allsts = [1:length(states.ind)];
  while sts<length(states.ind)
    sts = sts+1;
    notvisited = min(allsts(~ismember(allsts,visited)));
    
    if states.ind(notvisited)==1 %| take only the good session 
      visited = [visited notvisited]
      continue
    end
    
    %%% ask: combine same-state-sessions? 
    fprintf([states.info{states.ind(sts)} '\n']);
    ask = input('Do you want to combine all sessions of this kind into one [0/1]? ');
    if ask
      goodsegs = find(states.ind==states.ind(sts));
      visited = [visited goodsegs]
      sts = sts+length(goodsegs)-1; 
    else
      goodsegs = notvisited;
      visited = [visited goodsegs];
    end
    
    %% ask: cells from which region to look at
    elc.regionind 
    whichcells = input('cells from which region sould be included? ');
    goodelc = find(ismember(elc.region,whichcells));
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    switch states.ind(sts)
      
     case 2 %% track
      
      %% combine sessions:
      CatTrial = CatStruct(trial(goodsegs));
      
      %% spike count - Rate
      pos = round(whl.lin);
      gtrials = CatTrial.itv(find(CatTrial.dir>1),:);
      gtrialdir =  CatTrial.dir(find(CatTrial.dir>1));
      trialindwh = WithinRanges([1:length(whl.lin)],gtrials,[1:length(gtrials)]','vector')';
      gpos = (pos>0 & trialindwh >0);
      
      goodspikes = find(round(spike.t/RateFactor));
      SpkCnt = Accumulate([round(spike.t(goodspikes)/RateFactor) spike.ind(goodspikes)],1,[length(whl.lin) max(spike.ind)])*whl.rate;
      
      for n=1:length(neurons)
	n
	
	if ~ismember(spike.clu(n,1),goodelc)
	  continue
	end
		
	%% spike count - Rate
	[AvR StdR Bins] = MakeAvF([trialindwh(gpos) pos(gpos)],SpkCnt(gpos,neurons(n)),[max(trialindwh) max(pos)]);
	for tr=1:size(AvR,1)
	  smAvR(tr,:) = smooth(AvR(tr,:),15,'lowess');
	end
	
	%% loop through directions
	for nn=1:length(direct)
	  
	  neu = neurons(n);
	  dir = direct(nn);
	  if dir<2 
	    continue;
	  end
	  
	  %% indeces of spikes
	  indx = find(spike.ind==neu & spike.dir==dir & spike.good & WithinRanges(round(spike.t/RateFactor),gtrials));
	  [ccg, t] = CCG(spike.t(indx),1,20,50,20000);
	  
	  if isempty(indx) | mean(ccg(:,1,1))<1
	    continue
	  end
	  
	  if length(indx)>1000
	    indx = indx([1:round(length(indx)/1000):length(indx)]);
	  end
	  
	  clf
	  %% plot spikes-phase 
	  subplot(211)
	  [PhMatrix PhBin1 PhBin2] = PlotPhasegram(spike.t(indx),spike.ph(indx), spike.lpos(indx),whl.lin(gpos));
	  imagesc(PhBin1,PhBin2,PhMatrix*1000)
	  %plot(spike.lpos(indx,1),180/pi*spike.ph(indx,1),'.')
	  %hold on
	  %plot(spike.lpos(indx,1),180/pi*spike.ph(indx,1)+360,'.')
	  %plot(spike.lpos(indx,1),180/pi*spike.ph(indx,1)+720,'.')
	  %Lines(trial.evtlin(find(trial.evtind(:,1)==nn)),[],'b','--',2*ones(size(trial.evtlin(find(trial.evtind(:,1)==nn)))));
	  axis xy
	  axis tight; %xlim([0 max(spike.lpos)]);
	  title(['cell ' num2str(n) ' || direction ' num2str(dir) ' || ' num2str(spike.clu(neu,1)) '|' num2str(spike.clu(neu,2))]);
	  %hold off;
	  %% plot 2D scatter
	  subplot(234)
	  plot(whl.plot(1:100:end,1),whl.plot(1:100:end,2),'o', ...
	       'markersize',5,'markeredgecolor','none','markerfacecolor',[0.9 0.9 0.9]);
	  hold on;
	  scatter(spike.pos(indx,1),spike.pos(indx,2),30,(spike.ph(indx))*180/pi);
	  hold off;
	  axis tight;
	  %% plot autocorrelogram
	  subplot(235)
	  bar(t,ccg);
	  xlim([min(t) max(t)]);
	  %% plot 2D rate
	  subplot(236)
	  %% spike count - Rate
	  imagesc(smAvR(find(gtrialdir==dir),:));
	    
	  %% classify neurons: bad cell / place cell / interneuron 
	  fprintf('classify neurons: place cell (left), interneuron (middle), bad cell (right)\n')
	  waitforbuttonpress;
	  whatbutton = get(gcf,'SelectionType');
	  switch whatbutton
	   case 'normal'   % left -- PC 
	    celltype = 1
	   case 'alt'      % right -- bad
	    celltype = 0
	   case 'extend'   % mid -- interneuron
	    celltype = 2
	   case 'open'     % double click -- go ba
	    celltype = 0;
	  end
	  
	  %% select place fields
	  if celltype == 1 | celltype == 2
	    fprintf('');
	    [dumx dumy button]=PointInput(1);
	    switch button(1)
	     case 1 % left : Yes, there are place fields
	      while 1
		[dumx dumy button2]=PointInput(1)
		switch button2(1)
		 case 1 %% select field
		  field = field+1
		  identify(field,:) = [neu spike.clu(neu,:) dir celltype];
		  [x y] = ginput(2);
		  pl(field,:) = sort(x');
		  if pl(field,1)<1
		    pl(field,1)=1;
		  end
		  trials = [];
		  trials(:,2:3) = TrialsWithin(whl.lin,pl(field,:),CatTrial.itv(CatTrial.dir==dir,:));
		  trials(:,1) = field;
		  atrials = [atrials; trials];
		  h(field,:)=Lines(x,[],{'g','r'}',{'-','-'},[2 2]);%spike.clu(tt,:)
		 case 2
		  break
		 case 3
		  delete(h(field,:));
		  field = field-1;
		end
	      end
	     case 3
	      field = field+1
	      identify(field,:) = [neu spike.clu(neu,:) dir celltype];
	      pl(field,:) = [min(spike.lpos(indx,1)) max(spike.lpos(indx,1))];
	      if pl(field,1)<1
		pl(field,1)=1;
	      end
	      trials = [];
	      trials(:,2:3) = TrialsWithin(whl.lin,pl(field,:),CatTrial.itv(CatTrial.dir==dir,:));
	      trials(:,1) = field;
	      atrials = [atrials; trials];
	    end
	  end  
	end
      end  
      
     case 3 %% open field
      continue
    end
      
  end %% while sts<length(states.ind)
  
  PlaceCellAll.ind = identify;
  PlaceCellAll.lfield = pl;
  PlaceCellAll.trials = atrials;
  
  %save([FileBase '.PlaceCellAll'],'PlaceCellAll');
else
  load([FileBase '.PlaceCellAll'],'-MAT');
end
  
return;


%subplot(222)
%%[Fspike Fx] = LinRate(whl,spike,n,nn);
%[FRate T FRate2 T2] = LinRate(whl,spike,n,nn);
%%bar(Fx,Fspike);
%plot(T,FRate,'r','LineWidth',2);%hold on;plot(T2,FRate2,'g','LineWidth',2);
%xlim([0 max(spike.lpos)]);
      
