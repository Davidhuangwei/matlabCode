

cd /BEEF02/smm/sm9608_Analysis/analysis02
CalcRunningSpectra8('noExp',[LoadVar('AlterFiles.mat'); LoadVar('ForceFiles.mat')],'_LinNear.eeg',97,626,1,[6 12],[65 100]);
CalcRunningSpectra8('noExp',[LoadVar('AlterFiles.mat'); LoadVar('ForceFiles.mat')],'_LinNearCSD121.csd',72,626,1,[6 12],[65 100]);

cd /BEEF02/smm/sm9614_Analysis/analysis02
CalcRunningSpectra8('noExp',[LoadVar('AlterFiles.mat'); LoadVar('ZMazeFiles.mat')],'_LinNear.eeg',97,626,1,[6 12],[65 100]);
CalcRunningSpectra8('noExp',[LoadVar('AlterFiles.mat'); LoadVar('ZMazeFiles.mat')],'_LinNearCSD121.csd',72,626,1,[6 12],[65 100]);


