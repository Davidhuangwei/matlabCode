function [Periodogram, f, dfWeight]=mtptperiodogram(varargin)
%function [per, f, dfWeight ]=mtptperiodogram(x,Res, Clu, nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers, FreqRange,
% CluSubset,Segments,pval,MinSpikes);
% Multitaper Hybrid Spikes-Field Periodogram
% x : input time series, Res/Clu - spikes for the
% nFFT = number of points of FFT to calculate (default 1024)
% Fs = sampling frequency (default 2)
% WinLength = length of moving window (default is nFFT)
% nOverlap = overlap between successive windows (default is WinLength/2)
% NW = time bandwidth parameter (e.g. 3 or 4), default 3
% nTapers = number of data tapers kept, default 2*NW -1
%
% default arguments and that
[x, Res, Clu, nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,nChannels, nClu, nSamples,...
    nFFTChunks,winstep,select,nFreqBins,f,t,FreqRange,CluSubset,Segments,pval,MinSpikes]  = mtparam_pt(varargin);

winstep = WinLength - nOverlap;
nChannelsAll = nChannels + nClu;
clear varargin; % since that was taking up most of the memory!
Periodogram = complex(zeros(nFFTChunks,nFreqBins, nTapers, nChannelsAll)); 
dfWeight = zeros(nFFTChunks,nChannelsAll);

% calculate Slepian sequences.  Tapers is a matrix of size [WinLength, nTapers]
[Tapers V]=Sdpss(WinLength,NW,nTapers, 'calc');

TaperingArray = repmat(Tapers, [1 1 nChannels]);

normmat = zeros(nChannelsAll, nChannelsAll);
for j=1:nFFTChunks
    if sum(WithinRanges((j-1)*winstep+[1 WinLength],Segments))==0
        continue;
    end
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
            Periodogram(j,:,:,1:nChannels) = fftOut(select,:,:)*sqrt(2/nFFT);
            dfWeight(j,1:nChannels)=1;
        end
    end

    %point process data periodograms
    Segment = (j-1)*winstep+[1 WinLength];
    SegmentId = find(Res>=Segment(1) & Res<=Segment(2));
    if ~isempty(SegmentId)
        SegmentRes = Res(SegmentId) ;
        SegmentClu = Clu(SegmentId);
        if length(CluSubset)==1
            numsp = length(SegmentClu);
        else
            numsp = hist(SegmentClu,CluSubset)'; %number of spikes of each cell
        end
        if any(numsp>=MinSpikes)
            SegmentRes = SegmentRes - Segment(1) + 1;
            fftOut = PointFFT(Tapers,SegmentRes, SegmentClu, nClu, CluSubset, nFFT,Fs, MinSpikes);
            Periodogram(j,: , : ,  nChannels+1:nChannelsAll) = fftOut(select, : , :)*sqrt(2/nFFT);
            dfWeight(j,nChannels+1:end) = numsp;
        end
    end

end


