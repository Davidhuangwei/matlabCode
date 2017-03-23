function [y,f, phi, yerr, phierr, ynorm, ycom, phinorm]=mtptchd_segs(varargin)
%function [y, f,  phi, yerr, phierr,ynorm, ycoh, phinorm]=mtptchd(x,Res, Clu, nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers, FreqRange,CluSubset,Starts,pval,MinSpikes);
% Multitaper coherence density for continuous and point process
% triggered by the times in Starts
% %%%%%%%%%%%%%%%%% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%
% x : input time series, Res/Clu - spikes 
% nFFT = number of points of FFT to calculate (default 1024)
% Fs = sampling frequency (default 2)
% WinLength = length of moving window (default is nFFT)
% nOverlap = overlap between successive windows (default is WinLength/2)
% NW = time bandwidth parameter (e.g. 3 or 4), default 3
% nTapers = number of data tapers kept, default 2*NW -1
% FreqRange =[Fi_beg Fi_end]
% ClustSubset = set of indexes to use for point process estimates (default
% all)
% Starts - samples of the beginnings of the windows to comute the
% spectra/coherences from
% pval - significance level for error bars
% MinSpike - minimal number of spikes to include in the spectral analysis
% $$$$$$$$$$$$$$$$    Output: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% y - f x ch x ch matrix of coherence/spectra, f - freq, phi - phase shift
% ch = nChannelsEeg + length(CluSubset)
% yerr: matrix nChannelsAll x nChannelsAll x 2 - lower/upper limits. Factor
% of the spectral power for lower/upper value for spectra for now (diagonal),
% offdiagonal - coherence confidence level.
% phierr = variance of the phase (theoretical)
% ynorm, ycoh, phinorm = new measures normalizedfor each segment.
% Original code by Partha Mitra - modified by Ken Harris
% Also containing elements from specgram.m
% and adopted for point processes, long files and phase by Anton Sirota
% Poitnt Process spectra calculation following Jarvis&Mitra,2000 and Bijan Pesaran's code

[x, Res, Clu, nFFT,Fs,WinLength,WinStep,NW,Detrend,nTapers,nChannels, nClu, nSamples, ...
    nFFTChunks,select,nFreqBins,f,t, FreqRange, CluSubset, FFTChunks, Starts, pval,MinSpikes] = mtparam_pt_segs(varargin);
nChannelsAll = nChannels + nClu;
[yo, f, normmat, ynorm, ycom] = mtptcsd_segs(x,Res, Clu, nFFT,Fs,WinLength,WinStep,NW,Detrend,nTapers, FreqRange,CluSubset,Starts,pval,MinSpikes);

y = zeros(size(yo));
if nargout>2; phi = zeros(size(y)); end

% main loop
for Ch1 = 1:nChannelsAll
    for Ch2 = 1:nChannelsAll

        if (Ch1 == Ch2)
            % for diagonal elements (i.e. power spectra) leave unchanged
            y(:,Ch1, Ch2) = yo(:,Ch1, Ch2);
        else
            % for off-diagonal elements, scale
            normpow = sq(sqrt(yo(:,Ch1,Ch1) .* yo(:,Ch2,Ch2)));
            nz = normpow>0;
            y(nz,Ch1, Ch2) = abs(yo(nz,Ch1, Ch2))./ normpow(nz);

            if nargout>2
                phi(nz,Ch1,Ch2) = angle(yo(nz,Ch1, Ch2) ./normpow(nz));
            end
            

        end
    end
end

phinorm = angle(ynorm);
ynorm = abs(ynorm);


if nargout>3 % assymptotic error
    pp=1-pval/2;
    qq=1-pval;
    if length(CluSubset)==1
        numsp = length(Clu);
    else
        numsp = hist(Clu,CluSubset); %number of spikes of each cell
    end
    %coherence
    yerr = []; phierr = [];
    for Ch1=1:nChannelsAll
        %spectra
        dof = 2*normmat(Ch1,Ch1);
        if normmat(Ch1,Ch1)==0 
            yerr(1:nFreqBins,Ch1,Ch1,1) = 0;
            yerr(1:nFreqBins,Ch1,Ch1,2) = 0;
            for Ch2=Ch1+1:nChannelsAll
                yerr(1:nFreqBins,Ch1,Ch2,:) = 0;
                yerr(1:nFreqBins,Ch2,Ch1,:) = 0;
                phierr(1:nFreqBins,Ch1,Ch2) = 0;
                phierr(1:nFreqBins,Ch2,Ch1) = 0;
            end
            continue
        end
            
        if Ch1>nChannels
            %finite size correction for spikes
            dof = fix(1/(1./dof + 1./(2*numsp(Ch1-nChannels))));
        end
        Qp=Schi2inv(pp,dof);
        Qq=Schi2inv(qq,dof);
        yerr(1:nFreqBins,Ch1,Ch1,1) = dof*y(:,Ch1,Ch1)/Qp;
        yerr(1:nFreqBins,Ch1,Ch1,2) = dof*y(:,Ch1,Ch1)/Qq;

        %coherence
        for Ch2=Ch1+1:nChannelsAll
            
            if normmat(Ch2,Ch2)==0
                yerr(1:nFreqBins,Ch1,Ch2,:) = 0;
                yerr(1:nFreqBins,Ch2,Ch1,:) = 0;
                phierr(1:nFreqBins,Ch1,Ch2) = 0;
                phierr(1:nFreqBins,Ch2,Ch1) = 0;
                continue
            end
            
            dof = 2*normmat(Ch1,Ch2);
            if Ch1<=nChannels
                dof1 = dof;
            else
                %finite size correction
                dof1=fix(2*numsp(Ch1-nChannels)*dof/(2*numsp(Ch1-nChannels)+dof));
            end
            if Ch2<=nChannels
                dof2 = dof;
            else
                dof2=fix(2*numsp(Ch2-nChannels)*dof/(2*numsp(Ch2-nChannels)+dof));
            end
            dof =min(dof1,dof2);
            yerr(1:nFreqBins,Ch1,Ch2,1) = repmat(confc(dof,pval),nFreqBins,1);
            yerr(1:nFreqBins,Ch2,Ch1,1) = yerr(1:nFreqBins,Ch1,Ch2,1);

            %now phase variance
            perfi = find((sq(y(:,Ch1,Ch2))-1).^2 < 10^-5 | sq(y(:,Ch1,Ch2))==0);
            goodi = setdiff([1:nFreqBins],perfi);
            if ~isempty(goodi)
                phierr(goodi,Ch1,Ch2) = sqrt(2./dof.*(1./(abs(y(goodi,Ch1,Ch2)).^2) - 1));
            end
            if ~isempty(perfi)
                phierr(perfi,Ch1,Ch2) = 0;
            end
            phierr(:,Ch2,Ch1) = -phierr(:,Ch1,Ch2);

        end
    end
end
% plot stuff if required

if (nargout<1)
    PlotMatrix(fo,yo);
end;

if 0
    for i=1:vargout
        sz = size(vargout{i})
%        fprintf('output %d = %d'
    end
end

%helper to compute coherence confidence values
function confC = confc(dof,p)
if dof <= 2
    confC = 1;
else
    df = 1./((dof/2)-1);
    confC = sqrt(1 - p.^df);
end;
return

