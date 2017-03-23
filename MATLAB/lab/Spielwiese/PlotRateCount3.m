function PlotRateCount3(PlaceCell,trial,Tune,varargin)
[RepFig] = DefaultArgs(varargin,{0});

neurons = unique(PlaceCell.ind(:,1));
directions = unique(PlaceCell.ind(:,4));
gtrials = trial.itv(find(trial.dir>1),:);
gtrialdir =  trial.dir(find(trial.dir>1));

Speed = Tune.speed;

figure(834759);


for n=1:length(PlaceCell.ind(:,1))
  neu = PlaceCell.ind(n,1);
  dir=PlaceCell.ind(n,4);
  
  Lstart = ceil(PlaceCell.lfield(n,1));
  Lend = floor(PlaceCell.lfield(n,2));
  
  Rate = Tune.rate(:,:,find(neurons==neu))';
  Norm = Rate./Speed;
  
  trindx = find(gtrialdir==dir);
  [MaxRate MaxInd] = max(Rate(Lstart:Lend,trindx));
  AA=Accumulate([MaxInd' trindx],1,size(Rate));
  
  [so indx] = sort(MaxRate);
  %[so indx2] = sort(mean(Rate(:,trindx)));
  
  % keyboard
 
  clf
  subplot(421)
  imagesc(Rate(:,trindx)');
  subplot(422)
  imagesc(Rate(:,trindx(indx))');
  title(['cell ' num2str(neu) ' | dir ' num2str(dir)]);
  %colorbar
  
  subplot(423)
  imagesc(Norm(:,trindx)');
  subplot(424)
  imagesc(Norm(:,trindx(indx))');

  subplot(425)
  imagesc(Speed(:,trindx)');
  subplot(426)
  imagesc(Speed(:,trindx(indx))');
  %colorbar
  
  subplot(427)
  %plot(Speed(find(AA)),Rate(find(AA)),'.')
  plot(so,'.');hold on;plot(Speed(round(mean(indx)),trindx(indx)),'r.');

  subplot(427)
  %plot(Speed(find(AA)),Rate(find(AA)),'.')
  plot(so,'.');hold on;plot(Speed(round(mean(indx)),trindx(indx)),'r.');
  
  clear trindx indx;
  
  
  if RepFig
    reportfig([],[],[],['cell ' num2str(n)]);
  end
  
  waitforbuttonpress
    
end

