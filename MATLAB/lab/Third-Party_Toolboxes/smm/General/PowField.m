function [powMap occupancyMap] = PowField(powData,posData,varargin)

[binSize,smoothSize] = DefaultArgs(varargin,{1,4});

posData = ceil(posData/binSize);

goodInd = find(posData(:,1)>0 & posData(:,2)>0);

occupancyMap = Accumulate(posData(goodInd,:));
powMap = Accumulate(posData(goodInd,:),powData(goodInd,1));

occupancyMap = Smooth(occupancyMap,smoothSize);
powMap = Smooth(powMap,smoothSize);
