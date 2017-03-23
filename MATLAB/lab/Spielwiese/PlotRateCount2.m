function PlotRateCount2(PlaceCell,trial,Tune,varargin)
[RepFig] = DefaultArgs(varargin,{0});

neurons = unique(PlaceCell.ind(:,1));
directions = unique(PlaceCell.ind(:,4));
gtrials = trial.itv(find(trial.dir>1),:);
gtrialdir =  trial.dir(find(trial.dir>1));

Speed = Tune.speed;

figure(278368);

for n=1:length(neurons)
  neu = neurons(n);
  
  Rate = Tune.rate(:,:,n)';
  
  clf;
  for dir=1:2;
    trindx = find(gtrialdir==dir+1);
    [MaxRate MaxInd] = max(Rate(:,trindx));
    AA=Accumulate([MaxInd' trindx],1,size(Rate));
    
    [so indx] = sort(MaxRate);
    %[so indx2] = sort(mean(Rate(:,trindx)));
    
    %keyboard
    
    subplot(3,2,dir)
    imagesc(Rate(:,trindx(indx))');
    %colorbar
    
    subplot(3,2,2+dir)
    imagesc(Speed(:,trindx(indx))');
    %colorbar
    
    subplot(3,2,4+dir)
    %plot(Speed(find(AA)),Rate(find(AA)),'.')
    plot(so,'.');hold on;plot(Speed(round(mean(indx)),trindx(indx)),'r.');

    clear trindx indx;
  end
  
  if RepFig
    reportfig([],[],[],['cell ' num2str(n)]);
  end
  
  waitforbuttonpress
    
end
