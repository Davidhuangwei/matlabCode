function [y,f, t, phi, yerr, phierr]=mtptchg(varargin)
%function [y, f,  phi, yerr, phierr]=mtptchg(x,Res, Clu, nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers, FreqRange,CluSubset,Segments, pval, MinSpikes);
% Multitaper coherencogram (time-freq) for continuous and point process 
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
% 
% $$$$$$$$$$$$$$$$    Output: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% y - f x ch x ch matrix of coherence/spectra, f - freq, phi - phase shift
% ch = nChannelsEeg + length(CluSubset)
% yerr: matrix nChannelsAll x nChannelsAll x 2 - lower/upper limits. Factor
% of the spectral power for lower/upper value for spectra for now (diagonal),
% offdiagonal - coherence confidence level.
% phierr = variance of the phase (theoretical)
% Original code by Partha Mitra - modified by Ken Harris
% and adopted for point processes, long files and phase by Anton Sirota
% Poitnt Process spectra calculation following Jarvis&Mitra,2000 and Bijan Pesaran's code

[x, Res, Clu, nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,nChannels, nClu, nSamples, ...
    nFFTChunks,winstep,select,nFreqBins,f,t, FreqRange, CluSubset, Segments, pval, MinSpikes] = mtparam_pt(varargin);
winstep = WinLength - nOverlap;
nChannelsAll = nChannels + nClu;
[yo, f, t] = mtptcsg(x,Res, Clu, nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers, FreqRange,CluSubset,Segments,pval,MinSpikes);

y = zeros(size(yo));
if nargout>3; phi = zeros(size(y)); end

% main loop
for Ch1 = 1:nChannelsAll
    for Ch2 = 1:nChannelsAll

        if (Ch1 == Ch2)
            % for diagonal elements (i.e. power spectra) leave unchanged
            y(:,:,Ch1, Ch2) = yo(:,:,Ch1, Ch2);
        else
            % for off-diagonal elements, scale
            normpow = sqrt(yo(:,:,Ch1,Ch1) .* yo(:,:,Ch2,Ch2));

            y(:,:,Ch1, Ch2) = abs(yo(:,:,Ch1, Ch2)) ./ normpow;

            if nargout>2
                phi(:,:,Ch1,Ch2) = angle(yo(:,:,Ch1, Ch2) ./normpow);
            end

        end
    end
end


if nargout>4 % assymptotic error
    pp=1-pval/2;
    qq=1-pval;
    numsp = hist(Clu,CluSubset); %number of spikes of each cell

    %coherence
    yerr = []; phierr = [];
    for Ch1=1:nChannelsAll
        %spectra
        dof = 2*normmat(Ch1,Ch1);
        if Ch1>nChannels
            %finite size correction for spikes
            dof = fix(1/(1./dof + 1./(2*numsp(Ch1-nChannels))));
        end
        Qp=chi2inv(pp,dof);
        Qq=chi2inv(qq,dof);
        yerr(1:nFreqBins,Ch1,Ch1,1) = dof*y(:,Ch1,Ch1)/Qp;
        yerr(1:nFreqBins,Ch1,Ch1,2) = dof*y(:,Ch1,Ch1)/Qq;

        %coherence
        for Ch2=Ch1+1:nChannelsAll
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
                phierr(goodi,Ch1,Ch2) = sqrt(2./dof.*(1./(y(goodi,Ch1,Ch2).^2) - 1));
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

%helper to compute coherence confidence values
function confC = confc(dof,p)
if dof <= 2
    confC = 1;
else
    df = 1./((dof/2)-1);
    confC = sqrt(1 - p.^df);
end;
return

