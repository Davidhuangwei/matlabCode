function mua = SVMUmua(FileBase,Eeg,spkt,spki,run,varargin)
[gcells,overwrite,PLOT,FileOut] = DefaultArgs(varargin,{[],0,0,'.muarate'});

if ~FileExists([FileBase FileOut]) | overwrite
  
  %% get Sample Rates
  Par = LoadPar(FileBase);
  EegRate = Par.lfpSampleRate;
  SampleRate = Par.SampleRate;
  
  %% get Eeg and spikes within runs
  PEeg = SelectPeriods(Eeg,run,'c',1);
  SEeg = ButFilter(PEeg,1,[4 12]/(EegRate/2),'bandpass');
  
  %keyboard  
  
  %% get spikes
  if isempty(gcells)
    gcells = unique(spki);
  end
  pcells = ismember(spki,gcells);
  ipcells = find(pcells);
  
  [SpkT iPSpk] = SelectPeriods(round(spkt(pcells)/SampleRate*EegRate),run,'d',1,1);
  SpkI = spki(ipcells(iPSpk));
  
    
  %% MUA Rate in EegRate
  [Rate RBin] = InstantRate(FileBase,round(SpkT),ones(size(SpkT)),1);
  if length(Rate)<length(SEeg)
    Rate = [Rate; zeros(length(SEeg)-length(Rate),1)];
  elseif length(Rate)>length(SEeg)
    nRate = Rate(1:length(SEeg)); clear Rate;
    Rate = nRate;
  end
  MRate = ButFilter(Rate,1,4/(EegRate/2),'high');

  
  %  %% unit Rate in coherence rate
  %  wstep = 1/4;
  %  WinLength = 2^11;%512;
  %  nOverlap = WinLength*wstep;
  %  [Segs, SpkInd, SegInd, SegGrpInd] = FitOverlapedBins(WinLength,nOverlap,SpkT,min(SpkT));
  %  SRate = Accumulate([SegInd SpkI(SpkInd)],1)/WinLength*EegRate;
  %  CellsActive = sum(SRate>5,2);
  %  
  %  
  %  %% coherence
  %  nFFT = 2^12;
  %  Fs = EegRate;
  %  NW = 2;  %% ~5 for gamma
  %  Detrend = 'linear';
  %  nTapers = [];
  %  FreqRange = [1 20];
  %  CluSubset = [];
  %  pval = []; 
  %  %WinLength see above!
  %  nOverlap = WinLength*(1-wstep);
  
  
  %% unit Rate in coherence rate
  wstep = 1/4;
  WinLength = 2^11;%512;
  nOverlap = WinLength*wstep;
  [Segs, SpkInd, SegInd, SegGrpInd] = FitOverlapedBins(WinLength,nOverlap,SpkT,min(SpkT));
  SRate = Accumulate([SegInd SpkI(SpkInd)],1)/WinLength*EegRate;
  CellsActive = sum(SRate>5,2);
  
  
  %% coherence
  nFFT = 2^12;
  Fs = EegRate;
  NW = 2;  %% ~5 for gamma
  Detrend = 'linear';
  nTapers = [];
  FreqRange = [1 20];
  CluSubset = [];
  pval = []; 
  %WinLength see above!
  nOverlap = WinLength*(1-wstep);
  
  
  [yo, fo, to, ph] = mtptchglong(SEeg,SpkT,ones(size(SpkT)),nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,CluSubset);
  
  if length(to)>length(SRate)
    SRate = [SRate; zeros(length(to)-size(SRate,1),size(SRate,2))];
    CellsActive = sum(SRate>5,2);
  end
    
  %% OUTPUT/SAVE
  mua.eeg = SEeg;
  
  mua.spkt = SpkT; % in EegRate
  mua.spki = SpkI;  
  mua.rate = MRate;% in EegRate

  mua.unitrate = SRate(1:length(to),:);
  mua.unitbin = to; %% in seconds
  mua.activecells = CellsActive(1:length(to));
 
  mua.spT = to;
  mua.spF = fo;
  mua.spectgreeg = yo(:,:,1,1);
  mua.spectgrunit = yo(:,:,2,2);
  mua.spectgrcoh = yo(:,:,1,2);
  mua.phase = ph(:,:,2,1);
  
  %% SAVE
  save([FileBase FileOut],'mua');
  
else
  load([FileBase FileOut],'-MAT');
end
  
if PLOT
  %% get Sample Rates
  Par = LoadPar(FileBase);
  EegRate = Par.lfpSampleRate;
  SampleRate = Par.SampleRate;
  
  figure(654);clf
  subplot(511)
  plot([1:length(mua.eeg)]/EegRate,mua.eeg/max(mua.eeg),'r')
  hold on
  plot([1:length(mua.eeg)]/EegRate,mua.rate/max(mua.rate))
  axis tight
  %
  subplot(512)
  plot(mua.unitbin,mua.activecells)
  axis tight
  %
  subplot(513)
  imagesc(mua.spT,mua.spF,mua.coh(:,:,1,2)')
  axis xy
  %
  subplot(514)
  imagesc(mua.spT,mua.spF,mua.coh(:,:,1,1)')
  axis xy
  %
  subplot(515)
  imagesc(mua.spT,mua.spF,unity(mua.coh(:,:,2,2)'))
  axis xy
  %

  %TimeBrowse(10,10)
end

