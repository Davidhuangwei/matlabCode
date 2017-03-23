analDirs = {...
    '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-17-04/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/',...
    }

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

