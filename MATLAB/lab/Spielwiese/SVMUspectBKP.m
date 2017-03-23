function spect = SVMUspectBKP(FileBase,Eeg,spike,run,PrintBase,varargin)
[goodPC,goodIN,overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate,allPC,CluSubset] = DefaultArgs(varargin,{[],[],0,0,0,'.spect',1250,20000,[],[]});


if ~FileExists([FileBase FileOut]) | overwrite
  nFFT = 2^13;
  Fs = EegRate;
  nOverlap = [];
  NW = 2;  %% ~5 for gamma
  Detrend = 'linear';
  nTapers = [];
  FreqRange = [1 20];
  WinLength = 2^12;%512;
  
  if isempty(goodPC)
    goodPC = unique(spike.ind);
  end
  if isempty(goodIN)
    goodIN = unique(spike.ind);
  end
 
  
  %% select spikes end Eeg
  [Res indx] = SelectPeriods(round(spike.t/SampleRate*EegRate),run,'d',1,1);
  Clu = spike.ind(indx);
  pEeg = SelectPeriods(Eeg,run,'c',1,1);
  
  if isempty(CluSubset)
    CluSubset = unique(Clu);
  end

  %% single unit 
  if length(CluSubset)<50
    [SP,f]=mtptcsd(pEeg,Res,Clu,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,CluSubset,[],[],1);
    if length(CluSubset)+1> size(SP,2)
      ii = find(ismember(CluSubset,unique(Clu(find(ismember(Clu,CluSubset))))));
      cSP = zeros(size(f,1),length(CluSubset)+1);
      cSP(:,[1 ii+1]) = GetDiagonal(SP);
    else
      cSP = GetDiagonal(SP);
    end
  
  else
    CC = CluSubset;
    for n=1:length(CC)
      CC(n)
      idx = find(Clu == CC(n));
      
      if length(idx)<5
	cSP(:,n+1) = zeros(size(f));
      else
	[SP,f]=mtptcsd(pEeg,Res(idx),Clu(idx),nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,[],[],[],1);
      end
	
      if size(SP,2)<2
	cSP(:,n+1) = zeros(size(f));
      else
	cSP(:,n+1) = SP(:,2,2);
      end
      cSP(:,1) = SP(:,1,1);
    end
  end
  
  %% insert zeros for spike-less cells:
  ncell = find(ismember(unique(spike.ind),unique(CluSubset)));
  ySP = zeros(size(f,1),max(spike.ind));
  ySP(:,ncell) = cSP(:,2:end);
  ySPeeg(:,1) = cSP(:,1);

  %multi unit
  if isempty(allPC)
    ResM = Res;
  else
    indxM = find(ismember(Clu,allPC));
    ResM = Res(indxM);
  end
  [mSP,f]=mtptcsd(pEeg,ResM,ones(size(ResM)),nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,[],[],[],1);

  
  spect.f = f;
  spect.speeg = ySPeeg;
  spect.spunit = ySP;
  spect.mua = mSP(:,2,2);

  save([FileBase FileOut],'spect')
else
  load([FileBase FileOut],'-MAT')
end

if PLOT
  
  if isempty(goodPC)
    goodPC = [1:size(spect.spunit,2)];
  end
  if isempty(goodIN)
    goodIN = [1:size(spect.spunit,2)];
  end
  
  f = spect.f;
  fg = find(f>=5 & f<=10);
  fg2 = find(f>=5 & f<=12);
  
  figure(543);clf;
  subplot(2,3,[1 2])
  imagesc(spect.f,[],unity(spect.spunit(:,goodPC))')
  hold on
  axis xy
  %Lines(xcorrl.eegf,[],'k','--',2);
  plot(spect.f,spect.speeg(:,1)/max(spect.speeg(:,1))*length(goodPC),'k','LineWidth',2)
  [mm mi] = max(spect.speeg(:,1));
  Lines(spect.f(mi),[],'k','--',2);
  ylabel('pyramidal cells #','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  %
  text(-2,length(goodPC),'a)','FontSize',16)
  %
  subplot(2,3,[4 5])
  imagesc(spect.f,[],unity(spect.spunit(:,goodIN))')
  hold on
  axis xy
  %Lines(xcorrl.eegf,[],'k','--',2);
  Lines(spect.f(mi),[],'k','--',2);
  plot(spect.f,spect.speeg(:,1)/max(spect.speeg(:,1))*length(goodIN),'k','LineWidth',2)
  xlabel('frequency [Hz]','FontSize',16)
  ylabel('interneuron #','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  %
  text(-2,length(goodIN),'b)','FontSize',16)
  %
  subplot(433)
  plot(spect.f,spect.speeg(:,1)/max(spect.speeg(:,1)),'k','LineWidth',2)
  axis tight
  xlim([5 12])
  %Lines(xcorrl.eegf,[],'r','--',2);
  Lines(spect.f(mi),[],'k','--',2);
  ylabel('LFP','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  %
  text(2.5,1,'c)','FontSize',16);
  %
  subplot(436)
  xx = mean(spect.spunit(:,goodPC),2);
  plot(spect.f,xx/max(xx),'k','LineWidth',2)
  axis tight
  xlim([5 12])
  %Lines(xcorrl.eegf,[],'r','--',2);
  Lines(spect.f(mi),[],'k','--',2);
  ylabel('PC','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  %
  subplot(439)
  plot(spect.f(fg2),spect.mua(fg2)/max(spect.mua(fg2)),'k','LineWidth',2)
  axis tight
  xlim([5 12])
  %Lines(xcorrl.eegf,[],'r','--',2);
  Lines(spect.f(mi),[],'k','--',2);
  ylabel('MUA','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  %
  subplot(4,3,12)
  xy = mean(spect.spunit(:,goodIN),2);
  plot(spect.f,xy/max(xy),'k','LineWidth',2)
  axis tight
  xlim([5 12])
  %Lines(xcorrl.eegf,[],'r','--',2);
  Lines(spect.f(mi),[],'k','--',2);
  xlabel('frequency [Hz]','FontSize',16)
  ylabel('IN','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  %
  %
  PrintFig([PrintBase FileOut '1'],PRINTFIG)

  %%%%%%%%%%
  %% BAR PLOT
  [meeg ieeg] = max(spect.speeg(fg));
  [mmua imua] = max(spect.mua(fg));
  [mpc ipc] = max(spect.spunit(fg,goodPC));
  [mini in] = max(spect.spunit(fg,goodIN));
  %
  figure(545);clf;
  subplot(122)
  ipc2 = ipc(find(ipc>5));
  b1 = bar(1,mean(spect.f(fg(ipc))));
  hold on
  b2 = bar(2,mean(spect.f(fg(in))));
  set(b1,'FaceColor',[1 1 1]*0.5,'EdgeColor',[0 0 0]);
  set(b2,'FaceColor',[1 1 1]*0.5,'EdgeColor',[0 0 0]);
  errorbar(1,mean(f(fg(ipc))),std(f(fg(ipc))),'k','LineWidth',2);
  errorbar(2,mean(f(fg(in))),std(f(fg(in))),'k','LineWidth',2);
  xlim([0.2 2.8]);
  ylim([5 10])
  Lines([],f(fg(ieeg)),'k','--',2);
  Lines([],f(fg(imua)),'r','--',2);
  ylabel('frequency [Hz]','FontSize',16)
  set(gca,'TickDir','out','XTick',[],'FontSize',16)
  box off
  text(0.9,4.6,'PC','Fontsize',20)
  text(1.9,4.6,'IN','Fontsize',20)
  text(-0.4,10,'e)','FontSize',16)
  %
  subplot(121)
  imagesc([1:length(ipc)],spect.f,unity(spect.spunit(:,goodPC)))
  hold on
  imagesc([1:length(in)]+length(ipc)+3,spect.f,unity(spect.spunit(:,goodIN)))
  colormap gray;
  brighten(0.2)
  axis tight
  axis xy
  pospc = mean([1:length(ipc)]);
  posin = mean([1:length(in)]+length(ipc)+3);
  plot(pospc,mean(spect.f(fg(ipc))),'o','markersize',7,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0]);
  hold on
  plot(posin,mean(spect.f(fg(in))),'o','markersize',7,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0]);
  plot([1:length(ipc)],spect.f(fg(ipc)),'+','MarkerSize',10,'LineWidth',2,'MarkerEdgeColor',[1 1 1]*0)
  plot([1:length(in)]+length(ipc)+3,spect.f(fg(in)),'+','MarkerSize',10,'LineWidth',2,'MarkerEdgeColor',[1 1 1]*0)
  errorbar(pospc,mean(f(fg(ipc))),std(f(fg(ipc))),'r','LineWidth',2);
  errorbar(posin,mean(f(fg(in))),std(f(fg(in))),'r','LineWidth',2);
  ylim([5 10])
  Lines([],f(fg(ieeg)),'k','--',2);
  Lines([],f(fg(imua)),'r','--',2);
  ylabel('frequency [Hz]','FontSize',16)
  set(gca,'TickDir','out','XTick',[],'FontSize',16)
  box off
  text(pospc-2,4.6,'PC','Fontsize',20)
  text(posin-2,4.6,'IN','Fontsize',20)
  text(-10,10,'d)','FontSize',16)
  %
  PrintFig([PrintBase FileOut '2'],PRINTFIG)
  %
 
  fprintf(['\n Eeg frequency: ' num2str(f(fg(ieeg))) '\n']);
  fprintf([' MUA frequency: ' num2str(f(fg(imua))) '\n']);
  fprintf([' mean and stdv PC frequency: ' num2str(mean(f(fg(ipc)))) ' ' num2str(std(f(fg(ipc)))) '\n']);
  fprintf([' mean and stdv IN frequency: ' num2str(mean(f(fg(in)))) ' ' num2str(std(f(fg(in)))) '\n\n']);

  
  spect.feeg = f(fg(ieeg));
  spect.fmua = f(fg(imua));
  spect.fpc = [mean(f(fg(ipc))) std(f(fg(ipc)))];
  spect.fin = [mean(f(fg(in))) std(f(fg(in)))];
  
end

