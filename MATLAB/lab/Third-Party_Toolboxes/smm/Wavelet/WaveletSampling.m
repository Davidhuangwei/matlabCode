%[f,s,p] = WaveletSampling(Fs,FreqRange,IsLogSc, w0)
function [f,s,p] = WaveletSampling(varargin)

[Fs, FreqRange, IsLogSc, w0] = DefaultArgs(varargin, {1250,[1 200],1,6});
% fix optional arguments for now
%FreqRes =0.1; % for even sampling
dj = 0.03; % for logarythmic sampling
dt = 1./Fs;
fourier_factor = (4*pi)/(w0 + sqrt(2 + w0^2));
% select the freq. sampling
if length(FreqRange)==2 & IsLogSc ==0
    %even sampling, not good statistically
    nFBins = 100;
    %dF=FreqRange(2)-FreqRange(1);
    %nFBins = round(dF/FreqRes);
    f = linspace(FreqRange(1),FreqRange(2),nFBins);
    s = 1./(fourier_factor*f); 
elseif length(FreqRange)==2 & IsLogSc ==1
%keyboard
    %loghorythmic scaling
    J = round(log2(FreqRange(2)/FreqRange(1))/dj);
    s0 = 1./(fourier_factor*FreqRange(2)); 
    s = s0*2.^((0:J)*dj);   
    f = 1./(fourier_factor*s); 
    f =flipud(f(:));%reverse the order in f
    s =flipud(s(:));% and s accordingly to start at low freq.
    nFBins = length(f);
else
    % if freq. scaling is passed
    f = FreqRange;
    nFBins = length(FreqRange);
    s = 1./(fourier_factor*f); 
end
p = fourier_factor*s;