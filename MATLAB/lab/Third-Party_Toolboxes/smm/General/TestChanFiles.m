function TestChanFiles(fileExt)

chanInfoDir = 'ChanInfo/';
badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);
chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']);
selChans = load([chanInfoDir 'SelectedChannels' fileExt '.txt']);
offSet = load([chanInfoDir 'OffSet' fileExt '.txt']);

figure(1)
clf
hold on
plotMat1 = Make2DPlotMat(ones(max(max(chanMat)),1),chanMat,badChans);
plotMat1(isnan(plotMat1(:))) = 0;
plotMat2 = Make2DPlotMat(ones(max(max(chanMat)),1),chanMat,selChans);
plotMat2(isnan(plotMat2(:))) = 3;
plotMat = plotMat1 + plotMat2;
imagesc(plotMat);
colorbar;
PlotAnatCurves([chanInfoDir 'AnatCurves.mat'],[16.5 6.5],offSet);

return


mkdir ChanInfo
!mv SelectedChannels* ChanInfo/
!mv AnatCurves.mat* ChanInfo/
!mv BadChan* ChanInfo/
!mv ChanMat* ChanInfo/
!mv OffSet* ChanInfo/

mkdir FileLists
!mv Rem* FileLists/
!mv AlterFiles.mat FileLists/
!mv ZMazeFiles.mat FileLists/
!mv ForceFi* FileLists/
!mv CircleFi* FileLists/
!mv DayStruct.mat FileLists/


