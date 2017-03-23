function Tune = RateTune(FileBase,PlaceCell,whl,trial,spike,varargin)
%function Tune = RateTune(FileBase,PlaceCell,whl,trial,spike,varargin)
%[SpikeThr,Split,overwrite,Plotting] = DefaultArgs(varargin,{3,[50],0,1});
% compute tuning curves and average them over speed percentile
[SpikeThr,Split,overwrite,Plotting] = DefaultArgs(varargin,{3,[50],0,1});

%%%%%%%%%
%prctile

RateFactor = 20000/whl.rate;

if ~FileExists([FileBase '.tune']) | overwrite
  
  neurons = unique(PlaceCell.ind(:,1));
  directions = unique(PlaceCell.ind(:,4));
  gtrials = trial.itv(find(trial.dir>1),:);
  gtrialdir =  trial.dir(find(trial.dir>1));
  
  %% position-bins:
  pos = round(whl.lin);
  trialindwh = WithinRanges([1:length(whl.lin)],gtrials,[1:length(gtrials)]','vector')';
  gpos = (pos>0 & trialindwh >0);
  OccCnt = Accumulate([pos(gpos) trialindwh(gpos)],1,[max(pos) max(trialindwh)]);
  [AvS Std Bins] = MakeAvF([trialindwh(gpos) pos(gpos)],whl.speed(gpos,1),[max(trialindwh) max(pos)]);
  
  %% occupancy and speed
  for tr=1:length(gtrials)
    % occupancy
    smOccCnt(:,tr) = smooth(OccCnt(:,tr),5,'lowess');
    % speed
    [t,intpos,fintpos]=Interpol(find(AvS(tr,:)'>0),AvS(tr,find(AvS(tr,:)'>0))');
    Speed(find(AvS(tr,:)'<=0),tr) = 0;
    Speed(t,tr) = intpos';
    %% interpolate edges 
    n=1;
    while Speed(n,tr)==0
      n=n+1;
    end
    if n>1
      Speed(1:n-1,tr) = Speed(n,tr);
    end
    n=length(Speed(:,tr));
    while Speed(n,tr)==0
      n=n-1;
    end
    if n<length(Speed(:,tr))
      Speed(n+1:length(Speed(:,tr)),tr) = Speed(n,tr);
    end
    Speed(:,tr) = smooth(Speed(:,tr),10,'lowess');
  end
  
  %% spike count - Rate
  SpkCnt = Accumulate([round(spike.t/RateFactor) spike.ind],1,[length(whl.lin) max(spike.ind)])*whl.rate;
  count = 0;
  for n=unique(PlaceCell.ind(:,1))'
    %if PlaceCell.ind(:,5)~=1
    %  continue
    %end
    count=count+1;
    [AvR(:,:,count) StdR(:,:,count) Bins] = MakeAvF([trialindwh(gpos) pos(gpos)],SpkCnt(gpos,n),[length(gtrials) max(pos)]);
    for tr=1:size(AvR,1)
      smAvR(tr,:,count) = smooth(AvR(tr,:,count),15,'lowess');
    end
  end  
  
  %% Direction:
  dires = [{find(gtrialdir==2)},{find(gtrialdir==3)}];
  
  %% Mean Rate
  for n=1:count
    for dire = 1:length(dires)
      MeanRate(:,n,dire) = smooth(mean(smAvR(dires{dire},:,n),1)',10,'lowess');
      MMeanRate(:,n,dire) = MeanRate(:,n,dire)/max(MeanRate(:,n,dire));
    end
  end
  
  %% Speed of each place-field-trial
  for n=1:size(PlaceCell.trials,1)
    speedAll(n,1) = mean(whl.speed(PlaceCell.trials(n,2):PlaceCell.trials(n,3),1));
  end
  for n=1:size(PlaceCell.ind,1)
    speed(:,1) = speedAll(find(PlaceCell.trials(:,1)==n));
    [sorted indx] = sort(speed,1,'descend'); %% fast first!!
    AveSpeed(n) = {[sorted indx]};
    clear speed sorted indx;
  end
  
  %% select trials
  neurons = unique(PlaceCell.ind(:,1));
  count2 = 0;
  for dire = 1:length(dires)
    for n=1:count
      dd = dires{dire};
	if ~isempty(find(PlaceCell.ind(:,1)==neurons(n) & PlaceCell.ind(:,4)==directions(dire)))
	  if length(find(PlaceCell.ind(:,1)==neurons(n) & PlaceCell.ind(:,4)==directions(dire)))==1
	    indx = AveSpeed{find(PlaceCell.ind(:,1)==neurons(n) & PlaceCell.ind(:,4)==directions(dire))};
	  else
	    indx = AveSpeed{min(find(PlaceCell.ind(:,1)==neurons(n) & PlaceCell.ind(:,4)==directions(dire)))};
	  end
	else
	  indx(:,2) = find(dd);
	end
	count2 = count2+1;
	%AveSpeedInd(count2) = {indx};
	AveSpeedInd(n,dire) = {indx};
	clear indx dd;
    end
  end
  
  Tune.speed = Speed;
  Tune.rate = smAvR;
  Tune.mrate = MeanRate;
  Tune.pftrspeed = AveSpeedInd;
  
  save([FileBase '.tune'],'Tune');
  
else
  
  load([FileBase '.tune'],'-MAT');
end

%% plotting
if Plotting
  %keyboard
  coloring = [{'b'}, {'r'},{'g'}]; 
  neurons = unique(PlaceCell.ind(:,1));
  gtrialdir =  trial.dir(find(trial.dir>1));
  count2 = 0;
  dires = [{find(gtrialdir==2)},{find(gtrialdir==3)}];
  for dire = 1:length(dires)
    figure(1)
    subplot(1,length(dires),dire)
    imagesc(Tune.speed(:,dires{dire})')
    figure(2)
    for n=1:size(Tune.mrate,2)
      MRate(:,n) = ones(size(Tune.mrate,1),1)*max(Tune.mrate(:,n,dire));
    end
    PlotTraces(Tune.mrate(:,:,dire)./MRate,[],[],[],coloring{dire});
    hold on
    axis off
    figure(2+dire)
    for n=1:length(unique(PlaceCell.ind(:,1)))
      subplotfit(n,length(unique(PlaceCell.ind(:,1))))
      dd = dires{dire};
      indx = Tune.pftrspeed{n,dire};
      plot(mean(Tune.rate(dd(indx(1:round(size(indx,1)/2),2)),:,n)),'r');
      hold on
      plot(mean(Tune.rate(dd(indx(round(size(indx,1)/2)+1:end,2)),:,n)),'b');
      axis tight
      axis off
    end
    figure(2+length(dires)+dire)
    for n=1:length(unique(PlaceCell.ind(:,1)))
      subplotfit(n,length(unique(PlaceCell.ind(:,1))))
      dd = dires{dire};
      indx = Tune.pftrspeed{n,dire};
      imagesc(Tune.rate(dd(indx(:,2)),:,n))
      %imagesc(Tune.rate(:,:,n))
      count2 = count2+1;
      clear indx dd;
      title(num2str(neurons(n)))
    end
    clear MRate dd indx; 
  end
end

return;

%%%%%%%%%%%%%%%%%%%%%%



trialspeed(2,:) = prctile(triallength(find(triallength(:,2)>0),2),Split);
trialspeed(3,:) = prctile(triallength(find(triallength(:,3)>0),3),Split);

fasttr2 = (triallength(:,2)<trialspeed(2,1) & gtrialdir==2);
slowtr2 = (triallength(:,2)>trialspeed(2,end) & gtrialdir==2);
fasttr3 = (triallength(:,3)<trialspeed(3,1) & gtrialdir==3);
slowtr3 = (triallength(:,3)>trialspeed(3,end) & gtrialdir==3);

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





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
neurons = unique(PlaceCell.ind(:,1));
directions = unique(PlaceCell.ind(:,4));
gtrials = trial.itv(find(trial.dir>1),:);
gtrialdir =  trial.dir(find(trial.dir>1));

Speed = ALL.tune.speed;
for tr=1:length(gtrials)
  n=1;
  while Speed(n,tr)==0
    n=n+1;
  end
  if n>1
    Speed(1:n-1,tr) = Speed(n,tr);
  end
  n=length(Speed(:,tr));
  while Speed(n,tr)==0
    n=n-1;
  end
  if n<length(Speed(:,tr))
    Speed(n+1:length(Speed(:,tr)),tr) = Speed(n,tr);
  end
  Speed(:,tr) = smooth(Speed(:,tr),10,'lowess');
end
  
figure

for n=1:length(neurons)
  neu = neurons(n);
  
  Rate = ALL.tune.rate(:,:,n)';
  Norm = Rate./Speed;
  
  clf;
  for dir=1:2;
    trindx = find(trial.dir==dir+1);
    Trial = ALL.tune.pftrspeed{n,dir}(:,2);
    
    subplot(4,2,dir)
    imagesc(Rate(:,trindx)');
    %colorbar
    
    subplot(4,2,2+dir)
    plot(mean(Rate(:,trindx(Trial(1:round(length(Trial)/2))))'),'r')
    hold on
    plot(mean(Rate(:,trindx(Trial(round(length(Trial)/2):end)))'))
    axis tight
    
    subplot(4,2,4+dir)
    imagesc(Norm(:,trindx)');
    %colorbar
    
    subplot(4,2,6+dir)
    plot(mean(Norm(:,trindx(Trial(1:round(length(Trial)/2))))'),'r')
    hold on
    plot(mean(Norm(:,trindx(Trial(round(length(Trial)/2):end)))'))
    axis tight
    
    clear trindx Trial;
  end
    
  waitforbuttonpress
end
