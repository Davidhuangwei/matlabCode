
fileBaseCell = LoadVar('FileInfo/AlterFiles')
 eegNChan = load(['ChanInfo/NChan.eeg.txt'])
eegTrigChan = LoadVar('ChanInfo/SelChan.eeg.mat');eegTrigChan = eegTrigChan.lm
filtFreqRange = [6 12]
maxFreq = 15
fileExt = '.eeg' 
nChan = load(['ChanInfo/NChan' fileExt '.txt'])
[chanMat,badChans,peakTrigBool,trialTypesBool,mazeRegionsBool,plotBool]

saveBaseName = 'Corr_CA';
TroughTrigSegs(saveBaseName,fileBaseCell,eegNChan,eegTrigChan,filtFreqRange,maxFreq,fileExt,nChan,...
    [],[],[],[1 0 1 0 0 0 0 0 0 0 0 0  0],[0 0 0 0 1 0 0 0 0]);

saveBaseName = 'Corr_RA';
TroughTrigSegs(saveBaseName,fileBaseCell,eegNChan,eegTrigChan,filtFreqRange,maxFreq,fileExt,nChan,...
    [],[],[],[1 0 1 0 0 0 0 0 0 0 0 0  0],[0 0 0 0 0 0 0 1 1]);


fileExt = '_LinNearCSD121.csd'
nChan = load(['ChanInfo/NChan' fileExt '.txt'])

saveBaseName = 'Corr_CA';
TroughTrigSegs(saveBaseName,fileBaseCell,eegNChan,eegTrigChan,filtFreqRange,maxFreq,fileExt,nChan,...
    [],[],[],[1 0 1 0 0 0 0 0 0 0 0 0  0],[0 0 0 0 1 0 0 0 0]);

saveBaseName = 'Corr_RA';
TroughTrigSegs(saveBaseName,fileBaseCell,eegNChan,eegTrigChan,filtFreqRange,maxFreq,fileExt,nChan,...
    [],[],[],[1 0 1 0 0 0 0 0 0 0 0 0  0],[0 0 0 0 0 0 0 1 1]);

fileExt = '_NearAveCSD1.csd'
nChan = load(['ChanInfo/NChan' fileExt '.txt'])

saveBaseName = 'Corr_CA';
TroughTrigSegs(saveBaseName,fileBaseCell,eegNChan,eegTrigChan,filtFreqRange,maxFreq,fileExt,nChan,...
    [],[],[],[1 0 1 0 0 0 0 0 0 0 0 0  0],[0 0 0 0 1 0 0 0 0]);

saveBaseName = 'Corr_RA';
TroughTrigSegs(saveBaseName,fileBaseCell,eegNChan,eegTrigChan,filtFreqRange,maxFreq,fileExt,nChan,...
    [],[],[],[1 0 1 0 0 0 0 0 0 0 0 0  0],[0 0 0 0 0 0 0 1 1]);


PlotTrigSegs(alterFiles,'TroughTrigSegs_Corr_CA_freq6-12_maxFreq30','_LinNearCSD121.csd','.eeg',1,[],[-500 500]);
PlotTrigSegs(alterFiles,'TroughTrigSegs_Corr_RA_freq6-12_maxFreq30','_LinNearCSD121.csd','.eeg',2,[],[-500 500]);

PlotTrigSegs(alterFiles,'TroughTrigSegs_Corr_CA_freq6-12_maxFreq30','_LinNearCSD121.csd','_LinNearCSD121.csd',1,[],[-500 500]);
PlotTrigSegs(alterFiles,'TroughTrigSegs_Corr_RA_freq6-12_maxFreq30','_LinNearCSD121.csd','_LinNearCSD121.csd',2,[],[-500 500]);

PlotTrigSegs(alterFiles,'TroughTrigSegs_Corr_CA_freq6-12_maxFreq30','_NearAveCSD1.csd','_NearAveCSD1.csd',1,[],[-100 100]);
PlotTrigSegs(alterFiles,'TroughTrigSegs_Corr_RA_freq6-12_maxFreq30','_NearAveCSD1.csd','_NearAveCSD1.csd',2,[],[-100 100]);

