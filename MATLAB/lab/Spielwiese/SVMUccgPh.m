function xcorrl = SVMUccgPh(FileBase,spiket,spikei,varargin)
[run,gPC,gIN,allPC,overwrite,PLOT,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{[],[],[],[],0,0,'.xcorrPh',1250,20000});

if ~FileExists([FileBase FileOut]) | overwrite
  
  %%%%%%%%%%%%%%
  %% Eeg
  Phase =  InternThetaPh(FileBase);
  UPhase = unwrap(mod(Phase.deg+2*pi,2*pi))*180/pi;
  
  %%%%%%%%%%%%%%
  %% all (good) cells
  if isempty(gPC)
    gPC = unique(spikei);
  end
  if isempty(gIN)
    gIN = unique(spikei);
  end
  gindx = find(WithinRanges(round(spiket/SampleRate*EegRate),run) & ismember(spikei,unique([gPC gIN])));
  
  [xccg, ph] = CCG(UPhase(round(spiket(gindx)*EegRate/SampleRate)),spikei(gindx),10,100,360);  
  ccg = GetDiagonal(xccg);
  
  %% insert zeros for spike-less cells:
  ncell = find(ismember(unique(spikei),unique(spikei(gindx))));
  yccg = zeros(size(ph,2),max(spikei));
  yccg(:,ncell) = ccg;
  
  %% smooth
  syccg = ButFilter(yccg,1,0.1,'low');

  %% MUA
  muaix = find(WithinRanges(round(spiket/SampleRate*EegRate),run) & ismember(spikei,allPC));
  [xmua, uph] = CCG(UPhase(round(spiket(muaix)*EegRate/SampleRate)),ones(size(muaix)),10,100,360);  
  %% smooth
  smua = ButFilter(xmua,1,0.1,'low');
 
  
  %% get local maxima
  for n=1:size(syccg,2)
    sc = syccg(:,n);
    mm = LocalMinima(-sc,20,-max(sc)/10);
    [mid imid] = max(sc(mm));
    [msort,isort] = sort(abs(mm-mm(imid)));
    if length(isort)<5
      mccg(:,n) = ones(5,1);
      mccg(1:length(isort),n) = sort(mm(isort));
      mccg(:,n) = sort(mccg(:,n));
    else
      mccg(:,n) = sort(mm(isort(1:5)));
    end
    freq(n) = mean(diff(ph(mccg(:,n))))/360;
    signal(:,n) = [mean(sc(mccg(1,n):mccg(end,n))) max(sc(mccg(1,n):mccg(end,n))) min(sc(mccg(1,n):mccg(end,n)))];
    statmccg(:,n) = [mean(diff(ph(mccg(:,n)))) std(diff(ph(mccg(:,n))))];
  end
  
  %% PLOT 
  %figure(3475);clf
  %subplot(211)
  gt = [round(size(ccg,1)/2):size(ccg,1)];
  imagesc(ph(gt)/1000,[],unity(syccg(gt,gPC))')
  Lines([1 2],[],'k','--',2);
  axis xy
  hold on
  plot(ph(mccg(4,gPC))/1000,[1:length(gPC)],'k+')
  plot(uph(gt)/1000,smua(gt)/max(smua(gt))*length(gPC),'--r','LineWidth',2)
  set(gca,'TickDir','out','FontSize',16)
  xlabel('theta cycles','FontSize',16)
  ylabel('cell #','FontSize',16)
  box off
  %subplot(212)
  %imagesc(ph(gt)/1000,[],unity(syccg(gt,gIN))')
  %Lines([1 2],[],'k','--',2);
  %axis xy
  %hold on
  %plot(ph(mccg(4,gIN))/1000,[1:length(gIN)],'k+')
  %Lines(360+circmean(ph(mccg(4,gIN))*pi/180)*180/pi);
  
  xcorrl.t = ph(gt)/1000;
  xcorrl.uccg = syccg(gt,:);
  xcorrl.max = ph(mccg(4,:))/1000;
  xcorrl.mccg = smua(gt);
  
  save([FileBase FileOut],'xcorrl');
else
  
  load([FileBase FileOut],'-MAT')
end
