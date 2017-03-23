%[nBlocks, BlockSize] = WaveletTimeSplit(x,Fs,FreqRange,IsLogSc, MemPart)
% computes the number of blocks to split the signal
% according to existing memory to use about MemPart 
% (from 0 to 1) of freemem , default is 0.5
function [nBlocks, BlockSize] = WaveletTimeSplit(x,varargin)

[Fs,FreqRange,IsLogSc,MemPart] = DefaultArgs(varargin, {1250,[1 200],1, 0.1});
w0=6; % fixed default for now
nChannels = size(x,2);
nTime = size(x,1);
[f,s,p] = WaveletSampling(Fs,FreqRange,IsLogSc, w0);
nFBins = length(f);
% is will use more than 80% of available memory -split
avmemory = FreeMemory*1000;

if (2*nChannels*nTime*nFBins*16 > MemPart*avmemory)
    % find a block size that is power of 2, n=2^m
    BlockSize = 2^floor(log2(MemPart*avmemory/(2*16*nFBins*nChannels)));
    nBlocks = ceil(nTime/BlockSize);
else
    nBlocks =1;
    BlockSize = nTime;
end
    
    

