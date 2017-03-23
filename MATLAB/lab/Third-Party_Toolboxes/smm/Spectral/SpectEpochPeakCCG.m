% function SpectEpochPeakCCG(fileBaseCell,fileExt,spectAnalBase,winLen,varargin)
% eegSamp = 1250;
% datSamp = eegSamp;
% timeWin = winLen/eegSamp;
% binSize = 20;
% [nChan chan filtFreqRange maxFreq normalization,binSize,halfBins,biasCorrBool bps] = ...
%     DefaultArgs(varargin,{load(['ChanInfo/NChan' fileExt '.txt']),...
%     [1:load(['ChanInfo/NChan' fileExt '.txt'])],[4 25],14,...
%     'count',binSize,floor(1000/2/binSize),1,2});
function SpectEpochPeakCCG(fileBaseCell,fileExt,spectAnalBase,winLen,varargin)
eegSamp = 1250;
datSamp = 20000;
timeWin = winLen/eegSamp;
binSize = 10;
[nChan chan filtFreqRange maxFreq normalization,binSize,halfBins,biasCorrBool bps] = ...
    DefaultArgs(varargin,{load(['ChanInfo/NChan' fileExt '.txt']),...
    [1:load(['ChanInfo/NChan' fileExt '.txt'])],[4 12],14,...
    'count',binSize,floor(1000/2/binSize),1,2});

prevWarnSettings = SetWarnings({'off','MATLAB:divideByZero'});

spectAnalDir = [spectAnalBase fileExt '/'];
%bps = 2;
%nChan = load('ChanInfo/NChan.eeg.txt');
%chanLoc = LoadVar('ChanInfo/ChanLoc_Full.eeg.mat');

peakCCG.infoStruct.eegSamp = eegSamp;
peakCCG.infoStruct.timeWin = timeWin;
peakCCG.infoStruct.binSize = binSize;
peakCCG.infoStruct.halfBins = halfBins;
peakCCG.infoStruct.winLen = winLen;
peakCCG.infoStruct.spectAnalBase = spectAnalBase;
peakCCG.infoStruct.bps = bps;
peakCCG.infoStruct.nChan = nChan;
peakCCG.infoStruct.chan = chan;
peakCCG.infoStruct.fileExt = fileExt;
peakCCG.infoStruct.filtFreqRange = filtFreqRange;
peakCCG.infoStruct.maxFreq = maxFreq;
peakCCG.infoStruct.normalization = normalization;
peakCCG.infoStruct.biasCorrBool = biasCorrBool;
peakCCG.infoStruct.mfilename = mfilename;


% try
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};
    time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    
%     if length(time)
%         epochs = Times2Epochs(time - timeWin/2,timeWin);
%     else
%         epochs = [0 0];
%     end
    inBase = [fileBase '_Peak' num2str(filtFreqRange(1)) '-' ...
        num2str(filtFreqRange(2)) 'Hz_Max' num2str(maxFreq) fileExt];
    
    catRes = load([fileBase '/' inBase '.res']);
    catClu = load([fileBase '/' inBase '.clu']);
    catClu = catClu(2:end);
%     
%     [catRes catClu] = Peak2Res([fileBase '/' fileBase],nChan,chan,...
%         fileExt,filtFreqRange,maxFreq,epochs,eegSamp,datSamp,bps);

    gSubset = unique(catClu);
    
    trialEpochs = [time-timeWin/2 time+timeWin/2]*datSamp;
    [peakCCG.yo peakCCG.to peakRate] = TrialCCG(catRes,catClu,...
    round(binSize*datSamp/1000),halfBins,...
                datSamp,gSubset,normalization,...
                trialEpochs,biasCorrBool);
    if biasCorrBool
        bcText = 'BC';
    else
        bcText = '';
    end
    save([fileBase '/' SC(spectAnalDir) 'peakCCG' ...
        num2str(filtFreqRange(1)) '-' num2str(filtFreqRange(2)) 'HzMaxF' num2str(maxFreq) ....
        'Bin' num2str(binSize) normalization bcText '.mat'],SaveAsV6,'peakCCG');
    save([fileBase '/' SC(spectAnalDir) 'peakRate' ...
        num2str(filtFreqRange(1)) '-' num2str(filtFreqRange(2)) 'HzMaxF' ...
        num2str(maxFreq) '.mat'],SaveAsV6,'peakRate');
end
% catch
%     junk = lasterror
%     %junk.stack
%     keyboard
% end

SetWarnings(prevWarnSettings);