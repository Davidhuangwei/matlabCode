% % function CalcTonicRemTrials(fileBaseCell,phasicFileExt,phasicSamp,phasicWin,spectAnalDir,spectralWin,varargin)
% [eegSamp,plotBool] = DefaultArgs(varargin,{1250,1});
% spectralWin should be specified in eegSamp
% tag:tonic
% tag:rem
% tag:spectral

function CalcTonicRemTrials(fileBaseCell,phasicFileExt,phasicSamp,phasicWin,spectAnalDir,spectralWin,varargin)
[eegSamp,plotBool] = DefaultArgs(varargin,{1250,1});

for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};
    phasicFile = [SC(fileBase) 'PhasicRemTimes' phasicFileExt];
    outFile = [SC(fileBase) SC(spectAnalDir) 'TonicRemTimes' Dot2Underscore(phasicFileExt) '.mat'];
    eegSegTime = LoadVar([SC(fileBase) SC(spectAnalDir) 'eegSegTime']); %load spectAnalTimes
    originalTime = LoadVar([SC(fileBase) SC(spectAnalDir) 'originalTime.mat']);
    phasicTimes = load(phasicFile); % load phasicEpochs
    phasicEpochs = [phasicTimes-phasicWin/2 phasicTimes+phasicWin/2]*eegSamp/phasicSamp;
    
    phasic = logical(zeros(size(eegSegTime)));
    if ~isempty(phasicEpochs)
        for k=1:size(eegSegTime,1)
            if any( (phasicEpochs(:,1)>=eegSegTime(k) & phasicEpochs(:,1)<=eegSegTime(k)+spectralWin) ...
                    | (phasicEpochs(:,2)>=eegSegTime(k) & phasicEpochs(:,2)<=eegSegTime(k)+spectralWin) ...
                    | (phasicEpochs(:,1)<=eegSegTime(k) & phasicEpochs(:,2)>=eegSegTime(k)+spectralWin));
                phasic(k,1) = 1;
            end
        end
        tonic = ~phasic & originalTime;
        if plotBool
            figure
            hold on
            PlotVertLines(phasicEpochs(:,1),[0 2],...
                'color','g')
            PlotVertLines(phasicEpochs(:,2),[0 2],...
                'color','r')
            plot([eegSegTime(tonic) eegSegTime(tonic)+spectralWin]',repmat([1 1],[sum(tonic) 1])',...
                'c')
            plot([eegSegTime(phasic) eegSegTime(phasic)+spectralWin]',repmat([1 1],[sum(phasic) 1])',...
                'k')
            plot([eegSegTime(tonic) eegSegTime(tonic)+spectralWin]',repmat([1 1],[sum(tonic) 1])',...
                'c.')
            plot([eegSegTime(phasic) eegSegTime(phasic)+spectralWin]',repmat([1 1],[sum(phasic) 1])',...
                'k.')
            %         set(gca,'xlim',[unionEpochs(1,1) unionEpochs(1,1)+Fs*plotDuration]);
            set(gcf,'name',[fileBase '_PhasicRemTimes' phasicFileExt])
            SetFigPos(gcf,[0.5 0.5 15 5]);
        end
    end
    tonic = ~phasic & originalTime;
    fprintf('Saving: %s\n',outFile);
    save(outFile,SaveAsV6,'tonic');
end
    
    

