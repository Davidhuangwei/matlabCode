function [y, f, t, phi]=mtptchglong(varargin);
%function [yo, fo, to, ph]=mtptchglong(x,Res, Clu, nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,CluSubset);
% Multitaper Time-Frequency Cross-Spectrum (cross spectrogram) for hybrid data:
% x - matrix of continuous signlas, Res,Clu - give times and cluster index for point processes. 
% if x is not givven, does it only for point process
% handles long files - splits data into blockes to save memory
% function A=mtcsg(x,nFFT,Fs,WinLength,nOverlap,NW,nTapers)
% x : input time series
% nFFT = number of points of FFT to calculate (default 1024)
% Fs = sampling frequency (default 2)
% WinLength = length of moving window (default is nFFT)
% nOverlap = overlap between successive windows (default is WinLength/2)
% NW = time bandwidth parameter (e.g. 3 or 4), default 3
% nTapers = number of data tapers kept, default 2*NW -1
% CluSubset  
% output yo is yo(f, t)
%
% If x is a multicolumn matrix, each column will be treated as a time
% series and you'll get a matrix of cross-spectra out yo(f, t, Ch1, Ch2)
% NB they are cross-spectra not coherences. If you want coherences use
% mtcohere
% Original code by Partha Mitra - modified by Ken Harris 
% and adopted for point processes, long files, phase etc by Anton Sirota
% Point Process spectra calculation following Jarvis&Mitra,2000 and Bijan Pesaran's code

% default arguments and that
[x, Res, Clu, nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,nChannels, nClu, nSamples, ...
        nFFTChunks,winstep,select,nFreqBins,f,t] = mtparam_pt(varargin);

nChannelsAll = nChannels + nClu;
CluInd = unique(Clu);
% allocate memory now to avoid nasty surprises later
y=complex(zeros(nFFTChunks,nFreqBins, nChannelsAll, nChannelsAll)); % output array
if nargout>3
    phi=complex(zeros(nFFTChunks,nFreqBins, nChannelsAll, nChannelsAll));
end
nFFTChunksall= nFFTChunks;
%freemem = FreeMemory;
BlockSize = 2^6;
nBlocks = ceil(nFFTChunksall/BlockSize);
%h = waitbar(0,'Wait..');
for Block=1:nBlocks
 %   waitbar(Block/nBlocks,h);
    minChunk = 1+(Block-1)*BlockSize;
    maxChunk = min(Block*BlockSize,nFFTChunksall);
    nFFTChunks = maxChunk - minChunk+1;
    iChunks = [minChunk:maxChunk];
    Periodogram = complex(zeros(nFreqBins, nTapers, nChannelsAll, nFFTChunks)); % intermediate FFTs
    %PeriodogramRes = complex(zeros(nFreqBins, nTapers, nClu, nFFTChunks)); % intermediate FFTs for spikes
    Temp1 = complex(zeros(nFreqBins, nTapers, nFFTChunks));
    Temp2 = complex(zeros(nFreqBins, nTapers, nFFTChunks));
    Temp3 = complex(zeros(nFreqBins, nTapers, nFFTChunks));
    eJ = complex(zeros(nFreqBins, nFFTChunks));
    tmpy =complex(zeros(nFreqBins,nFFTChunks, nChannelsAll, nChannelsAll));
    % calculate Slepian sequences.  Tapers is a matrix of size [WinLength, nTapers]
    [Tapers V]=dpss(WinLength,NW,nTapers, 'calc');
    
    %  Calculate the Slepian transforms - use in bias calculation for point process
    H = fft(Tapers,nFFT)';

    % New super duper vectorized alogirthm
    % compute tapered periodogram with FFT 
    % This involves lots of wrangling with multidimensional arrays.
    
    if nChannels > 0 
        %continuous data periodograms, if needed
        TaperingArray = repmat(Tapers, [1 1 nChannels]);
        for j=1:nFFTChunks
            jcur = iChunks(j);
            Segment = x((jcur-1)*winstep+[1:WinLength], :);
            if (~isempty(Detrend))
                Segment = detrend(Segment, Detrend);
            end;
            SegmentsArray = permute(repmat(Segment, [1 1 nTapers]), [1 3 2]);
            TaperedSegments = TaperingArray .* SegmentsArray;
            
            fftOut = fft(TaperedSegments,nFFT);
            Periodogram(: , : , 1:nChannels , j) = fftOut(select,:,:); 
        end	
    end
    %point process data periodograms
    for j=1:nFFTChunks
        jcur = iChunks(j);
        Segment = (jcur-1)*winstep+[1 WinLength];
        SegmentId = find(Res>=Segment(1) & Res<=Segment(2));
        if ~isempty(SegmentId)
            SegmentRes = Res(SegmentId) ;
            SegmentClu = Clu(SegmentId);
            SegmentRes = SegmentRes - SegmentRes(1) + 1;
            fftOut = PointFFT(Tapers,SegmentRes, SegmentClu, nClu, CluInd, nFFT, Fs,3); 
            Periodogram(: , : ,  nChannels+1:nChannelsAll , j) = fftOut(select, : , :);   
        else
            Periodogram(: , : ,  nChannels+1:nChannelsAll , j) = zeros(nFreqBins,nTapers, nClu);
        end
    end    
    
    % Now make cross-products of them to fill cross-spectrum matrix
    for Ch1 = 1:nChannelsAll
        for Ch2 = Ch1:nChannelsAll % don't compute cross-spectra twice
            Temp1 = reshape(Periodogram(:,:,Ch1,:), [nFreqBins,nTapers,nFFTChunks]);
            Temp2 = reshape(Periodogram(:,:,Ch2,:), [nFreqBins,nTapers,nFFTChunks]);
            Temp2 = conj(Temp2);
            Temp3 = Temp1 .* Temp2;
            eJ=sum(Temp3, 2);
            tmpy(:,:, Ch1, Ch2)= eJ/nTapers;
            
            % for off-diagonal elements copy into bottom half of matrix
            if (Ch1 ~= Ch2)
                tmpy(:,:, Ch2, Ch1) = conj(eJ) / nTapers;
            end            
          
        end
    end
    
    for Ch1 = 1:nChannelsAll
        for Ch2 = 1:nChannelsAll % don't compute cross-spectra twice
            
            if (Ch1 == Ch2)
                % for diagonal elements (i.e. power spectra) leave unchanged
                y(iChunks,:,Ch1, Ch2) = permute(tmpy(:,:,Ch1, Ch2),[2 1 3 4]);
            else
                % for off-diagonal elements, scale
                warning off  
                normspec = sq(tmpy(:,:,Ch1,Ch1) .* tmpy(:,:,Ch2,Ch2))';
                % now Chunks x FreqBins 
                goodChunks = find(all(normspec,2));
                normspec = normspec(goodChunks,:);
                y(iChunks(goodChunks),:,Ch1, Ch2) = abs(tmpy(:,goodChunks,Ch1, Ch2)'.^2) ...
                    ./ normspec;
                
                if nargout>3
                    phi(iChunks(goodChunks),:,Ch1,Ch2) = angle(tmpy(:,goodChunks,Ch1, Ch2)' ...
                        ./ sqrt(normspec));
                end
                warning on
            end
        end
    end
    
    
end
%close(h);
% we've now done the computation.  the rest of this code is stolen from
% specgram and just deals with the output stage

if nargout == 0
    % take abs, and use image to display results
    newplot;
    for Ch1=1:nChannelsAll, 
        for Ch2 = 1:nChannelsAll
            subplot(nChannelsAll, nChannelsAll, Ch1 + (Ch2-1)*nChannelsAll);
            if length(t)==1
                imagesc([0 1/f(2)],f,20*log10(abs(y(:,:,Ch1,Ch2))+eps));axis xy; colormap(jet)
            else
                imagesc(t,f,20*log10(abs(y(:,:,Ch1,Ch2))+eps));axis xy; colormap(jet)
            end
        end; 
    end;
    xlabel('Time')
    ylabel('Frequency')
% elseif nargout == 1,
%     yo = y;
% elseif nargout == 2,
%     yo = y;
%     fo = f;
% elseif nargout == 3,
%     yo = y;
%     fo = f;
%     to = t;
end



