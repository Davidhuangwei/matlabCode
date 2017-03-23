function PlotChanLocTools03(reportFigBool)

dayCell = Struct2CellArray(LoadVar('DayStruct.mat'));
days = unique(dayCell(:,2));
for j=1:length(days)
    dayName = days{j}
    dayCell = Struct2CellArray(LoadVar('DayStruct.mat'));
    day = dayCell(strcmp(dayCell(:,2),dayName),1);
    if exist('AlterFiles.mat','file'),
        alterFiles = LoadVar('AlterFiles');
        alterFiles = cell2mat(intersect(alterFiles,day))
    end
    if exist('SleepFiles.mat','file'),
        sleepFiles = LoadVar('SleepFiles');
        sleepFiles = cell2mat(intersect(sleepFiles,day))
    end
    if exist('DatFiles.mat','file'),
        datFiles = LoadVar('DatFiles');
        datFiles = cell2mat(intersect(datFiles,day))
    end
    if exist('PPStimFiles.mat','file'),
        ppStimFiles = LoadVar('PPStimFiles');
        ppStimFiles = cell2mat(intersect(ppStimFiles,day))
    end
    if exist('CommStimFiles.mat','file'),
        commStimFiles = LoadVar('CommStimFiles');
        commStimFiles = cell2mat(intersect(commStimFiles,day))
    end
    stimVs = [30 40 100];
    %stimVs = [100];
    nextFig = 1;

    try PlotTrigSegs(alterFiles,'TroughTrigSegs_freq6-30_maxFreq15','_LinNearCSD121.csd','.eeg',nextFig,[-2000 2000]); nextFig = nextFig+1; catch ErrorScript(lasterror); end
    %PlotTrigSegs(alterFiles(2,:),'TroughTrigSegs_trigCh40_freq6-30_maxFreq15','_NearAveCSD1.csd','.eeg',[],[],[],2,[-1000 1000])

    %PlotTrigSegs(ppStimFiles,'StimTrigSegs_PP40V_TrigChan33','_NearAveCSD1.csd','.dat',1,[-3000 3000])
    for k=1:length(stimVs)
        try PlotTrigSegs(ppStimFiles,['StimTrigSegs_PP' num2str(stimVs(k)) 'V'],'_LinNearCSD121.csd','.dat',nextFig,[-6000 6000]); nextFig = nextFig+1; catch ErrorScript(lasterror); end
        try PlotTrigSegs(ppStimFiles,['StimTrigSegs_PP' num2str(stimVs(k)) 'V'],'_NearAveCSD1.csd','_NearAveCSD1.csd',nextFig,[-3000 3000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end
        try PlotTrigSegs(ppStimFiles,['StimTrigSegs_PP' num2str(stimVs(k)) 'V'],'_LinNearCSD121.csd','_LinNearCSD121.csd',nextFig,[-6000 6000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end
        try PlotTrigSegs(commStimFiles,['StimTrigSegs_COMM' num2str(stimVs(k)) 'V'],'_LinNearCSD121.csd','.dat',nextFig,[-6000 6000]); nextFig = nextFig+1; catch ErrorScript(lasterror); end
        try PlotTrigSegs(commStimFiles,['StimTrigSegs_COMM' num2str(stimVs(k)) 'V'],'_NearAveCSD1.csd','_NearAveCSD1.csd',nextFig,[-3000 3000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end
        try PlotTrigSegs(commStimFiles,['StimTrigSegs_COMM' num2str(stimVs(k)) 'V'],'_LinNearCSD121.csd','_LinNearCSD121.csd',nextFig,[-6000 6000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end
    end
    
    %PlotTrigSegs(sleepFiles(1,:),'RippTrigSegs_RippTrigChan9_SwTrigChan37','_NearAveCSD1.csd','.eeg',3,[-2000 2000])
    try PlotTrigSegs(sleepFiles,'RippTrigSegs','_LinNearCSD121.csd','.eeg',nextFig,[-4000 4000]); nextFig = nextFig+1; catch ErrorScript(lasterror); end
    try PlotTrigSegs(sleepFiles,'RippTrigSegs','_NearAveCSD1.csd','_NearAveCSD1.csd',nextFig,[-2000 2000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end
    try PlotTrigSegs(sleepFiles,'RippTrigSegs','_LinNearCSD121.csd','_LinNearCSD121.csd',nextFig,[-4000 4000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end

    try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_NearAveCSD1.csd','_LinNearCSD121.csd','.eeg',nextFig,[-2000 1500]); nextFig = nextFig+1; catch ErrorScript(lasterror); end
    try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_NearAveCSD1.csd','_NearAveCSD1.csd','_NearAveCSD1.csd',nextFig,[-1500 1000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end
    try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_NearAveCSD1.csd','_LinNearCSD121.csd','_LinNearCSD121.csd',nextFig,[-2000 1500],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end

    try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_LinNearCSD121.csd','_LinNearCSD121.csd','.eeg',nextFig,[-2000 1500]); nextFig = nextFig+1; catch ErrorScript(lasterror); end
    try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_LinNearCSD121.csd','_NearAveCSD1.csd','_NearAveCSD1.csd',nextFig,[-1500 1000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end
    try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_LinNearCSD121.csd','_LinNearCSD121.csd','_LinNearCSD121.csd',nextFig,[-2000 1500],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end

    try PlotRippPowerDist(sleepFiles,'RippTrigSegs','.eeg',nextFig,[],[]); nextFig = nextFig+1; catch ErrorScript(lasterror); end
    try PlotRippPowerDist(sleepFiles,'RippTrigSegs','_NearAveCSD1.csd',nextFig,[],[]); nextFig = nextFig+1; catch ErrorScript(lasterror); end

    try PlotSpikeChanDist(datFiles,'SpikeChanDist',nextFig); nextFig=nextFig+2; catch ErrorScript(lasterror); end

    figNums = 1:nextFig-1
    if reportFigBool & ~isempty(figNums)
        ReportFigSM(figNums,['NewFigs/ChannelLocalization/'],repmat({['Day_' dayName]},size(figNums)),[10 8],repmat({{'GCFNAME'}},size(figNums)))
    end
end
return

function ErrorScript(lastError1)

fprintf(['\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ' ...
    lastError1.message ...
    ' \n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n']);
return
