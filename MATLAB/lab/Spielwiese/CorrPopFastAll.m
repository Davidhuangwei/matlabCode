function C = CorrPopFastAll(PlaceCell,spike,whl,trial,Rate,Tune,SpectTr,varargin)
[Filter,FilterL,plotting] = DefaultArgs(varargin,{30,100,1});
%
%function CorrPopFast(PlaceCell,spike,whl,trial,varargin)
%[plotting] = DefaultArgs(varargin,{0});
%
%
%% Simmilar to CorrPopFast.m


%%% take cells for BOTH directions! But plot them both separately,
%too, in order to check if the place fields are really matching
%(DON'T USE DAVID'S!)). 


PC=(PlaceCell.ind(:,5)==1);
IN=(PlaceCell.ind(:,5)==2);

ccgBin = 60;
ccgHBin = 100;
ccgBinL = 200;
ccgHBinL = 400;
ccgRate = 20000;
Filter = round(Filter*ccgRate*0.001/ccgBin);

if isempty(PC)
  return
end

CorrMaxS = [];
CorrMaxF = [];
CorrA = [];

CorrFitSsort = [];
CorrFitFsort = [];
CorrFitSlong = [];
CorrFitFlong = [];

for dire=unique(PlaceCell.ind(find(PC),4))';
  
  gdir = find(trial.dir==dire);
  fields = find(PlaceCell.ind(:,4)==dire & PlaceCell.ind(:,5)==1);
  [neurons nindx] = unique(PlaceCell.ind(fields,1));
  
  %% time interval of place cells
  gintv = ismember(PlaceCell.trials(:,1),fields);
  
  %% sort overlapping intervals
  ranges = NoOverlapRanges(PlaceCell.trials(find(gintv),2:3));
  whlinfields = WithinRanges([1:size(whl.dir,1)],ranges);
  
  %% rename clus if more than one PF per cell:
  for n=1:length(fields)
    pfindx = find(PlaceCell.trials(:,1)==fields(n));
    spikeindx = spike.ind==PlaceCell.ind(fields(n),1) & WithinRanges(round(spike.t/20000*whl.rate),PlaceCell.trials(pfindx,2:3)) & spike.good;
    nspikeind(find(spikeindx),1) = fields(n); 
  end
  gspikes = zeros(size(spike.ind));
  gspikes(1:length(nspikeind)) = nspikeind>0;
    
  %% ccgs for each trial
  chh = []; clear chh;
  chhL = []; clear chhL;
  for tr=1:length(gdir)
    gspikesTR =  find(gspikes & WithinRanges(round(spike.t/20000*whl.rate),trial.itv(gdir(tr),:)));
    if length(unique(nspikeind(gspikesTR)))<length(fields)
      goodcells = ismember(fields,nspikeind(gspikesTR));
      spiket = [spike.t(gspikesTR); [1:length(find(~goodcells))]'+max(spike.t)];
      spikeind = [nspikeind(gspikesTR); fields(find(~goodcells))];
    else
      spiket = spike.t(gspikesTR);
      spikeind = nspikeind(gspikesTR);
    end
    [ccg, t] = CCG(spiket,spikeind,ccgBin,ccgHBin,ccgRate,unique(spikeind));
    chh(:,:,:,tr) = ccg;
    chh(ccgHBin+1,:,:,tr) = (chh(ccgHBin,:,:,tr)+chh(ccgHBin+2,:,:,tr))/2;
    
    [ccgL, tL] = CCG(spiket,spikeind,ccgBinL,ccgHBinL,ccgRate,unique(spikeind));
    chhL(:,:,:,tr) = ccgL;
    chhL(ccgHBinL+1,:,:,tr) = (chhL(ccgHBinL,:,:,tr)+chhL(ccgHBinL+2,:,:,tr))/2;
  end
  
  %% speed for each trial/pair
  count = 0;
  for neu=1:length(fields)
    for neu2=neu+1:length(fields)
      count=count+1;
      %% get fast/slow for each pair separate:
      pair=fields([neu neu2]);
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
  
  %% distance between place fields (from tuning curves):
  tneu = unique(PlaceCell.ind(:,1));
  gttr = find(trial.dir>1);
  ttr = find(trial.dir(gttr)==dire);
  
  count = 0;
  for neu=1:length(fields)
    for neu2=neu+1:length(fields)
      count=count+1;
      %% select trials where ccg > ??/ms
      spcount = squeeze(mean(chh(:,neu,neu2,:),1));
      goodtr = find(spcount>0.5);
      if length(goodtr)<4
	count=count-1;
	continue;
      end
      [SrtPair IxPair] = sort(SpPair(goodtr,count));
      slowP = IxPair(1:round(length(IxPair)/2));
      fastP = IxPair(round(length(IxPair)/2)+1:length(IxPair));
      SpeedS = mean(SrtPair(1:round(length(IxPair)/2)));
      SpeedF = mean(SrtPair(round(length(IxPair)/2)+1:length(IxPair)));
      
      FiltFreq = 40;
      NFreq = 1/abs(diff(t(1:2)))*1000;
      sm(:,1) = ButFilter(mean(chh(:,neu,neu2,goodtr(slowP)),4),2,FiltFreq/NFreq);
      sm(:,2) = ButFilter(mean(chh(:,neu,neu2,goodtr(fastP)),4),2,FiltFreq/NFreq);
      
      FiltFreq = 1.5;
      NFreq = 1/abs(diff(tL(1:2)))*1000;
      smL(:,1) = ButFilter(mean(chhL(:,neu,neu2,goodtr(slowP)),4),2,FiltFreq/NFreq);
      smL(:,2) = ButFilter(mean(chhL(:,neu,neu2,goodtr(fastP)),4),2,FiltFreq/NFreq);

      %% place field location in "real time"
      [maxL maxLidx] = max(smL(:,1));
      tLS = tL(maxLidx);
      [maxL maxLidx] = max(smL(:,2));
      tLF = tL(maxLidx);
      
      %% local maxima | select the largest and two closest
      minS = t(LocalMinima(-sm(:,1),round(60*ccgRate*0.001/ccgBin)))'*sign(tLS);
      minS1st = min(minS(find(minS>=0)))*sign(tLS);
      minS = minS*sign(tLS);
      
      minF = t(LocalMinima(-sm(:,2),round(60*ccgRate*0.001/ccgBin)))'*sign(tLF);
      minF1st = min(minF(find(minF>=0)))*sign(tLF);
      minF = minF*sign(tLF);
      
      %% x-distance between fields 
      tune = zeros([size(Tune.rate,2) 2]);
      tuneidx1 = [round(PlaceCell.lfield(fields(neu),1)):round(PlaceCell.lfield(fields(neu),2))];
      tuneidx2 = [round(PlaceCell.lfield(fields(neu2),1)):round(PlaceCell.lfield(fields(neu2),2))];
      tune(tuneidx1,1) = mean(Tune.rate(ttr(goodtr(slowP)),tuneidx1,find(tneu==PlaceCell.ind(fields(neu),1))),1)';
      tune(tuneidx2,2) = mean(Tune.rate(ttr(goodtr(slowP)),tuneidx2,find(tneu==PlaceCell.ind(fields(neu2),1))),1)';
      [xtune xtunelag] = xcorr(tune(:,1),tune(:,2));
      [dummy xtunemax] = max(xtune);
      xDist(1) = xtunelag(xtunemax);
      tune(tuneidx1,1) = mean(Tune.rate(ttr(goodtr(fastP)),tuneidx1,find(tneu==PlaceCell.ind(fields(neu),1))),1)';
      tune(tuneidx2,2) = mean(Tune.rate(ttr(goodtr(fastP)),tuneidx2,find(tneu==PlaceCell.ind(fields(neu2),1))),1)';
      [xtune xtunelag] = xcorr(tune(:,1),tune(:,2));
      [dummy xtunemax] = max(xtune);
      xDist(2) = xtunelag(xtunemax);
      if dire==2
	xDist=-xDist;
      end
      
      %keyboard
      
      %% oscillation frequency of the two cells for fast and slow runs
      %spectidx1 = find(SpectTr.ind(:,1)==fields(neu));
      %spectidx2 = find(SpectTr.ind(:,1)==fields(neu2));
      %spect1(:,1) = mean(SpectTr.yCell(spectidx1(goodtr(slowP)),:));
      %spect1(:,2) = mean(SpectTr.yCell(spectidx1(goodtr(fastP)),:));
      %spect2(:,1) = mean(SpectTr.yCell(spectidx2(goodtr(slowP)),:));
      %spect2(:,2) = mean(SpectTr.yCell(spectidx2(goodtr(fastP)),:));
      %figure(1); clf
      %subplot(211)
      %plot(SpectTr.f,spect1)
      %subplot(212)
      %plot(SpectTr.f,spect2)
      
      
      %% put it together
      CorrMaxS = [CorrMaxS; [minS ones(size(minS))*neu ones(size(minS))*neu2 ones(size(minS))*xDist(1)]];
      CorrMaxF = [CorrMaxF; [minF ones(size(minF))*neu ones(size(minF))*neu2 ones(size(minF))*xDist(2)]];
      CorrA = [CorrA; [neu neu2 xDist(1) minS1st tLS SpeedS xDist(2) minF1st tLF SpeedF]];
      
      if plotting
	neu
	neu2
	figure(23645);clf
	subplot(221)
	bar(t,mean(chh(:,neu,neu2,goodtr(slowP)),4));
	hold on
	plot(t,sm(:,1),'r');
	subplot(222)
	bar(t,mean(chh(:,neu,neu2,goodtr(fastP)),4));
	hold on
	plot(t,sm(:,2),'r');
 	
	subplot(223)
	bar(tL,mean(chhL(:,neu,neu2,goodtr(slowP)),4));
	hold on
	plot(tL,smL(:,1),'r');
	subplot(224)
	bar(tL,mean(chhL(:,neu,neu2,goodtr(fastP)),4));
	hold on
	plot(tL,smL(:,2),'r');

	figure(286428);clf
	subplot(311)
	TuneE(:,1) = mean(Tune.rate(ttr(goodtr),:,find(tneu==PlaceCell.ind(fields(neu),1))),1)';
	TuneE(:,2) = mean(Tune.rate(ttr(goodtr),:,find(tneu==PlaceCell.ind(fields(neu2),1))),1)';
	plot(TuneE(:,1));
	hold on
	plot(TuneE(:,2),'r');
	xlabel('distance [cm]','FontSize',16);
	Lines(PlaceCell.lfield(fields(neu),:),[],'b');
	Lines(PlaceCell.lfield(fields(neu2),:),[],'r');
	subplot(312)
	plot(t,sm(:,1),'g');
	hold on
	plot(t,sm(:,2),'b');
	xlabel('time [ms]','FontSize',16);
	subplot(313)
	plot(tL,smL(:,1),'g');
	hold on
	plot(tL,smL(:,2),'b');
	xlabel('time [ms]','FontSize',16);
	ForAllSubplots('axis tight; grid on; box off')
	
	Exp.tune = TuneE;
	Exp.xcorr = [t' sm];
	Exp.XCORR = [tL' smL];
	
	%save('Example','Exp')
	
	waitforbuttonpress
	%comment = ['neurons ' num2str(neu) ' and ' num2str(neu2)];
	%reportfig(gcf,[],[],comment,150)
      end	
      
    
      clear min1 min2 minF minS;
    end
  end
  
  if size(CorrA,1)>2
    CorrB = abs(CorrA);
    [b stats] = robustfit(CorrB(:,3),CorrB(:,4));
    CorrFitSsort = [CorrFitSsort; [b(2) stats.p(2) b(1) stats.p(1)]];
    [b stats] = robustfit(CorrB(:,6),CorrB(:,7));
    CorrFitFsort = [CorrFitFsort; [b(2) stats.p(2) b(1) stats.p(1)]];

    [b stats] = robustfit(CorrB(:,3),CorrB(:,5));
    CorrFitSlong = [CorrFitSlong; [b(2) stats.p(2) b(1) stats.p(1)]];
    [b stats] = robustfit(CorrB(:,6),CorrB(:,8));
    CorrFitFlong = [CorrFitFlong; [b(2) stats.p(2) b(1) stats.p(1)]];
  elseif size(CorrA,1)==2
    CorrB = abs(CorrA);
    b(2) = diff(CorrB(:,4))/diff(CorrB(:,3));
    b(1) = CorrB(1,4) - b(2)*CorrB(1,3);
    CorrFitSsort = [CorrFitSsort; [b(2) -1  b(1) -1]];
    b(2) = diff(CorrB(:,7))/diff(CorrB(:,6));
    b(1) = CorrB(1,7) - b(2)*CorrB(1,6);
    CorrFitFsort = [CorrFitFsort; [b(2) -1  b(1) -1]];
    
    b(2) = diff(CorrB(:,5))/diff(CorrB(:,3));
    b(1) = CorrB(1,5) - b(2)*CorrB(1,3);
    CorrFitSlong = [CorrFitSlong; [b(2) -1 b(1) -1]];
    b(2) = diff(CorrB(:,8))/diff(CorrB(:,6));
    b(1) = CorrB(1,8) - b(2)*CorrB(1,6);
    CorrFitFlong = [CorrFitFlong; [b(2) -1 b(1) -1]];
  end
  
  %keyboard
  
  clear ccg ccgL Speed SpPair;
 
end

%keyboard

C.corrS = CorrMaxS;
C.corrF = CorrMaxF;
C.corr = CorrA;

C.corrSshort = CorrFitSsort;
C.corrFshort = CorrFitFsort;
C.corrSlong = CorrFitSlong;
C.corrFlong = CorrFitFlong;

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
  


      
%sm(:,1) = smooth(mean(chh(:,neu,neu2,goodtr(slowP)),4),Filter,'lowess');
%sm(:,2) = smooth(mean(chh(:,neu,neu2,goodtr(fastP)),4),Filter,'lowess');
%smL(:,1) = smooth(mean(chhL(:,neu,neu2,goodtr(slowP)),4),FilterL,'lowess');
%smL(:,2) = smooth(mean(chhL(:,neu,neu2,goodtr(fastP)),4),FilterL,'lowess');

%min1(:,1) = LocalMinima(-sm(:,1),round(60*ccgRate*0.001/ccgBin),-10);
%min1(:,2) = sm(min1(:,1),1);
%[maxmin maxind] = max(min1(:,2));
%[srtmin indmin] = sort(abs(min1(:,1)-min1(maxind,1)));
%minS = min1(indmin(1:3),:);
%min2(:,1) = LocalMinima(-sm(:,2),round(60*ccgRate*0.001/ccgBin),-10);
%min2(:,2) = sm(min2(:,1),2);
%[maxmin maxind] = max(min2(:,2));
%[srtmin indmin] = sort(abs(min2(:,1)-min2(maxind,1)));
%minF = min2(indmin(1:3),:);

%CorrMaxS = [CorrMaxS; [t(minS(:,1))' ones(3,1)*neu ones(3,1)*neu2 ones(3,1)*xDist(1)]];
%CorrMaxF = [CorrMaxF; [t(minF(:,1))' ones(3,1)*neu ones(3,1)*neu2 ones(3,1)*xDist(2)]];





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

