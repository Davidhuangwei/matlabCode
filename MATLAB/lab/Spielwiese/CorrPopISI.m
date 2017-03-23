function C = CorrPopISI(PlaceCell,spike,whl,trial,Rate,Tune,varargin)
[Filter,FilterL,plotting] = DefaultArgs(varargin,{30,100,0});
%
%function CorrPop(PlaceCell,spike,whl,trial,varargin)
%[plotting] = DefaultArgs(varargin,{0});
%

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
  [neurons nindx] = unique(PlaceCell.ind(find(PlaceCell.ind(:,4)==dire & PlaceCell.ind(:,5)==1),1));
  
  %% time interval of place cells
  gintv = ismember(PlaceCell.trials(:,1),find(PlaceCell.ind(:,5)==1&PlaceCell.ind(:,4)==dire));

  %% sort overlapping intervals
  ranges = NoOverlapRanges(PlaceCell.trials(find(gintv),2:3));
  whlinfields = WithinRanges([1:size(whl.dir,1)],ranges);

  %% get all the spikes in the place fields
  gspikes = ismember(spike.ind,neurons) & WithinRanges(round(spike.t/20000*whl.rate),ranges);
  
  %% for distance between place fields (from tuning curves):
  tneu = unique(PlaceCell.ind(:,1));
  gttr = find(trial.dir>1);
  ttr = find(trial.dir(gttr)==dire);
  
  %% speed for each trial/pair
  count = 0;
  for neu=1:length(neurons)
    for neu2=neu+1:length(neurons)
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
  
  count = 0;
  for neu=1:length(neurons)
    for neu2=neu+1:length(neurons)
      goodtr = find(max(Tune.rate(ttr,:,find(tneu==neurons(neu)))')>10 & max(Tune.rate(ttr,:,find(tneu==neurons(neu2)))')>10);
      [SrtPair IxPair] = sort(SpPair(goodtr,neu)); %%!! sorting with PAIR info!!!
      slowP = IxPair(1:round(length(IxPair)/2));
      fastP = IxPair(round(length(IxPair)/2)+1:length(IxPair));
      SpeedS = mean(SrtPair(1:round(length(IxPair)/2)));
      SpeedF = mean(SrtPair(round(length(IxPair)/2)+1:length(IxPair)));
      
      %% x-distance between fields 
      tuneS(:,1) = mean(Tune.rate(ttr(goodtr(slowP)),:,find(tneu==neurons(neu))),1)';
      tuneS(:,2) = mean(Tune.rate(ttr(goodtr(slowP)),:,find(tneu==neurons(neu2))),1)';
      tuneF(:,1) = mean(Tune.rate(ttr(goodtr(fastP)),:,find(tneu==neurons(neu))),1)';
      tuneF(:,2) = mean(Tune.rate(ttr(goodtr(fastP)),:,find(tneu==neurons(neu2))),1)';
      [Max Maxind] = max([tuneS(:,1) tuneF(:,1)]);
      
      % get time of max tuning curve in each trial!
      for tr=1:length(goodtr)
	goodpos = []; clear goodpos;  
	goodpos(:,1) = [trial.itv(ttr(goodtr(tr)),1):trial.itv(ttr(goodtr(tr)),2)]'; 
	goodpos(:,2) = whl.lin(goodpos(:,1)); 
	[Min MinInd] = min([abs(goodpos(:,2)-Maxind(1)) abs(goodpos(:,2)-Maxind(2))]);
	InTrialsT(tr,:) = goodpos(MinInd,1)';
      end
      
      gspiket = find((spike.ind==neurons(neu) | spike.ind==neurons(neu2)) & spike.good);
      %spiket = [round(spike.t(gspiket)/20000*whl.rate); reshape(InTrialsT,1,2*tr)'];
      spiket = [spike.t(gspiket); 20000/whl.rate*reshape(InTrialsT,1,2*tr)'];
      spikeind = [spike.ind(gspiket); (max(neurons)+1)*ones(tr,1); (max(neurons)+2)*ones(tr,1)];
      
      %[ccg, t] = CCG(spiket,spikeind,4,200,whl.rate,[1 2 3]);
      [ccg, t] = CCG(spiket,spikeind,800,100,ccgRate,unique(spikeind));
      
      %keyboard
      figure(32554);clf
      subplot(211)
      plot(t,smooth(ccg(:,1,3),10,'lowess'))
      hold on
      plot(t,smooth(ccg(:,2,3),10,'lowess'),'r')

      subplot(212)
      plot(t,smooth(ccg(:,1,4),10,'lowess'))
      hold on
      plot(t,smooth(ccg(:,2,4),10,'lowess'),'r')

      
      %waitforbuttonpress
      comment = ['neurons ' num2str(neu) ' and ' num2str(neu2)];
      reportfig(gcf,[],[],comment,150)
      
      
      %%% put it together
      %CorrMaxS = [CorrMaxS; [minS ones(size(minS))*neu ones(size(minS))*neu2 ones(size(minS))*xDist(1)]];
      %CorrMaxF = [CorrMaxF; [minF ones(size(minF))*neu ones(size(minF))*neu2 ones(size(minF))*xDist(2)]];
      %CorrA = [CorrA; [neu neu2 xDist(1) minS1st tLS SpeedS xDist(2) minF1st tLF SpeedF]];
      
      clear min1 min2 minF minS InTrialsT;
    end
  end
  %keyboard
  
  clear ccg ccgL Speed SpPair;
 
end

%keyboard

%C.corrS = CorrMaxS;
%C.corrF = CorrMaxF;
%C.corr = CorrA;

%C.corrSshort = CorrFitSsort;
%C.corrFshort = CorrFitFsort;
%C.corrSlong = CorrFitSlong;
%C.corrFlong = CorrFitFlong;


return;

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

