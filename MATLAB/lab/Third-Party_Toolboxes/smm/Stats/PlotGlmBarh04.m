function PlotGlmBarh04(depVarCell,spectAnalDir,fileExt,chanLocVersion,analRoutine,varargin)

[analDirs betaXlimCell reportFigBool chanLocVersion saveDir statAlpha] = ...
    DefaultArgs(varargin,{[],[],0,'Min','/u12/smm/public_html/NewFigs/',0.01});


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
        
    dataStruct = GlmResultsLoad01(depVar,chanLocVersion,spectAnalDir,fileExt,analRoutine,analDirs,dirname,selChanBool,saveDir,reportFigBool);
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
        [mu stDev pVal] = GlmResultsCalcMuStdP(plotData,1);
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
        [mu stDev pVal] = GlmResultsCalcMuStdP(plotData,1);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%%%%% categMeans %%%%%%%%
        plotData = dataStruct.categMeans;
        titlesExt = 'categMeans';
        xLimits = betaXlimCell;
        [mu stDev pVal] = GlmResultsCalcMuStdP(plotData,1);
        mu = GlmResultsUnTransform(mu,depVarType);
        mu = GlmResultsSubtractConst(mu,constantMu);
        nextFig = LocalPlotBarHelper(nextFig,mu,betaStDev,betaPval,b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%%% pVals %%%%%%
        plotData = dataStruct.pVals;
        titlesExt = 'pVal';
        xLimits = [];
        plotData = GlmResultsCalcLog10(plotData);
        [mu stDev pVal] = GlmResultsCalcMuStdP(plotData,1);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%% residNormPs %%%%%
        plotData = dataStruct.residNormPs;
        titlesExt = 'residNormPs';
        xLimits = [];
        plotData = GlmResultsCalcLog10(plotData);
        [mu stDev pVal] = GlmResultsCalcMuStdP(plotData,1);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%% residMeanPs %%%%%
        plotData = dataStruct.residMeanPs;
        titlesExt = 'residMeanPs';
        xLimits = [];
        plotData = GlmResultsCalcLog10(plotData);
        [mu stDev pVal] = GlmResultsCalcMuStdP(plotData,1);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%% contDwPvals %%%%%
        plotData = dataStruct.contDwPvals;
        titlesExt = 'contDwPvals';
        xLimits = [];
        plotData = GlmResultsCalcLog10(plotData);
        [mu stDev pVal] = GlmResultsCalcMuStdP(plotData,1);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%% categDwPvals %%%%%
        plotData = dataStruct.categDwPvals;
        titlesExt = 'categDwPvals';
        xLimits = [];
        plotData = GlmResultsCalcLog10(plotData);
        [mu stDev pVal] = GlmResultsCalcMuStdP(plotData,1);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%% prllPvals %%%%%
         plotData = dataStruct.prllPvals;
        titlesExt = 'prllPvals';
        xLimits = [];
        plotData = GlmResultsCalcLog10(plotData);
        [mu stDev pVal] = GlmResultsCalcMuStdP(plotData,1);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
     
        if reportFigBool
            ReportFigSM(1:nextFig-1,Dot2Underscore(['/u12/smm/public_html/NewFigs/' saveDir dirname '/' chanLocVersion '/' analRoutine '/' spectAnalDir fileExt '/']));
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
    hold on
    plot([tempMu tempMu+tempStDev.*sign(tempMu)]',...
        [ get(gca,'ytick'); get(gca,'ytick') ],'b')
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


