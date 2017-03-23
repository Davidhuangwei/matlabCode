%[wave,f,t,s,wb] = Wavelet(x,FreqRange,Fs, w0, IsLogSc, WhatBlock, wb,Split)
% computes the scalogram for the signal x (Time by Channels)
% FreqRange  -- range of frequencies [Fmin Fmax]
% Fs         -- sampling rate
% w0         -- center freq.(dimensionless) of 
%               mother (Morlet) wavelet
% IsLogSc -- 0 - even, 1 - logorythmic(default)	
% wb - matrix of wave_base computed on previous step
% Output:
% wavelet decomposition wave (freq/scale by time)
% t-time(sec), f - freq.(Hz),
% s- scale, p -period (sec)
% function is rewritten after Cristopher Torrence and
% Gilbert Compo (see their paper for details)

function [wave,f,t,s,wb] = Wavelet(x,varargin)
global memcont;
%set defaults
                    [FreqRange, Fs,   w0, IsLogSc, WhatBlock, wb,   Split   ] = ...
DefaultArgs(varargin,{[1 250],  1250, 6,  1,       0,         [],   0       }); 

pad = 1; % will pad to nearest power of 2
mother = 'MORLET'; % so far it is fixed

% compute the req. axis sampling
[f,s,p] = WaveletSampling(Fs,FreqRange,IsLogSc, w0);
nFBins = length(f);
 if size(x,1)<size(x,2)
     error('fist dimmension has to be time');
%     x =x';
 end
nSamples = size(x,1);
nChannels =size(x,2);
n = size(x,1);
% if will take more than available memory - exit
if isempty(Split)
    Split = 0; %don't split by default
    avmemory = FreeMemory*1000*0.3;
    if (nChannels*nFBins*2*16 > avmemory)
        %error('It will take more memory then available');
        Split=1;
    end
    memcont(end+1) =FreeMemory;
end

wave = zeros(nSamples, nFBins);
if Split
fprintf('splitting...\n');

   [nBlocks, BlockSize] = WaveletTimeSplit(x,Fs,FreqRange,IsLogSc);
    for j=1:nBlocks
        segind = [((j-1)*BlockSize+1) : min(nSamples,j*BlockSize)];
        segment = x(segind,:);  
        [waveBlock, f, t, s, wb] = Wavelet(segment,FreqRange,Fs, w0, IsLogSc, wb);
        wave(segind,:) =  waveBlock;
    end
    memcont(end+1) =FreeMemory;
 
else
    
    % zero center
    x = x - repmat(mean(x),nSamples,1);
    if (pad == 1 & ~mod(nSamples,2))
        base2 = fix(log2(nSamples) + 0.4999);   % power of 2 nearest to nSamples
        x = [x;zeros(2^(base2+1)-nSamples, nChannels)];
    end
    
    n = size(x,1);
    %....construct freq. vector for fft transform [Eqn(5)]
    k = [1:fix(n/2)];
    k = k.*((2.*pi)/(n/Fs));
    k = [0., k, -k(fix((n-1)/2):-1:1)];
    
    %....compute FFT of the (padded) time series
    fftX = fft(x);    % [Eqn(3)]
    
    %attempt to save memory: use (nChannels+1)*n*nFBins*16 bytes
    if isempty(wb) | size(wb,2)~=n
        [wb,fourier_factor,coi,dofmin] = wave_bases(mother,k,s,w0);
    end
    memcont(end+1) =FreeMemory;
    wave = repmat(wb,[1, 1, nChannels]);
    wave = wave .*permute(repmat(fftX, [1,1,nFBins]), [3 1 2]);
    wave = permute( ifft(wave,[],2), [2 1 3]);
    
    % for si = 1:nFBins
    % 	[daughter,fourier_factor,coi,dofmin]=wave_bases(mother,k,scale(si),w0);	
    % 	wave(si,:) = ifft(fftX.*daughter);  % wavelet transform[Eqn(4)]
    % end
    
    %coi = coi*[1E-5,1:((nSamples+1)/2-1),fliplr((1:(nSamples/2-1))),1E-5]/Fs;  % COI [Sec.3g]
    wave = wave(1:nSamples,:,:);  % get rid of padding before returning
    t = [1:nSamples]/Fs;
    t=t(:); p=p(:);f=f(:);s=s(:);
end
t = [1:nSamples]/Fs;t=t(:);

% save('wavtmp.mat','wave','t','f','s','wb');
% clear
% load('wavtmp.mat','wave','t','f','s','wb');
% system('rm wavtmp.mat');
%memcont(end+1) =FreeMemory;
return 

