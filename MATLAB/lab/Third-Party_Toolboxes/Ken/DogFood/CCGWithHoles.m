% CCGWithHoles(Res, Clu, WhlGood, WhlSamp, BinSize, HalfBins, SampleRate, GSubset, Normalization)
%
% Performs a ccg of spikes with the restriction that only those that occur in times with 
% good camera are found.  WhlGood should be an array of 0 or 1, with 1 indicating good 
% camera.  WhlSamp specifies the sampling rate of this array, relative to the .res file.
% (would be 512 for 20kHz).
%
% why would you want to do this?  because that way you can compare it with the predicted 
% ccg from space
%
% the ccg is normalized by the total amount of time for each lag where 
%
% see CCG, xcorr

function [ccg, t, denom] = CCGWithHoles(Res, Clu, WhlGood, WhlSamp, BinSize, HalfBins, SampleRate, GSubset)

% first restrict to those spike with tracking

ResWhlTm = 1+floor(Res/WhlSamp);
InRange = find(ResWhlTm<=length(WhlGood));
Good = InRange(find(WhlGood(ResWhlTm(InRange))));

% total time available 
TotTime = sum(WhlGood)*WhlSamp/SampleRate; % time in seconds

% make ccg - # counts.  t will be in milliseconds
[ccg0 t] = CCG(Res(Good), Clu(Good), BinSize, HalfBins, SampleRate, GSubset, 'count');

% xcorr of WhlGood gives total time available.
[c lags] = xcorr(WhlGood, ceil(BinSize*HalfBins/WhlSamp));

% interpolate it to ccg time - i did the math and i think linear is right
denom = interp1(lags*WhlSamp/SampleRate*1000, c, t, 'linear') * WhlSamp * BinSize / SampleRate^2;

ccg = ccg0./denom';