function Speed = RateVsSpeedTr(FileBase,whl,trial,spike,PlaceCell,Speed,Eeg,varargin)
[overwrite,Plotting] = DefaultArgs(varargin,{0,0});
% function Speed = RateVsSpeed(FileBase,whl,trial,spike,PlaceCell,varargin)
% [overwrite] = DefaultArgs(varargin,{0});
%
% Rate vs. Speed
%
% output:

RateFactor = 20000/whl.rate;

if ~FileExists([FileBase '.ratespeed']) | overwrite
  
  cells = unique(PlaceCell.ind(:,1));
  mrate = [];
  
  Speed.count = [];
  Speed.speed = [];
  Speed.rate = []; 
  Speed.theta = [];
  Speed.slopeR = [];
  Speed.slopeC = [];
  Speed.slopeT = [];

  EegRate = 1250;
  NFreq = EegRate/2;
  Eegf = ButFilter(Eeg,2,[4 12]/NFreq,'bandpass');
  Eegf = Eegf - mean(Eegf);
  EegMin = LocalMinima(Eegf,100);
  
  for neu=1:size(PlaceCell.ind,1)
    
    neuron = find(cells==PlaceCell.ind(neu,1));
    dire = PlaceCell.ind(neu,4);
    gtrials = find(trial.dir(find(trial.dir>1))==dire);
    
    trials = PlaceCell.trials(find(PlaceCell.trials(:,1)==neu),2:3);
    spikes = WithinRanges(round(spike.t/RateFactor),trials,[1:size(trials,1)],'vector')'.*(spike.ind==PlaceCell.ind(neu,1) & spike.good);
    
    Theta = WithinRanges(round(EegMin/EegRate*whl.rate),trials,[1:size(trials,1)],'vector')';
    
    %% Count
    Count(:,3) = Accumulate(spikes(find(spikes>0)),1,size(trials,1));
    Count(:,1) = neu;
    Count(:,2) = find(trial.dir==dire);%find(trials(:,1));
    %% count Theta
    CTheta(:,1) =  Count(:,3)./Accumulate(Theta(find(Theta>0)),1,size(trials,1));
    CTheta(:,2) =  Accumulate(Theta(find(Theta>0)),1,size(trials,1));
    
    %% Speed
    smspeed = smooth(whl.speed(:,1),round(whl.rate)/2,'lowess');
    smspeedL = smooth(whl.speedlin(:,1),round(whl.rate)/2,'lowess');
    %% Rate
    rate =  smooth(Accumulate([round(spike.t(find(spikes))/RateFactor)],1,[length(whl.lin)])*whl.rate,1000,'lowess');
    
    %% Mean Speed of Spikes - bias toward center of place field
    SpSpeed = MakeAvF(spikes(find(spikes>0)),smspeed(round(spike.t(find(spikes>0))/RateFactor),1),size(trials,1));
    SpRate = MakeAvF(spikes(find(spikes>0)),rate(round(spike.t(find(spikes>0))/RateFactor),1),size(trials,1));
    
    %% Mean Speed in Interval
    for n=1:size(trials,1)
      Speed1(n,:) = [mean(smspeed(trials(n,1):trials(n,1),1))];
    end

    %% Rate
    Rate1 = Count(:,3)./diff(trials')'*whl.rate;
    %for n=1:size(trials,1)
    %  Rate2(n,1) = 20000./mean(diff(spike.t(find(spikes==n))));
    %end
    
    for n=1:size(trials,1)
      MaxRate(n,1) = max(rate(trials(n,1):trials(n,2)));
    end

    %% slope: rate/count vs speed  
    goodRate = find(Rate1>3);
    if ~isempty(goodRate) & length(goodRate)>2
      [b stats] = robustfit(Speed1(goodRate),Rate1(goodRate));
      SlopeR = [b(2) b(1) stats.p(2) stats.p(1)];
      [b stats] = robustfit(Speed1(goodRate),Count(goodRate,3));
      SlopeC = [b(2) b(1) stats.p(2) stats.p(1)];
      [b stats] = robustfit(Speed1(goodRate),CTheta(goodRate,1));
      SlopeT = [b(2) b(1) stats.p(2) stats.p(1)];
    elseif length(goodRate)==2
      SlopeR = [diff(Rate1(goodRate))/diff(Speed1(goodRate)) Rate1(goodRate(1))-diff(Rate1(goodRate))/diff(Speed1(goodRate))*Speed1(goodRate(1)) 1 1];
      SlopeC = [diff(Count(goodRate,3))/diff(Speed1(goodRate)) Count(goodRate(1),3)-diff(Count(goodRate,3))/diff(Speed1(goodRate))*Speed1(goodRate(1)) 1 1];
      SlopeT = [diff(CTheta(goodRate,1))/diff(Speed1(goodRate)) CTheta(goodRate(1),1)-diff(CTheta(goodRate),1)/diff(Speed1(goodRate))*Speed1(goodRate(1)) 1 1];
    else
      SlopeR = [NaN 0 1 1];
      SlopeC = [NaN 0 1 1];
      SlopeT = [NaN 0 1 1];
    end
      
    %% All together
    Speed.count = [Speed.count; Count];
    Speed.speed = [Speed.speed; [Speed1 SpSpeed]];
    Speed.rate = [Speed.rate; [Rate1 MaxRate SpRate]];
    Speed.theta = [Speed.theta; CTheta];
    Speed.slopeR = [Speed.slopeR; SlopeR];
    Speed.slopeC = [Speed.slopeC; SlopeC];
    Speed.slopeT = [Speed.slopeT; SlopeT];
    
    %% clear
    clear Count Speed1 SpSpeed Rate1 MaxRate SpRate CTheta;
    
  end
    
  save([FileBase '.ratespeed'],'Speed');
  
else
  
  load([FileBase '.ratespeed'],'-MAT');
  
end
%% Plot

if Plotting
  for n=1:length(PlaceCell.ind)
    n
    
    if PlaceCell.ind(:,5)==2
      continue
    end
    
    figure(3274);clf;
    indx = find(Speed.count(:,1)==n);
    subplot(121)
    plot(Speed.speed(indx,1),Speed.rate(indx,1),'.')
    hold on
    plot(Speed.speed(indx,1),Speed.speed(indx,1)*Speed.slopeR(n,1)+Speed.slopeR(n,2),'r')
    title(['p=' num2str(Speed.slopeR(n,3))])
    subplot(122)
    plot(Speed.speed(indx,1),Speed.count(indx,3),'.')
    hold on
    plot(Speed.speed(indx,1),Speed.speed(indx,1)*Speed.slopeC(n,1)+Speed.slopeC(n,2),'r')
    title(['p=' num2str(Speed.slopeC(n,3))])
    
    waitforbuttonpress
  end
end

return