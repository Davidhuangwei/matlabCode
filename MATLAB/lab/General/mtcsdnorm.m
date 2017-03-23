function [yo, fo]=mtcsdnorm(varargin);
%function [yo, fo]=mtcsg(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers);
% Multitaper Cross-Spectral Density, Normalized
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
% normalization added by Anton Sirota
% Also containing elements from specgram.m


[x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers] = mtparam(varargin);
[yo, fo] = mtcsd(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers);
df = 2*nTapers; %degrees of freedom
nCh1 = size(yo,2);
nCh2 = size(yo,3);
for Ch1 = 1:nCh1
	for Ch2 = 1:nCh2
		
		if (Ch1 == Ch2)
			% for diagonal elements (i.e. power spectra) normalize by 
			% mean power in each frequency band
			ynorm = yo(:,Ch1, Ch2);
			ynorm = df*ynorm ./ mean(ynorm);
			% and then do chi2 -> normal
			%yo(:,:,Ch1, Ch2) = norminv(chi2cdf(ynorm, n));
			% just square root for now ...
			% yo(:,:,Ch1,Ch2) = sqrt(ynorm);
            % In fact, the log...
            yo(:,Ch1,Ch2) = log(ynorm);
		else
			% for off-diagonal elements, z transform
			yo(:,Ch1, Ch2) = zTrans(yo(:,Ch1, Ch2));
		end
	end
end

