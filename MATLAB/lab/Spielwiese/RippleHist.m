function [RHist RSts] = RippleHist(FileBase,spiket,spikeind,Eeg,varargin)
[allclu,Itv,overwrite] = DefaultArgs(varargin,{unique(spikeind),[1 length(Eeg)],0});
%% 
%% function RippleHist(FileBase,varargin)
%% overwrite = DefaultArgs(varargin,{0});
%% 

RateFactor = 1250/20000;

%% get ripples
Rips = InternRips(FileBase,overwrite);
RipItv = [Rips.t-Rips.len/2 Rips.t+Rips.len/2];

Peaks = RipplesPeaks(Eeg,Rips.t,RipItv);

gPeakctr = Peaks.ctr(find(WithinRanges(Peaks.ctr,Itv)));
gPeakmin = Peaks.min(find(WithinRanges(Peaks.min,Itv)));

%% cross-correlogram 
HBin = 20;
Bin = 10;
t=[];

for n=1:length(allclu)
  indx = find(spikeind==allclu(n));
  
  if isempty(indx)
    CcgMin(n,:) = zeros(1,2*HBin+1);
    CcgCtr(n,:) = zeros(1,2*HBin+1);
    CcgEval(n,:) = zeros(1,2*4);
  else
    [ccgMin, t] = CCG([spiket(indx)*RateFactor; gPeakmin],[ones(size(indx));2*ones(size(gPeakmin))],Bin,HBin,1250,[1 2],'count');
    CcgMin(n,:) = ccgMin(:,1,2);
    
    [ccgCtr, t] = CCG([spiket(indx)*RateFactor; gPeakctr'],[ones(size(indx));2*ones(size(gPeakctr'))],Bin,HBin,1250,[1 2],'count');
    CcgCtr(n,:) = ccgCtr(:,1,2);
  
    [ccgEval, teval] = CCG([spiket(indx)*RateFactor-50/2; gPeakctr'],[ones(size(indx));2*ones(size(gPeakctr'))],50,4,1250,[1 2],'count');
    CcgEval(n,:) = ccgEval(2:end,1,2);
    
  end
  
  if isempty(t)
    t = zeros(1,2*HBin+1);
    teval = zeros(1,2*HBin+1);
  end
  
  %%%%%%%%%%%%%%%%%%
  %% # of spikes (average count per bin)
  RSts.n(n,1) = sum(CcgCtr(n,:))/length(t);

  %% max of distribution
  smRHist = smooth(CcgCtr(n,:),10,'lowess');
  [dummy ii] = max(smRHist);
  RSts.max(n,1) = t(ii);
  
  %% asymetry
  RSts.asym(n,:) = [sum(CcgEval(n,1:4)) sum(CcgEval(n,5:end))];
  %%%%%%%%%%%%%%%%%%
  
end

%% ripple peak triggered Eeg
[ccgEeg] = TriggeredAv(Eeg,500,500,gPeakctr',1);
%[ccgEeg] = TriggeredAv(Eeg,500,500,Rips.t,1);
etS = [-500:500]/1.250;

RHist.histMin = CcgMin;
RHist.histCtr = CcgCtr;
RHist.histEval = CcgEval;
RHist.bin(1,:) = t;
RHist.binEval(1,:) = teval(2:end)-mean(diff(teval))/2;
RHist.histEeg(n,:) = ccgEeg;
RHist.binEeg(1,:) = etS;
%RHist.statRp(n,:) = [mean(smccg(1:10)) smccg((length(t)+1)/2) mean(smccg(end-9:end))];
RHist.ind = allclu;
RHist.nrip = size(gPeakctr,2);

return;
