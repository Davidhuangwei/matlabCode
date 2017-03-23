function PlotRateCount(PlaceCell,trial,Tune,varargin)
[Plotting,RepFig] = DefaultArgs(varargin,{1,0});

neurons = unique(PlaceCell.ind(:,1));
directions = unique(PlaceCell.ind(:,4));
gtrials = trial.itv(find(trial.dir>1),:);
gtrialdir =  trial.dir(find(trial.dir>1));

Speed = Tune.speed;
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
  
figure(238746)

for n=1:length(neurons)
  neu = neurons(n);
  
  Rate = Tune.rate(:,:,n)';
  Norm = Rate./Speed;
  Norm(find(Norm<0)) = 0;  
  
  clf;
  for dir=1:2;

    %keyboard
      
    trindx = find(gtrialdir==dir+1);
    Trial = Tune.pftrspeed{n,dir}(:,2);
    
    RateIntv = find(WithinRanges([1:size(Rate,1)],PlaceCell.lfield(find(PlaceCell.ind(:,1)==neu&PlaceCell.ind(:,4)==dir+1),:)));
    
    if length(RateIntv)<2
      RateIntv = [1:size(Rate,1)]';
    end
    
    MaxRate = max(Rate(RateIntv,trindx(Trial)));
    GoodTrials = trindx(Trial(find(MaxRate>10.0)));

    if length(GoodTrials)<2
      continue;
    end
    
    subplot(5,2,dir)
    imagesc(Speed(:,GoodTrials)');
    %colorbar
    
    subplot(5,2,2+dir)
    imagesc(Rate(:,GoodTrials)');
    %imagesc(Rate(:,trindx)');
    %colorbar
    
    subplot(5,2,4+dir)
    plot(mean(Rate(:,GoodTrials(1:round(length(GoodTrials)/2)))'),'r')
    hold on
    plot(mean(Rate(:,GoodTrials(round(length(GoodTrials)/2):end))'))
    axis tight
    
    subplot(5,2,6+dir)
    imagesc(Norm(:,trindx)');
    %colorbar
    
    subplot(5,2,8+dir)
    plot(mean(Norm(:,GoodTrials(1:round(length(GoodTrials)/2)))'),'r')
    hold on
    plot(mean(Norm(:,GoodTrials(round(length(GoodTrials)/2):end))'))
    axis tight
    
    clear trindx Trial;
  end
  
  if RepFig
    reportfig([],[],[],['cell ' num2str(n)]);
  end
  
  waitforbuttonpress
    
end
