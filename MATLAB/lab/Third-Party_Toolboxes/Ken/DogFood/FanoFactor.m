function [ff]=FanoFactor(Res,BinSizes, Epochs)
% ff=FanoFactor(Res,BinSizes,Epochs)
%
% computes fano factors for a spike train at a range of timescales given by BinSizes
%
% ff(i) gives Fano factor (variance/mean) spike count for BinSize i (in sample units)
%
% if you specifiy MaxRes, this gives the end of the recording time.  Otherwise, it takes
% the maximum value of Res - which is no good if the cell is silent at the end of
% the recording.

Res = Res(:);
BinSizes = BinSizes(:);
nRes = length(Res);
nSizes = length(BinSizes);

SmallAmount = 0.5; % to make it not include both edges.

if nargin<3, MaxRes = max(Res); end

for bs=1:nSizes
    
    [Starts Bin] = FitEvenlySpacedBins(BinSizes(bs),Epochs, Res);
	
    nBins = length(Starts);
    Good = find(Bin>0);
    if isempty(Good)
        ff(bs) = NaN;
    else
    	SpkCnt = Accumulate(Bin(Good),1,nBins);
    	ff(bs) = var(SpkCnt)/mean(SpkCnt);
    end
    
    if 0
        % display stuff
        fprintf('Bin Size %f\n', BinSizes(bs));
        hold off; hist(SpkCnt,100);
        xr = 0:max(SpkCnt);
        hold on; plot(xr, length(SpkCnt)*poisspdf(xr,mean(SpkCnt)), 'r');
    	pause;
    end
end