function PlotGlmBarh06(depVarCell,spectAnalDir,fileExt,chanLocVersion,analRoutine,varargin)

[analDirs betaXlimCell reportFigBool printFigBool statsDir saveDir bonfFactor statAlpha] = ...
    DefaultArgs(varargin,{[],[],0,0,'GlmWholeModel08','/u12/smm/public_html/NewFigs/',1,0.01});


chanInfoDir = 'ChanInfo/';

prevWarn = SetWarnings({'off','MATLAB:divideByZero'});

% depVarPoss = {...
%     'gammaCohMean60-120Hz',...
%     'gammaCohMean40-100Hz',...
%     'gammaCohMean40-120Hz',...
%     'gammaCohMean50-100Hz',...
%     'gammaCohMean50-120Hz',...
%     'thetaCohMean6-12Hz',...
%     'thetaCohPeakSelChF6-12Hz',...
%     'thetaCohMedian6-12Hz',...
%     'gammaCohMedian60-120Hz',...
%     'thetaCohPeakLMF6-12Hz',...
%     'thetaPowIntg4-12Hz',...
%     'thetaPowIntg6-12Hz',...
%     'gammaPowIntg40-100Hz',...
%     'gammaPowIntg40-120Hz',...
%     'gammaPowIntg50-100Hz',...
%     'gammaPowIntg50-120Hz',...
%     'gammaCohMean40-100Hz',...
%     'thetaCohMean4-12Hz',...
%     'thetaPhaseMean4-12Hz',...
%     'gammaPhaseMean40-100Hz',...
%     };
% 
% 
% depVarCell = intersect(depVarCell,depVarPoss);

anatNames = fieldnames(LoadVar([analDirs{1}{1} 'ChanInfo/ChanLoc_' chanLocVersion fileExt]));

for a=1:length(depVarCell)
    depVar = depVarCell{a}

    if ~isempty([strfind(depVar,'Phase') strfind(depVar,'phase')])
        depVarType = 'phase';
        selChanNames = fieldnames(LoadVar([analDirs{1}{1} 'ChanInfo/SelChan' fileExt]));
        selChanBool = 1;
    elseif ~isempty([strfind(depVar,'Coh') strfind(depVar,'coh')])
        depVarType = 'coh';
        selChanNames = fieldnames(LoadVar([analDirs{1}{1} 'ChanInfo/SelChan' fileExt]));
        selChanBool = 1;
    elseif ~isempty([strfind(depVar,'Pow') strfind(depVar,'pow')]);
        depVarType = 'pow';
        selChanNames = {''};
        selChanBool = 0;
    else
        depVarType = 'undef';
        selChanNames = {''};
        selChanBool = 0;
    end
    dataStruct = GlmResultsLoad01(depVar,chanLocVersion,spectAnalDir,fileExt,analRoutine,analDirs,statsDir,selChanBool);
    dataStruct = GlmResultsCatAnimal(dataStruct,0);
    
     varNames = fieldnames(dataStruct.coeffs);
     [nLayers nSelChan] = size(dataStruct.coeffs.(varNames{1}));
%     alpha = baseAlpha/(nLayers*nSelChan);
    for b=1:nSelChan
        fileName = [depVar '_' selChanNames{b} '_barh'];

        nextFig = 1;

        %%%%%%% coeffs %%%%%%%%
        plotData = dataStruct.coeffs;
        titlesExt = 'beta';
        xLimits = betaXlimCell;
        %plotData = GlmResultsCalcLog10(plotData);
        [mu stDev pVal] = GlmResultsCalcMedC95P(plotData,bonfFactor);
        transMu = GlmResultsUnTransform(mu,depVarType);
        mu.Constant = transMu.Constant;
        constantMu = mu.Constant;
        betaPval = pVal;
        betaStDev = stDev;
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,pVal,b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%%% rSqs %%%%%%
        plotData = dataStruct.rSqs;
        titlesExt = 'rSq';
        xLimits = [0 1];
        [mu stDev pVal] = GlmResultsCalcMedC95P(plotData);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%%%%% categMeans %%%%%%%%
        if isfield(dataStruct,'categMeans')
        plotData = dataStruct.categMeans;
        titlesExt = 'categMeans';
        xLimits = betaXlimCell;
%         keyboard
        test = GlmResultsUnTransform(plotData,depVarType);
        test = GlmResultsSubtractConst(test,constantMu);
        [mu stDev pVal] = GlmResultsCalcMedC95P(test);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,pVal,b,anatNames,titlesExt,xLimits,fileName,statAlpha);
%         [mu stDev pVal] = GlmResultsCalcMedC95P(plotData);
%         mu = GlmResultsUnTransform(mu,depVarType);
%         mu = GlmResultsSubtractConst(mu,constantMu);
%         nextFig = LocalPlotBarHelper(nextFig,mu,betaStDev,betaPval,b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%%%%% subtracted %%%%%%%%
        fNames = fieldnames(dataStruct.categMeans);
        if length(fNames) == 2
            plotData = dataStruct.categMeans;
            titlesExt = 'subtr beta';
            xLimits = betaXlimCell;
            plotData1 = GlmResultsSubtractConst(plotData,plotData.(fNames{2}));
            plotData2 = GlmResultsSubtractConst(plotData,plotData.(fNames{1}));
            plotData.(fNames{1}) = plotData1.(fNames{1});
            plotData.(fNames{2}) = plotData2.(fNames{2});
            [mu stDev pVal] = GlmResultsCalcMedC95P(plotData,bonfFactor);
            nextFig = LocalPlotBarHelper(nextFig,mu,stDev,pVal,b,anatNames,titlesExt,xLimits(2:end),fileName,statAlpha);
%             [mu stDev pVal] = GlmResultsCalcMedC95P(plotData);
%             mu = GlmResultsUnTransform(mu,depVarType);
%             mu1 = GlmResultsSubtractConst(mu,mu.(fNames{2}));
%             mu2 = GlmResultsSubtractConst(mu,mu.(fNames{1}));
%             mu.(fNames{1}) = mu1.(fNames{1});
%             mu.(fNames{2}) = mu2.(fNames{2});
%             nextFig = LocalPlotBarHelper(nextFig,mu,betaStDev,betaPval,b,anatNames,titlesExt,xLimits(2:end),fileName,statAlpha);
        end    
        end
        %%%%% pVals %%%%%%
        plotData = dataStruct.pVals;
        titlesExt = 'pVal';
        xLimits = [];
        plotData = GlmResultsCalcLog10(plotData);
        [mu stDev pVal] = GlmResultsCalcMedC95P(plotData);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%%%%% coeffNormP %%%%%%%%
        plotData = dataStruct.coeffs;
        titlesExt = 'coeffNormP';
        xLimits = [];
        pVal = GlmResultsCalcNormP(plotData);
        pVal = GlmResultsCalcLog10(pVal);
        nextFig = LocalPlotBarHelper(nextFig,pVal,pVal,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
       %%%% residNormPs %%%%%
        plotData = dataStruct.residNormPs;
        titlesExt = 'residNormPs';
        xLimits = [];
        plotData = GlmResultsCalcLog10(plotData);
        [mu stDev pVal] = GlmResultsCalcMedC95P(plotData);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%% residMeanPs %%%%%
        plotData = dataStruct.residMeanPs;
        titlesExt = 'residMeanPs';
        xLimits = [];
        plotData = GlmResultsCalcLog10(plotData);
        [mu stDev pVal] = GlmResultsCalcMedC95P(plotData);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%% contDwPvals %%%%%
        plotData = dataStruct.contDwPvals;
        titlesExt = 'contDwPvals';
        xLimits = [];
        plotData = GlmResultsCalcLog10(plotData);
        [mu stDev pVal] = GlmResultsCalcMedC95P(plotData);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%% categDwPvals %%%%%
        plotData = dataStruct.categDwPvals;
        titlesExt = 'categDwPvals';
        xLimits = [];
        plotData = GlmResultsCalcLog10(plotData);
        [mu stDev pVal] = GlmResultsCalcMedC95P(plotData);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%% prllPvals %%%%%
         plotData = dataStruct.prllPvals;
        titlesExt = 'prllPvals';
        xLimits = [];
        plotData = GlmResultsCalcLog10(plotData);
        [mu stDev pVal] = GlmResultsCalcMedC95P(plotData);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
               
        if reportFigBool
            ReportFigSM(1:nextFig-1,Dot2Underscore(['/u12/smm/public_html/NewFigs/' saveDir statsDir '/' chanLocVersion '/' analRoutine '/' spectAnalDir fileExt '/']));
        end
        if printFigBool
            length(fNames) == 2
            PrintSaveFig([depVarCell{a} '_' analRoutine Dot2Underscore(fileExt) '_bf' Dot2Underscore(num2str(bonfFactor)) 'subtrBeta'],4);
%             print(4,'-depsc2',[depVarCell{a} '_' analRoutine Dot2Underscore(fileExt) '_bf' Dot2Underscore(num2str(bonfFactor)) 'subtrBeta.eps']);
%             print(4,'-dpng',[depVarCell{a} '_' analRoutine Dot2Underscore(fileExt) '_bf' Dot2Underscore(num2str(bonfFactor)) 'subtrBeta.png']);
        else
            PrintSaveFig([depVarCell{a} '_' analRoutine Dot2Underscore(fileExt) '_bf' Dot2Underscore(num2str(bonfFactor)) 'beta'],1);
%             print(1,'-depsc2',[depVarCell{a} '_' analRoutine Dot2Underscore(fileExt) '_bf' Dot2Underscore(num2str(bonfFactor)) 'beta.eps']);
%             print(1,'-dpng',[depVarCell{a} '_' analRoutine Dot2Underscore(fileExt) '_bf' Dot2Underscore(num2str(bonfFactor)) 'beta.png']);
        end
     
       
    end
end
SetWarnings(prevWarn);
return

function nextFig = LocalPlotBarHelper(nextFig,mu,stDev,pVal,selChCol,anatNames,titlesExt,xLimits,fileName,statAlpha)
addpath /u12/smm/matlab/Plotting/Bar/
resizeWinBool = 1;
figSizeFactor = 2.5;
figVertOffset = 0.5;
figHorzOffset = 0;

figure(nextFig)
clf
nextFig = nextFig + 1;

plotNames=fieldnames(mu);

set(gcf,'name',fileName);
defaultAxesPosition = [0.1,0.1,0.85,0.70];
set(gcf,'DefaultAxesPosition',defaultAxesPosition);
if resizeWinBool
    set(gcf, 'Units', 'inches')
    set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(length(plotNames)),figSizeFactor])
    set(gcf, 'PaperPosition', [figHorzOffset,figVertOffset,figSizeFactor*(length(plotNames)),figSizeFactor])
end
anatNames = flipud(anatNames);
for j=1:length(plotNames)
    subplot(1,length(plotNames),j)
    hold on  
    tempMu = flipud(mu.(plotNames{j})(:,selChCol));
    tempStDev = flipud(stDev.(plotNames{j})(:,selChCol));
    if ~isempty(pVal)
        tempPval = flipud(pVal.(plotNames{j})(:,selChCol));
    end
    barh(tempMu,0.7)
    set(gca,'fontsize',5,'ytick',1:length(anatNames),'yticklabel',anatNames)
    set(gca,'ylim',[0 length(anatNames)+1])
    hold on
%     keyboard
    if iscell(tempStDev)
        plot(cat(2,tempStDev{:}),[1:size(stDev.(plotNames{j}),1);1:size(stDev.(plotNames{j}),1)],'color',[0.65 0.65 0.65])
    else
        plot([tempMu tempMu+tempStDev.*sign(tempMu)]',...
            [ get(gca,'ytick'); get(gca,'ytick') ],'b')
    end
    if ~isempty(xLimits)
%     if strcmp(plotNames{j},'Constant')
%         if tempMu < 1
%             set(gca,'xlim',[0 1])
%         else
%             set(gca,'xlim',[0 100])
%         end
%         title(SaveTheUnderscores([plotNames{j} ' ' titlesExt ]))
%     else
%         if ~isempty(xLimits)
%             set(gca,'xlim',xLimits)
%         end
        if iscell(xLimits)
            set(gca,'xlim',xLimits{j})
        else
            set(gca,'xlim',xLimits)
        end
    end
    if ~strcmp(plotNames{j},'Constant')
        if ~isempty(pVal)
            title(SaveTheUnderscores([plotNames{j} ' ' titlesExt ' p<' num2str(statAlpha)]))
            for k=1:length(anatNames)%length(anatNames):-1:1
                if ~isnan(tempPval(k)) & (tempPval(k) < statAlpha)
                    if isempty(xLimits)
                        xlims = get(gca,'xlim');
                    elseif iscell(xLimits)
                        xlims = xLimits{j};
                    else
                        xlims = xLimits;
                    end
                    if 0
                        plot(xlims(1),k,'*','color',[1 0 0])
                    else
                        plot(xlims(2),k,'*','color',[1 0 0])
                    end
                end
            end
        else
            title(SaveTheUnderscores([plotNames{j} ' ' titlesExt ]))
        end
    end
end
return


