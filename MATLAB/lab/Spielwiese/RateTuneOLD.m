function Tune = RateTuneOLD(FileBase,PlaceCell,whl,trial,spike,varargin)
[SpikeThr,Split,overwrite] = DefaultArgs(varargin,{3,[50],1});

% compute tuning curves and average them over speed percentile

%%%%%%%%%
%prctile

RateFactor = 20000/whl.rate;

if ~FileExists([FileBase '.tune']) | overwrite
  
  CatPlaceCell = CatStruct(PlaceCell,[],1);
  
  %% position-bins:
  rpos = round(whl.lin);
  trialindwh = WithinRanges(find(whl.lin),trial.itv,[1:length(trial.itv)]','vector');
  nowh = (rpos>0 & trialindwh' >0);
  OccCnt = Accumulate([rpos(nowh) trialindwh(nowh)'],1,[max(rpos) max(trialindwh)]);
  for tr=1:length(trial.itv)
    smOccCnt(:,tr) = smooth(OccCnt(:,tr),5,'lowess');
  end

  binpos = [floor(min(whl.lin(find(whl.lin>-10)))):1:ceil(max(whl.lin))];
  [h posind] = histcI(spike.lpos(find(spike.good)),binpos);
  trialind = WithinRanges(round(spike.t(find(spike.good))/RateFactor),trial.itv,[1:length(trial.itv)]','vector');
  nosp = (trialind'>0 & posind>0);
  SpkCnt = Accumulate([posind(nosp) trialind(nosp)' spike.ind(nosp)],1,[max(rpos) max(trialind) max(spike.ind)]);
  
  %% whl data within trials
  goodwhl = WithinRanges([1:length(whl.lin)],trial.itv,[1:length(trial.itv)],'vector')';
  
  count = 0;
  for neu=unique(CatPlaceCell.indall(find(CatPlaceCell.indall(:,5)>0),1))';
    
    fprintf([num2str(neu) '... ']);
    
    count = count+1;
    Tune.ind(count) = [neu];
    for tr=1:length(trial.itv)
      smSpkCnt(:,tr,count) = smooth(SpkCnt(:,tr,neu),5,'lowess')./smOccCnt(:,tr);
    end
    
    neu
    
    %keyboard
    
    if ismember(neu,CatPlaceCell.ind(:,1))
      lfieldinx = find(CatPlaceCell.ind(:,1)==neu);
      %newinvls = NonoverlapTrials(CatPlaceCell.lfield(:,lfieldinx)');
      goodinfield = WithinRanges(whl.lin,CatPlaceCell.lfield(lfieldinx,:));
      
      indxx = goodwhl>0 & whl.dir>1 & goodinfield>0;
      
      triallength = Accumulate([goodwhl(indxx) whl.dir(indxx)],1,[max(goodwhl) max(whl.dir(indxx))]);
    else
      indxx = goodwhl>0 & whl.dir>1;
      triallength = Accumulate([goodwhl(indxx) whl.dir(indxx)],1,[max(goodwhl) max(whl.dir(indxx))]);
    end
    
    trialspeed(2,:) = prctile(triallength(find(triallength(:,2)>0),2),Split);
    trialspeed(3,:) = prctile(triallength(find(triallength(:,3)>0),3),Split);
        
    fasttr2 = (triallength(:,2)<trialspeed(2,1) & trial.dir==2);
    slowtr2 = (triallength(:,2)>trialspeed(2,end) & trial.dir==2);
    fasttr3 = (triallength(:,3)<trialspeed(3,1) & trial.dir==3);
    slowtr3 = (triallength(:,3)>trialspeed(3,end) & trial.dir==3);
    
    FastTune(:,2,count) = mean(smSpkCnt(:,fasttr2,count),2)*whl.rate;
    Tune.fast(:,2,count) = smooth(FastTune(:,2,count),10,'lowess');
    FastTune(:,3,count) = mean(smSpkCnt(:,fasttr3,count),2)*whl.rate;
    Tune.fast(:,3,count) = smooth(FastTune(:,3,count),10,'lowess');
    
    SlowTune(:,2,count) = mean(smSpkCnt(:,slowtr2,count),2)*whl.rate;
    Tune.slow(:,2,count) = smooth(SlowTune(:,2,count),10,'lowess');
    SlowTune(:,3,count) = mean(smSpkCnt(:,slowtr3,count),2)*whl.rate;
    Tune.slow(:,3,count) = smooth(SlowTune(:,3,count),10,'lowess');
    
    subplot(311)
    plot(Tune.slow(:,2,count))
    hold on
    plot(Tune.fast(:,2,count),'r')
    hold off 
    
    subplot(312)
    plot(Tune.slow(:,3,count))
    hold on
    plot(Tune.fast(:,3,count),'r')
    hold off 
    
    %subplot(325)
    %hist([triallength(:,2)*whl.rate triallength(:,3)*whl.rate])
    %Lines([trialspeed(2:3,:)]);

    %subplot(326)
    %hist(triallength(:,3)*whl.rate)
    %Lines([trialspeed(3,:)]);
    
    waitforbuttonpress
    
  end
  
  save([FileBase '.tune'],'Tune');
  
else
  
  load([FileBase '.tune']);
  
end
  
return;
