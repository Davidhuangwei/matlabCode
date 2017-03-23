function PlotPowSpeedOverlay(controlDir,expDir,fileNamesFile,minSpeed,winLength,NW,lowCut,highCut)

figure(1)
clf
figure(2)
clf

currentDir = pwd;

cd(controlDir);
load(fileNamesFile);
PlotPowSpeed2(alterFiles,minSpeed,winLength,NW,lowCut,highCut,'.','k');

cd(expDir);
load(fileNamesFile);
PlotPowSpeed2(alterFiles,minSpeed,winLength,NW,lowCut,highCut,'.','g');

cd(currentDir)