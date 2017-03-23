
remFiles = files with rem periods
CalcRunningSpectra15_noExp_MinSpeed5wavParam6Win1250

allEegSegTime = Epochs2Times(sts.REM)
eegSegTime = Epochs2Times(sts.REM)
time = (Epochs2Times(sts.REM)+winLen/2)/winLen;



files = dir('sm9614*');
allFiles = {files.name}';
remFiles = {};
for j=1:length(allFiles)
    if exist([allFiles{j} '/' allFiles{j} '.sts.REM'],'file')>0
        remFiles = cat(1,remFiles,allFiles(j));
    end
end
eval('!cp FileInfo/RemFiles.mat FileInfo/RemFiles.mat.old.1')
save('FileInfo/RemFiles.mat',SaveAsV6,'remFiles')
remFiles = LoadVar('FileInfo/RemFiles.mat')


description = 'allTimes';
fileBaseCell = remFiles;
fileExt = '_LinNearCSD121.csd';
nChan = 72;
wavParam = 6;
winLength = 1250;
thetaFreqRange = [4 12];
gammaFreqRange = [40 120];
maxNTimes = NaN;
batchModeBool = 1;


saveDir = [ 'CalcRemSpectra06_' description '_wavParam' num2str(wavParam) 'Win' num2str(winLength) fileExt];

infoStruct = [];
infoStruct = setfield(infoStruct,'nChan',nChan);
infoStruct = setfield(infoStruct,'winLength',winLength);
infoStruct = setfield(infoStruct,'wavParam',wavParam);
infoStruct = setfield(infoStruct,'maxNTimes',maxNTimes);
infoStruct = setfield(infoStruct,'fileExt',fileExt);
infoStruct = setfield(infoStruct,'thetaFreqRange',thetaFreqRange);
infoStruct = setfield(infoStruct,'gammaFreqRange',gammaFreqRange);
infoStruct = setfield(infoStruct,'description',description);
infoStruct = setfield(infoStruct,'saveDir',saveDir);

currDir = pwd;
for j=1:length(fileBaseCell)
        c1 = clock;

        figure(j)
        clf
        fileBase = fileBaseCell{j};
        infoStruct = setfield(infoStruct,'fileBase',fileBase);

        if ~exist([fileBase '/' saveDir],'dir')
            mkdir([fileBase '/' saveDir])
        end

        save([fileBase '/' saveDir '/infoStruct.mat'],SaveAsV6,'infoStruct');

        CalcRemSpectraTime02(saveDir,fileBaseCell(j),fileExt,winLength,maxNTimes,batchModeBool)
        
        c2 = clock-c1;
        disp(num2str(c2))
        cd(currDir)
end

fileBaseCell = LoadVar('FileInfo/MazeFiles');
fileBaseCell = LoadVar('FileInfo/RemFiles');
saveDir = ['RemVsRun04_noExp_MinSpeed5wavParam6Win1250' fileExt];
totalTime = 0;
for j=1:length(fileBaseCell)
    length(LoadVar([fileBaseCell{j} '/' saveDir '/time.mat']))
    totalTime = totalTime + length(LoadVar([fileBaseCell{j} '/' saveDir '/time.mat']));
end
totalTime
    
saveDir = 'CalcRunningSpectra14_noExp_MinSpeed5wavParam6Win1250_LinNearCSD121.csd'
fileBaseCell = LoadVar('FileInfo/MazeFiles')
totalTime = 0;
for j=1:length(fileBaseCell)
    totalTime = totalTime + length(LoadVar([fileBaseCell{j} '/' saveDir '/allEegSegTime.mat']));
end
totalTime
eegSamp = 1250;

analDirs = {...
    '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-17-04/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/',...
    };
for k=1:length(analDirs)
    cd(analDirs{k})
    spectAnalDir = 'CalcRunningSpectra15_noExp_MinSpeed5wavParam6Win1250_LinNearCSD121.csd';
    oldSpectAnalDir = 'CalcRunningSpectra14_noExp_MinSpeed5wavParam6Win1250_LinNearCSD121.csd';
    fileBaseCell = LoadVar('FileInfo/MazeFiles');
    for j=1:length(fileBaseCell)
        mkdir([fileBaseCell{j} '/' spectAnalDir])
        allEegSegTime = LoadVar([fileBaseCell{j} '/' oldSpectAnalDir '/allEegSegTime']);
        infoStruct = LoadVar([fileBaseCell{j} '/' oldSpectAnalDir '/infoStruct']);
        keptTime = ones(size(allEegSegTime));
        eegSegTime = allEegSegTime;
        time = (eegSegTime+winLength/2)/eegSamp;
        save([fileBaseCell{j} '/' spectAnalDir '/allEegSegTime'],SaveAsV6,'allEegSegTime');
        save([fileBaseCell{j} '/' spectAnalDir '/infoStruct'],SaveAsV6,'infoStruct');
        save([fileBaseCell{j} '/' spectAnalDir '/keptTime'],SaveAsV6,'keptTime');
        save([fileBaseCell{j} '/' spectAnalDir '/eegSegTime'],SaveAsV6,'eegSegTime');
        save([fileBaseCell{j} '/' spectAnalDir '/time'],SaveAsV6,'time');
    end
end


for k=1:length(analDirs)
    cd(analDirs{k})
    fileBaseCell = LoadVar('FileInfo/MazeFiles');
    for j=1:length(fileBaseCell)
        eval(['!cp ' fileBaseCell{j} '/CalcRunningSpectra15_noExp_MinSpeed5wavParam6Win1250_LinNearCSD121.csd'...
            ' ' fileBaseCell{j} '/CalcRunningSpectra15_noExp_MinSpeed5wavParam6Win1250.eeg -r']);
    end
end
    
for k=1:length(analDirs)
    cd(analDirs{k})
    fileBaseCell = LoadVar('FileInfo/RemFiles');
    for j=1:length(fileBaseCell)
        eval(['!cp ' fileBaseCell{j} '/CalcRemSpectra06_allTimes_wavParam6Win1250_LinNearCSD121.csd'...
            ' ' fileBaseCell{j} '/CalcRemSpectra06_allTimes_wavParam6Win1250.eeg -r']);
    end
end
