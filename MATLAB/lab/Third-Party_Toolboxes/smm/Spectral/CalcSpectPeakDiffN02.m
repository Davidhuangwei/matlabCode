function CalcSpectPeakDiffN(fileExt,spectAnalBase,analRoutine,varargin)
[TrialDesigVersion filtFreqRange maxFreq chans diffN] = DefaultArgs(varargin,...
    {[4 25],14,[1:load(['ChanInfo/nChan' fileExt '.txt'])],2});

load(['TrialDesig/' TrialDesigVersion '/' analRoutine '.mat']);

dt2 = [];
clu = [];

datSamp = 20000;
eegSamp = LoadField([fileBase '/' spectAnalBase fileExt '/infoStruct.eegSamp']);
winLen = LoadField([fileBase '/' spectAnalBase fileExt '/infoStruct.winLen']);
timeWin = winLen/eegSamp;

time = Struct2CellArray(LoadDesigVar(fileBaseCell,...
    [fileBase '/' spectAnalBase fileExt],...
    'time',trialDesig),[],1);
% dtN = time;
% clu = time;
% for j=1:size(time,1)
%     dtN{j,end} = [];
%     clu{j,end} = [];
% end
for j=1:size(time,1)
    for k=1:length(fileBaseCell)
        time = Struct2CellArray(LoadDesigVar(fileBaseCell{k},...
            [fileBase '/' spectAnalBase fileExt],...
            'time',trialDesig),[],1);
        inBase = [fileBase '_Peak' ...
            num2str(filtFreqRange(1)) '-' num2str(filtFreqRange(1)) 'Hz'...
            '_Max' num2str(maxFreq) fileExt];

        if length(time{j,end})
            epochs = Times2Epochs(time{j,end} - timeWin/2,timeWin);
        else
            epochs = [0 0];
        end

        [catRes catClu] = LoadResClu([fileBase '/' inBase],chans,epochs*datSamp);

        for c=chans
            if length(dtN)<j
                dtN{j} = diff(catRes(catClu==c),diffN,1);
                clu{j} = repmat(c,[sum(catClu==c)-2 1]);
            else
                dtN{j} = cat(1,dtN{j},diff(catRes(catClu==c),diffN,1));
                clu{j} = cat(1,clu{j},repmat(c,[sum(catClu==c)-2 1]));
            end
        end
    end
end



for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};
    time = LoadDesigVar(
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
return
%%%
% plot dtN for all dt points
% plot dtN for ave dt w/in a spectral window.