function [yo, fo, to]=mtcloeve(varargin);

% Multitaper Loeve coherence
%
% This basically does the same thing as mtloeve, but scales
% the cross-spectra to become coherences

[x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,...
        nChannels,nSamples,nFFTChunks,winstep,select,nFreqBins,f,t, FreqRange] = mtparam(varargin);
[y fo] = mtloeve(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange);
[pow fo] = mtcsd(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange);

nCh1 = size(y,3);
nCh2 = size(y,4);

yo = zeros(size(y));
% fdiag = [1:nFreqBins]*eye(nFreqBins);
% fdiag = repmat(shiftdim(fdiag,-2),nCh1,nCh2,1,1);
% fdiag = permute(fdiag, [3 4 1 2]);

% main loop
for Ch1 = 1:nCh1
	for Ch2 = 1:nCh2
		
		if (Ch1 == Ch2)
			% for diagonal elements (i.e. power spectra) leave unchanged
			yo(:,:,Ch1, Ch2) = abs(y(:,:,Ch1, Ch2));
		else
			% for off-diagonal elements, normalize
			yo(:,:,Ch1, Ch2) = (abs(y(:,:,Ch1, Ch2))).^2 ...
				./ (permute(repmat(shiftdim(pow(:,Ch1,Ch1),-1),[nFreqBins, 1,1,1]), [2 1 3 4]) ...
                .* repmat(shiftdim(pow(:,Ch2,Ch2),-1),[nFreqBins, 1,1,1]));
%					yo(:,Ch1, Ch2) = abs(y(:,Ch1, Ch2)).^2 ...
% 				./ sqrt(y(:,Ch1,Ch1) .* y(:,Ch2,Ch2));
    end
	end
end
			
% plot stuff if required

if (nargout<1)
	ImageMatrix(fo,fo,yo);
end;