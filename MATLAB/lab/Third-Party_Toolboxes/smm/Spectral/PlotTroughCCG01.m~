
analDirs = {'/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/'};
depVarBase = 'peak';
spectAnalDir = 'RemVsRun06_noExp_MinSpeed5wavParam6Win1250.eeg'
statsAnalFunc = 'GlmWholeModel08';
analRoutine = 'PhasicVsTonicVsMaze_MolSD2'
'RemVsMaze_All';
normalization = 'count';
filtFreqRange = [4 12]
maxFreq = 14
binSize = 10;
timeLim = 500;
biasCorrBool = 1;
fileExt = '.eeg';
selChanCell = Struct2CellArray(LoadVar(['ChanInfo/SelChan' fileExt]),[],1);
selChan = [selChanCell{:,2}];

function PlotTroughCCG01(analDirs,depVarBase,spectAnalDir,statsAnalFunc,...
    analRoutine,normalization,binSize,timeLim,biasCorrBool,selchan)



prevWarnSettings = SetWarnings({'off','LoadDesigVar:fileNotFound';...
   'off', 'MATLAB:divideByZero'});

cwd = pwd;

if biasCorrBool
    bcText = 'BC';
else
    bcText = '';
end
rates = [];
acgs = [];
ccgs = [];
for j=1:length(analDirs)
    cd(analDirs{j})
    load(['TrialDesig/' statsAnalFunc '/' analRoutine '.mat'])
    tempRate = Struct2CellArray(LoadDesigVar(fileBaseCell,spectAnalDir,...
        [depVarBase 'Rate' num2str(filtFreqRange(1)) '-' num2str(filtFreqRange(2)) 'HzMaxF' num2str(maxFreq) ],trialDesig),[],1);
    
    tempCCG = Struct2CellArray(SumDesigVar(1,fileBaseCell,spectAnalDir,...
        [depVarBase 'CCG' num2str(filtFreqRange(1)) '-' num2str(filtFreqRange(2)) 'HzMaxF' num2str(maxFreq) ...
        'Bin' num2str(binSize) normalization bcText '.yo'],trialDesig),[],1);
end
to = LoadField([fileBaseCell{1} '/' spectAnalDir '/'...
    [depVarBase 'CCG' num2str(filtFreqRange(1)) '-' num2str(filtFreqRange(2)) 'HzMaxF' num2str(maxFreq) ...
    'Bin' num2str(binSize) normalization bcText '.to']]);
catCCG = tempCCG;
catRate = tempRate;


figure
clf
plotColors = 'rbgk';
for j=1:length(selChan)
    for m=1:length(selChan)
        subplot(length(selChan),length(selChan),(j-1)*length(selChan)+m)
        for k=1:size(catCCG,1)
            [junkVal toInd] = FurcateData(to,[-timeLim timeLim]);
            toInd = toInd(1):toInd(end);
            totalCount = sum(catCCG{k,end}(:,j,m,toInd),4);
            plot(to(toInd),squeeze(catCCG{k,end}(:,j,m,toInd))./totalCount,...
                plotColors(k));
            hold on
            set(gca,'xlim',[-timeLim timeLim])
            yLimits = get(gca,'ylim');
            if m==length(selChan) & j==1
                text(timeLim,yLimits(2)*k/size(catCCG,1),cat(2,catCCG(k,1:end-1)),'color',plotColors(k))
            end
        end
        if m==1
            ylabel(selChanCell{j,1})
        end
        if j==length(selChan)
            xlabel(selChanCell{m,1})
        end
    end
end

figure
clf
plotColors = 'rbgk';
for j=1:length(selChan)
    subplot(length(selChan),1,j)
    for k=1:size(catCCG,1)
        plot(catRate{k,end}(:,selChan(j)),plotColors(k));
        hold on
%         set(gca,'xlim',[-timeLim timeLim])
%         set(gca,'ylim',[0 20])
    end
end
    
plan:
load with LoadTrialDesig
normalize scale (for each trial or over all trials?)
plot selchan
bootstrap error bars