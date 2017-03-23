function PlotUnitTrigAveStd(spectAnalDir,analRoutine,timeWindow,varargin)
[reportFigBool,normFactor, colorLimits,traceExt, colorExt,traceNChan, colorNChan, eegFs, resFs, glmVersion, bps] = ...
    DefaultArgs(varargin,{0,[],[],'.eeg','_LinNearCSD121.csd',[],[],1250,20000,'GlmWholeModel08',2});
[reportFigBool,normFactor, colorLimits, traceExt, colorExt,traceNChan, colorNChan, eegFs, resFs, glmVersion, bps] = ...
    DefaultArgs({reportFigBool,normFactor, colorLimits, traceExt, colorExt,traceNChan, colorNChan, eegFs, resFs, glmVersion, bps},...
    {[],[],[],[],[],load(['ChanInfo/NChan' traceExt '.txt']),load(['ChanInfo/NChan' colorExt '.txt']),[],[],[],[]});


load(['TrialDesig/' glmVersion '/' analRoutine '.mat']);
time = LoadDesigVar(fileBaseCell,spectAnalDir,'time',trialDesig);
timeNames = fieldnames(time);

fileBase = fileBaseCell{1};
cellLayer = LoadCellLayers([SC(fileBase) fileBase '.cellLayer']);
cellType = LoadCellTypes([SC(fileBase) fileBase '.type']);

[junk sortedCellIndexes] = sortrows(cat(2,cellLayer(:,3),cellType(:,3)));

for k=sortedCellIndexes'
    for n=1:length(timeNames)
        colorSegs{n} = [];
        traceSegs{n} = [];
        
        for j=1:length(fileBaseCell)
            fileBase = fileBaseCell{j};
            colorInfo = dir([SC(fileBase) fileBase colorExt]);
           traceInfo = dir([SC(fileBase) fileBase traceExt]);
             
            inbase = [fileBase '/' fileBase '.res.' num2str(cellLayer{k,1})];
            fprintf('\nLoading: %s',inbase);
            res = load(inbase);
            
            inbase = [fileBase '/' fileBase '.clu.' num2str(cellLayer{k,1})];
            fprintf('\nLoading: %s',inbase);
            clu = load(inbase);
            
            time = LoadDesigVar(fileBaseCell(j),spectAnalDir,'time',trialDesig);
            cluRes = res(find(clu(2:end)==cellLayer{k,2}));
            epochs = Times2Epochs(time.(timeNames{n}),timeWindow)*resFs;
            selRes = TimesInEpochs(cluRes,epochs)*eegFs/resFs;

            for m=1:length(selRes)
                try
                     colorSegs{n} = cat(3,colorSegs{n},bload([SC(fileBase) fileBase colorExt],[colorNChan, timeWindow*eegFs],...
                        bps*colorNChan*round(selRes(m)-timeWindow*eegFs/2)));
                    traceSegs{n} = cat(3,traceSegs{n},bload([SC(fileBase) fileBase traceExt],[traceNChan, timeWindow*eegFs],...
                        bps*traceNChan*round(selRes(m)-timeWindow*eegFs/2)));
%                     colorSegs{n} = cat(3,colorSegs{n},bload([SC(fileBase) fileBase colorExt],[colorNChan, timeWindow*eegFs],...
%                         clip(bps*colorNChan*(selRes(m)-round(timeWindow*eegFs/2)),1,ceil(colorInfo.bytes-timeWindow*eegFs))));
%                     traceSegs{n} = cat(3,traceSegs{n},bload([SC(fileBase) fileBase traceExt],[traceNChan, timeWindow*eegFs],...
%                         clip(bps*traceNChan*(selRes(m)-round(timeWindow*eegFs/2)),1,ceil(traceInfo.bytes-timeWindow*eegFs))));
                catch
                    junk = lasterror;
                    junk.message
                    junk.stack(1)
                    keyboard
                end
            end
        end
    end
    figure(1)
    clf
    SetFigPos(gcf,[0 1 9*length(timeNames) 7]);
    for n=1:length(timeNames)
        subplot(1,length(timeNames),n);
%          subplot(size(selChan,1),length(timeNames),n+(k-1)*length(timeNames));
        if ~isempty(traceSegs{n}) 
         [normFactor colorLimits] = PlotTrigCSD(traceSegs{n},colorSegs{n},normFactor,colorLimits,...
           LoadVar(['ChanInfo/ChanMat' traceExt]),...
           load(['ChanInfo/Offset' traceExt '.txt']),...
           LoadVar(['ChanInfo/ChanMat' colorExt]),...
           load(['ChanInfo/Offset' colorExt '.txt']),...
           load(['ChanInfo/BadChan' traceExt '.txt'])...
           );
        end
%        PlotTrigCSD(traceSegs{n},colorSegs{n},colorLimits)
        if k==1
            title(timeNames{n});
        end
        if n==1
            ylabel(STU(['ref cell: ' cellType{k,3} ', ' cellLayer{k,3} ...
                ' (' num2str(k) ') , n=' num2str(size(traceSegs{n},3)) ...
                ',  color=' colorExt ', trace=' traceExt]));
        end
        if reportFigBool
            ReportFigSM([],['./NewFigs/UnitTrigAveStd07/ ' SC(analRoutine)],{['Color-' colorExt '_trace-' traceExt]},[])
        end
    end
end
