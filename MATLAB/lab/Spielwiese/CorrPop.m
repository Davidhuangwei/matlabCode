function C = CorrPop(FileBase,PlaceCell,spike,whl,trial,Rate,varargin)
[Filter,plotting,overwrite] = DefaultArgs(varargin,{50,0,0});
%
%function CorrPop(PlaceCell,spike,whl,trial,varargin)
%[plotting] = DefaultArgs(varargin,{0});
%

PC=(PlaceCell.ind(:,5)==1);
IN=(PlaceCell.ind(:,5)==2);

if isempty(PC)
  return
end

if ~FileExists([FileBase '.xcorr']) | overwrite

  Corr = [];
  CorrS = [];
  CorrF = [];
  
  for dire=unique(PlaceCell.ind(find(PC),4))';
    
    gdir = find(trial.dir==dire);
    [neurons nindx] = unique(PlaceCell.ind(find(PlaceCell.ind(:,4)==dire & PlaceCell.ind(:,5)==1),1));
    
    %% time interval of place cells
    gintv = ismember(PlaceCell.trials(:,1),find(PlaceCell.ind(:,5)==1&PlaceCell.ind(:,4)==dire));
    
    %% sort overlapping intervals
    ranges = NoOverlapRanges(PlaceCell.trials(find(gintv),2:3));
    whlinfields = WithinRanges([1:size(whl.dir,1)],ranges);
    
    %% get all the spikes in the place fields
    gspikes = ismember(spike.ind,neurons) & WithinRanges(round(spike.t/20000*whl.rate),ranges);
    
    %% ccgs for each trial
    chh = []; clear chh;
    for tr=1:length(gdir)
      gspikesTR =  find(gspikes & WithinRanges(round(spike.t/20000*whl.rate),trial.itv(gdir(tr),:)));
      if length(unique(spike.ind(gspikesTR)))<length(neurons)
	goodcells = ismember(neurons,spike.ind(gspikesTR));
	spiket = [spike.t(gspikesTR); [1:length(find(~goodcells))]'];
	spikeind = [spike.ind(gspikesTR); neurons(find(~goodcells))];
      else
	spiket = spike.t(gspikesTR);
	spikeind = spike.ind(gspikesTR);
      end
      %[ccg, t] = CCG(spiket,spikeind,2000,200,20000);
      [ccg, t] = CCG(spiket,spikeind,200,400,20000);
      chh(:,:,:,tr) = ccg;
      
      %% av. speed for each trial 
      intv = find(WithinRanges([1:size(whl.speed,1)],trial.itv(gdir(tr),:)) & whlinfields);
      Speed(tr) = mean(whl.speed(intv,1));
    end
    
    [SrtSp SrtIdx] = sort(Speed);
    
    slow = SrtIdx(1:round(length(SrtIdx)/2));
    fast = SrtIdx(round(length(SrtIdx)/2)+1:length(SrtIdx));
    
    %% speed for each trial
    count = 0;
    for neu=1:length(neurons)
      for neu2=neu:length(neurons)
	count=count+1;
	%% get fast/slow for each pair separate:
	pair=find((PlaceCell.ind(:,1)==neurons(neu)|PlaceCell.ind(:,1)==neurons(neu2))&PlaceCell.ind(:,4)==dire);
	intPair = ismember(PlaceCell.trials(:,1),pair);
	%% sort overlapping intervals
	rangesP = NoOverlapRanges(PlaceCell.trials(find(intPair),2:3));
	whlinfieldsP = WithinRanges([1:size(whl.dir,1)],rangesP);
	for tr=1:length(gdir)
	  intvP = find(WithinRanges([1:size(whl.dir,1)],trial.itv(gdir(tr),:)) & whlinfieldsP);
	  SpPair(tr,count) = mean(whl.speed(intvP,1));
	end
      end
    end
    
    figure(dire);clf
    count=0;
    for neu=1:length(neurons)
      for neu2=neu:length(neurons)
	count=count+1;
	%keyboard
	%% select trials where the firing rate of each cell is larger than 5Hz
	cell1 = find(PlaceCell.ind(:,1)==neurons(neu) & PlaceCell.ind(:,4)==dire);
	if length(cell1)==1
	  rate1 = Rate.rate(find(Rate.count(:,1)==cell1),1);
	else
	  dummy = Rate.rate(find(ismember(Rate.count(:,1),cell1)),1);
	dummy2 = reshape(dummy,length(dummy)/length(cell1),length(cell1));
	rate1 = max(dummy2')';
	end
	cell2 = find(PlaceCell.ind(:,1)==neurons(neu2) & PlaceCell.ind(:,4)==dire);      
	if length(cell2)==1
	  rate2 = Rate.rate(find(Rate.count(:,1)==cell2),1);
	else
	  dummy = Rate.rate(find(ismember(Rate.count(:,1),cell2)),1);
	  dummy2 = reshape(dummy,length(dummy)/length(cell2),length(cell2));
	  rate2 = max(dummy2')';
	end
	goodtr = find(rate1>5 & rate2>5);
	if length(goodtr)<4
	  count=count-1;
	  continue;
	end
	[SrtPair IxPair] = sort(SpPair(goodtr,count));
	slowP = IxPair(1:round(length(IxPair)/2));
	fastP = IxPair(round(length(IxPair)/2)+1:length(IxPair));
	%[SrtPair IxPair] = sort(SpPair(:,count));
	%slowP = IxPair(1:round(length(IxPair)/2));
	%fastP = IxPair(round(length(IxPair)/2)+1:length(IxPair));
	
	sm(:,1) = smooth(mean(chh(:,neu,neu2,goodtr(slowP)),4),Filter,'lowess');
	sm(:,2) = smooth(mean(chh(:,neu,neu2,goodtr(fastP)),4),Filter,'lowess');
	%sm(:,1) = mean(chh(:,1,5,slow),4);
	%sm(:,2) = mean(chh(:,1,5,fast),4);
	[maxS midxS] = max(sm(:,1));
	[maxF midxF] = max(sm(:,2));
	
	%% xcorr between slow and fast
	[xcor2, lags] = xcorr(sm(:,1),sm(:,2),400,'unbiased');
	%[xcor2, lags] = xcorr(sm(:,1),sm(:,2),400);
	lags = lags*diff(t(1:2));
	[maxA midxA] = max(xcor2);
	
	CorrS = [CorrS; maxS t(midxS)];
	CorrF = [CorrF; maxF t(midxF)];
	Corr = [Corr; dire neurons(neu) neurons(neu2) maxA lags(midxA)];
	
	if plotting
	  if neu == neu2 | max(sm(:,1))<5 | max(sm(:,2))<5
	    continue
	  end
	  figure(dire+1);clf
	  subplot(211)
	  plot(t,sm(:,1),'g')
	  hold on
	  plot(t,sm(:,2),'b')
	  title([num2str(neu) ' || ' num2str(neu2)])
	  subplot(212)
	  plot(lags,xcor2)
	  grid on
	  
	  figure(dire)
	  %count = (neu-1)*length(neurons) +neu2;
	  %subplotfit(count,length(neurons)^2)
	  %plot(t,mean(chh(:,neu,neu2,slow),4),'g')
	  %hold on
	  %plot(t,mean(chh(:,neu,neu2,fast),4),'b')
	  %grid on
	  %ForAllSubplots('axis tight; box off; axis off')
	  subplot(211)
	  plot(t,[mean(chh(:,neu,neu2,goodtr(slowP)),4) sm(:,1)])
	  subplot(212)
	  plot(t,[mean(chh(:,neu,neu2,goodtr(fastP)),4) sm(:,2)])
	  
	  %pause(1)
	  waitforbuttonpress
	end
      end
    end
    
    clear ccg Speed SpPair;
    
  end
  
  C.corr = Corr;
  C.corrS = CorrS;
  C.corrF = CorrF;
  
  save([FileBase '.xcorr'],'C');
else
  load([FileBase '.xcorr'],'-MAT');
end


return;
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

ksm = Filter;
smccg = smooth(ccg(:,neu,neu2),ksm,'lowess');
[maxC indx] = max(smccg(ksm:end-ksm));
bar(t,smccg);
axis tight
Lines(t(indx+ksm),[],'r');

%figure(dire);clf
%subplot(211)
%plot(squeeze(mean(Tune.rate(find(trial.dir(gdir)==dire),:,find(NPC)),1)))
  
for neu=1:length(neurons)
  gintvS = ismember(PlaceCell.trials(:,1),find(PlaceCell.ind(:,1)==neurons(neu)&PlaceCell.ind(:,4)==dire));
  gspikesS = spike.ind==neurons(neu) & WithinRanges(round(spike.t/20000*whl.rate),PlaceCell.trials(find(gintvS),2:3));
  
  SngHist(neu,:) = histcI([spike.ph(gspikesS); spike.ph(gspikesS)+2*pi]*180/pi,Bin)/(2*length(spike.ph(gspikesS))*DBin);
  
  clear gintvS gspikesS
end

subplot(212)
bar(Bin(2:end)-DBin/2,AllHist)
hold on
plot(Bin(2:end)-DBin/2,mean(SngHist,1),'r')

ForAllSubplots('axis tight')
  
%intrials = WithinRanges(round(spike.t(gspikes)/20000*whl.rate),trial.itv,[1:size(trial.itv,1)],'vector');
%gspikesF = ismember(spike.ind,neurons) & WithinRanges(round(spike.t/20000*whl.rate),ranges) & WithinRanges(round(spike.t/20000*whl.rate),fast);
%gspikesS = ismember(spike.ind,neurons) & WithinRanges(round(spike.t/20000*whl.rate),ranges) & WithinRanges(round(spike.t/20000*whl.rate),slow);

%% tuning curves
Neu = unique(PlaceCell.ind(:,1));
[neurons nindx] = unique(PlaceCell.ind(find(PlaceCell.ind(:,4)==dire & PlaceCell.ind(:,5)==1),1));
NPC = ismember(Neu,neurons);

%% fast and slow trials
%rate = Rate.rate()
  
