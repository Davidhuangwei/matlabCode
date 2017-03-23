 spectAnalDir = [spectAnalBaseCell{1} fileExtCell{1}]


cd /BEEF01/smm/sm9603_Analysis/3-21-04/analysis/
 cd /BEEF01/smm/sm9603_Analysis/3-20-04/analysis/
%PlotPeakTrigAveStd(spectAnalDir,analRoutine{1},[4 35],15,0.3,'_LinNearCSD121.csd',1,[-2000 2000],[])
PlotPeakTrigAveStd(spectAnalDir,analRoutine{1},[4 35],15,0.3,'_LinNearCSD121.csd',1,2000,[-2000 2000],[],'_LinNearCSD121.csd')
PlotPeakTrigAveStd_fig01(spectAnalDir,analRoutine{1},[4 35],15,0.3,'_LinNearCSD121.csd',1,2000,[-2000 2000],[],'_LinNearCSD121.csd')
PlotPeakTrigAveStd_fig01(spectAnalDir,analRoutine{1},[4 35],15,0.3,'_LinNearCSD121.csd',1,2000,[-2000 2000],[],'_6-12Hz_Win0.5_Ave0.5_LinNearCSD121.csd.filt',[],72)

PlotPeakTrigAveStd_fig01(spectAnalDir,analRoutine{1},[4 35],15,0.3,'_LinNearCSD121.csd',1,2000,[-2000 2000],[],'_6-12Hz_Win0.5_Ave0.5_LinNearCSD121.csd.filt',[],72)

dbstop in PlotPeakTrigAveStd at 14
PlotPeakTrigAveStd(spectAnalDir,analRoutine{1},[4 35],15,0.3,'_LinNearCSD121.csd',1,2000,[-2000 2000],[],'_LinNearCSD121.csd')



PlotPeakTrigAveStd(spectAnalDir,analRoutine,filtFreqRange,maxFreq,timeWindow,trigFileExt,varargin)
[reportFigBool,normFactor, colorLimits, selChan, traceExt, colorExt,traceNChan, colorNChan, eegFs, resFs, glmVersion, bps] = ...

  cd /BEEF02/smm/sm9614_Analysis/4-16-05/analysis/
  cd /BEEF02/smm/sm9614_Analysis/4-17-05/analysis/
% PlotPeakTrigAveStd(spectAnalDir,analRoutine{1},[4 35],15,0.3,'_LinNearCSD121.csd',1,[-1000 1000],[])
PlotPeakTrigAveStd(spectAnalDir,analRoutine{1},[4 35],15,0.3,'_LinNearCSD121.csd',1,'./NewFigs/PeakTrigAveStd03/',2000,[-1100 1100],[],'.eeg')
PlotPeakTrigAveStd(spectAnalDir,analRoutine{1},[4 35],15,0.3,'_LinNearCSD121.csd',1,'./NewFigs/PeakTrigAveStd03/',2000,[-1100 1100],[],'_LinNearCSD121.csd')
 
 cd /BEEF01/smm/sm9603_Analysis/3-21-04/analysis/
 PlotUnitTrigAveStd(spectAnalDir,analRoutine{1},0.3,1,[1500],[-1000 1000])
 PlotUnitTrigAveStd(spectAnalDir,analRoutine{1},0.3,1,[2000],[-1000 1000],'_LinNearCSD121.csd')

 PlotUnitTrigAveStd_temp01(spectAnalDir,analRoutine{1},0.3,1,[1500],[-1000 1000])
 PlotUnitTrigAveStd_temp01(spectAnalDir,analRoutine{1},0.3,1,[2000],[-1000 1000],'_LinNearCSD121.csd')

 
 cd /BEEF01/smm/sm9601_Analysis/2-16-04/analysis/
PlotUnitTrigAveStd(spectAnalDir,analRoutine{1},0.3,1,[1500],[-1000 1000])
 PlotUnitTrigAveStd(spectAnalDir,analRoutine{1},0.3,1,[2000],[-1000 1000],'_LinNearCSD121.csd')
 
 
  cd /BEEF02/smm/sm9614_Analysis/4-17-05/analysis/
PlotUnitTrigAveStd(spectAnalDir,analRoutine{1},0.3,1,[1500],[-1000 1000])
 PlotUnitTrigAveStd(spectAnalDir,analRoutine{1},0.3,1,[2000],[-1000 1000],'_LinNearCSD121.csd') 
   
 cd /BEEF02/smm/sm9608_Analysis/7-17-04/analysis/
PlotUnitTrigAveStd(spectAnalDir,analRoutine{1},0.3,1,[1500],[-1000 1000])
 PlotUnitTrigAveStd(spectAnalDir,analRoutine{1},0.3,1,[2000],[-1000 1000],'_LinNearCSD121.csd')

 
 close all
  plotColors = ['rbcym']
chanLoc  = LoadVar(['ChanInfo/ChanLoc_Min' traceExt '.mat'])
  chans = [chanLoc.(selChan{mod(k,2)+1,1}){:}]
 refChan = selChan{k,2}
 for p=1:length(chans)
     figure(p)
     clf
     title(['Ref: ' selChan{k,1}])
     hold on
     plot(squeeze(mean(traceSegs{1}(refChan,:,:),3)),'k')
     for r=1:length(timeNames)
         plot(squeeze(mean(traceSegs{r}(chans(p),:,:),3)),plotColors(r))
         xLimits = get(gca,'xlim');
         yLimits = get(gca,'ylim');
         yLoc = yLimits(1)+(yLimits(2)-yLimits(1))/(length(timeNames)+2)*r;
         text(xLimits(2),yLoc,timeNames(r),'color',plotColors(r))
     end
 end
 ReportFigSM([1:length(chans)],'NewFigs/CA3-CA1PhaseShift/',repmat({['CA3-CA1_Phase_Shift' traceExt]},length(chans),1))

% 
%  close all
%   chanLoc  = LoadVar(['ChanInfo/ChanLoc_Min' traceExt '.mat'])
% %  chans = [chanLoc.ca3Pyr{:}]
%  chans = [chanLoc.ca1Pyr{:}]
%  refChan = selChan{2,2}
%  for p=1:length(chans)
%      figure(p)
%      clf
%      hold on
%   plot(squeeze(mean(traceSegs{1}(refChan,:,:),3)),'k')    
%  plot(squeeze(mean(traceSegs{1}(chans(p),:,:),3)),'r')
%  plot(squeeze(mean(traceSegs{2}(chans(p),:,:),3)),'b')
%  end
%  
% 

for j=1:length(analDirs)
    cd(analDirs{j})
    eval('!cp ChanInfo/ChanLoc_Min_LinNearCSD121.csd.mat ChanInfo/ChanLoc_Min_6-24Hz_Win0.5_Ave0.5_LinNearCSD121.csd.filt.mat')
end
for j=1:length(analDirs)
    cd(analDirs{j})
    eval('!cp ChanInfo/ChanLoc_Min_LinNearCSD121.csd.mat ChanInfo/ChanLoc_Min_6-12Hz_Win0.5_Ave0.5_LinNearCSD121.csd.filt.mat')
end

for j=1:length(analDirs)
    cd(analDirs{j})
    PlotPeakTrigAveStd_fig03(spectAnalDir,analRoutine{1},[6 12],15,0.3,'_LinNearCSD121.csd',1,2000,[-2000 2000],[],'_LinNearCSD121.csd',[],72)
end

for j=1:length(analDirs)
    cd(analDirs{j})
    PlotPeakTrigAveStd_fig03(spectAnalDir,analRoutine{1},[6 36],15,0.3,'_LinNearCSD121.csd',1,2000,[-2000 2000],[],'_6-36Hz_Win0.5_Ave0.5_LinNearCSD121.csd.filt',[],72)
end
for j=1:length(analDirs)
    cd(analDirs{j})
    PlotPeakTrigAveStd_fig03(spectAnalDir,analRoutine{1},[6 24],15,0.3,'_LinNearCSD121.csd',1,2000,[-2000 2000],[],'_6-24Hz_Win0.5_Ave0.5_LinNearCSD121.csd.filt',[],72)
end
for j=1:length(analDirs)
    cd(analDirs{j})
    PlotPeakTrigAveStd_fig03(spectAnalDir,analRoutine{1},[6 12],15,0.3,'_LinNearCSD121.csd',1,2000,[-2000 2000],[],'_6-12Hz_Win0.5_Ave0.5_LinNearCSD121.csd.filt',[],72)
end


for j=1:length(analDirs)
    cd(analDirs{j})
    PlotPeakTrigAveStd_fig03(spectAnalDir,analRoutine{1},[6 12],15,0.3,'_LinNearCSD121.csd',1,2000,[-2000 2000],[],'_6-36Hz_Win0.5_Ave0.5_LinNearCSD121.csd.filt',[],72)
end
for j=1:length(analDirs)
    cd(analDirs{j})
    PlotPeakTrigAveStd_fig03(spectAnalDir,analRoutine{1},[6 12],15,0.3,'_LinNearCSD121.csd',1,2000,[-2000 2000],[],'_6-36Hz_Win0.5_Ave0.5_LinNearCSD121.csd.filt',[],72)
end


for j=1:length(analDirs)
    cd(analDirs{j})
    !cp ChanInfo/ChanLoc_Min_LinNearCSD121.csd.mat ChanInfo/ChanLoc_Min_6-12Hz_Win0.5_Ave0.5_LinNearCSD121.csd.filt.mat 
    FiltRectSmoothDS7(LoadVar('FileInfo/MazeFiles'),'_LinNearCSD121.csd',72,1250,6,12,0.5,0.5,0)
    CalcPeakTrigRes(LoadVar('FileInfo/MazeFiles'),'_LinNearCSD121.csd',[],[],[6 12],15)
    PlotPeakTrigAveStd_fig01(spectAnalDir,analRoutine{1},[6 12],15,0.3,'_LinNearCSD121.csd',1,2000,[-2000 2000],[],'_6-12Hz_Win0.5_Ave0.5_LinNearCSD121.csd.filt',[],72)
end

for j=1:length(analDirs)
    cd(analDirs{j})
    CalcPeakTrigRes(LoadVar('FileInfo/MazeFiles'),'_LinNearCSD121.csd',[],[],[6 24],15)
    PlotPeakTrigAveStd_fig02(spectAnalDir,analRoutine{1},[6 24],15,0.3,'_LinNearCSD121.csd',1,2000,[-2000 2000],[],'_LinNearCSD121.csd',[],72)
end

for j=1:length(analDirs)
    cd(analDirs{j})
    CalcPeakTrigRes(LoadVar('FileInfo/MazeFiles'),'_LinNearCSD121.csd',[],[],[6 36],15)
end

for j=1:length(analDirs)
    cd(analDirs{j})
    FiltRectSmoothDS7(LoadVar('FileInfo/MazeFiles'),'_LinNearCSD121.csd',72,1250,6,24,0.5,0.5,0)
end

for j=1:length(analDirs)
    cd(analDirs{j})
    FiltRectSmoothDS7(LoadVar('FileInfo/MazeFiles'),'_LinNearCSD121.csd',72,1250,6,36,0.5,0.5,0)
end



