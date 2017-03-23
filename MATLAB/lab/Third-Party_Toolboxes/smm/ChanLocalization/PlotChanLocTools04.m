function PlotChanLocTools04(reportFigBool)

fileInfoDir = 'FileInfo/';
    if exist([fileInfoDir 'AlterFiles.mat'],'file'),
        alterFiles = LoadVar([fileInfoDir 'AlterFiles.mat']);
    end
    if exist([fileInfoDir 'SleepFiles.mat'],'file'),
        sleepFiles = LoadVar([fileInfoDir 'SleepFiles']);
    end
    if exist([fileInfoDir 'DatFiles.mat'],'file'),
        datFiles = LoadVar([fileInfoDir 'DatFiles']);
    end
    if exist([fileInfoDir 'PPStimFiles.mat'],'file'),
        ppStimFiles = LoadVar([fileInfoDir 'PPStimFiles']);
    end
    if exist([fileInfoDir 'CommStimFiles.mat'],'file'),
        commStimFiles = LoadVar([fileInfoDir 'CommStimFiles']);
    end
    stimVs = [30 40 60 100];
    %stimVs = [100];
    nextFig = 1;

     PlotTrigSegs(alterFiles,'TroughTrigSegs_freq6-30_maxFreq15','_LinNearCSD121.csd','.eeg',nextFig,[],[-2000 2000]); nextFig = nextFig+1;% catch ErrorScript(lasterror); end
    %PlotTrigSegs(alterFiles(2,:),'TroughTrigSegs_trigCh40_freq6-30_maxFreq15','_NearAveCSD1.csd','.eeg',[],[],[],2,[-1000 1000])

    %PlotTrigSegs(ppStimFiles,'StimTrigSegs_PP40V_TrigChan33','_NearAveCSD1.csd','.dat',1,[-3000 3000])
    for k=1:length(stimVs)
        try PlotTrigSegs(ppStimFiles,['StimTrigSegs_PP' num2str(stimVs(k)) 'V'],'_LinNearCSD121.csd','.dat',nextFig,[],[-6000 6000]); nextFig = nextFig+1; catch ErrorScript(lasterror); end
        try PlotTrigSegs(ppStimFiles,['StimTrigSegs_PP' num2str(stimVs(k)) 'V'],'_NearAveCSD1.csd','_NearAveCSD1.csd',nextFig,[],[-3500 3500],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end
        try PlotTrigSegs(ppStimFiles,['StimTrigSegs_PP' num2str(stimVs(k)) 'V'],'_LinNearCSD121.csd','_LinNearCSD121.csd',nextFig,[],[-6000 6000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end
        try PlotTrigSegs(commStimFiles,['StimTrigSegs_COMM' num2str(stimVs(k)) 'V'],'_LinNearCSD121.csd','.dat',nextFig,[],[-6000 6000]); nextFig = nextFig+1; catch ErrorScript(lasterror); end
        try PlotTrigSegs(commStimFiles,['StimTrigSegs_COMM' num2str(stimVs(k)) 'V'],'_NearAveCSD1.csd','_NearAveCSD1.csd',nextFig,[],[-10000 10000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end
        try PlotTrigSegs(commStimFiles,['StimTrigSegs_COMM' num2str(stimVs(k)) 'V'],'_LinNearCSD121.csd','_LinNearCSD121.csd',nextFig,[],[-12000 12000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end
    end
    
    %PlotTrigSegs(sleepFiles(1,:),'RippTrigSegs_RippTrigChan9_SwTrigChan37','_NearAveCSD1.csd','.eeg',3,[-2000 2000])
    try PlotTrigSegs(sleepFiles,'RippTrigSegs','_LinNearCSD121.csd','.eeg',nextFig,[],[-4000 4000]); nextFig = nextFig+1; catch ErrorScript(lasterror); end
    try PlotTrigSegs(sleepFiles,'RippTrigSegs','_NearAveCSD1.csd','_NearAveCSD1.csd',nextFig,[],[-2000 2000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end
    try PlotTrigSegs(sleepFiles,'RippTrigSegs','_LinNearCSD121.csd','_LinNearCSD121.csd',nextFig,[],[-4000 4000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end

    try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_NearAveCSD1.csd','_LinNearCSD121.csd','.eeg',nextFig,[],[-2000 1500]); nextFig = nextFig+1; catch ErrorScript(lasterror); end
    try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_NearAveCSD1.csd','_NearAveCSD1.csd','_NearAveCSD1.csd',nextFig,[],[-1500 1000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end
    try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_NearAveCSD1.csd','_LinNearCSD121.csd','_LinNearCSD121.csd',nextFig,[],[-2000 1500],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end

    try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_LinNearCSD121.csd','_LinNearCSD121.csd','.eeg',nextFig,[],[-2000 1500]); nextFig = nextFig+1; catch ErrorScript(lasterror); end
    try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_LinNearCSD121.csd','_NearAveCSD1.csd','_NearAveCSD1.csd',nextFig,[],[-1500 1000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end
    try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_LinNearCSD121.csd','_LinNearCSD121.csd','_LinNearCSD121.csd',nextFig,[],[-2000 1500],[],[],LoadVar('ChanInfo/ChanMat.eeg')); nextFig = nextFig+1; catch ErrorScript(lasterror); end

    try PlotRippPowerDist(sleepFiles,'RippTrigSegs','.eeg',nextFig,[],[],[34 45]); nextFig = nextFig+1; catch ErrorScript(lasterror); end
    try PlotRippPowerDist(sleepFiles,'RippTrigSegs','_NearAveCSD1.csd',nextFig,[],[],[34 45]); nextFig = nextFig+1; catch ErrorScript(lasterror); end

    try PlotSpikeChanDist(datFiles,'SpikeChanDist',nextFig,[]); nextFig=nextFig+2; catch ErrorScript(lasterror); end

    figNums = 1:nextFig-1;
    if reportFigBool & ~isempty(figNums)
        ReportFigSM(figNums,['NewFigs/ChannelLocalization/'],repmat({date},size(figNums)),[10 8],repmat({{'GCFNAME'}},size(figNums)))
    end
return

function ErrorScript(lastError1)

fprintf(['\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ' ...
    lastError1.message ...
    ' \n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n']);
return
