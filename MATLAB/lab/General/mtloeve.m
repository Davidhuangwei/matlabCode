function [yo, fo]=mtloeve(varargin);
%function [yo, fo]=mtloeve(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers, FreqRange);
% Multitaper Loeve cross-spectrum
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
[x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,nChannels,nSamples,nFFTChunks,winstep,select,nFreqBins,f,t] = mtparam(varargin);
winstep = WinLength - nOverlap;

clear varargin; % since that was taking up most of the memory!

% check for column vector input
if nSamples == 1
	x = x';
	nSamples = size(x,1);
	nChannels = 1;
end;

% allocate memory now to avoid nasty surprises later
y=complex(zeros(nFreqBins,nFreqBins, nChannels, nChannels)); % output array
Periodogram = complex(zeros(nFreqBins, nTapers, nChannels)); % intermediate FFTs
% Temp1 = complex(zeros(nFreqBins, nTapers));
% Temp2 = complex(zeros(nFreqBins, nTapers));
% Temp3 = complex(zeros(nFreqBins, nTapers));
%eJ = complex(zeros(nFreqBins,1));

% calculate Slepian sequences.  Tapers is a matrix of size [WinLength, nTapers]
[Tapers V]=dpss(WinLength,NW,nTapers, 'calc');

% New super duper vectorized alogirthm
% compute tapered periodogram with FFT 
% This involves lots of wrangling with multidimensional arrays.

TaperingArray = repmat(Tapers, [1 1 nChannels]);
for j=1:nFFTChunks
	Segment = x((j-1)*winstep+[1:WinLength], :);
	if (~isempty(Detrend))
		Segment = detrend(Segment, Detrend);
	end;
	SegmentsArray = permute(repmat(Segment, [1 1 nTapers]), [1 3 2]);
	TaperedSegments = TaperingArray .* SegmentsArray;

	fftOut = fft(TaperedSegments,nFFT);
	Periodogram(:,:,:) = fftOut(select,:,:); %fft(TaperedSegments,nFFT);

	% Now make cross-products of them to fill cross-spectrum matrix
	for Ch1 = 1:nChannels
		for Ch2 = Ch1:nChannels % don't compute cross-spectra twice
            % Peridogram: freq x tapers x channels
			Temp1 = squeeze(Periodogram(:,:,Ch1));
			Temp2 = squeeze(Periodogram(:,:,Ch2));	
			Temp2 = conj(Temp2);
            % here is where change happens
            Temp1 = repmat(shiftdim(Temp1,-1),[nFreqBins, 1, 1,1]);
            Temp2 = permute(repmat(shiftdim(Temp2,-1),[ nFreqBins,1, 1,1]), [2 1 3 4]);
			Temp3 = Temp1 .* Temp2;
			eJ=sum(Temp3, 3);
			y(:,:,Ch1, Ch2)= y(:,:,Ch1,Ch2) + eJ/(nTapers*nFFTChunks);

		end
	end
end

% now fill other half of matrix with complex conjugate
for Ch1 = 1:nChannels
	for Ch2 = (Ch1+1):nChannels % don't compute cross-spectra twice
		y(:,:, Ch2, Ch1) = conj(y(:,:,Ch1,Ch2));
	end
end
		
% we've now done the computation.  the rest of this code is stolen from
% specgram and just deals with the output stage

if nargout == 0
	% take abs, and plot results
    newplot;
    for Ch1=1:nChannels, for Ch2 = 1:nChannels
    	subplot(nChannels, nChannels, Ch1 + (Ch2-1)*nChannels);
		imagesc(f,f,20*log10(abs(y(:,:,Ch1,Ch2))+eps));
        set(gca,'YDir', 'norm');
		grid on;
		if(Ch1==Ch2) 
			ylabel('psd (dB)'); 
		else 
			ylabel('csd (dB)'); 
		end;
		xlabel('Frequency');
	end; end;
elseif nargout == 1
    yo = y;
elseif nargout == 2
    yo = y;
    fo = f;
end
