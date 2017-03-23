function PlotPeakTrigAveStd(spectAnalDir,analRoutine,filtFreqRange,maxFreq,timeWindow,trigFileExt,varargin)
[reportFigBool,colorLimits, selChan, traceExt, colorExt,traceNChan, colorNChan, eegFs, resFs, glmVersion, bps] = ...
    DefaultArgs(varargin,{0,[],LoadVar(['ChanInfo/SelChan' trigFileExt]),'.eeg','_LinNearCSD121.csd',[],[],1250,20000,'GlmWholeModel08',2});
[reportFigBool,colorLimits, selChan, traceExt, colorExt,traceNChan, colorNChan, eegFs, resFs, glmVersion, bps] = ...
    DefaultArgs({reportFigBool,colorLimits, selChan, traceExt, colorExt,traceNChan, colorNChan, eegFs, resFs, glmVersion, bps},...
    {0,[],[],[],[],load(['ChanInfo/NChan' traceExt '.txt']),load(['ChanInfo/NChan' colorExt '.txt']),[],[],[],[]});

selChan = Struct2CellArray(selChan);

load(['TrialDesig/' glmVersion '/' analRoutine '.mat']);

for k=1:size(selChan,1)
    colorSegs{k} = [];
    traceSegs{k} = [];

    for j=1:length(fileBaseCell)
        fileBase = fileBaseCell{j};
        inBase = [fileBase '_Peak' num2str(filtFreqRange(1)) '-' ...
            num2str(filtFreqRange(2)) 'Hz_Max' num2str(maxFreq) trigFileExt];
        fprintf('\nLoading:\n %s.res\n %s.clu',inBase,inBase);
        res = load([fileBase '/' inBase '.res']);
        clu = load([fileBase '/' inBase '.clu']);

        time = LoadDesigVar(fileBaseCell(j),spectAnalDir,'time',trialDesig);
        timeNames = fieldnames(time);

        cluRes = res(find(clu(2:end)==selChan{k,2}));
        
        for n=1:length(timeNames)
            epochs = Times2Epochs(time.(timeNames{n}),timeWindow)*resFs;
            
            selRes = TimesInEpochs(cluRes,epochs)*eegFs/resFs;
            if j==1
                colorSegs{k}{n} = [];
                traceSegs{k}{n} = [];
            end
            for m=1:length(selRes)
                try
                colorSegs{k}{n} = cat(3,colorSegs{k}{n},bload([SC(fileBase) fileBase colorExt],[colorNChan, timeWindow*eegFs],...
                    bps*colorNChan*(selRes(m)-round(timeWindow*eegFs/2))));
                traceSegs{k}{n} = cat(3,traceSegs{k}{n},bload([SC(fileBase) fileBase traceExt],[traceNChan, timeWindow*eegFs],...
                    bps*traceNChan*(selRes(m)-round(timeWindow*eegFs/2))));
                catch
                    junk = lasterror;
                    junk.message
                    junk.stack(1)
                    keyboard
                end
            end
        end
    end
end
% figure(1)
% SetFigPos(gcf,[0 1 15*size(selChan,1) 1+12*length(timeNames)]);
keyboard
for k=1:size(selChan,1)
    figure(1)
    clf
    SetFigPos(gcf,[0 1 9*length(timeNames) 7]);
    for n=1:length(timeNames)
        subplot(1,length(timeNames),n);
%          subplot(size(selChan,1),length(timeNames),n+(k-1)*length(timeNames));
       PlotTrigCSD(traceSegs{k}{n},colorSegs{k}{n},colorLimits)
        if k==1
            title(timeNames{n});
        end
        if n==1
            ylabel(STU(['ref: ' selChan{k,1} ', color=' colorExt ', trace=' traceExt]));
        end
        if reportFigBool
            ReportFigSM([],'./NewFigs/',{['PeakTrigAveStd_' analRoutine '_filt' num2str(filtFreqRange(1)) '-' ...
                num2str(filtFreqRange(2)) 'Hz_max' num2str(maxFreq) 'Hz_' trigFileExt]},[])
        end
    end
end
% ReportFigSM([],'./NewFigs/',{['PeakTrigAveStd_' analRoutine '_filt' num2str(filtFreqRange(1)) '-' ...
%     num2str(filtFreqRange(2)) 'Hz_max' num2str(maxFreq) 'Hz_' trigFileExt]},[],{['trace - ' traceExt]; ['color - ' colorExt]})
    
keyboard
return

    
    