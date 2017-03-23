function PlotGlmBarh03(depVarCell,spectAnalDir,fileExt,chanLocVersion,analRoutine,varargin)
%function PlotGlmBarh03(depVarCell,fileExt,chanLocVersion,analRoutine,varargin)
% [analDirs betaClim reportFigBool dirname saveDir statAlpha] = ...
%     DefaultArgs(varargin,{analDirs,[],1,'GlmWholeModel08','MazePaper/',0.01});
analDirs = {...
    {'/BEEF01/smm/sm9601_Analysis/2-13-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-14-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-15-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-16-04/analysis/'},...
    {'/BEEF02/smm/sm9608_Analysis/7-15-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-16-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-17-04/analysis/'},...
    {'/BEEF01/smm/sm9603_Analysis/3-20-04/analysis/',...
    '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/'},...
    {'/BEEF02/smm/sm9614_Analysis/4-16-05/analysis/',...
   '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/'},...
    };
[analDirs betaXlim reportFigBool dirname saveDir statAlpha] = DefaultArgs(varargin,{analDirs,[],1,'GlmWholeModel08','MazePaper/',0.01});
chanInfoDir = 'ChanInfo/';

depVarPoss = {...
    'gammaCohMean60-120Hz',...
    'gammaCohMean40-100Hz',...
    'gammaCohMean40-120Hz',...
    'gammaCohMean50-100Hz',...
    'gammaCohMean50-120Hz',...
    'thetaCohMean6-12Hz',...
    'thetaCohPeakSelChF6-12Hz',...
    'thetaCohMedian6-12Hz',...
    'gammaCohMedian60-120Hz',...
    'thetaCohPeakLMF6-12Hz',...
    'thetaPowIntg4-12Hz',...
    'thetaPowIntg6-12Hz',...
    'gammaPowIntg40-100Hz',...
    'gammaPowIntg40-120Hz',...
    'gammaPowIntg50-100Hz',...
    'gammaPowIntg50-120Hz',...
    'gammaCohMean40-100Hz',...
    'thetaCohMean4-12Hz',...
    'thetaPhaseMean4-12Hz',...
    'gammaPhaseMean40-100Hz',...
    };


depVarCell = intersect(depVarCell,depVarPoss);

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
        log10Bool = 0;
        xLimits = betaXlim;
        %plotData = GlmResultsLog10(plotData);
        [mu stDev pVal] = GlmResultsCalcMuStdP(plotData,log10Bool,depVarType);
        mu = GlmResultsUnTransform(mu,depVarType);
        constantMu = mu.Constant;
        betaPval = pVal;
        betaStDev = stDev;
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,pVal,b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%%% rSqs %%%%%%
        plotData = dataStruct.rSqs;
        titlesExt = 'rSq';
        log10Bool = 0;
        xLimits = [0 1];
        [mu stDev pVal] = GlmResultsCalcMuStdP(plotData,log10Bool,depVarType);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%%%%% categMeans %%%%%%%%
        plotData = dataStruct.categMeans;
        titlesExt = 'categMeans';
        log10Bool = 0;
        xLimits = betaXlim;
        [mu stDev pVal] = GlmResultsCalcMuStdP(plotData,log10Bool,depVarType);
        mu = GlmResultsSubtractConst(mu,constantMu);
        nextFig = LocalPlotBarHelper(nextFig,mu,betaStDev,betaPval,b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        keyboard
        %%%%% pVals %%%%%%
        plotData = dataStruct.pVals;
        titlesExt = 'pVal';
        log10Bool = 1;
        xLimits = [];
        [mu stDev pVal] = GlmResultsCalcMuStdP(plotData,log10Bool,depVarType);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%% residNormPs %%%%%
        plotData = dataStruct.residNormPs;
        titlesExt = 'residNormPs';
        log10Bool = 1;
        xLimits = [];
        [mu stDev pVal] = GlmResultsCalcMuStdP(plotData,log10Bool,depVarType);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%% residMeanPs %%%%%
        plotData = dataStruct.residMeanPs;
        titlesExt = 'residMeanPs';
        log10Bool = 1;
        xLimits = [];
        [mu stDev pVal] = GlmResultsCalcMuStdP(plotData,log10Bool,depVarType);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%% contDwPvals %%%%%
        plotData = dataStruct.contDwPvals;
        titlesExt = 'contDwPvals';
        log10Bool = 1;
        xLimits = [];
        [mu stDev pVal] = GlmResultsCalcMuStdP(plotData,log10Bool,depVarType);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%% categDwPvals %%%%%
        plotData = dataStruct.categDwPvals;
        titlesExt = 'categDwPvals';
        log10Bool = 1;
        xLimits = [];
        [mu stDev pVal] = GlmResultsCalcMuStdP(plotData,log10Bool,depVarType);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
        %%%% prllPvals %%%%%
         plotData = dataStruct.prllPvals;
        titlesExt = 'prllPvals';
        log10Bool = 1;
        xLimits = [];
        [mu stDev pVal] = GlmResultsCalcMuStdP(plotData,log10Bool,depVarType);
        nextFig = LocalPlotBarHelper(nextFig,mu,stDev,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha);
     
        if reportFigBool
            ReportFigSM(1:nextFig-1,Dot2Underscore(['/u12/smm/public_html/NewFigs/' saveDir dirname '/' chanLocVersion '/' analRoutine '/' spectAnalDir fileExt '/']));
        end
       
    end
end
return

function nextFig = LocalPlotBarHelper(nextFig,mu,stDev,pVal,selChCol,anatNames,titlesExt,xLimits,fileName,statAlpha)
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

    if strcmp(plotNames{j},'Constant')
        if tempMu < 1
            set(gca,'xlim',[0 1])
        else
            set(gca,'xlim',[0 100])
        end
        title(SaveTheUnderscores([plotNames{j} ' ' titlesExt ]))
    else
        if ~isempty(xLimits)
            set(gca,'xlim',xLimits)
        end
        if ~isempty(pVal)
            title(SaveTheUnderscores([plotNames{j} ' ' titlesExt ' p<' num2str(statAlpha)]))
            for k=1:length(anatNames)%length(anatNames):-1:1
                if ~isnan(tempPval(k)) & (tempPval(k) < statAlpha)
                    if isempty(xLimits)
                        xlims = get(gca,'xlim');
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


