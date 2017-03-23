function cohe = SVMUspectL(FileBase,spike,run,mua,PrintBase,varargin)
[gcells,overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{[],0,0,0,'.coherence',1250,20000});

if ~FileExists([FileBase FileOut]) | overwrite
  
  if isempty(gcells)
    gcells = unique(spike.ind);
  end
  pcells = ismember(spike.ind,gcells);
  
  
  nFFT = 2^12;
  Fs = EegRate;
  NW = 2;  %% ~5 for gamma
  Detrend = 'linear';
  nTapers = [];
  FreqRange = [1 20];
  CluSubset = [];
  pval = []; 
  WinLength = 2^11;%512;
  nOverlap = WinLength*3/4;
  
  yy = find(pcells);
  [PSpk iPSpk] = SelectPeriods(round(spike.t(yy)/SampleRate*EegRate),run,'d',1,1);
  indx = yy(iPSpk);
  
  Res = PSpk;
  %Clu = spike.ind(indx);
  
  [yo, fo, to, ph] = mtptchglong(mua.eeg,Res,ones(size(Res)),nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,CluSubset);
  
  %% TimeBrowse
  tb = figure(441); clf;
  subplot(611)
  plot(mua.spkt,spike.ind(mua.spki),'.')
  axis tight
  Lines(mua.gluept);
  title('find good episode');
  subplot(612)
  plot(mua.bin,mua.rate)
  axis tight
  Lines(mua.gluept);
  subplot(613)
  imagesc(to,fo,(yo(:,:,2,2)'));
  hold on
  [mx imx] = max(yo(:,:,1,1)');
  plot(to,fo(imx),'k.')
  axis xy
  Lines(mua.gluept);
  ylim([4 12])
  subplot(614)
  plot([1:length(mua.eeg)]/EegRate,mua.eeg)
  axis tight
  Lines(mua.gluept);
  subplot(615)
  imagesc(to,fo,yo(:,:,1,1)');
  axis xy
  Lines(mua.gluept);
  ylim([4 12])
  subplot(616)
  imagesc(to,fo,yo(:,:,1,2)');
  axis xy
  Lines(mua.gluept);
  ylim([4 12])

  TimeBrowse(10,100)
  
  go=input('go\n');
  episode = get(gca,'XLim');
  
  close(tb)
  
  
  cohe.y = yo;
  cohe.t = to;
  cohe.f = fo;
  cohe.episode = episode;
  
  
  %% Average spectra and coherence
  x = [mua.eeg mua.rawrate];
  nFFT = 2^12;
  FS = EegRate;
  WinLength = nFFT;
  nOverlap = [];
  NW = 3;
  Detrend = 1;
  nTapers = [];
  
  [yo, fo, ph]=mtchd(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,[1 20]);
  
  cohe.avy = yo;
  cohe.avf = fo;
  cohe.avph = ph;
  
  save([FileBase FileOut],'cohe');
  
else
  load([FileBase FileOut],'-MAT');
end

if PLOT
  
  %% the following adjustments are for file 3 of Eva / maze

  cohe.episode(2) = 168;
  
  figure(442); clf;
  IDX = find(mua.spkt>=cohe.episode(1) & mua.spkt<=cohe.episode(2));
  EIDX = find(mua.bin>=cohe.episode(1) & mua.bin<=cohe.episode(2));
  IIDX = find(cohe.t>=cohe.episode(1) & cohe.t<=cohe.episode(2));
  %
  subplot(611)
  plot(mua.spkt(IDX),spike.ind(mua.spki(IDX)),'k.')
  xlim([cohe.episode(1) cohe.episode(2)]);
  ylabel('cell #','FontSize',16)
  set(gca,'XTick',[],'TickDir','out','FontSize',16,'YTick',[0 50 100])
  axis tight
  box off
  %
  subplot(612)
  plot(mua.bin(EIDX),(mua.rate(EIDX)-min(mua.rate(EIDX))))
  xlim([cohe.episode(1) cohe.episode(2)]);
  ylabel('rate','FontSize',16)
  set(gca,'XTick',[],'TickDir','out','FontSize',16)
  axis tight
  box off
  %
  subplot(613)
  imagesc(cohe.t(IIDX),cohe.f,(cohe.y(IIDX,:,2,2)'));
  axis xy
  hold on
  [mx imx] = max(cohe.y(:,:,1,1)');
  plot(cohe.t(IIDX),cohe.f(imx(IIDX)),'k+')
  xlim([cohe.episode(1) cohe.episode(2)]);
  ylabel('frequency','FontSize',16)
  set(gca,'XTick',[],'TickDir','out','FontSize',16)
  axis tight
  ylim([4 12])
  box off
  %
  subplot(614)
  plot([1:length(EIDX)]/EegRate,mua.eeg(EIDX)/2^15*10)
  xlim([cohe.episode(1) cohe.episode(2)]);
  ylabel('LFP','FontSize',16)
  set(gca,'XTick',[],'TickDir','out','FontSize',16)
  axis tight
  box off
  %
  subplot(615)
  imagesc(cohe.t(IIDX),cohe.f,cohe.y(IIDX,:,1,1)');
  axis xy
  hold on
  plot(cohe.t(IIDX),cohe.f(imx(IIDX)),'k+')
  xlim([cohe.episode(1) cohe.episode(2)]);
  ylabel('frequency','FontSize',16)
  set(gca,'XTick',[],'TickDir','out','FontSize',16)
  axis tight
  ylim([4 12])
  box off
  %
  subplot(616)
  imagesc(cohe.t(IIDX)-cohe.episode(1),cohe.f,cohe.y(IIDX,:,1,2)');
  axis xy
  hold on
  plot(cohe.t(IIDX)-cohe.episode(1),cohe.f(imx(IIDX)),'k+')
  xlim([cohe.episode(1) cohe.episode(2)]);
  xlabel('time [sec]','FontSize',16)
  ylabel('frequency','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  axis tight
  ylim([4 12])
  box off
  %
  %text(-1,112,'a)','FontSize',24)
  %text(-1,92,'b)','FontSize',24)
  %text(-1,72,'c)','FontSize',24)
  %text(-1,52,'d)','FontSize',24)
  %text(-1,32,'e)','FontSize',24)
  %text(-1,12,'f)','FontSize',24)
  %
  
  PrintFig([PrintBase '_Cohe1'],PRINTFIG)
  
  %%%%%%%%%%%%%%%
  figure(443);clf
  subplot(221)
  plot(cohe.avf,cohe.avy(:,1,1),'k','lineWidth',2)
  [mx imx] = max(cohe.avy(:,1,1));
  axis tight
  Lines(cohe.avf(imx),[],'r','--',2);
  xlim([4 12])
  ylabel('Eeg power','FontSize',16)
  xlabel('frequency [Hz]','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  %
  subplot(223)
  plot(cohe.avf,cohe.avy(:,2,2)/max(cohe.avy(:,2,2)),'k','lineWidth',2)
  hold on
  plot(cohe.avf,cohe.avy(:,1,1)/mx,'--','color',[1 1 1]*0.5,'lineWidth',2)
  Lines(cohe.avf(imx),[],'r','--',2);
  xlim([4 12])
  ylabel('Rate power','FontSize',16)
  xlabel('frequency [Hz]','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  %
  subplot(222)
  plot(cohe.avf,cohe.avy(:,2,1),'k','lineWidth',2)
  axis tight
  Lines(cohe.avf(imx),[],'r','--',2);
  xlim([4 12])
  ylabel('coherence','FontSize',16)
  xlabel('frequency [Hz]','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  %
  subplot(224)
  plot(cohe.avf,cohe.avph(:,2,1)*180/pi,'k','lineWidth',2)
  axis tight
  Lines(cohe.avf(imx),[],'r','--',2);
  xlim([4 12])
  ylabel('phase [deg]','FontSize',16)
  xlabel('frequency [Hz]','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  
  PrintFig([PrintBase '_Cohe2'],PRINTFIG)
end
