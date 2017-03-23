function PlotPeakTrigAveStd(spectAnalDir,analRoutine,filtFreqRange,maxFreq,timeWindow,trigFileExt,varargin)
[reportFigBool,normFactor, colorLimits, selChan, traceExt, colorExt, traceNChan, colorNChan, eegFs, resFs, glmVersion, bps] = ...
    DefaultArgs(varargin,{0,[],[],LoadVar(['ChanInfo/SelChan' trigFileExt]),'.eeg','_LinNearCSD121.csd',[],[],1250,20000,'GlmWholeModel08',2});
if isempty(traceNChan)
    if exist(['ChanInfo/NChan' traceExt '.txt'],'file')
        traceNChan = load(['ChanInfo/NChan' traceExt '.txt']);
    end
end
if isempty(colorNChan)
    if exist(['ChanInfo/NChan' colorExt '.txt'],'file')
       colorNChan  = load(['ChanInfo/NChan' colorExt '.txt']);
    end
end
% 
% [reportFigBool,normFactor, colorLimits, selChan, traceExt, colorExt,traceNChan, colorNChan, eegFs, resFs, glmVersion, bps] = ...
%     DefaultArgs({reportFigBool,normFactor, colorLimits, selChan, traceExt, colorExt,traceNChan, colorNChan, eegFs, resFs, glmVersion, bps},...
%     {[],[],[],[],[],[],load(['ChanInfo/NChan' traceExt '.txt']),load(['ChanInfo/NChan' colorExt '.txt']),[],[],[],[]});

% selChan = Struct2CellArray(selChan);

load(['TrialDesig/' glmVersion '/' analRoutine '.mat']);
time = LoadDesigVar(fileBaseCell,spectAnalDir,'time',trialDesig);
timeNames = fieldnames(time);

selChan = Struct2CellArray(LoadVar(['ChanInfo/ChanLoc_Min' trigFileExt '.mat']),[],1)
selChan = selChan([8 2],:)
reportFigBool = 0;
keyboard
for k=1:size(selChan,1)
    for kk=1:length(selChan{k,2})
        if ~isempty(selChan{k,2}{kk})
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
                cluRes = res(find(clu(2:end)==selChan{k,2}{kk}));
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
        close all
        plotColors = ['rkbcym']
        chanLoc  = LoadVar(['ChanInfo/ChanLoc_Min' traceExt '.mat'])
keyboard
        chans = [chanLoc.(selChan{mod(k,2)+1,1}){:}]
        refChan = selChan{k,2}{kk}
        for p=1:length(chans)
            figure(p)
            clf
            title(['Ref: ' selChan{k,1}])
            hold on
            xTimes = [ceil(-size(traceSegs{1},2)/2):ceil(size(traceSegs{1},2)/2)-1]/eegFs*1000;
            %         plot(xTimes,squeeze(mean(traceSegs{1}(refChan,:,:),3)),'color',[0.5 0.5 0.5],'linewidth',5)
%             plotInd = 5:10:length(xTimes);
%             meanTrace = squeeze(mean(traceSegs{r}(refChan,:,:),3));
%             semTrace = squeeze(std(traceSegs{r}(refChan,:,:),[],3))/size(traceSegs{r}(chans(p),:,:),3);
%             plot([xTimes(plotInd);xTimes(plotInd)],[meanTrace(plotInd)+semTrace(plotInd); meanTrace(plotInd)-semTrace(plotInd)],'color',[0.5 0.5 0.5])
            %        plot(xTimes,squeeze(mean(traceSegs{1}(refChan,:,:),3)),'color',[0.5 0.5 0.5])
            for r=1:length(timeNames)
            plotInd = 5:10:length(xTimes);
            meanTrace = squeeze(mean(traceSegs{r}(refChan,:,:),3));
            semTrace = squeeze(std(traceSegs{r}(refChan,:,:),[],3))/size(traceSegs{r}(chans(p),:,:),3);
                plot(xTimes,meanTrace,'color',[0.4 0.4 0.4]+0.1*r,'linewidth',3)
            plot([xTimes(plotInd);xTimes(plotInd)],[meanTrace(plotInd)+semTrace(plotInd); meanTrace(plotInd)-semTrace(plotInd)],...
                'color',[0.4 0.4 0.4]+0.1*r)
                %          keyboard
                %          plot(repmat(xTimes',1,size(traceSegs{r},3)),squeeze(traceSegs{r}(chans(p),:,:)),plotColors(r),'linewidth',5)
                meanTrace = squeeze(mean(traceSegs{r}(chans(p),:,:),3));
                %              plot(xTimes,meanTrace,plotColors(r),'linewidth',5)
                plot(xTimes,meanTrace,plotColors(r),'linewidth',3)
                semTrace = squeeze(std(traceSegs{r}(chans(p),:,:),[],3))/size(traceSegs{r}(chans(p),:,:),3);
                plotInd = r*5:10:length(xTimes);
                plot([xTimes(plotInd);xTimes(plotInd)],[meanTrace(plotInd)+semTrace(plotInd); meanTrace(plotInd)-semTrace(plotInd)],...
                    plotColors(r))
                xLimits = get(gca,'xlim');
                yLimits = get(gca,'ylim');
                yLoc = yLimits(1)+(yLimits(2)-yLimits(1))/(length(timeNames)+2)*r;
                text(xLimits(2),yLoc,timeNames(r),'color',plotColors(r))
            end
        end
        if reportFigBool
            ReportFigSM([1:length(chans)],['NewFigs/CA3-CA1PhaseShift/trig'...
               num2str(filtFreqRange(1)) '-' ...
                    num2str(filtFreqRange(2)) 'Hz_Max' num2str(maxFreq) trigFileExt '_03/'], ...
                    repmat({['CA3-CA1_Phase_Shift' traceExt]},length(chans),1))
        end
        end
    end
end

return

    
    