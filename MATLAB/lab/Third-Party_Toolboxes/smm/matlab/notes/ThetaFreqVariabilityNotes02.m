% function SpectEpochTroughCCG(fileBaseCell,fileExt,spectAnalBase,winLen,varargin)
% eegSamp = 1250;
% datSamp = eegSamp;
% timeWin = winLen/eegSamp;
% binSize = 20;
% [nChan chan filtFreqRange maxFreq normalization,binSize,halfBins,biasCorrBool bps] = ...
%     DefaultArgs(varargin,{load(['ChanInfo/NChan' fileExt '.txt']),...
%     [1:load(['ChanInfo/NChan' fileExt '.txt'])],[4 30],15,...
%     'count',binSize,floor(1000/2/binSize),1,2});
function SpectEpochTroughCCG(analdirs,analRoutine,fileExt,spectAnalBase,winLen,varargin)
eegSamp = 1250;
datSamp = eegSamp;
timeWin = winLen/eegSamp;
binSize = 10;
[chan filtFreqRange maxFreq statsAnalFunc] = ...
    DefaultArgs(varargin,{...
    [],[4 25],15,'GlmWholeModel08'});

prevWarnSettings = SetWarnings({'off','MATLAB:divideByZero'});

spectAnalDir = [spectAnalBase fileExt '/'];
%bps = 2;
%nChan = load('ChanInfo/NChan.eeg.txt');
%chanLoc = LoadVar('ChanInfo/ChanLoc_Full.eeg.mat');

% troughCCG.infoStruct.eegSamp = eegSamp;
% troughCCG.infoStruct.timeWin = timeWin;
% troughCCG.infoStruct.binSize = binSize;
% troughCCG.infoStruct.halfBins = halfBins;
% troughCCG.infoStruct.winLen = winLen;
% troughCCG.infoStruct.spectAnalBase = spectAnalBase;
% troughCCG.infoStruct.bps = bps;
% troughCCG.infoStruct.chan = chan;
% troughCCG.infoStruct.fileExt = fileExt;
% troughCCG.infoStruct.filtFreqRange = filtFreqRange;
% troughCCG.infoStruct.maxFreq = maxFreq;
% troughCCG.infoStruct.normalization = normalization;
% troughCCG.infoStruct.biasCorrBool = biasCorrBool;
% troughCCG.infoStruct.mfilename = mfilename;
keyboard
cwd = pwd;
for k=1:length(analDirs)
    cd(analdirs{k})
    load(['TrialDesig/' SC(statsAnalFunc) analRoutine])
selChanCell = Struct2CellArray(LoadVar(['ChanInfo/SelChan' fileExt]),[],1);
selChan = [selChanCell{:,2}];
% try
dt2 = [];
chanVec = [];
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};
    timeStruct = LoadDesigVar(fileBase,spectAnalDir,'time',trialDesig);
%     time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    inBase = [fileBase '_Peak' ...
        num2str(filtFreqRange(1)) '-' num2str(filtFreqRange(2)) 'Hz'...
        '_Max' num2str(maxFreq) fileExt];
    timeCell = Struct2CellArray(timeStruct,[],1);
    for m=1:length(timeCell)
        time = timeCell{m,end};
    if length(time)
        epochs = Times2Epochs(time - timeWin/2,timeWin);
    else
        epochs = [0 0];
    end
    [catRes catClu] = LoadResClu([fileBase '/' inBase],selChan,epochs);
    for c=chan
        dt2 = cat(1,dt2,diff(catRes(catClu==c),2,1));
        chanVec = cat(1,chanVec,repmat(c,[sum(catClu==c)-2 1]));
    end
end
end
cd(cwd)


clf
for j=1:length(selChan)
    subplot(length(selChan),1,j)
    [n x] = hist((dt2(chanVec==selChan(j))/eegSamp*1000),-150:300/30:150);
    plot(x,n/sum(chanVec==selChan(j)),'r')
    hold on
    [n x] = hist((runDt2(runChanVec==selChan(j))/eegSamp*1000),-150:300/30:150);
    plot(x,n/sum(runChanVec==selChan(j)),'b')
    set(gca,'ylim',[0 0.25])
end

    hist(1/(dt2(chanVec==40)/eegSamp),50)
    
