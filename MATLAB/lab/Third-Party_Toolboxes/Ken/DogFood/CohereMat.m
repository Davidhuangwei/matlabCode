% [C, f] = CohereMat(X, nFFT, Fs, Window)
%
% computes all the power spectra and coherences for
% a multivariate time series, using MATLAB signal 
% processing tookit function (i.e. not multitaper)
%
% X should be in the form X(t, Channel);
%
% Output C is of the form C(f, Ch1, Ch2);
% Diagonal elements are power spectra.
% Off-diagonal elements are coherences.

function [C, f] = CohereMat(X, nFFT, Fs, Window);

if nargin<2 nFFT=[]; end;
if nargin<3 Fs=[]; end;
if nargin<4 Window=[]; end;


nChannels = size(X,2);
C = zeros(1+nFFT/2, nChannels, nChannels);

for Ch1 = 1:nChannels
	for Ch2 = Ch1:nChannels
	fprintf('Doing %d vs %d\n', Ch1, Ch2);
		% diagonal elements: power spectra
		if (Ch1==Ch2)
			[C(:,Ch1,Ch2), f] = psd(X(:,Ch1),nFFT,Fs);
		else
			[C(:,Ch1,Ch2), f] = cohere(X(:,Ch1),X(:,Ch2),nFFT,Fs);
			C(:,Ch2,Ch1) = C(:,Ch1,Ch2);
		end
	end
end