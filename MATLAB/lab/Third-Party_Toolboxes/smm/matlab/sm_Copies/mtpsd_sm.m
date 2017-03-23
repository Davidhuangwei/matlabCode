%function [y,f]= mtpsd(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange)
% Multitaper spectral density power (for each channel, without coherences
% calculation)
function [y,f]=mtpsd(varargin);

[x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,nChannels,nSamples,nFFTChunks,winstep,select,nFreqBins,f,t, FreqRange] = mtparam_sm(varargin);

sz = size(x);
if sz(1)<sz(2) x=x'; sz = size(x); end
nCh = sz(2);
y = [];
for ii=1:nCh
    [y(:,ii) fo] = mtcsd_sm(x(:,ii),nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange);
    %y(:,ii) = y(:,ii)./length(x(:,ii));
end

		
% plot stuff if required

if (nargout<1)
    figure;
   % subplotfit(1, nCh+1);
    imagesc(f,[1:nCh],20*log10(abs(y)+eps)');
%     for ii=1:nCh
%             subplotfit(ii+1, nCh+1);
%             plot(f,20*log10(abs(y(:,ii))+eps));
%             ylabel('psd (dB)');
%             xlabel('Frequency');
%             title(num2str(ii));
%             grid on;
%             
%     end;
end;