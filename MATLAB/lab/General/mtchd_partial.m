function [y, f, ph]=mtchd_partial(varargin);
%function [y, f, ph]=mtchd_partial(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers, FreqRange);
% Multitaper Partial coherence x - 3 column vector for now
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
if nChannels>3 | nChannels<3 error('need 3 channels'); end
    
% allocate memory now to avoid nasty surprises later
%y=complex(zeros(nFreqBins, nChannels, nChannels)); % output array
Nominator=complex(zeros(nFreqBins, 1));
Denominator1=complex(zeros(nFreqBins, 1));
Denominator2=complex(zeros(nFreqBins, 1));
% phloc=zeros(nFreqBins, nChannelsAll, nChannelsAll); % output array
%phloc=zeros(nFreqBins, nChannels, nChannels); % output array
Periodogram = complex(zeros(nFreqBins, nTapers, nChannels)); % intermediate FFTs
Temp1 = complex(zeros(nFreqBins, nTapers));
Temp2 = complex(zeros(nFreqBins, nTapers));
Temp3 = complex(zeros(nFreqBins, nTapers));
eJ = complex(zeros(nFreqBins,1));

% calculate Slepian sequences.  Tapers is a matrix of size [WinLength, nTapers]
if nFFTChunks==1
[Tapers V]=Sdpss(nSamples,NW,nTapers, 'calc');
else
[Tapers V]=Sdpss(WinLength,NW,nTapers, 'calc');
end
% New super duper vectorized alogirthm
% compute tapered periodogram with FFT 
% This involves lots of wrangling with multidimensional arrays.

TaperingArray = repmat(Tapers, [1 1 nChannels]);
for j=1:nFFTChunks
    if nFFTChunks==1
        Segment = x;
    else
    	Seg = [(j-1)*winstep+1: min((j-1)*winstep+WinLength,nSamples)];
        Segment = x(Seg,:);
    end
	if (~isempty(Detrend))
		Segment = detrend(Segment, Detrend);
	end;
	SegmentsArray = permute(repmat(Segment, [1 1 nTapers]), [1 3 2]);
	TaperedSegments = TaperingArray .* SegmentsArray;

	fftOut = fft(TaperedSegments,nFFT);
    %norm factor to get the original units (rms)
    normfac = sqrt(2/nFFT); %disregard that 0 and Fnyq should not have 2 in the normfac
    % but we are not computing them anyway
	Periodogram(:,:,:) = fftOut(select,:,:).*normfac; %fft(TaperedSegments,nFFT);

    Sx = squeeze(Periodogram(:,:,1));
    Sy = squeeze(Periodogram(:,:,2));	
    Sz= squeeze(Periodogram(:,:,3));	
    
    Nominator  = Nominator + mean(Sy.*conj(Sx),2).*mean(Sz.*conj(Sz),2) - mean(Sy.*conj(Sz),2).*mean(Sz.*conj(Sx),2);
    Denominator1 = Denominator1 + mean(Sy.*conj(Sy),2).*mean(Sz.*conj(Sz),2)-abs(mean(Sy.*conj(Sz),2)).^2;
    Denominator2 = Denominator2 + mean(Sx.*conj(Sx),2).*mean(Sz.*conj(Sz),2)-abs(mean(Sx.*conj(Sz),2)).^2;
	% Now make cross-products of them to fill cross-spectrum matrix
% 	for Ch1 = 1:nChannels
% 		for Ch2 = Ch1:nChannels % don't compute cross-spectra twice
% 			Temp1 = squeeze(Periodogram(:,:,Ch1));
% 			Temp2 = squeeze(Periodogram(:,:,Ch2));	
% 			Temp2 = conj(Temp2);
% 			Temp3 = Temp1 .* Temp2;
% 			eJ=sum(Temp3, 2);
% 			y(:,Ch1, Ch2)= y(:,Ch1,Ch2) + eJ/(nTapers*nFFTChunks);
%              %phase locking index
%             phloc(:,Ch1,Ch2) = phloc(:,Ch1,Ch2) + sum(exp(-i*angle(Temp1)-i*angle(Temp2)),2);
% 		end
% 	end
end

y = abs(Nominator)./sqrt(Denominator1.*Denominator2);
ph = angle(Nominator);
% % now fill other half of matrix with complex conjugate
% for Ch1 = 1:nChannels
% 	for Ch2 = (Ch1+1):nChannels % don't compute cross-spectra twice
% 		y(:, Ch2, Ch1) = conj(y(:,Ch1,Ch2));
% 	end
% end
		
% we've now done the computation.  the rest of this code is stolen from
% specgram and just deals with the output stage

if nargout == 0
	% take abs, and plot results
    %newplot;
    for Ch1=1:nChannels, for Ch2 = 1:nChannels
    	subplot(nChannels, nChannels, Ch1 + (Ch2-1)*nChannels);
		plot(f,10*log10(abs(y(:,Ch1,Ch2))+eps));
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
