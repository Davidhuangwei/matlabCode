function PlotPeakTrigAveStd_FullFig01(spectAnalDir,analRoutine,filtFreqRange,maxFreq,timeWindow,trigFileExt,varargin)
[reportFigBool,saveDir,normFactor, colorLimits, selChan, traceExt, colorExt,traceNChan, colorNChan, eegFs, resFs, glmVersion, bps] = ...
    DefaultArgs(varargin,{0,'./NewFigs/PeakTrigAveStd02/',[],[],LoadVar(['ChanInfo/SelChan' trigFileExt]),'.eeg','_LinNearCSD121.csd',[],[],1250,20000,'GlmWholeModel08',2});
[reportFigBool,saveDir,normFactor, colorLimits, selChan, traceExt, colorExt,traceNChan, colorNChan, eegFs, resFs, glmVersion, bps] = ...
    DefaultArgs({reportFigBool,saveDir,normFactor, colorLimits, selChan, traceExt, colorExt,traceNChan, colorNChan, eegFs, resFs, glmVersion, bps},...
    {[],[],[],[],[],[],[],load(['ChanInfo/NChan' traceExt '.txt']),load(['ChanInfo/NChan' colorExt '.txt']),[],[],[],[]});

selChan = Struct2CellArray(selChan);

load(['TrialDesig/' glmVersion '/' analRoutine '.mat']);
time = LoadDesigVar(fileBaseCell,spectAnalDir,'time',trialDesig);
timeNames = fieldnames(time);
keyboard
for k=1:size(selChan,1)
    for n=1:length(timeNames)
        colorSegs{n} = [];
        traceSegs{n} = [];
       
        for j=1:length(fileBaseCell)
            fileBase = fileBaseCell{j};
            inBase = [fileBase '_Peak' num2str(filtFreqRange(1)) '-' ...
                num2str(filtFreqRange(2)) 'Hz_Max' num2str(maxFreq) trigFileExt];
            fprintf('\nLoading:\n %s.res\n %s.clu',inBase,inBase);
            res = load([fileBase '/' inBase '.res']);
            clu = load([fileBase '/' inBase '.clu']);

            time = LoadDesigVar(fileBaseCell(j),spectAnalDir,'time',trialDesig);
            cluRes = res(find(clu(2:end)==selChan{k,2}));
            epochs = Times2Epochs(time.(timeNames{n}),timeWindow)*resFs;
            selRes = TimesInEpochs(cluRes,epochs)*eegFs/resFs;

            for m=1:length(selRes)
                try
                    colorSegs{n} = cat(3,colorSegs{n},bload([SC(fileBase) fileBase colorExt],[colorNChan, timeWindow*eegFs],...
                        bps*colorNChan*round(selRes(m)-timeWindow*eegFs/2)));
                    traceSegs{n} = cat(3,traceSegs{n},bload([SC(fileBase) fileBase traceExt],[traceNChan, timeWindow*eegFs],...
                        bps*traceNChan*round(selRes(m)-timeWindow*eegFs/2)));
                catch
                    junk = lasterror;
                    junk.message
                    junk.stack(1)
                    keyboard
                end
            end
        end
    end
    keyboard
    figure(1)
    clf
    SetFigPos(gcf,[0 1 9*length(timeNames) 7]);
    for n=1:length(timeNames)
        subplot(1,length(timeNames),n);
%          subplot(size(selChan,1),length(timeNames),n+(k-1)*length(timeNames));
        try
       [normFactor colorLimits] = PlotTrigCSD_Fig01(traceSegs{n},colorSegs{n},normFactor,colorLimits,...
           LoadVar(['ChanInfo/ChanMat' traceExt]),...
           load(['ChanInfo/Offset' traceExt '.txt']),...
           LoadVar(['ChanInfo/ChanMat' colorExt]),...
           load(['ChanInfo/Offset' colorExt '.txt']),...
           load(['ChanInfo/BadChan' traceExt '.txt'])...
           );
                catch
                    junk = lasterror;
                    junk.message
                    junk.stack(1)
                    keyboard
                end
           
        if k==1
            title(timeNames{n});
        end
        if n==1
            ylabel(STU(['ref: ' selChan{k,1} ', n=' num2str(size(traceSegs{n},3))...
                ',   color=' colorExt ', trace=' traceExt]));
        end
        if reportFigBool
            ReportFigSM([],SC([SC(saveDir) analRoutine]),{GenFieldName(['Filt' num2str(filtFreqRange(1)) '-' ...
                num2str(filtFreqRange(2)) 'Hz_max' num2str(maxFreq) 'Hz' trigFileExt '_color' colorExt '_trace' traceExt])},[])
        end
    end
end

return

    
    