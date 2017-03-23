function [y, f, t]=mtperiodogram(varargin);
%function [yo, fo]=mtperiodogram(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers, FreqRange);
% Multitaper Periodogram for each channel (comple number averaged over
% tapers and periods
% function A=mtcsd(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers)
% x : input time series
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

% Original code by Partha Mitra - modified by Ken Harris
% Also containing elements from specgram.m

% default arguments and that
[x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,nChannels,nSamples,nFFTChunks,winstep,select,nFreqBins,f,t, FreqRange] = mtparam(varargin);
winstep = WinLength - nOverlap;

clear varargin; % since that was taking up most of the memory!

% check for column vector input
if nSamples == 1
	x = x';
	nSamples = size(x,1);
	nChannels = 1;
end;

% allocate memory now to avoid nasty surprises later
y=(zeros(nFFTChunks, nFreqBins, nChannels)); % output array
%ph=(zeros(nFreqBins, nChannels)); % output array

Periodogram = complex(zeros(nFreqBins, nTapers, nChannels)); % intermediate FFTs
Temp1 = complex(zeros(nFreqBins, nTapers));
amp = (zeros(nFreqBins,1));
ang = (zeros(nFreqBins,1));
% calculate Slepian sequences.  Tapers is a matrix of size [WinLength, nTapers]
if nFFTChunks==1
[Tapers V]=dpss(nSamples,NW,nTapers, 'calc');
else
[Tapers V]=dpss(WinLength,NW,nTapers, 'calc');
end
% New super duper vectorized alogirthm
% compute tapered periodogram with FFT 
% This involves lots of wrangling with multidimensional arrays.

TaperingArray = repmat(Tapers, [1 1 nChannels]);
for j=1:nFFTChunks
	Seg = [(j-1)*winstep+1: min((j-1)*winstep+WinLength,nSamples)];
	
	Segment = x(Seg,:);
	if (~isempty(Detrend))
		Segment = detrend(Segment, Detrend);
	end;
	SegmentsArray = permute(repmat(Segment, [1 1 nTapers]), [1 3 2]);
	TaperedSegments = TaperingArray .* SegmentsArray;

	fftOut = fft(TaperedSegments,nFFT);
	Periodogram(:,:,:) = fftOut(select,:,:); %fft(TaperedSegments,nFFT);

    y(j,:,:) = sq(mean(Periodogram,2)); %just average accross tapers
    
% 	% Now make cross-products of them to fill cross-spectrum matrix
% 	for Ch1 = 1:nChannels
% 			Temp1 = squeeze(Periodogram(:,:,Ch1));
% 			amp=sum(Temp1.*conj(Temp1), 2);
%             ang=sum(angle(Temp1), 2);
% 			y(:,Ch1)= y(:,Ch1) + amp/(nTapers*nFFTChunks);
%             ph(:,Ch1)= ph(:,Ch1) + ang/(nTapers*nFFTChunks);
% 	end
end

% now fill other half of matrix with complex conjugate
% for Ch1 = 1:nChannels
% 	for Ch2 = (Ch1+1):nChannels % don't compute cross-spectra twice
% 		y(:, Ch2, Ch1) = conj(y(:,Ch1,Ch2));
% 	end
% end
		
% we've now done the computation.  the rest of this code is stolen from
% specgram and just deals with the output stage

% if nargout == 0
% 	% take abs, and plot results
%     %newplot;
%     for Ch1=1:nChannels, for Ch2 = 1:nChannels
%     	subplot(nChannels, nChannels, Ch1 + (Ch2-1)*nChannels);
% 		plot(f,10*log10(abs(y(:,Ch1,Ch2))+eps));
% 		grid on;
% 		if(Ch1==Ch2) 
% 			ylabel('psd (dB)'); 
% 		else 
% 			ylabel('csd (dB)'); 
% 		end;
% 		xlabel('Frequency');
% 	end; end;
% elseif nargout == 1
%     yo = y;
% elseif nargout == 2
%     yo = y;
%     fo = f;
% end
