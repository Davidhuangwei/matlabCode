function PlotPowSpeedOverlay(controlDir,expDir,fileNamesFile,winLength,NW,lowCut,highCut)

figure(1)
clf
figure(2)
clf

cd(controlDir);
load(fileNamesFile);
PlotPowSpeed(alterFiles,winLength,NW,lowCut,highCut,'k');


cd(expDir);
load(fileNamesFile);
PlotPowSpeed(alterFiles,winLength,NW,lowCut,highCut,'g');
