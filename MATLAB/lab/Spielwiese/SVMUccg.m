function xcorrl = SVMUccg(FileBase,Eeg,spike,run,varargin)
[overwrite,PLOT,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{0,0,'.xcorr',1250,20000});

if ~FileExists([FileBase FileOut]) | overwrite

  %%%%%%%%%%%%%%
  %% Eeg
  wEeg = Eeg(find(WithinRanges([1:length(Eeg)],run)));
  [Eegccg lags] = xcorr(wEeg,wEeg,2*EegRate);
  % minima
  mm = LocalMinima(-Eegccg,100/mean(diff(lags)));
  [mid imid] = max(Eegccg(mm));
  [msort,isort] = sort(abs(mm-mm(imid)));
  meccg = sort(mm(isort(1:7)));
  efreq = 1/mean(diff(lags(meccg)/EegRate));

  %%%%%%%%%%%%%%
  %% spikes - ALL
  gindx = find(WithinRanges(round(spike.t/SampleRate*EegRate),run));
  dt = round(5/1000*SampleRate);
  [ccg, t] = CCG(spike.t(gindx),spike.ind(gindx),dt,500,SampleRate);  
  cccg = GetDiagonal(ccg);
  
  %% insert zeros for spike-less cells:
  ncell = find(ismember(unique(spike.ind),unique(spike.ind(gindx))));
  yccg = zeros(size(t,2),max(spike.ind));
  yccg(:,ncell) = cccg;
  
  %% smooth
  syccg = ButFilter(yccg,1,20/(1000/mean(diff(t))/2),'low');
  
  %% good cells: average rate > ??
  tg = find(t>=-500 & t<=500);
  r = mean(yccg(tg,:),1);
  [sr ir] = sort(r);
  ratecut = 2;
  
  %keyboard
  
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
    freq(n) = 1000/mean(diff(t(mccg(:,n))));
    signal(:,n) = [mean(sc(mccg(1,n):mccg(end,n))) max(sc(mccg(1,n):mccg(end,n))) min(sc(mccg(1,n):mccg(end,n)))];
    statmccg(:,n) = [mean(diff(t(mccg(:,n)))) std(diff(t(mccg(:,n))))];
  end
  
  %% cell types
  [ctype cmono] = CellTypes(FileBase);
  IN = find(ctype.num==1);
  PC = find(ctype.num==2);
  
  %% multi unit
  [muccg, t] = CCG(spike.t(gindx),1,dt,500,SampleRate);
  smuccg = ButFilter(muccg,1,20/(1000/mean(diff(t))/2),'low');
  dt = mean(diff(t));
  mm = LocalMinima(-smuccg,100/dt);
  [mid imid] = max(muccg(mm));
  [msort,isort] = sort(abs(mm-mm(imid)));
  mmuccg = sort(mm(isort(1:5)));
  mufreq = 1000/mean(diff(t(mmuccg)));
  
  
  xcorrl.eegt = lags/EegRate;
  xcorrl.eegccg = (Eegccg-min(Eegccg))/(max(Eegccg)-min(Eegccg));
  xcorrl.eegmax = lags(meccg)/EegRate;
  xcorrl.muat = t/1000;
  xcorrl.muaccg = (smuccg-min(smuccg))/(max(smuccg)-min(smuccg));
  
  xcorrl.ccg = syccg;
  xcorrl.ccgt = t/1000;
  xcorrl.ccgmax = t(mccg)/1000;
  xcorrl.rate = r;
  xcorrl.goodPC = PC(find(r(PC)>ratecut));
  xcorrl.goodIN = IN(find(r(IN)>ratecut));

  xcorrl.freq = freq;
  xcorrl.eegf = efreq;
  xcorrl.muaf = mufreq;
  
  save([FileBase FileOut],'xcorrl');
else
  
  load([FileBase FileOut],'-MAT')
  
end
if PLOT
  
  figure(54);clf; %% EEG & multi-unit
  subplot(311)
  plot(xcorrl.eegt,xcorrl.eegccg,'k','LineWidth',2)
  hold on 
  plot(xcorrl.muat,xcorrl.muaccg,'r','LineWidth',2)
  xlim([-0.5 0.5])
  Lines(xcorrl.eegmax,[],'k','--',2);
  %title([num2str(efreq) ' Hz'])
  set(gca,'TickDir','out','FontSize',16)
  box off
  %
  subplot(312) %% PC
  tg = find(xcorrl.ccgt>=-0.5 & xcorrl.ccgt<=0.5);
  imagesc(xcorrl.ccgt(tg),[1:length(xcorrl.goodPC)],unity(xcorrl.ccg(tg,xcorrl.goodPC))')
  axis xy
  Lines(xcorrl.eegmax,[],'k','--',2);
  hold on;
  for n=1:length(xcorrl.goodPC)
    plot(xcorrl.ccgmax(:,xcorrl.goodPC(n)),n*ones(size(xcorrl.ccgmax(:,xcorrl.goodPC(n)))),'+k')
  end
  ylabel('pyramidal cell #','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  %
  subplot(313) %% IN
  imagesc(xcorrl.ccgt(tg),[1:length(xcorrl.goodIN)],unity(xcorrl.ccg(tg,xcorrl.goodIN))')
  axis xy
  Lines(xcorrl.eegmax,[],'k','--',2);
  hold on;
  for n=1:length(xcorrl.goodIN)
    plot(xcorrl.ccgmax(:,xcorrl.goodIN(n)),n*ones(size(xcorrl.ccgmax(:,xcorrl.goodIN(n)))),'+k')
  end
  xlabel('time [sec]','FontSize',16)
  ylabel('interneurons #','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  %
  text(-0.65,42,'a)','FontSize',16)
  text(-0.65,26.5,'b)','FontSize',16)
  text(-0.65,11.5,'c)','FontSize',16)
  
  %%%%%%%%%%%%%%%%%%%%%%
  
  figure(53);clf;
  fpc = xcorrl.freq(xcorrl.goodPC);
  fin = xcorrl.freq(xcorrl.goodIN);
  
  bar(1,mean(fpc),0.8)
  hold on
  errorbar(1,mean(fpc),std(fpc),'k','LineWidth',2);
  bar(2,mean(fin),0.8)
  errorbar(2,mean(fin),std(fin),'k','LineWidth',2);
  xlim([0.2 2.8])
  Lines([],xcorrl.eegf,'k','--',2);
  Lines([],xcorrl.muaf,'r','--',2);
  ylabel('frequency [Hz]','FontSize',16)
  set(gca,'TickDir','out','XTick',[],'FontSize',16)
  box off
  % 
  text(0.9,-0.5,'PC','Fontsize',20)
  text(1.9,-0.5,'IN','Fontsize',20)
end


