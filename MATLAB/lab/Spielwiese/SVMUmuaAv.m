function acohe = SVMUmuaAv(FileBase,Eeg,spike,run,varargin)
[gcells,overwrite,PLOT,OutFile,PrintBase,PRINTFIG,EegRate,SampleRate] = DefaultArgs(varargin,{[],1,0,'.acoherence','Out',0,1250,20000});

if ~FileExists([FileBase OutFile]) | overwrite
  
  if isempty(gcells)
    gcells = unique(spike.ind);
  end
  
  st = round(spike.t/SampleRate*EegRate);
  ThPhase = InternThetaPh(FileBase);
  
  for n=1:size(run,1)
    ina = [run(n,1):run(n,2)];
    UThPhase(ina) = unwrap(ThPhase.deg(ina));
    
    inb = find(WithinRanges(round(spike.t/SampleRate*EegRate),run(n,:)));
    st(inb) = st(inb)-run(n,1);
  end
  
  indx = find(WithinRanges(round(spike.t/SampleRate*EegRate),run));
  
  spkt = st(indx);
  spki = spike.ind(indx);
  spkph = UThPhase(round(spike.t(indx)/SampleRate*EegRate));
  mapph = UThPhase([run(1,1):run(1,2)]);
  
  [xx xi yi] = NearestNeighbour(mapph,spkph);
  
  %% multi unit activity:
  pcells = ismember(spki,gcells);
  spkt = spkt+1;
  
  rrate = Accumulate(xi(pcells),1);
  keep = conv(rrate(1:end-1),exp(-[-1000:1000].^2/1000)./sum(exp(-[-1000:1000].^2/1000)));
  mrate = keep(1001:end-1000);
  smrate = ButFilter(mrate,1,4/(EegRate/2),'high');
  clear keep;
  MRbin = ([1:length(mrate)])/EegRate;
  
  %% spectrum
  x = [Eeg(run(1,1):run(1,2)-1)' smrate];
  nFFT = 2^11;
  Fs = EegRate;
  WinLength = nFFT;
  nOverlap = WinLength/4*3;
  NW = 3;
  Detrend = 1;
  nTapers = [];
  
  [yo, fo, to] = mtchglong(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,[1 15]);
  
  %%
  acohe.spkt = xi(pcells)/EegRate;
  acohe.spki = spki(pcells);
  acohe.rate = smrate;
  acohe.rbin = MRbin;
  acohe.t = to;
  acohe.f = fo;
  acohe.y = yo;
  %%
  
  save([FileBase OutFile],'acohe');
else
  load([FileBase OutFile],'-MAT')
end

if PLOT
  figure(222); clf;
  subplot(611)
  plot(acohe.spkt,acohe.spki,'.k')
  ylabel('cell #','FontSize',16)
  set(gca,'XTick',[],'TickDir','out','FontSize',16)
  axis tight
  box off
  %
  subplot(612)
  plot(acohe.rbin,acohe.rate-min(acohe.rate))
  ylabel('rate','FontSize',16)
  set(gca,'XTick',[],'TickDir','out','FontSize',16)
  axis tight
  box off
  %
  subplot(613)
  imagesc(acohe.t,acohe.f,acohe.y(:,:,2,2)');
  axis xy
  hold on
  [mx imx] = max(acohe.y(:,:,1,1)');
  plot(acohe.t,acohe.f(imx),'k+')
  ylabel('frequency [Hz]','FontSize',16)
  set(gca,'XTick',[],'TickDir','out','FontSize',16)
  axis tight
  box off
  %
  subplot(614)
  plot([1:length(acohe.rate)]/EegRate,Eeg(run(1,1):run(1,2)-1)/2^15*10)
  ylabel('LFP','FontSize',16)
  set(gca,'XTick',[],'TickDir','out','FontSize',16)
  axis tight
  box off
  %
  subplot(615)
  imagesc(acohe.t,acohe.f,acohe.y(:,:,1,1)');
  axis xy
  hold on
  plot(acohe.t,acohe.f(imx),'k+')
  ylabel('frequency [Hz]','FontSize',16)
  set(gca,'XTick',[],'TickDir','out','FontSize',16)
  axis tight
  box off
  %
  subplot(616)
  imagesc(acohe.t+1,acohe.f,acohe.y(:,:,1,2)');
  axis xy
  xlabel('time [sec]','FontSize',16)
  ylabel('frequency [Hz]','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  axis tight
  box off
  %
  text(-4,112,'a)','FontSize',24)
  text(-4,92,'b)','FontSize',24)
  text(-4,72,'c)','FontSize',24)
  text(-4,52,'d)','FontSize',24)
  text(-4,33,'e)','FontSize',24)
  text(-4,13,'f)','FontSize',24)

  PrintFig([PrintBase '_CoheAll'],PRINTFIG)

  figure(223);clf;
  subplot(311)
  gt = find(acohe.t<10);
  plot(acohe.f,mean(acohe.y(gt,:,2,2))/max(mean(acohe.y(gt,:,2,2))),'color',[1 1 1]*0.7,'LineWidth',2)
  hold on
  plot(acohe.f,mean(acohe.y(gt,:,1,1))/max(mean(acohe.y(gt,:,1,1))),'--','color',[1 1 1]*0.7,'LineWidth',2)
  axis tight
  [mx mi] = max(mean(acohe.y(gt,:,1,1)));
  gf = find(acohe.f>4 & acohe.f<12);
  com1 = CenterOfMass(acohe.f(gf),mean(acohe.y(gt,gf,1,1)));
  com2 = CenterOfMass(acohe.f(gf),mean(acohe.y(gt,gf,2,2)));
  Lines(com1,[],'r','--',2);
  Lines(com2,[],'r','-',2);
  ylabel('MUA power','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  subplot(312)
  plot(acohe.f,mean(acohe.y(gt,:,1,1))/max(mean(acohe.y(gt,:,1,1))),'color',[1 1 1]*0.7,'LineWidth',2)
  axis tight
  Lines(com1,[],'r','--',2)
  ylabel('LFP power','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  subplot(313)
  plot(acohe.f,mean(acohe.y(gt,:,1,2)),'color',[1 1 1]*0.7,'LineWidth',2)
  axis tight
  com3 = CenterOfMass(acohe.f(gf),mean(acohe.y(gt,gf,1,2)));
  Lines(com1,[],'r','--',2)
  %Lines(com3,[],'r','-',2)
  xlabel('frequency [Hz]','FontSize',16)
  ylabel('Coherence','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off

  PrintFig([PrintBase '_CoheAll2'],PRINTFIG)
  
end

  
