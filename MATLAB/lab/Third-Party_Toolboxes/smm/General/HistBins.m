% function bins = HistBins(nBins,binLimits)
% creates bin centers vector for hist function such that area w/in
% bin limits is covered equally by each bin
% bins = [binLimits(1)+diff(binLimits)/nBins/2:...
%     diff(binLimits)/(nBins):...
%     binLimits(2)-diff(binLimits)/nBins/2];
% tag:histogram
% tag:bins
% tag:limits

function bins = HistBins(nBins,binLimits)

bins = [binLimits(1)+diff(binLimits)/nBins/2:...
    diff(binLimits)/(nBins):...
    binLimits(2)-diff(binLimits)/nBins/2];
