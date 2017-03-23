function spectph = SVMUspectPh(FileBase,spike,run,PrintBase,varargin)
[goodPC,goodIN,overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate,allPC,CluSubset] = DefaultArgs(varargin,{[],[],0,0,0,'.spectPh',1250,20000,[],[]});


if ~FileExists([FileBase FileOut]) | overwrite
  nFFT = 2^14;
  Fs = 360;
  nOverlap = [];
  NW = 2;  %% ~5 for gamma
  Detrend = 'linear';
  nTapers = [];
  FreqRange = [0 2];
  WinLength = 2^13;%512;
  
  if isempty(goodPC)
    goodPC = unique(spike.ind);
  end
  if isempty(goodIN)
    goodIN = unique(spike.ind);
  end
  
  Phase =  InternThetaPh(FileBase);
  UPhase = unwrap(mod(Phase.deg+2*pi,2*pi))*180/pi;

  %% select spikes and EEg
  [Res indx] = SelectPeriods(round(spike.t/SampleRate*EegRate),run,'d',1,1);
  Clu = spike.ind(indx);
  pUPh = SelectPeriods(UPhase,run,'c',1,1);
  PhRes = round(pUPh(Res));
  
  if isempty(CluSubset)
    CluSubset = unique(Clu);
  end

  %% single unit 
  if length(CluSubset)<50
    [SP,f]=mtptcsd(PhRes,Clu,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,CluSubset,[],[],1);
    if length(CluSubset)+1> size(SP,2)
      ii = find(ismember(CluSubset,unique(Clu(find(ismember(Clu,CluSubset))))));
      cSP = zeros(size(f,1),length(CluSubset));
      cSP(:,ii) = GetDiagonal(SP);
    else
      cSP = GetDiagonal(SP);
    end
  
  else
    CC = CluSubset;
    for n=1:length(CC)
      CC(n)
      idx = find(Clu == CC(n));
      
      if length(idx)<5
	fr = GetFreqBins(nFFT,Fs,FreqRange);
	cSP(:,n) = zeros(length(fr),1);
      else
	[SP,f]=mtptcsd(PhRes(idx),Clu(idx),nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,[],[],[],1);
	cSP(:,n) = SP;
      end
    end
  end
  
  %% insert zeros for spike-less cells:
  ncell = find(ismember(unique(spike.ind),unique(CluSubset)));
  ySP = zeros(size(f,1),max(spike.ind));
  ySP(:,ncell) = cSP;

  %multi unit
  if isempty(allPC)
    ResM = Res;
  else
    indxM = find(ismember(Clu,allPC));
    ResM = Res(indxM);
  end
  [mSP,f]=mtptcsd(round(pUPh(ResM)),ones(size(ResM)),nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,[],[],[],1);
 
  spectph.f = f;
  spectph.spunit = ySP;
  spectph.mua = mSP;

  save([FileBase FileOut],'spectph')
else
  load([FileBase FileOut],'-MAT')

  [dummy spectph.maxfu] = MaxPeak(spectph.f,spectph.spunit,[0.5 1.5]);
  clear dummy
  
end

if PLOT
  
  if isempty(goodPC)
    goodPC = [1:size(spectph.spunit,2)];
  end
  if isempty(goodIN)
    goodIN = [1:size(spectph.spunit,2)];
  end
  
  f = spectph.f;

  figure(543);clf;
  subplot(311)
  imagesc(spectph.f,[],unity(spectph.spunit(:,goodPC))')
  hold on
  axis xy
  plot(spectph.f,spectph.mua(:,1)/max(spectph.mua(:,1))*length(goodPC),'k','LineWidth',2)
  [mm mi] = max(spectph.mua(:,1));
  Lines(spectph.f(mi),[],'k','--',2);
  ylabel('pyramidal cells #','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  %
  text(-2,length(goodPC),'a)','FontSize',16)
  %
  subplot(312)
  imagesc(spectph.f,[],unity(spectph.spunit(:,goodIN))')
  hold on
  axis xy
  Lines(spectph.f(mi),[],'k','--',2);
  plot(spectph.f,spectph.mua(:,1)/max(spectph.mua(:,1))*length(goodIN),'k','LineWidth',2)
  xlabel('frequency','FontSize',16)
  ylabel('interneuron #','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  %
  text(-2,length(goodIN),'b)','FontSize',16)
  
  
  %%
  fg = find(f>0.5 & f<1.5);
  [mpc ipc] = max(spectph.spunit(fg,goodPC));
  [mini in] = max(spectph.spunit(fg,goodIN));
  %
  subplot(325)
  hbin = [0.5:0.1:1.5];
  hpc = histcI(f(fg(ipc)),hbin);
  bar(hbin(2:end)-0.05,hpc);
  xlabel('frequency','FontSize',16)
  ylabel('count','FontSize',16)
  title('pyramidal cells','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  Lines(mean(f(fg(ipc))),[],[],'--',2);
  box off
  
  subplot(326)
  hin = histcI(f(fg(in)),hbin);
  bar(hbin(2:end)-0.05,hin);
  xlabel('frequency','FontSize',16)
  ylabel('count','FontSize',16)
  title('interneuron','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  Lines(mean(f(fg(in))),[],[],'--',2);
  box off
   
end

