function PlotChanLocTools02(reportFigBool)

dayCell = Struct2CellArray(LoadVar('DayStruct.mat'));
days = unique(dayCell(:,2));
for j=1:length(days)
    dayName = days{j}
    alterFiles = LoadVar('AlterFiles');
    sleepFiles = LoadVar('SleepFiles');
    datFiles = LoadVar('DatFiles');
    ppStimFiles = LoadVar('PPStimFiles');
    commStimFiles = LoadVar('CommStimFiles');
    dayCell = Struct2CellArray(LoadVar('DayStruct.mat'));
    day = dayCell(strcmp(dayCell(:,2),dayName),1);
    alterFiles = cell2mat(intersect(alterFiles,day))
    sleepFiles = cell2mat(intersect(sleepFiles,day))
    datFiles = cell2mat(intersect(datFiles,day))
    ppStimFiles = cell2mat(intersect(ppStimFiles,day))
    commStimFiles = cell2mat(intersect(commStimFiles,day))
nextFig = 1;

    try PlotTrigSegs(alterFiles,'TroughTrigSegs_trigCh40_freq6-30_maxFreq15','_LinNearCSD121.csd','.eeg',nextFig,[-2000 2000]); nextFig = nextFig+1; end
    %PlotTrigSegs(alterFiles(2,:),'TroughTrigSegs_trigCh40_freq6-30_maxFreq15','_NearAveCSD1.csd','.eeg',[],[],[],2,[-1000 1000])

    %PlotTrigSegs(ppStimFiles,'StimTrigSegs_PP40V_TrigChan33','_NearAveCSD1.csd','.dat',1,[-3000 3000])
    try PlotTrigSegs(ppStimFiles,'StimTrigSegs_PP40V_TrigChan33','_LinNearCSD121.csd','.dat',nextFig,[-6000 6000]); nextFig = nextFig+1; end
    try PlotTrigSegs(ppStimFiles,'StimTrigSegs_PP40V_TrigChan33','_NearAveCSD1.csd','_NearAveCSD1.csd',nextFig,[-3000 3000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; end
    try PlotTrigSegs(ppStimFiles,'StimTrigSegs_PP40V_TrigChan33','_LinNearCSD121.csd','_LinNearCSD121.csd',nextFig,[-6000 6000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; end

    %PlotTrigSegs(sleepFiles(1,:),'RippTrigSegs_RippTrigChan9_SwTrigChan37','_NearAveCSD1.csd','.eeg',3,[-2000 2000])
    try PlotTrigSegs(sleepFiles,'RippTrigSegs_RippTrigChan9_SwTrigChan37','_LinNearCSD121.csd','.eeg',nextFig,[-4000 4000]); nextFig = nextFig+1; end
    try PlotTrigSegs(sleepFiles,'RippTrigSegs_RippTrigChan9_SwTrigChan37','_NearAveCSD1.csd','_NearAveCSD1.csd',nextFig,[-2000 2000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; end
    try PlotTrigSegs(sleepFiles,'RippTrigSegs_RippTrigChan9_SwTrigChan37','_LinNearCSD121.csd','_LinNearCSD121.csd',nextFig,[-4000 4000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; end

    try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_NearAveCSD1.csd','_LinNearCSD121.csd','.eeg',nextFig,[-2000 1500]); nextFig = nextFig+1; end
    try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_NearAveCSD1.csd','_NearAveCSD1.csd','_NearAveCSD1.csd',nextFig,[-1500 1000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; end
    try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_NearAveCSD1.csd','_LinNearCSD121.csd','_LinNearCSD121.csd',nextFig,[-2000 1500],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; end

    try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_LinNearCSD121.csd','_LinNearCSD121.csd','.eeg',nextFig,[-2000 1500]); nextFig = nextFig+1; end
    try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_LinNearCSD121.csd','_NearAveCSD1.csd','_NearAveCSD1.csd',nextFig,[-1500 1000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; end
    try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_LinNearCSD121.csd','_LinNearCSD121.csd','_LinNearCSD121.csd',nextFig,[-2000 1500],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; end

    try PlotRippPowerDist(sleepFiles,'RippTrigSegs_RippTrigChan9_SwTrigChan37','.eeg',nextFig,[],[36 44]); nextFig = nextFig+1; end
    try PlotRippPowerDist(sleepFiles,'RippTrigSegs_RippTrigChan9_SwTrigChan37','_NearAveCSD1.csd',nextFig,[],[30 42]); nextFig = nextFig+1; end

    try PlotSpikeChanDist(datFiles,'SpikeChanDist',nextFig); nextFig=nextFig+2; end

    %figNums = [1:16];
    if reportFigBool
        ReportFigSM(1:nextFig-1,['NewFigs/ChannelLocalization/'],repmat({['Day_' dayName]},size(figNums)),[10 8],repmat({{'GCFNAME'}},size(figNums)))
    end
end
