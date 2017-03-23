function Count = RateCount(PlaceCell,trial,Tune,varargin)
[Plotting,RepFig] = DefaultArgs(varargin,{0,0});

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
count=0;
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

    if length(GoodTrials)<4
      continue;
    end
    
    MeanRateF = mean(Rate(:,GoodTrials(1:round(length(GoodTrials)/2)))');
    MeanRateS = mean(Rate(:,GoodTrials(round(length(GoodTrials)/2):end))');
    MeanNormF = mean(Norm(:,GoodTrials(1:round(length(GoodTrials)/2)))');
    MeanNormS = mean(Norm(:,GoodTrials(round(length(GoodTrials)/2):end))');
      
    if Plotting
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
    end
  
    %% Accumulate
    count = count+1;
    Count.max(count,:) = [max(MeanRateF(RateIntv)) max(MeanRateS(RateIntv)) max(MeanNormF(RateIntv)) max(MeanNormS(RateIntv))];
    Count.int(count,:) = [mean(MeanRateF(RateIntv)) mean(MeanRateS(RateIntv)) sum(MeanNormF(RateIntv)) sum(MeanNormS(RateIntv))];
    
    clear trindx Trial;
  end
  
  if RepFig
    reportfig([],[],[],['cell ' num2str(n)]);
  end
  
  if Plotting
    waitforbuttonpress
  end
  
end

return;

figure
subplot(221)
hist(Count.max(:,1)-Count.max(:,2))
subplot(222)
hist(Count.max(:,3)-Count.max(:,4))
subplot(223)
plot(Count.max(:,1)-Count.max(:,2),Count.max(:,3)-Count.max(:,4),'.')
subplot(224)
plot(Count.max(:,1)./Count.max(:,2),Count.max(:,3)./Count.max(:,4),'.')
hold
plot([0 3],[0 3],'r')
figure
subplot(221)
hist(Count.int(:,1)-Count.int(:,2))
subplot(222)
hist(Count.int(:,3)-Count.int(:,4))
subplot(223)
plot(Count.int(:,1)-Count.int(:,2),Count.int(:,3)-Count.int(:,4),'.')
subplot(224)
plot(Count.int(:,1)./Count.int(:,2),Count.int(:,3)./Count.int(:,4),'.')
hold
plot([0 3],[0 3],'r')
