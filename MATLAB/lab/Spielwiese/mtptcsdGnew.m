function [y, f, t]=mtptcsdGnew(varargin)
%
% function [yo, fo, normmat, pow4coh, phloc]=mtptcsd(x,Res, Clu, nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,
% CluSubset,Segments,pval,MinSpikes);
% Multitaper Hybrid Spikes-Field Cross-Spectral Density
% 
% INPUT:
%    x:         input time series (e.g. Eeg) 
%    Res/Clu:   spike-times and cluster number
%    nFFT:      number of points of FFT to calculate (default 1024)
%    Fs:        sampling frequency (default 2)
%    WinLength: length of moving window (default is nFFT)
%    nOverlap:  overlap between successive windows (default is WinLength/2)
%    NW:        time bandwidth parameter (e.g. 3 or 4), default 3
%    nTapers:   number of data tapers kept, default 2*NW -1
%
% OUTPUT: 
%    yo:        spectrogram (freq x chan x time) 
%
% Original code by Partha Mitra/Bijan Pesaran - modified by Ken Harris
% Also containing elements from specgram.m
% and adopted for point processes, long files and other stuff by Anton Sirota
% Poitnt Process spectra calculation following Jarvis&Mitra,2000 and Bijan Pesaran's code
%
% modified my caro: for one channel only. spectra as time series. no cross-spectra

%% default arguments:
[x, Res, Clu, nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,nChannels, nClu, nSamples,...
 nFFTChunks,winstep,select,nFreqBins,f,t,FreqRange,CluSubset,Segments,pval,MinSpikes]  = mtparam_pt(varargin);

winstep = WinLength - nOverlap;
nChannelsAll = nChannels + nClu;
clear varargin; 

%% allocate memory 
Temp1 = complex(zeros(nFreqBins, nTapers));
Temp2 = (zeros(nFreqBins, nTapers));
eJ = (zeros(nFreqBins,1));

% calculate Slepian sequences.  Tapers is a matrix of size [WinLength, nTapers]
[Tapers V]=Sdpss(WinLength,NW,nTapers, 'calc');

%% initiate
TaperingArray = repmat(Tapers, [1 1 nChannels]);

%% loop through nFFTChunks
for j=1:nFFTChunks
  if sum(WithinRanges((j-1)*winstep+[1 WinLength],Segments))==0
    continue;
  end
  
  %% intermediate FFTs:
  Periodogram = complex(zeros(nFreqBins, nTapers, nChannelsAll)); 
  
  %% continuous case
  if nChannels > 0
    Segi=(j-1)*winstep+[1:WinLength];
    
    %% now find if this chunk is within Segments (e.g. REM)
    Segi_in = SelectPeriods(Segi,Segments,'d',1);
    if length(Segi_in)>length(Segi)/2
      Segment = zeros(WinLength,nChannels);
      
      %% find indexes of the good samples within current segment
      indinseg = ismember(Segi,Segi_in); 
      Segment(indinseg,:) = x(Segi_in, :);
      
      if (~isempty(Detrend))
	Segment = detrend(Segment, Detrend);
      end;
      SegmentsArray = permute(repmat(Segment, [1 1 nTapers]), [1 3 2]);
      TaperedSegments = TaperingArray .* SegmentsArray;
      
      fftOut = fft(TaperedSegments,nFFT);
      Periodogram(:,:,1:nChannels) = fftOut(select,:,:)*sqrt(2/nFFT);
    end
  end
  
  %% point process case
  if ~isempty(Res)
    Segment = (j-1)*winstep+[1 WinLength];
    SegmentId = find(Res>=Segment(1) & Res<=Segment(2));
    if ~isempty(SegmentId)
      SegmentRes = Res(SegmentId) ;
      SegmentClu = Clu(SegmentId);
      SegmentRes = SegmentRes - Segment(1) + 1;
      fftOut = PointFFT(Tapers,SegmentRes, SegmentClu, nClu, CluSubset, nFFT,Fs, MinSpikes);
      Periodogram(:,:,nChannels+1:nChannelsAll) = fftOut(select,:,:)*sqrt(2/nFFT);
    end
  end
  %% compute spectrum
  y(j,:,:) = sq(mean(Periodogram.*conj(Periodogram),2));
end

%% time bins
t = ([1:size(y,1)]*(WinLength-nOverlap) - (WinLength/2-nOverlap))/1250;

return;


%if nargout == 0
%  
%  %% plot results
%  newplot;
%  for Ch1=1:nChannelsAll
%    subplot(nChannelsAll, nChannelsAll, Ch1 + (Ch2-1)*nChannelsAll);
%    plot(f,20*log10(abs(y(:,Ch1,Ch2))+eps));
%    grid on;
%    if(Ch1==Ch2)
%      ylabel('psd (dB)');
%    else
%      ylabel('csd (dB)');
%    end;
%    xlabel('Frequency');
%  end;
%end
