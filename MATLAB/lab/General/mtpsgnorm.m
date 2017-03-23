function [yo, fo, to]=mtpsg(varargin);
%function [yo, fo, to]=mtcsg(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers);
% Multitaper Time-Frequency Power-Spectrum (power spectrogram)
% function A=mtpsg(x,nFFT,Fs,WinLength,nOverlap,NW,nTapers)
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
% The difference between this and mtcsg is that this one computes power
% spectra only, no cross-spectra.  So If x is a multicolumn matrix, 
% each column will be treated as a time series and you'll get a 3D matrix 
% of power-spectra out yo(f, t, Ch)


[x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,nChannels,nSamples,nFFTChunks,winstep,select,nFreqBins,f,t] = mtparam(varargin);

[y, fo, to]=mtpsg(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers);

nTimeBins = size(y,2);
nCh1 = size(y,3);
nCh2 = size(y,4);

n = 2*nTapers; %degrees of freedom

yo = zeros(size(y));

% main loop
for Ch1 = 1:nCh1
	for Ch2 = 1:nCh2
		
		if (Ch1 == Ch2)
			% for diagonal elements (i.e. power spectra) normalize by 
			% mean power in each frequency band
			ynorm = y(:,:,Ch1, Ch2);
			ynorm = n*ynorm ./ repmat(mean(ynorm,2), 1, nTimeBins);
			% and then do chi2 -> normal
			%yo(:,:,Ch1, Ch2) = norminv(chi2cdf(ynorm, n));
			% just square root for now ...
			% yo(:,:,Ch1,Ch2) = sqrt(ynorm);
            % In fact, the log...
            yo(:,:,Ch1,Ch2) = log(ynorm);
		else
			% for off-diagonal elements, z transform
			yo(:,:,Ch1, Ch2) = zTrans(y(:,:,Ch1, Ch2));
		end
	end
end
			

