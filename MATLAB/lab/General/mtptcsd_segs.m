function [y, f, normmat, ynorm, ycom]=mtptcsd_segs(varargin)
%function [y, f]=mtptcsd_segs(x,Res, Clu, nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers, FreqRange,CluSubset,Starts,pval);
% Multitaper Hybrid Spikes-Field Cross-Spectral Density in windows
% triggered by time in Starts - this way one can specify any windows
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
% Original code by Partha Mitra - modified by Ken Harris
% Also containing elements from specgram.m
% and adopted for point processes, long files and other stuff by Anton Sirota
% Poitnt Process spectra calculation following Jarvis&Mitra,2000 and Bijan Pesaran's code

% default arguments and that
[x, Res, Clu, nFFT,Fs,WinLength,winstep,NW,Detrend,nTapers,nChannels, nClu, nSamples,...
    nFFTChunks,select,nFreqBins,f,t,FreqRange,CluSubset,FFTChunks,Starts,pval,MinSpikes]  = mtparam_pt_segs(varargin);

nChannelsAll = nChannels + nClu;

clear varargin; % since that was taking up most of the memory!

% allocate memory now to avoid nasty surprises later
y=complex(zeros(nFreqBins, nChannelsAll, nChannelsAll)); % output array
ynorm=complex(zeros(nFreqBins, nChannelsAll, nChannelsAll)); % output array
ycom=(zeros(nFreqBins, nChannelsAll, nChannelsAll)); % output array
mlog=(zeros(nFreqBins, nChannelsAll)); % output array
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
    Periodogram = complex(zeros(nFreqBins, nTapers, nChannelsAll)); % intermediate FFTs
    ComputeCsd = zeros(nChannelsAll,1); %a priory skip csd calculation
    %continuous case
    if nChannels > 0
        Segment =  x(FFTChunks(j,1):FFTChunks(j,2),:);
	if size(Segment,1)<WinLength
		topad = WinLength - size(Segment,1);
		Segment(end+1:WinLength,:) = zeros(topad,nChannels);
	end
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

    %point process data periodograms
    %    Segment = (j-1)*winstep+[1 WinLength];
    Segment = FFTChunks(j,:);
    SegmentId = find(Res>=Segment(1) & Res<=Segment(2));
    if ~isempty(SegmentId)
        SegmentRes = Res(SegmentId) ;
        SegmentClu = Clu(SegmentId);
        SegmentRes = SegmentRes - Segment(1) + 1;
        fftOut = PointFFT(Tapers,SegmentRes, SegmentClu, nClu, CluSubset, nFFT,Fs,MinSpikes);
        Periodogram(: , : ,  nChannels+1:nChannelsAll) = fftOut(select, : , :);
        if length(CluSubset)==1
            numsp = length(SegmentClu);
        else
            numsp = hist(SegmentClu,CluSubset)'; %number of spikes of each cell
        end
        %        nUsedUnitsChunks = nUsedUnitsChunks +ismember(CluSubset(:),Clu(SegmentId)); %accumulate counter for each cell if it fires in the segment
        nUsedUnitsChunks = nUsedUnitsChunks + double(numsp>=MinSpikes); %accumulate counter for each cell if it fires more than MinSpikes
        ComputeCsd(nChannels+1:end) = numsp>=MinSpikes;
    end


    % Now make cross-products of them to fill cross-spectrum matrix
    for Ch1 = 1:nChannelsAll
        for Ch2 = Ch1:nChannelsAll % don't compute cross-spectra twice
            if ComputeCsd(Ch1)& ComputeCsd(Ch2) % don't do csd calculation if both signals don't fall into Segments
                Temp1 = squeeze(Periodogram(:,:,Ch1));
                Temp2 = squeeze(Periodogram(:,:,Ch2));
                Temp2 = conj(Temp2);
                Temp3 = Temp1 .* Temp2;
                eJ=sum(Temp3, 2);
                y(:,Ch1, Ch2)= y(:,Ch1,Ch2) + eJ;
                %compute covariance (comodugram)
                ycom(:,Ch1, Ch2)= ycom(:,Ch1,Ch2) + (sqrt(mean(abs(Temp1.^2),2)).*(mean(abs(Temp2.^2),2)));
                if Ch2==Ch1
                    mlog(:,Ch1)= mlog(:,Ch1) + (sqrt(mean(abs(Temp1.^2),2)));
                end
                ynorm(:,Ch1,Ch2) = ynorm(:,Ch1,Ch2) + eJ./sqrt(mean(abs(Temp1.^2),2).*mean(abs(Temp2.^2),2));
                normmat(Ch1,Ch2) = normmat(Ch1,Ch2) + nTapers;
            end
        end
    end

end


% now fill other half of matrix with complex conjugate
for Ch1 = 1:nChannelsAll
    if normmat(Ch1,Ch1)==0 
        ycom(1:nFreqBins,Ch1,Ch1) = 0;
        continue;
    end
    for Ch2 = (Ch1+1):nChannelsAll % don't compute cross-spectra twice
        if normmat(Ch2,Ch2)==0 
                ycom(1:nFreqBins,Ch1,Ch2) = 0;
                continue;
        end
        y(:, Ch2, Ch1) = conj(y(:,Ch1,Ch2));
        normmat(Ch2,Ch1) = normmat(Ch1,Ch2);
        
        gi = find(ycom(:,Ch1,Ch1)~=0 & ycom(:,Ch2,Ch2)~=0);
        if isempty(gi) | normmat(Ch1,Ch2)==0
            ycom(1:nFreqBins,Ch1,Ch2) = 0;
        else
            ycom(gi,Ch1,Ch2) = (ycom(gi,Ch1,Ch2)/normmat(Ch1,Ch2)*nTapers - mlog(gi,Ch1).*mlog(gi,Ch2)/normmat(Ch1,Ch1)/normmat(Ch2,Ch2)*(nTapers^2)) ...
            ./ (ycom(gi,Ch1,Ch1).*ycom(gi,Ch1,Ch1)/normmat(Ch1,Ch1)/normmat(Ch2,Ch2)*(nTapers^2));
        end
    end
end

% normmat = [];
% for Ch1 = 1:nChannelsAll
%     for Ch2 = 1:nChannelsAll
%         if Ch1<=nChannels && Ch2<=nChannels
%             normmat(Ch1,Ch2) = nTapers*nUsedEegChunks;
%         elseif Ch1<=nChannels && Ch2>nChannels
%             normmat(Ch1,Ch2) = nTapers*min(nUsedEegChunks,nUsedUnitsChunks(Ch2-nChannels));
%         elseif Ch2<=nChannels && Ch1>nChannels
%             normmat(Ch1,Ch2) = nTapers*min(nUsedEegChunks,
%             nUsedUnitsChunks(Ch1-nChannels));
%         elseif Ch2>nChannels && Ch1>nChannels
%             normmat(Ch1,Ch2) = nTapers*min(nUsedUnitsChunks(Ch1-nChannels),nUsedUnitsChunks(Ch2-nChannels));
%         end
%     end
% end
normp = permute(repmat(normmat,[1,1,nFreqBins]),[3 1 2]);

nz = normp>0;
y(nz) = y(nz) ./ normp(nz);

ynorm(nz) = ynorm(nz) ./ normp(nz);


% we've now done the computation.  the rest of this code is stolen from
% specgram and just deals with the output stage

if nargout == 0
    % take abs, and plot results
    newplot;
    for Ch1=1:nChannelsAll, 
        for Ch2 = 1:nChannelsAll
            subplot(nChannelsAll, nChannelsAll, Ch1 + (Ch2-1)*nChannelsAll);
            plot(f,20*log10(abs(y(:,Ch1,Ch2))+eps));
            grid on;
            if(Ch1==Ch2)
                ylabel('psd (dB)');
            else
                ylabel('csd (dB)');
            end;
            xlabel('Frequency');
        end; 
    end;
end
