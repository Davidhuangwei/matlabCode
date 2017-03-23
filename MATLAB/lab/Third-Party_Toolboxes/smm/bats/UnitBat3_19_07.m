analDirs = {...
    '/BEEF01/smm/sm9601_Analysis/2-16-04/analysis/',...
    '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-17-04/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/',...
    }

for j=1:length(analDirs)
    cd(analDirs{j})
    fileBaseCell = [LoadVar('FileInfo/MazeFiles');LoadVar('FileInfo/RemFiles')];
    SumUnitCCGTimeLim01(fileBaseCell,...
        'RemVsRun03_noExp_MinSpeed5wavParam6Win1250.eeg/',250,'scale',3)
    SumUnitCCGTimeLim01(fileBaseCell,...
        'RemVsRun03_noExp_MinSpeed5wavParam6Win1250.eeg/',25,'scale',3)
    SumUnitCCGTimeLim01(fileBaseCell,...
        'RemVsRun03_noExp_MinSpeed5wavParam6Win1250.eeg/',8,'scale',3)
end
for j=1:length(analDirs)
    cd(analDirs{j})
    fileBaseCell = [LoadVar('FileInfo/MazeFiles');LoadVar('FileInfo/RemFiles')];
    MeanUnitCCGTimeLim01(fileBaseCell,...
        'RemVsRun03_noExp_MinSpeed5wavParam6Win1250.eeg/',250,'scale',3)
    MeanUnitCCGTimeLim01(fileBaseCell,...
        'RemVsRun03_noExp_MinSpeed5wavParam6Win1250.eeg/',25,'scale',3)
    MeanUnitCCGTimeLim01(fileBaseCell,...
        'RemVsRun03_noExp_MinSpeed5wavParam6Win1250.eeg/',8,'scale',3)
end

analRoutine = {'PhasicVsTonicVsMaze_MolSD2'}
timeLim = 200;
spectAnalDir = 'RemVsRun07_noExp_MinSpeed5wavParam6Win1250.eeg';
statsAnalFunc = 'GlmWholeModel08';
normalizationCell = {...
    'count',...
    'scale',...
    }
binSizeCell = {...
    4,...
    8,...
    }
biasCorrBool = 1;
rateMin = 0.05;
timeRangeCell = {...
    [-8 8],...
    [-25 25],...
    [-250 250]...
    }
% freqRange = [4 12];
% freqRangeName = 'theta';
saveDir = '/u12/smm/public_html/NewFigs/REMPaper/UnitAnal06/';
for m=1:length(analRoutine)
    PlotUnitRatesScat06(analDirs,spectAnalDir,statsAnalFunc,analRoutine{m},1,saveDir)
    for j=1:length(normalizationCell)
        for k=1:length(binSizeCell)
            PlotUnitCCG05(analDirs,spectAnalDir,statsAnalFunc,...
                analRoutine{m},normalizationCell{j},binSizeCell{k},timeLim,...
                biasCorrBool,rateMin,timeRangeCell,1,saveDir)
        end
    end
    %     PlotUnitCCGTimeLimScat02(analDirs,spectAnalDir,statsAnalFunc,...
    %         analRoutine{m},timeLim,normalization,binSize)
    %     PlotUnitCCGFreqRangeScat01(analDirs,spectAnalDir,statsAnalFunc,...
    %         analRoutine{m},freqRange,freqRangeName,normalization,binSize)
end

for n=1:length(spectAnalBase)
    for m=1:length(analRoutine)
        for j=1:length(fileExtCell)
            for k=1:length(analDirs)
                cd(analDirs{k})
%                  try
                    GlmWholeAnalysisBatch08(spectAnalBase{n},analRoutine{m},'01',fileExtCell{j},depVarCell)
%                     GlmWholeAnalysisBatch07('RemVsRun01_noExp',analRoutine{m},'01',fileExtCell{j},depVarCell,[],0,0,1250,1)
%                  catch
%                      ReportError(['ERROR:  ' date '  GLMbat02bat  ' analDirs{k}  spectAnalBase{n}  fileExtCell{j} '  ' analRoutine{m} '\n']);
%                  end
             end
        end
    end
end

analRoutine = {'PhasicVsTonicVsMaze_MolSD2'}
spectAnalBase = 'RemVsRun07_noExp_MinSpeed5wavParam6Win1250';
fileExtCell = {...
    '.eeg',...
    '_LinNearCSD121.csd',...
    }
cellRateMin = 7;
trialRateMin = 5;
% cellRateMin = 5;
% trialRateMin = 4;
freqLim = 200;
nTapersCell = {...
    5,...
    19,...
    }
statsAnalFunc = 'GlmWholeModel08';
cohName = 'orig';
saveDir = '/u12/smm/public_html/NewFigs/REMPaper/UnitAnal06/';
% cohName = '';
freqRangeCell = {...
    [4 12],...
    [40 120],...
    }
for j=1:length(nTapersCell)
    for k=1:length(fileExtCell)
        for m=1:length(analRoutine)
            PlotUnitFieldCoh07(analDirs,fileExtCell{k},[spectAnalBase fileExtCell{k}],statsAnalFunc,...
                analRoutine{m},freqLim,trialRateMin,cellRateMin,cohName,nTapersCell{j},freqRangeCell,1,saveDir)

%                 PlotUnitFieldPhase04(analDirs,fileExtCell{k},[spectAnalBase fileExtCell{k}],statsAnalFunc,...
%                     analRoutine{m},freqLim,trialRateMin,cellRateMin,nTapersCell{j},freqRangeCell,1,saveDir)
        end
    end
end

analRoutine = {'PhasicVsTonicVsMaze_MolSD2'}
spectAnalDir = 'RemVsRun07_noExp_MinSpeed5wavParam6Win1250.eeg/';
% analRoutine = 'RemVsMaze_Beh'
statsAnalFunc = 'GlmWholeModel08';
freqLim = 200;
cellRateMin = 7;
trialRateMin = 5;
% cellRateMin = 5;
% trialRateMin = 4;
% rateMin = 0.05;
nTapersCell = {...
    5,...
    19,...
    }
freqRangeCell = {...
    [4 12],...
    [40 120],...
    }
saveDir = '/u12/smm/public_html/NewFigs/REMPaper/UnitAnal06/';
for j=1:length(nTapersCell)
    for m=1:length(analRoutine)
        PlotUnitSpectrum05(analDirs,spectAnalDir,statsAnalFunc,...
            analRoutine{m},trialRateMin,cellRateMin,nTapersCell{j},...
            freqLim,freqRangeCell,1,saveDir)
    end
end

fileExtCell = {
    '.eeg',...
    '_LinNearCSD121.csd',...
    };
spectAnalBase = 'RemVsRun07_noExp_MinSpeed5wavParam6Win1250';
nwTapersCell = {...
    [3 5],...
    [10 19],...
    };
for m=1:length(nwTapersCell)
    for k=1:length(fileExtCell)
        for j=1:length(analDirs)
            cd(analDirs{j})
            fileBaseCell = [LoadVar('FileInfo/RemFiles');LoadVar('FileInfo/MazeFiles')];
            CalcUnitFieldCoh06(fileBaseCell,fileExtCell{k},1250,SC([spectAnalBase fileExtCell{k}]),[],[0 200],nwTapersCell{m})
        end
    end
end
fileExt = '.eeg'
for m=1:length(nwTapersCell)
        for j=1:length(analDirs)
            cd(analDirs{j})
            fileBaseCell = [LoadVar('FileInfo/RemFiles');LoadVar('FileInfo/MazeFiles')];
            CalcUnitSpectrum03(fileBaseCell,1250,SC([spectAnalBase fileExt]),nwTapersCell{m},1024)
        end
end

addpath /u12/antsiro/matlab/draft/  
binsCell = {...
    [4 85],...
    [8 43],...
    }
normCell = {...
    'count',...
    'scale',...
    }
spectAnalDir = 'RemVsRun07_noExp_MinSpeed5wavParam6Win1250.eeg/'  % CalcRunningSpectra15 & CalcRemSpectra06
for m=1:length(normCell)
    for k=1:length(binsCell)
        for j=1:length(analDirs)
            cd(analDirs{j})
            fileBaseCell = [LoadVar('FileInfo/RemFiles');LoadVar('FileInfo/MazeFiles')];
            %     fileBaseCell = [LoadVar('FileInfo/RemFiles')];
            %     CalcUnitCCG04(fileBaseCell,1250,'RemVsRun03_noExp_MinSpeed5wavParam6Win1250.eeg/',...
            %         'count',8,62,1)
            CalcUnitCCG04(fileBaseCell,1250,spectAnalDir,...
                normCell{m},binsCell{k}(1),binsCell{k}(2),1)
            %     CalcUnitCCG04(fileBaseCell,1250,'RemVsRun03_noExp_MinSpeed5wavParam6Win1250.eeg/',...
            %         'scale',8,62,1)
            %         CalcUnitCCG04(fileBaseCell,1250,spectAnalDir,...
            %             'scale',binsCell{k}(1),binsCell{k}(2),1)
        end
    end
end


for j=1:length(analDirs)
    cd(analDirs{j})
    fileBaseCell = [LoadVar('FileInfo/MazeFiles');LoadVar('FileInfo/RemFiles')];
    CalcUnitRates05(fileBaseCell,'.eeg',1250,'RemVsRun04_noExp_MinSpeed5wavParam6Win1250.eeg/')
end

for j=1:length(analDirs)
    cd(analDirs{j})

    remFiles = LoadVar('FileInfo/RemFiles')
    CalcRemMeasTimes01('CalcRemSpectra04','allTimes',remFiles,'.eeg',97,1250,6)

    mazeFiles = LoadVar('FileInfo/MazeFiles')
    CalcMazeMeasTimes01('CalcRunningSpectra12','noExp',mazeFiles,'.eeg',97,1250,6,0)
end

MakeRemVsRunLinks(analDirs,{'.eeg'})


for j=1:length(analDirs)
    cd(analDirs{j})
    files = [LoadVar('FileInfo/MazeFiles')];
   %CalcUnitPopACG05(files,626,'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/',3,'count')
   %CalcUnitPopSpectrum02(files,626,'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/',2)
   %CalcUnitPopFieldCoh02(files,626,'.eeg','CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8',2)
   CalcUnitPopFieldCoh02(files,626,'_LinNearCSD121.csd','CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8',2)
end

for j=1:length(analDirs)
    cd(analDirs{j})
    files = [LoadVar('FileInfo/RemFiles');LoadVar('FileInfo/MazeFiles')];
%    CalcUnitACG02(files,1250,'RemVsRun02_noExp_MinSpeed0Win1250wavParam6.eeg/')
   CalcUnitPopACG05(files,1250,'RemVsRun02_noExp_MinSpeed0Win1250wavParam6.eeg/',3)
     %CalcUnitPopSpectrum02(files,1250,'RemVsRun02_noExp_MinSpeed0Win1250wavParam6.eeg/',10)
end

TrialDesigLists07({'RemVsMaze_Beh'})


analDirs = {...
    '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-17-04/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/',...
    }
trialTypesBool = [];
trialTypesBool.AllTrials = [1 1 1 1 1 1 1 1 1 1 1 1 1];
trialTypesBool.GoodTrials = [1 0 1 0 0 0 0 0 0 0 0 0 0];
trialTypesBool.AllCorrect = [1 0 1 0 1 0 1 0 1 0 1 0 0];
trialTypesBool.AllIncorrect = [0 1 0 1 0 1 0 1 0 1 0 1 0];
numFigs = length(fieldnames(trialTypesBool));
for j=1:length(analDirs)
    cd(analDirs{j})
    alterFiles = LoadVar('FileInfo/AlterFiles');
    PlotPopPlaceFields02(alterFiles,trialTypesBool)
    ReportFigSM([1:numFigs],[analDirs{j} 'NewFigs/PFPlots/'],repmat({'alterPop'},numFigs,1));
    close all
end

trialTypesBool = [];
trialTypesBool.AllTrials = [1 1 1 1 1 1 1 1 1 1 1 1 1];
trialTypesBool.GoodTrials = [1 0 1 0 0 0 0 0 0 0 0 0 0];
trialTypesBool.LRGood = [1 0 0 0 0 0 0 0 0 0 0 0 0];
trialTypesBool.RLGood = [0 0 1 0 0 0 0 0 0 0 0 0 0];
numFigs = length(fieldnames(trialTypesBool));
for j=1:length(analDirs)
    cd(analDirs{j})
    alterFiles = LoadVar('FileInfo/AlterFiles');
    mazeFiles = LoadVar('FileInfo/MazeFiles');
    PlotPopPlaceFields02(setdiff(mazeFiles,alterFiles),trialTypesBool)
    ReportFigSM([1:numFigs],[analDirs{j} 'NewFigs/PFPlots/'],repmat({'controlPop'},numFigs,1));
    close all
end

% LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP

