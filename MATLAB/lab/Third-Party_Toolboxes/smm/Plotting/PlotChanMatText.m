% function PlotChanMatText(varargin)
% [chanMat figHandles plotParam] = DefaultArgs(varargin,...
%     {LoadVar('ChanInfo/ChanMat.eeg.mat'),gcf,{'color','w'}});
function PlotChanMatText(varargin)
[chanMat] = TryFunc({@LoadVar,'ChanInfo/ChanMat.eeg.mat'});
[chanMat figHandles plotParam] = DefaultArgs(varargin,...
    {chanMat,gcf,{'color','w'}});

for j=1:size(chanMat,1)
    for k=1:size(chanMat,2)
        text(k,j,num2str(chanMat(j,k)),plotParam{:});
    end
end