% function csdData = CSD1D(inData,varargin)
%
%[Channels2Use, SpatialSmoother] = DefaultArgs(varargin, ...
%   {MakeChanCell(6,16), [1 2 1]});
%
% calculates csd for each cell array in Channels2Use and applies spatial
% smoothing according to SpatialSmoother

function csdData = CSD1D(inData,varargin)

[Channels2Use, SpatialSmoother] = DefaultArgs(varargin, ...
    {MakeChanCell(6,16), [1 2 1]});


if iscell(Channels2Use)
    nShanks = length(Channels2Use);
else
    nShanks =1;
    Channels2Use = {Channels2Use};
end


csdData = [];
for s=1:nShanks
    SmoothLoss =(length(SpatialSmoother)-1);
    nCsdChannels = length(Channels2Use{s}) -2 - SmoothLoss ;
    CsdChannels{s}  = Channels2Use{s}(2+SmoothLoss/2:end-1-SmoothLoss/2);
    if length(SpatialSmoother) > 1
        csdData(end+1:end+nCsdChannels,:) = -conv2(SpatialSmoother, 1 , diff(inData(Channels2Use{s},:), 2), 'valid');
    else
        csdData(end+1:end+nCsdChannels,:) = -diff(inData(Channels2Use{s},:),2);
    end
end

return
    
%csdChanMat = MakeChanMat(size(chanMat,2),size(chanMat,1)-2);
%for j=1:size(chanMat,2)
%    channels = chanMat(:,j);
%    csdChannels = csdChanMat(:,j);
%    csdData(csdChannels,:) = -diff(inData(channels,:),2,1);
%end
