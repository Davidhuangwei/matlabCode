function [y, f, normmat, pow4coh, phloc]=mtptcsdG(varargin)
%function [yo, fo, normmat, pow4coh, phloc]=mtptcsd(x,Res, Clu, nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers, FreqRange,
% CluSubset,Segments,pval,MinSpikes);
% Multitaper Hybrid Spikes-Field Cross-Spectral Density
% x : input time series, Res/Clu - spikes for the
% nFFT = number of points of FFT to calculate (default 1024)
% Fs = sampling frequency (default 2)
% WinLength = length of moving window (default is nFFT)
% nOverlap = overlap between successive windows (default is WinLength/2)
% NW = time bandwidth parameter (e.g. 3 or 4), default 3
% nTapers = number of data tapers kept, default 2*NW -1
%
% output yo is yo(f)
%
% If x is a multicolumn matrix, each column will be treated as a time
% series and you'll get a matrix of cross-spectra out yo(f, Ch1, Ch2)
% NB they are cross-spectra not coherences. If you want coherences use
% mtcohere
%
% Original code by Partha Mitra/Bijan Pesaran - modified by Ken Harris
% Also containing elements from specgram.m
% and adopted for point processes, long files and other stuff by Anton Sirota
% Poitnt Process spectra calculation following Jarvis&Mitra,2000 and Bijan Pesaran's code

% default arguments and that
[x, Res, Clu, nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,nChannels, nClu, nSamples,...
 nFFTChunks,winstep,select,nFreqBins,f,t,FreqRange,CluSubset,Segments,pval,MinSpikes]  = mtparam_pt(varargin);

winstep = WinLength - nOverlap;
nChannelsAll = nChannels + nClu;
clear varargin; % since that was taking up most of the memory!

% allocate memory now to avoid nasty surprises later
y=complex(zeros(nFreqBins, nChannelsAll,time)); % output array
pow4coh=zeros(nFreqBins, nChannelsAll, time,2); % output array
phloc=zeros(nFreqBins, nChannelsAll, nChannelsAll); % output array

Temp1 = complex(zeros(nFreqBins, nTapers));
Temp2 = complex(zeros(nFreqBins, nTapers));
Temp3 = complex(zeros(nFreqBins, nTapers));
eJ = complex(zeros(nFreqBins,1));

% calculate Slepian sequences.  Tapers is a matrix of size [WinLength, nTapers]
[Tapers V]=Sdpss(WinLength,NW,nTapers, 'calc');

% New super duper vectorized alogirthm
% compute tapered periodogram with FFT
% This involves lots of wrangling with multidimensional arrays.

TaperingArray = repmat(Tapers, [1 1 nChannels]);
nUsedUnitsChunks = zeros(nClu,1); % count chunks that had something for each cell
nUsedEegChunks = 0;
normmat = zeros(nChannelsAll, nChannelsAll);
for j=1:nFFTChunks
  if sum(WithinRanges((j-1)*winstep+[1 WinLength],Segments))==0
    continue;
  end
  Periodogram = complex(zeros(nFreqBins, nTapers, nChannelsAll)); % intermediate FFTs
  %    ComputeCsd = 0; %a priory skip csd calculation
  ComputeCsd = zeros(nChannelsAll,1); %a priory skip csd calculation
  %continuous case
  if nChannels > 0
    Segi=(j-1)*winstep+[1:WinLength];
    %now find if this chunk is within Segments (e.g. REM)
    Segi_in = SelectPeriods(Segi,Segments,'d',1);
    if length(Segi_in)>length(Segi)/2
      Segment = zeros(WinLength,nChannels);
      indinseg = ismember(Segi,Segi_in); %find indexes of the good samples within current segment
      Segment(indinseg,:) = x(Segi_in, :);
      
      if (~isempty(Detrend))
	Segment = detrend(Segment, Detrend);
      end;
      SegmentsArray = permute(repmat(Segment, [1 1 nTapers]), [1 3 2]);
      TaperedSegments = TaperingArray .* SegmentsArray;
      
      fftOut = fft(TaperedSegments,nFFT);
      Periodogram(:,:,1:nChannels) = fftOut(select,:,:)*sqrt(2/nFFT);
      nUsedEegChunks = nUsedEegChunks + 1;
      %            ComputeCsd = 1;
      ComputeCsd(1:nChannels,1)=1;
    end
  end
    
  %point process data periodograms
  Segment = (j-1)*winstep+[1 WinLength];
  SegmentId = find(Res>=Segment(1) & Res<=Segment(2));
  if ~isempty(SegmentId)
    SegmentRes = Res(SegmentId) ;
    SegmentClu = Clu(SegmentId);
    SegmentRes = SegmentRes - Segment(1) + 1;
    fftOut = PointFFT(Tapers,SegmentRes, SegmentClu, nClu, CluSubset, nFFT,Fs, MinSpikes);
    Periodogram(: , : ,  nChannels+1:nChannelsAll) = fftOut(select, : , :)*sqrt(2/nFFT);
    
      if length(CluSubset)==1
	numsp = length(SegmentClu);
      else
	numsp = hist(SegmentClu,CluSubset)'; %number of spikes of each cell
      end
      %    nUsedUnitsChunks = nUsedUnitsChunks +ismember(CluSubset(:),Clu(SegmentId)); %accumulate counter for each cell if it fires in the segment
      nUsedUnitsChunks = nUsedUnitsChunks + double(numsp>=MinSpikes); %accumulate counter for each cell if it fires more than MinSpikes
      ComputeCsd(nChannels+1:end) = numsp>=MinSpikes;
      %        ComputeCsd = 1;
  end
  
  
  % Now make cross-products of them to fill cross-spectrum matrix
  
  %% CARO: don't compute cross-spectra. Third dim time.
  for Ch1 = 1:nChannelsAll
    %for Ch2 = Ch1:nChannelsAll % don't compute cross-spectra twice
    if ComputeCsd(Ch1)  & ComputeCsd(Ch2) % don't do csd calculation if both signals don't fall into Segments
      
      Temp1 = squeeze(Periodogram(:,:,Ch1));
      Temp2 = conj(Temp1);
      Temp3 = Temp1 .* Temp2;
      eJ=sum(Temp3, 2);
      y(:,Ch1)= y(:,Ch1) + eJ;
      
      %% ACHTUNG: NORMMAT!!!
      
      normmat(Ch1) = normmat(Ch1) + nTapers;
      % also need to accumulate the power for cross-spectra
      % normalization for unit-field case - to take into account
      % that units are not firing (enough) in many segments -
      % this can create a bias 
      pow4coh(:,Ch1, Ch2,1)= pow4coh(:,Ch1,Ch2,1) + sum(Temp1.*conj(Temp1),2);
      pow4coh(:,Ch1, Ch2,2)= pow4coh(:,Ch1,Ch2,2) + sum(Temp2.*conj(Temp2),2);
      
      %phase locking index
      phloc(:,Ch1,Ch2) = phloc(:,Ch1,Ch2) + sum(exp(-i*angle(Temp1)-i*angle(Temp2)),2);
      
    end
  end
end

% now fill other half of matrix with complex conjugate
for Ch1 = 1:nChannelsAll
  for Ch2 = (Ch1+1):nChannelsAll % don't compute cross-spectra twice
    normmat(Ch2,Ch1) = normmat(Ch1,Ch2);
    y(:, Ch2, Ch1) = conj(y(:,Ch1,Ch2));
    pow4coh(:, Ch2, Ch1,:) = pow4coh(:,Ch1,Ch2,:);
  end
end

normp = permute(repmat(normmat,[1,1,nFreqBins]),[3 1 2]);

%y = y ./ normp; %CORRECT devide by zero
nz = normp>0;
y(nz) = y(nz) ./ normp(nz);

nz = normp>0;
phloc(nz) = phloc(nz) ./ normp(nz);

normp = repmat(normp,[1 1 1 2]);
nz = normp>0;
pow4coh(nz) = pow4coh(nz)./normp(nz);

% we've now done the computation.  the rest of this code is stolen from
% specgram and just deals with the output stage

if nargout == 0
  % take abs, and plot results
  newplot;
  for Ch1=1:nChannelsAll, for Ch2 = 1:nChannelsAll
      subplot(nChannelsAll, nChannelsAll, Ch1 + (Ch2-1)*nChannelsAll);
      plot(f,20*log10(abs(y(:,Ch1,Ch2))+eps));
      grid on;
      if(Ch1==Ch2)
	ylabel('psd (dB)');
      else
	ylabel('csd (dB)');
      end;
      xlabel('Frequency');
    end; end;
end
