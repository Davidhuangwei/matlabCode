% function SpectEpochTrough2Res(fileBaseCell,fileExt,spectAnalBase,varargin)
% [nChan chan filtFreqRange maxFreq eegFs resFs bps] = ...
%     DefaultArgs(varargin,{load(['ChanInfo/NChan' fileExt '.txt']),...
%     [1:load(['ChanInfo/NChan' fileExt '.txt'])],[4 30],15,1250,20000,2});
function SpectEpochTrough2Res(fileBaseCell,fileExt,spectAnalBase,varargin)
[nChan chan filtFreqRange maxFreq eegFs resFs bps] = ...
    DefaultArgs(varargin,{load(['ChanInfo/NChan' fileExt '.txt']),...
    [1:load(['ChanInfo/NChan' fileExt '.txt'])],[4 30],15,1250,20000,2});


for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalBase fileExt '/allEegSegTime'])/eegFs;
    epochs = Times2Epochs(time,median(diff(time)));
    [res clu] = Trough2Res([fileBase '/' fileBase],nChan,chan,...
        fileExt,filtFreqRange,maxFreq,epochs,eegFs,resFs,bps);
    outBase = [fileBase '_Trough' num2str(filtFreqRange(1)) '-' ...
        num2str(filtFreqRange(2)) 'Hz' fileExt];
    fprintf('Saving:\n %s.res\n %s.clu',outBase,outBase);
    msave([fileBase '/' outBase '.res'],res);
    msave([fileBase '/' outBase '.clu'],clu);
end
