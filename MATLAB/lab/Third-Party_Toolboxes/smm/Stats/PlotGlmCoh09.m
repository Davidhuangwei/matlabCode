function PlotGlmCoh09(depVarCell,spectAnalDir,fileExt,chanLocVersion,analRoutine,varargin)
%function PlotGlmCoh08(depVarCell,fileExt,chanLocVersion,analRoutine,varargin)
% [analDirs betaClim reportFigBool statsDir saveDir statAlpha nonSigSat nonSigVal] = ...
%     DefaultArgs(varargin,{analDirs,[],1,'GlmWholeModel08','REMPaper/',0.001,0.35,0.35});
analDirs = {...
    {'/BEEF01/smm/sm9601_Analysis/2-13-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-14-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-15-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-16-04/analysis/'},...
    {'/BEEF02/smm/sm9608_Analysis/7-15-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-16-04/analysis/'},...
    {'/BEEF01/smm/sm9603_Analysis/3-20-04/analysis/',...
    '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/'},...
    {'/BEEF02/smm/sm9614_Analysis/4-16-05/analysis/',...
   '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/'},...
    };
[analDirs betaClimCell reportFigBool statsDir saveDir statAlpha nonSigSat nonSigVal] = ...
    DefaultArgs(varargin,{analDirs,[],1,'GlmWholeModel08','REMPaper/',0.001,0.35,0.35});

prevWarn = SetWarnings({'off','MATLAB:divideByZero'});
%for paper
% nonSigSat = 0.15
% nonSigVal = 1

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
    'gammaCohMean40-100Hz',...
    'thetaCohMean4-12Hz',...
    'thetaPhaseMean4-12Hz',...
    'thetaPhaseMean6-12Hz',...
    'gammaPhaseMean40-100Hz',...
    'gammaPhaseMean40-120Hz',...
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
    
    dataStruct = GlmResultsLoad01(depVar,chanLocVersion,spectAnalDir,fileExt,analRoutine,analDirs,statsDir,selChanBool);
    dataStruct = GlmResultsCatAnimal(dataStruct,1,depVarType);

    varNames = fieldnames(dataStruct.coeffs);
%     [nLayers nSelChan] = size(dataStruct.coeffs.(varNames{1}));
%     alpha = baseAlpha/(nLayers*(nSelChan+1)/2);
    fileName = [depVar];
    nextFig = 1;
    %%%%%%% coeffs %%%%%%%%
    plotData = dataStruct.coeffs;
    titlesExt = 'beta';
    colorLimits = [betaClimCell];
    [mu stDev pVal] = GlmResultsCalcMuStdP(plotData);
    transMu = GlmResultsUnTransform(mu,depVarType);
    mu.Constant = transMu.Constant;
    constantMu = mu.Constant;
    betaPval = pVal;
    nextFig = LocalImageHelper(nextFig,mu,pVal,fileName,titlesExt,anatNames,selChanNames,colorLimits,statAlpha,nonSigSat,nonSigVal);
    %%%%%%% coeffs pVal %%%%%%%%
    plotData = dataStruct.coeffs;
    titlesExt = 'betaPval';
    colorLimits = repmat({[0 -3]},length(varNames),1);
    [mu stDev pVal] = GlmResultsCalcMuStdP(plotData);
    pVal = GlmResultsCalcLog10(pVal);
    nextFig = LocalImageHelper(nextFig,pVal,[],fileName,titlesExt,anatNames,selChanNames,colorLimits,statAlpha,nonSigSat,nonSigVal);
    
    %%%%%%% UnTransCoeffs %%%%%%%%
    plotData = dataStruct.coeffs;
    titlesExt = 'transBeta';
    colorLimits = [betaClimCell];
    [mu stDev pVal] = GlmResultsCalcMuStdP(plotData);
    transMu = GlmResultsUnTransform(mu,depVarType);
    mu = GlmResultsAddConst(transMu,-0.5);
    mu.Constant = transMu.Constant;
    nextFig = LocalImageHelper(nextFig,mu,betaPval,fileName,titlesExt,anatNames,selChanNames,colorLimits,statAlpha,nonSigSat,nonSigVal);
    %%%%%%% categMeans %%%%%%%%
%     plotData = dataStruct.categMeans;
%     titlesExt = 'categMeans';
%     colorLimits = [betaClimCell(2:end)];
%     [mu stDev pVal] = GlmResultsCalcMuStdP(plotData);
%     mu = GlmResultsUnTransform(mu,depVarType);
%     mu = GlmResultsSubtractConst(mu,constantMu);
%     nextFig = LocalImageHelper(nextFig,mu,betaPval,fileName,titlesExt,anatNames,selChanNames,colorLimits,statAlpha,nonSigSat,nonSigVal);
    %%%%% rSqs %%%%%%
    plotData = dataStruct.rSqs;
    titlesExt = 'rSq';
    colorLimits = repmat({[0 1]},length(varNames),1);
    [mu stDev pVal] = GlmResultsCalcMuStdP(plotData);
    nextFig = LocalImageHelper(nextFig,mu,[],fileName,titlesExt,anatNames,selChanNames,colorLimits,statAlpha,nonSigSat,nonSigVal);
    %%%%% pVals %%%%%%
    plotData = dataStruct.pVals;
    titlesExt = 'pVal';
    colorLimits = repmat({[0 -10]},length(varNames),1);
    plotData = GlmResultsCalcLog10(plotData);
    [mu stDev pVal] = GlmResultsCalcMuStdP(plotData);
    nextFig = LocalImageHelper(nextFig,mu,[],fileName,titlesExt,anatNames,selChanNames,colorLimits,statAlpha,nonSigSat,nonSigVal);
    %%%%%%% coeffNormP %%%%%%%%
    plotData = dataStruct.coeffs;
    titlesExt = 'coeffNormP';
    colorLimits = repmat({[0 -5]},length(varNames),1);
    pVal = GlmResultsCalcNormP(plotData);
    pVal = GlmResultsCalcLog10(pVal);
    nextFig = LocalImageHelper(nextFig,pVal,[],fileName,titlesExt,anatNames,selChanNames,colorLimits,statAlpha,nonSigSat,nonSigVal);
    %%%% residNormPs %%%%%
    plotData = dataStruct.residNormPs;
    titlesExt = 'residNormPs';
    colorLimits = repmat({[0 -3]},length(varNames),1);
    plotData = GlmResultsCalcLog10(plotData);
    [mu stDev pVal] = GlmResultsCalcMuStdP(plotData);
    nextFig = LocalImageHelper(nextFig,mu,[],fileName,titlesExt,anatNames,selChanNames,colorLimits,statAlpha,nonSigSat,nonSigVal);
    %%%% residMeanPs %%%%%
    plotData = dataStruct.residMeanPs;
    titlesExt = 'residMeanPs';
    colorLimits = repmat({[0 -3]},length(varNames),1);
    plotData = GlmResultsCalcLog10(plotData);
    [mu stDev pVal] = GlmResultsCalcMuStdP(plotData);
    nextFig = LocalImageHelper(nextFig,mu,[],fileName,titlesExt,anatNames,selChanNames,colorLimits,statAlpha,nonSigSat,nonSigVal);
    %%%% contDwPvals %%%%%
    plotData = dataStruct.contDwPvals;
    titlesExt = 'contDwPvals';
    colorLimits = repmat({[0 -3]},length(varNames),1);
    plotData = GlmResultsCalcLog10(plotData);
    [mu stDev pVal] = GlmResultsCalcMuStdP(plotData);
    nextFig = LocalImageHelper(nextFig,mu,[],fileName,titlesExt,anatNames,selChanNames,colorLimits,statAlpha,nonSigSat,nonSigVal);
    %%%% categDwPvals %%%%%
    plotData = dataStruct.categDwPvals;
    titlesExt = 'categDwPvals';
    colorLimits = repmat({[0 -3]},length(varNames),1);
    plotData = GlmResultsCalcLog10(plotData);
    [mu stDev pVal] = GlmResultsCalcMuStdP(plotData);
    nextFig = LocalImageHelper(nextFig,mu,[],fileName,titlesExt,anatNames,selChanNames,colorLimits,statAlpha,nonSigSat,nonSigVal);
    %%%% prllPvals %%%%%
    plotData = dataStruct.prllPvals;
    titlesExt = 'prllPvals';
    colorLimits = repmat({[0 -3]},length(varNames),1);
    plotData = GlmResultsCalcLog10(plotData);
    [mu stDev pVal] = GlmResultsCalcMuStdP(plotData);
    nextFig = LocalImageHelper(nextFig,mu,[],fileName,titlesExt,anatNames,selChanNames,colorLimits,statAlpha,nonSigSat,nonSigVal);
    
    if reportFigBool
        fprintf('Reporting: %s\n',Dot2Underscore(['/u12/smm/public_html/NewFigs/' saveDir statsDir '/' chanLocVersion '/' analRoutine '/' spectAnalDir fileExt '/']))
        ReportFigSM(1:nextFig-1,Dot2Underscore(['/u12/smm/public_html/NewFigs/' saveDir statsDir '/' chanLocVersion '/' analRoutine '/' spectAnalDir fileExt '/']));
    end

end
SetWarnings(prevWarn);
return

function nextFig = LocalImageHelper(nextFig,plotData,valueData,figName,titleBase,yTickLabels,xTickLabels,varargin)
% function nextFig = LocalImageHelper(nextFig,plotData,valueData,log10Bool,figName,titleBase,commonCLim,colorLimits,yTickLabels,xTickLabels)
try
    analNames = fieldnames(plotData);
[colorLimits statAlpha sat val] = DefaultArgs(varargin,{cell(length(analNames),1),0.001,0.3,0.3});
valNaN = 0.35;

figure(nextFig)
nextFig = nextFig + 1;
clf
resizeWinBool = 1;
figSizeFactor = 2.5;
figVertOffset = 0.5;
figHorzOffset = 0;

defaultAxesPosition = [0.1,0.15,0.85,0.70];
set(gcf,'DefaultAxesPosition',defaultAxesPosition);
set(gcf,'name',figName)

%baseAlpha = 0.01;
% pValCut = log10(baseAlpha./((length(valueData.(analNames{1}))+1)*length(valueData.(analNames{1}))/2));

if resizeWinBool
    set(gcf, 'Units', 'inches')
    set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(length(analNames)),figSizeFactor])
    set(gcf, 'PaperPosition', [figHorzOffset,figVertOffset,figSizeFactor*(length(analNames)),figSizeFactor])
end
% if isempty(colorLimits)
%     colorLimits = [NaN NaN];
%     autoCLim = 1;
% else
%     autoCLim = 0;
% end
%keyboard
% for j=1:length(analNames)
%     %     if log10Bool
%     %         plotData.(analNames{j}) = log10(plotData.(analNames{j}));
%     %     end
%     if 
%         ~strcmp(analNames{j},'Constant') & commonCLim > 0 & autoCLim
%         temp = max([abs(colorLimits(1)) max(max(abs(plotData.(analNames{j}))))]);
%         colorLimits = [-temp temp];
%     end
% end
for j=1:length(analNames)
    subplot(1,length(analNames),j)
    hold on
%     if commonCLim == 0  & autoCLim
%         colorLimits = [min(min(plotData.(analNames{j}))) max(max(plotData.(analNames{j})))];
%     end
    if isempty(colorLimits{j})
        cLimits = [min(min(plotData.(analNames{j}))) max(max(plotData.(analNames{j})))];
        if ~strcmp(analNames{j},'Constant')
            cLimits = [-max(abs(cLimits)) max(abs(cLimits))];
        end
    else
        cLimits  = colorLimits{j};
    end
    plotTemp = plotData.(analNames{j});
%     plotTemp(:,1) = NaN;
    plotNaNs = isnan(plotTemp);
    plotTemp(plotNaNs) = 0;
%     if strcmp(analNames{j},'Constant') %& commonCLim ~=2
%         valMask = ones(size(plotData.(analNames{j})));
%         triuMask = triu(ones(size(plotData.(analNames{j}))),1);
%         satMask = valMask;
%         satMask(satMask~=1) = sat;
%         satMask(triuMask==1) = 0;
%         valMask(valMask~=1) = val;
%         satMask(plotNaNs) = 0;
%         valMask(plotNaNs) = valNaN;
%         valMask(triuMask==1) = 1;
%         ImageScHSV(plotTemp,satMask,valMask,[cLimits]);
%         title(SaveTheUnderscores([titleBase, ' ' analNames{j}]),'fontsize',3);
    
    if isempty(valueData) | strcmp(analNames{j},'Constant')
        valMask = ones(size(plotData.(analNames{j})));
        triuMask = tril(ones(size(plotData.(analNames{j}))),-1);
        satMask = valMask;
        satMask(satMask~=1) = sat;
        satMask(triuMask==1) = 0;
        valMask(valMask~=1) = val;
        satMask(plotNaNs) = 0;
        valMask(plotNaNs) = valNaN;
        valMask(triuMask==1) = 1;
        ImageScHSV(plotTemp,satMask,valMask,[cLimits]);
        title(SaveTheUnderscores([titleBase, ' ' analNames{j}]),'fontsize',3);
    else
        valMask = clip((log10(valueData.(analNames{j}))/log10(statAlpha)),0,1);
        triuMask = tril(ones(size(plotData.(analNames{j}))),-1);
        satMask = valMask;
        satMask(satMask~=1) = sat;
        satMask(triuMask==1) = 0;
        valMask(valMask~=1) = val;
        satMask(plotNaNs) = 0;
        valMask(plotNaNs) = valNaN;
        valMask(triuMask==1) = 1;
        ImageScHSV(plotTemp,satMask,valMask,cLimits);
        title(SaveTheUnderscores([titleBase, ' ' analNames{j} ' p<' num2str(statAlpha,'%1.5f')]),'fontsize',3);
    end
    set(gca,'fontsize',3,'ytick',[1:length(yTickLabels)],'yticklabel',yTickLabels,'ylim',[0.5 length(yTickLabels)+0.5])
    set(gca,'fontsize',3,'xtick',[1:length(xTickLabels)],'xticklabel',xTickLabels,'xlim',[0.5 length(xTickLabels)+0.5])
    %plot(1:length(xTickLabels),1:length(yTickLabels),'-','color',[0.5 0.5 0.5])
end
catch
    keyboard
end
return



