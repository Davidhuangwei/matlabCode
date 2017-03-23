function [acg, tr] = ISI2ACG(isi,binsize,nbins,nsums)
% [acg, time] = ISI2ACG(isi,binsize,nbins,nsums)
% computes an ACG from a set of ISIs, under a renewal process model
%
% if isi is in ms, then output will be in Hz.
%
% binsize = size of isi/acg histogram bin (ms)
% nbins = number of bins in output acg (more used in internal calculation)
%   powers of 2 are good since this uses fft.
% nsums: number of successive ISIs to include in calculation 
% default is lowest power of 2 such that meanISI * n > binsize*nbins * 4.
% if its too low, you will see the ACG go down at high values.

if nargin<2
    binsize=4; % bin size in ms
end
if nargin<3
    nbins = 256; % up to 1 s
end

if nargin<4
    Overkill = 4;
    nsums = 2^ceil(log2(binsize*nbins*Overkill/mean(isi)));; % about 30 sec - so you can't go wrong ..
    nsums = max(nsums,1);
end


nBigBins = nbins*nsums;

str = (0:nbins-1)*binsize;
btr = (0:nBigBins-1)*binsize;

if isempty(isi)
    tr = str;
    acg = str*0;
    return;
end


sih = histc(isi,str)./length(isi);
bih = zeros(nBigBins,1); 
bih(1:nbins) = sih;
fih = fft(bih);

s = zeros(nBigBins,1);
for n=1:nsums
    s = s+fih.^n;
end

bigacg = real(ifft(s))/binsize*1000;
acg = bigacg(1:nbins);
tr = str;

% keyboard