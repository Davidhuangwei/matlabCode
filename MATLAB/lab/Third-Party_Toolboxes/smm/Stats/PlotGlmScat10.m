function PlotGlmScat09(depVarCell,spectAnalDir,fileExt,chanLocVersion,analRoutine,varargin)
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
[analDirs betaXlim reportFigBool dirname saveDir statAlpha plotColors] = DefaultArgs(varargin,...
    {analDirs,[],1,'GlmWholeModel08','MazePaper/',0.01,...
    [1 0 0;0 1 0;0 0 1;0 0 0;1 0 1;0 1 1;0.3 0.3 0.3;1 1 0]});
chanInfoDir = 'ChanInfo/';

prevWarn = SetWarnings({'off','MATLAB:divideByZero'});

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
    'gammaCohMean40-100Hz',...
    'thetaCohMean4-12Hz',...
    'thetaPhaseMean4-12Hz',...
    'thetaPhaseMean6-12Hz.ca3Pyr',...
    'gammaPhaseMean40-100Hz',...
    'gammaCohMean40-120Hz.ca3Pyr',...
    'gammaCohMean40-120Hz.ECs',...
    'gammaCohMean40-120Hz.ECsm',...
    'gammaCohMean40-120Hz.ECdm',...
    'gammaCohMean40-120Hz.ECd',...
    'gammaCohMean40-120Hz.CA1p',...
    'thetaCohMean4-12Hz.ECs',...
    'thetaCohMean4-12Hz.ECsm',...
    'thetaCohMean4-12Hz.ECdm',...
    'thetaCohMean4-12Hz.ECd',...
    'thetaCohMean4-12Hz.CA1p',...
'gammaCohMean40-120Hz.or',...
'thetaCohMean4-12Hz.or',...
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
    if ~isempty([strfind(depVar,'.') strfind(depVar,'.')])
        selChanNames = {''};
        selChanBool = 0;
    end
        
    dataStruct = GlmResultsLoad01(depVar,chanLocVersion,spectAnalDir,fileExt,analRoutine,analDirs,dirname,selChanBool,saveDir,reportFigBool);
    catDataStruct = GlmResultsCatAnimal(dataStruct,0);

    varNames = fieldnames(dataStruct.coeffs);
     [nLayers nSelChan] = size(catDataStruct.coeffs.(varNames{1}));
%     alpha = baseAlpha/(nLayers*nSelChan);
    for b=1:nSelChan
        fileName = [depVar '_' selChanNames{b} '_scat'];

        nextFig = 1;
        %%%%%%% coeffs %%%%%%%%
        plotData = dataStruct.coeffs;
        catPlotData = catDataStruct.coeffs;
        titlesExt = 'beta';
        xLimits = betaXlim;
        [mu stDev pVal] = GlmResultsCalcMuStdP(catPlotData,1);
        nextFig = LocalPlotScatHelper(nextFig,plotData,pVal,b,anatNames,titlesExt,xLimits,fileName,statAlpha,plotColors);
        %%%%% rSqs %%%%%%
        plotData = dataStruct.rSqs;
        titlesExt = 'rSq';
        xLimits = [0 1];
        nextFig = LocalPlotScatHelper(nextFig,plotData,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha,plotColors);
        %%%%% pVals %%%%%%
        plotData = dataStruct.pVals;
        titlesExt = 'pVal';
        xLimits = [];
        nextFig = LocalPlotScatHelper(nextFig,plotData,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha,plotColors);
        %%%% residNormPs %%%%%
        plotData = dataStruct.residNormPs;
        titlesExt = 'residNormPs';
        xLimits = [];
        nextFig = LocalPlotScatHelper(nextFig,plotData,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha,plotColors);
        %%%% residMeanPs %%%%%
        plotData = dataStruct.residMeanPs;
        titlesExt = 'residMeanPs';
        xLimits = [];
        nextFig = LocalPlotScatHelper(nextFig,plotData,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha,plotColors);
        %%%% contDwPvals %%%%%
        plotData = dataStruct.contDwPvals;
        titlesExt = 'contDwPvals';
        xLimits = [];
        nextFig = LocalPlotScatHelper(nextFig,plotData,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha,plotColors);
        %%%% categDwPvals %%%%%
        plotData = dataStruct.categDwPvals;
        titlesExt = 'categDwPvals';
        xLimits = [];
        nextFig = LocalPlotScatHelper(nextFig,plotData,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha,plotColors);
        %%%% prllPvals %%%%%
        plotData = dataStruct.prllPvals;
        titlesExt = 'prllPvals';
        xLimits = [];
        nextFig = LocalPlotScatHelper(nextFig,plotData,[],b,anatNames,titlesExt,xLimits,fileName,statAlpha,plotColors);
     
        comment = {};
        for j=1:length(analDirs)
            if iscell(analDirs{j})
                comment = cat(1,comment,cat(2,[analDirs{j}]',repmat({' = '},size([analDirs{j}]',1),1),...
                    repmat({num2str(plotColors(j,:))},size([analDirs{j}]',1),1)));
%             else
%                  comment = cat(1,comment,cat(2,analDirs(j),repmat({' = '},size([analDirs{j}]',1),1),...
%                     repmat({num2str(plotColors(j,:))},size([analDirs{j}]',1),1)));
           end
        end
        for j=1:size(comment,1)
            newComment{j,1} = [comment{j,:}];
        end
        if reportFigBool
            ReportFigSM(1:nextFig-1,...
                Dot2Underscore(['/u12/smm/public_html/NewFigs/' saveDir dirname '/' chanLocVersion '/' analRoutine '/' spectAnalDir fileExt '/']),...
                [],[],repmat({newComment},nextFig-1,1));
        end
       
    end
end
SetWarnings(prevWarn);
return

function nextFig = LocalPlotScatHelper(nextFig,plotData,pVal,selChCol,anatNames,titlesExt,xLimits,fileName,statAlpha,plotColors)
resizeWinBool = 1;
figSizeFactor = 2.5;
figVertOffset = 0.5;
figHorzOffset = 0;

figure(nextFig)
clf
nextFig = nextFig + 1;

plotNames=fieldnames(plotData);

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
    for k=1:length(plotData.(plotNames{j}))
        tempPlot = flipud(plotData.(plotNames{j}){k}(:,selChCol));
        for m=1:length(tempPlot)
            plot(tempPlot{m},repmat(m,size(tempPlot{m})),'o','color',plotColors(k,:));
        end
    end
    if ~isempty(pVal)
        tempPval = flipud(pVal.(plotNames{j})(:,selChCol));
    end
    set(gca,'fontsize',5,'ytick',1:length(anatNames),'yticklabel',anatNames)
    grid on
    if isempty(xLimits)
        xlims = get(gca,'xlim');
    elseif iscell(xLimits)
        xlims = xLimits{j};
    else
        xlims = xLimits;
    end
   
%     if strcmp(plotNames{j},'Constant')
%         if 1 < 1
%             set(gca,'xlim',[0 1])
%         else
%             set(gca,'xlim',[0 100])
%         end
%         title(SaveTheUnderscores([plotNames{j} ' ' titlesExt ]))
%     else
%         if ~isempty(xLimits)
%             set(gca,'xlim',xLimits)
%         end
set(gca,'xlim',xlims)
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
%     end
end
return


