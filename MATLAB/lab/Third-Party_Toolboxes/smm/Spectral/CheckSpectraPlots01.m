function CheckSpectraPlots01(analDirs,varargin)
[fileExts runningSpectAnalBase remSpectAnalBase thetaFreqRange] = DefaultArgs(varargin,{{'.eeg','_LinNearCSD121.csd'},...
    'CalcRunningSpectra11_noExp_MinSpeed0Win1250',...
    'CalcRemSpectra03_allTimes_Win1250',[4 12]});

CheckRunningSpectraPlots01(analDirs,fileExts,runningSpectAnalBase,thetaFreqRange)
CheckRemSpectraPlots01(analDirs,fileExts,remSpectAnalBase,thetaFreqRange)
