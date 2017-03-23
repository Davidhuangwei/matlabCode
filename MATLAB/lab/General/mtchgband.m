function [y, t, peak]=mtchgband(varargin);
%function [y, f, t]=mtchgband(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange);
% Multitaper Time-Frequency Cross-Spectrum (cross spectrogram) 
% function A=mtcsg(x,nFFT,Fs,WinLength,nOverlap,NW,nTapers)
% x : input time series
% nFFT = number of points of FFT to calculate (default 1024)
% Fs = sampling frequency (default 2)
% WinLength = length of moving window (default is nFFT)
% nOverlap = overlap between successive windows (default is WinLength/2)
% NW = time bandwidth parameter (e.g. 3 or 4), default 3
% nTapers = number of data tapers kept, default 2*NW -1
%
% output yo is yo(f, t)
%
% If x is a multicolumn matrix, each column will be treated as a time
% series and you'll get a matrix of cross-spectra out yo(f, t, Ch1, Ch2)
% NB they are cross-spectra not coherences. If you want coherences use
% mtcohere

% Original code by Partha Mitra - modified by Ken Harris
% adopted by Anton Sirota

% default arguments and that
[x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,nChannels,nSamples,nFFTChunksall,winstep,select,nFreqBins,f,t, FreqRange] = mtparam(varargin);

% allocate memory now to avoid nasty surprises later
nFreqRange = size(FreqRange,1);
if nFreqRange==1
    y=complex(zeros(nFFTChunksall, nChannels, nChannels)); % output array
    peak = complex(zeros(nFFTChunksall, 3, nChannels, nChannels)); % output array
else
    % in case of many freq. ranges
    y=complex(zeros(nFFTChunksall, nFreqRange, nChannels, nChannels)); % output array
    peak = complex(zeros(nFFTChunksall, 3, nFreqRange, nChannels, nChannels)); % output array
end

freemem = FreeMemory;
BlockSize = 2^8;
nBlocks = ceil(nFFTChunksall/BlockSize);
%h = waitbar(0,'Wait..');
for Block=1:nBlocks
    %   waitbar(Block/nBlocks,h);
    minChunk = 1+(Block-1)*BlockSize;
    maxChunk = min(Block*BlockSize,nFFTChunksall);
    nFFTChunks = maxChunk - minChunk+1;
    iChunks = [minChunk:maxChunk];
    Periodogram = complex(zeros(nFreqBins, nTapers, nChannels, nFFTChunks)); % intermediate FFTs
    Temp1 = complex(zeros(nFreqBins, nTapers, nFFTChunks));
    Temp2 = complex(zeros(nFreqBins, nTapers, nFFTChunks));
    Temp3 = complex(zeros(nFreqBins, nTapers, nFFTChunks));
    eJ = complex(zeros(nFreqBins, nFFTChunks));
    tmpy =complex(zeros(nFreqBins,nFFTChunks, nChannels, nChannels));
    % calculate Slepian sequences.  Tapers is a matrix of size [WinLength, nTapers]
    [Tapers V]=Sdpss(WinLength,NW,nTapers, 'calc');
    
    % New super duper vectorized alogirthm
    % compute tapered periodogram with FFT 
    % This involves lots of wrangling with multidimensional arrays.
    
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
        Periodogram(:,:,:,j) = fftOut(select,:,:); %fft(TaperedSegments,nFFT);
    end	
    
    % Now make cross-products of them to fill cross-spectrum matrix
    for Ch1 = 1:nChannels
        for Ch2 = Ch1:nChannels % don't compute cross-spectra twice
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
    
    
    for Ch1 = 1:nChannels
        for Ch2 = 1:nChannels % don't compute cross-spectra twice
            if nFreqRange ==1
                if (Ch1 == Ch2)
                    % for diagonal elements (i.e. power spectra) leave unchanged
                    % for a single freq. range
                    y(iChunks,Ch1, Ch2) = mean(tmpy(:,:,Ch1, Ch2));
                else
                    % for off-diagonal elements, scale
                    y(iChunks,Ch1, Ch2) = mean(abs(tmpy(:,:,Ch1, Ch2).^2) ...
                        ./ (tmpy(:,:,Ch1,Ch1) .* tmpy(:,:,Ch2,Ch2)));
                end
                if (nargout>2)
                    peak(iChunks, :, Ch1, Ch2) = PeakValues(tmpy,Ch1,Ch2,f);
                end
                
                
            else
                % for a multiple freq. ranges                
                for nf=1:nFreqRange
                    fselect=find(f>FreqRange(nf,1) & f<FreqRange(nf,2));
                    if (Ch1 == Ch2)
                        % for diagonal elements (i.e. power spectra) leave unchanged
                        y(iChunks, nf, Ch1, Ch2) = mean(tmpy(fselect,:,Ch1, Ch2));
                    else
                        % for off-diagonal elements, scale
                        y(iChunks,nf, Ch1, Ch2) = mean(abs(tmpy(fselect,:,Ch1, Ch2).^2) ...
                            ./ (tmpy(fselect,:,Ch1,Ch1) .* tmpy(fselect,:,Ch2,Ch2)));
                    end
                    if (nargout>2)
                        peak(iChunks, :, nf, Ch1, Ch2) = PeakValues(tmpy(fselect,:,:,:),Ch1,Ch2,f(fselect));
                    end
                    
                end
            end
        end
        
    end
end
%close(h);
% we've now done the computation.  the rest of this code is stolen from
% specgram and just deals with the output stage

if nargout == 0
    % take abs, and use image to display results
        figure
        PlotMatrix(y); 
        legend(num2str(FreqRanges));  
%     xlabel('Time')
%     ylabel('Frequency')
end


function out = PeakValues(in, Ch1, Ch2, freq)
if (Ch1 == Ch2)
    tmp = in(:,:,Ch1,Ch2);
    tmp = squeeze(tmp);
    [maxv ind] = max(tmp);
    out(:,1) = maxv';
    out(:,2) = freq(ind);
    out(:,3) = 0;
else
    tmp = in(:,:,Ch1,Ch2)./sqrt(in(:,:,Ch1,Ch1).*in(:,:,Ch2,Ch2));
    tmp = squeeze(tmp);
    [maxv ind] = max(abs(tmp.^2));
    out(:,1) = maxv';
    out(:,2) = freq(ind);
    ind = ind(:)+[0:size(tmp,2)-1]'*2;
    out(:,3) = angle(tmp(ind));
end
return

