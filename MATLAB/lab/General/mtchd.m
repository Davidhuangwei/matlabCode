%function [yo,fo, phi]= mtchd(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange)
% Multitaper coherence density
% This basically does the same thing as mtcsd, but scales
% the cross-spectra to become coherences
% also computes phase lag phi , which like the following:
% phi(:,1,2)=  phase(x2) - phase(x1)
% so positive sign means x1 is leading x2 (shifted to the left from x2)
% if phase shift is linear in freq. then slope indicates constant time lag
% positive - x1 leads x2
function [yo,fo, phi]=mtchd(varargin);

[x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,nChannels,nSamples,nFFTChunks,winstep,select,nFreqBins,f,t, FreqRange] = mtparam(varargin);
[y fo] = mtcsd(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange);


nCh1 = size(y,2);
nCh2 = size(y,3);

yo = zeros(size(y));
 if nargout>2 phi = zeros(size(y)); end
% main loop
for Ch1 = 1:nCh1
	for Ch2 = 1:nCh2
		
		if (Ch1 == Ch2)
			% for diagonal elements (i.e. power spectra) leave unchanged
			yo(:,Ch1, Ch2) = abs(y(:,Ch1, Ch2));
		else
			% for off-diagonal elements, scale
            norm = (y(:,Ch1,Ch1) .* y(:,Ch2,Ch2));
            
			yo(:,Ch1, Ch2) = abs(y(:,Ch1, Ch2)) ./ sqrt(norm);

            phi(:,Ch1,Ch2) = angle(y(:,Ch1, Ch2));

%					yo(:,Ch1, Ch2) = abs(y(:,Ch1, Ch2)).^2 ...
% 				./ sqrt(y(:,Ch1,Ch1) .* y(:,Ch2,Ch2));
    end
	end
end
			
% plot stuff if required

if (nargout<1)
    figure;
    for Ch1=1:nChannels
        for Ch2 = Ch1:nChannels
            subplot(nChannels, nChannels, Ch1 + (Ch2-1)*nChannels);
            if(Ch1==Ch2) 
                plot(f,20*log10(abs(yo(:,Ch1,Ch2))+eps));
                ylabel('psd (dB)'); 
            else 
                plot(f,yo(:,Ch1,Ch2));
                ylabel('chd (dB)'); 
                subplot(nChannels, nChannels, Ch2 + (Ch1-1)*nChannels);
                plot(f,unwrap(phi(:,Ch1,Ch2)));
                ylabel('phase shift (radians)');
            end;
            grid on;
            xlabel('Frequency');
        end; 
    end
end;