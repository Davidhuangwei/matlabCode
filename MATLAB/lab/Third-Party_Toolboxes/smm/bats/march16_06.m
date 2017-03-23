function CalcRunningSpectra6(description,fileBaseMat,fileExt,nChan,winLength,w0,midPointsBool,thetaFreqRange,gammaFreqRange,varargin)

CalcRunningSpectra6('noExp',fileBaseMat,fileExt,nChan,626,8,1,[6 12],[65 100]);


cd /BEEF01/smm/sm9603_Analysis/analysis04
CalcRunningSpectra6('noExp',[LoadVar('AlterFiles.mat'); LoadVar('CircleFiles.mat')],'.eeg',97,626,8,1,[6 12],[65 100]);
CalcRunningSpectra6('noExp',[LoadVar('AlterFiles.mat'); LoadVar('CircleFiles.mat')],'_LinNear.eeg',97,626,8,1,[6 12],[65 100]);
CalcRunningSpectra6('noExp',[LoadVar('AlterFiles.mat'); LoadVar('CircleFiles.mat')],'_LinNearCSD121.csd',72,626,8,1,[6 12],[65 100]);

cd /BEEF01/smm/sm9601_Analysis/analysis03/
CalcRunningSpectra6('noExp',[LoadVar('AlterFiles.mat'); LoadVar('CircleFiles.mat')],'.eeg',81,626,8,1,[6 12],[65 100]);
CalcRunningSpectra6('noExp',[LoadVar('AlterFiles.mat'); LoadVar('CircleFiles.mat')],'_LinNear.eeg',81,626,8,1,[6 12],[65 100]);
CalcRunningSpectra6('noExp',[LoadVar('AlterFiles.mat'); LoadVar('CircleFiles.mat')],'_LinNearCSD121.csd',72,626,8,1,[6 12],[65 100]);



cd /BEEF02/smm/sm9608_Analysis/analysis02
CalcRunningSpectra6('noExp',[LoadVar('AlterFiles.mat'); LoadVar('ForceFiles.mat')],'.eeg',97,626,8,1,[6 12],[65 100]);
CalcRunningSpectra6('noExp',[LoadVar('AlterFiles.mat'); LoadVar('ForceFiles.mat')],'_LinNear.eeg',97,626,8,1,[6 12],[65 100]);
CalcRunningSpectra6('noExp',[LoadVar('AlterFiles.mat'); LoadVar('ForceFiles.mat')],'_LinNearCSD121.csd',72,626,8,1,[6 12],[65 100]);

cd /BEEF02/smm/sm9614_Analysis/analysis02
CalcRunningSpectra6('noExp',[LoadVar('AlterFiles.mat'); LoadVar('ZMazeFiles.mat')],'.eeg',97,626,8,1,[6 12],[65 100]);
CalcRunningSpectra6('noExp',[LoadVar('AlterFiles.mat'); LoadVar('ZMazeFiles.mat')],'_LinNear.eeg',97,626,8,1,[6 12],[65 100]);
CalcRunningSpectra6('noExp',[LoadVar('AlterFiles.mat'); LoadVar('ZMazeFiles.mat')],'_LinNearCSD121.csd',72,626,8,1,[6 12],[65 100]);
