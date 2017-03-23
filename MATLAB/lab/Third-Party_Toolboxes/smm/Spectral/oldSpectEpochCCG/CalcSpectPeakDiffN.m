function CalcSpectPeakDiffN(fileBaseCell,fileExt,spectAnalBase,varargin)
[filtFreqRange maxFreq chans diffN] = DefaultArgs(varargin,{[4 25],14,...
    [1:load(['ChanInfo/nChan' fileExt '.txt'])],2});

dt2 = [];
clu = [];
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};
    time = LoadVar([fileBase '/' spectAnalBase fileExt '/time.mat']);
    inBase = [fileBase '_Peak' ...
        num2str(filtFreqRange(1)) '-' num2str(filtFreqRange(1)) 'Hz'...
        '_Max' num2str(maxFreq) fileExt];
    
    if length(time)
        epochs = Times2Epochs(time - timeWin/2,timeWin);
    else
        epochs = [0 0];
    end
    [catRes catClu] = LoadResClu([fileBase '/' inBase],chans,epochs);
    for c=chans
        dtN = cat(1,dt2,diff(catRes(catClu==c),diffN,1));
        clu = cat(1,clu,repmat(c,[sum(catClu==c)-2 1]));
    end
end

