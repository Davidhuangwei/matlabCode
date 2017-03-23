function [y, f, t]=mtptcsg(varargin)
%function [yo, fo]=mtptcsg(x,Res, Clu, nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers, FreqRange,CluSubset,Segments,pval,MinSpikes);
% Multitaper Hybrid Spikes-Field Cross-Spectral Density over time
% x : input time series, Res/Clu - spikes for the 
% nFFT = number of points of FFT to calculate (default 1024)
% Fs = sampling frequency (default 2)
% WinLength = length of moving window (default is nFFT)
% nOverlap = overlap between successive windows (default is WinLength/2)
% NW = time bandwidth parameter (e.g. 3 or 4), default 3
% nTapers = number of data tapers kept, default 2*NW -1
%
% output yo is yo(t,f)
%
% If x is a multicolumn matrix, each column will be treated as a time
% series and you'll get a matrix of cross-spectra out yo(f, Ch1, Ch2)
% NB they are cross-spectra not coherences. If you want coherences use
% mtcohere
%
% Original code by Partha Mitra - modified by Ken Harris
% Also containing elements from specgram.m
% and adopted for point processes, long files and phase by Anton Sirota
% Poitnt Process spectra calculation following Jarvis&Mitra,2000 and Bijan Pesaran's code

% default arguments and that
[x, Res, Clu, nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,nChannels, nClu, nSamples,...
    nFFTChunks,winstep,select,nFreqBins,f,t,FreqRange,CluSubset,Segments,pval,MinSpikes]  = mtparam_pt(varargin);
% to=t;
% t=[];

winstep = WinLength - nOverlap;
nChannelsAll = nChannels + nClu;

clear varargin; % since that was taking up most of the memory!

% allocate memory now to avoid nasty surprises later
y=complex(zeros( nFFTChunks, nFreqBins, nChannelsAll, nChannelsAll)); % output array

Temp1 = complex(zeros(nFreqBins, nTapers));
Temp2 = complex(zeros(nFreqBins, nTapers));
Temp3 = complex(zeros(nFreqBins, nTapers));
eJ = complex(zeros(nFreqBins,1));

% calculate Slepian sequences.  Tapers is a matrix of size [WinLength, nTapers]
[Tapers V]=Sdpss(WinLength,NW,nTapers, 'calc');

%  Calculate the Slepian transforms - use in bias calculation for point process
%H = fft(Tapers,nFFT)';

% New super duper vectorized alogirthm
% compute tapered periodogram with FFT 
% This involves lots of wrangling with multidimensional arrays.
goodt=[]; %index where the csd was computed
curt=1;
TaperingArray = repmat(Tapers, [1 1 nChannels]);
nUsedUnitsChunks = zeros(nClu,1); % count chunks that had something for each cell
nUsedEegChunks = 0;
for j=1:nFFTChunks
    Periodogram = complex(zeros(nFreqBins, nTapers, nChannelsAll)); % intermediate FFTs
    ComputeCsd = zeros(nChannelsAll,1); %a priory skip csd calculation
    %continuous case
    if nChannels > 0
        Segi=(j-1)*winstep+[1:WinLength];
        %now find if this chunk is within Segments (e.g. REM)
        Segi_in = SelectPeriods(Segi,Segments,'d',1);
        if length(Segi_in)>WinLength/2
            Segment = zeros(WinLength,nChannels);
            indinseg = ismember(Segi,Segi_in); %find indexes of the good samples within current segment
            Segment(indinseg,:) = x(Segi_in, :);

            if (~isempty(Detrend))
                Segment = detrend(Segment, Detrend);
            end;
            SegmentsArray = permute(repmat(Segment, [1 1 nTapers]), [1 3 2]);
            TaperedSegments = TaperingArray .* SegmentsArray;

            fftOut = fft(TaperedSegments,nFFT);
            Periodogram(:,:,1:nChannels) = fftOut(select,:,:);
            nUsedEegChunks = nUsedEegChunks + 1;
            ComputeCsd(1:nChannels,1)=1;
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
            Periodogram(: , : ,  nChannels+1:nChannelsAll) = fftOut(select, : , :)*sqrt(2/nFFT);
            nUsedUnitsChunks = nUsedUnitsChunks + double(numsp>=MinSpikes); %accumulate counter for each cell if it fires more than MinSpikes
            ComputeCsd(nChannels+1:end) = numsp>=MinSpikes;
        end
    end  
        
        
    if ComputeCsd % don't do csd calculation if both spikes and eeg don't fall into Segments (e.g. REM)
        % Now make cross-products of them to fill cross-spectrum matrix
        for Ch1 = 1:nChannelsAll
            for Ch2 = Ch1:nChannelsAll % don't compute cross-spectra twice
                if ComputeCsd(Ch1)  & ComputeCsd(Ch2) % don't do csd calculation if both signals don't fall into Segments
                    Temp1 = squeeze(Periodogram(:,:,Ch1));
                    Temp2 = squeeze(Periodogram(:,:,Ch2));
                    Temp2 = conj(Temp2);
                    Temp3 = Temp1 .* Temp2;
                    eJ=sum(Temp3, 2);
                    y(j, :, Ch1, Ch2)= eJ/nTapers;
                    y(j, :, Ch2, Ch1) = conj(y(j,:,Ch1,Ch2));
                end
%                 y(curt, :, Ch1, Ch2)= eJ/nTapers;
%                 y(curt, :, Ch2, Ch1) = conj(y(curt,:,Ch1,Ch2));
                
            end
        end
%        t(curt)=to(j);
 %       curt=curt+1;
    end
end


