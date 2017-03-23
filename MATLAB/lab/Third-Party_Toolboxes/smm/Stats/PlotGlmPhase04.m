function PlotGlmCoh02(chanLocVersion,fileExt,inNameNote,animalDirs,dirname,reportFigBool)
chanInfoDir = 'ChanInfo/';
reportFigBool = 1;

%dirname = 'GlmWholeModel01';
%inNameNote = 'Alter_secondRun_';
dirname = 'GlmWholeModel05';
%dirname = 'GlmPartialModel03';
%inNameNote = 'Alter_Vs_Control_EachRegion_firstRun';
%inNameNote = 'Alter_groupAnal1';
%inNameNote = 'RemVsThetaFreqSelCh1_01';
%inNameNote = 'MazeVsThetaFreqSelCh1_01';
%inNameNote = 'RemVsThetaFreqSelCh2_01';
%inNameNote = 'MazeVsThetaFreqSelCh1_allTrials_01';
%inNameNote = 'MazeVsThetaFreqSelCh3_01';
%inNameNote = 'MazeVsThetaFreqSelCh2_01';
%inNameNote = 'RemVsThetaFreqSelCh3_01';
%inNameNote = 'MazeVsThetaFreqSelCh3_01';
%inNameNote = 'RemVsRun_thetaFreqSelCh3_01';
%inNameNote = 'RemVsRun_thetaFreqSelCh3_allTrials_01';
%inNameNote = 'RemVsRun_01';
%inNameNote = 'RemVsRun_allTrials_01';
%inNameNote = 'RemVsRun_thetaFreqSelCh1_01';
%inNameNote = 'RemVsRun_thetaFreqSelCh1_allTrials_01';
%inNameNote = 'RemVsRunXthetaFreqSelCh1_01';
%inNameNote = 'RemVsRunXthetaFreqSelCh1_allTrials_01';
%inNameNote = 'RemVsRun_thetaFreqSelCh1_X_01';
%inNameNote = 'RemVsRun_thetaFreqSelCh1_X_allTrials_01';
%inNameNote = 'AlterGood_S0_A0_MR_01';
% inNameNote = 'AlterGood_S0_A0_RL_MR_01';
% inNameNote = 'AlterGood_S0_A0_MR_RLxMR_01';
% inNameNote = 'AlterGood_S0_A0_RL_MR_RLxMR_01';
% inNameNote = 'AlterAll_S0_A0_E_MR_01';
% inNameNote = 'AlterAll_S0_A0_MR_ExMR_01';
% inNameNote = 'AlterAll_S0_A0_E_MR_ExMR_01';
% inNameNote = 'MazeGood_S0_A0_TT_01';
% inNameNote = 'MazeGood_S0_A0_TT_TTxMR_01';
% inNameNote = 'MazeCenter_S0_A0_TT_01';
% inNameNote = 'MazeGood_S1000by500_A1000by500_01';

%fileExt = '.eeg';
%fileExt = '_NearAveCSD1.csd';
%fileExt = '_LinNearCSD121.csd';
%depVar = 'thetaCohMedian4-12Hz';
%depVar = 'gammaCohMedian60-120Hz';
%depVar = 'thetaPhaseMean4-12Hz';
%depVar = 'gammaPhaseMean60-120Hz';

depVarType = 'phase';
depVarCell = {...
%      'thetaCohPeakLMF6-12Hz',...
%      'gammaCohMean60-120Hz',...
   'thetaPhaseMean6-12Hz',...
   'gammaPhaseMean60-120Hz',...
    
    %'thetaCohPeakSelChF4-12Hz',...
    %'thetaCohMean4-12Hz',...
    %'thetaCohMedian4-12Hz',...
    %'gammaCohMedian60-120Hz',...
   };

%animalDirs = {...
%    '/BEEF01/smm/sm9601_Analysis/analysis03/',...
%    '/BEEF01/smm/sm9603_Analysis/analysis04/',...
%    '/BEEF02/smm/sm9614_Analysis/analysis02'...
%    '/BEEF02/smm/sm9608_Analysis/analysis02/',...
%    };
origDir = pwd;

plotColors = [1 0 0;0 0 1;0 1 0;0 0 0];


selChanNums = 1:6
selChanNames = {'pyr1','rad','lm','mol','gran','pyr3'};
for a=1:length(depVarCell)
%for a=1:1
    depVar = depVarCell{a};
    for j=1:length(selChanNums)
        for k=1:length(animalDirs)
            fprintf('\ncd %s',animalDirs{k})
            cd(animalDirs{k})
            if selChanNums
                selChans = load([chanInfoDir 'SelectedChannels' fileExt '.txt']);
                selChanField = ['.ch' num2str(selChans(selChanNums(j)))];
            else
                selChanField = '';
            end
            fprintf('\nLoading %s',[dirname '/' inNameNote '/' fileExt '/' depVar selChanField '.mat'])
            load([dirname '/' inNameNote '/' fileExt '/' depVar selChanField '.mat']);
            chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']);
            chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
            badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);

            anatFields = fieldnames(chanLoc);
            for n=1:length(anatFields)
                goodChans = setdiff(chanLoc.(anatFields{n}),union(badChans,selChans(selChanNums<j)));
                %%%%%%% Betas %%%%%%%%
                varNames = model.coeffNames;
                for m=1:length(varNames);
                    %varNames{m}
                    %try 
                        coeffs.(GenFieldName(varNames{m})).(anatFields{n}).(animalDirs{k}(13:18)){j} = ...
                            model.coeffs(m,goodChans)';
                    %catch keyboard
                    %end
                    if strcmp(varNames{m},'Constant')
                        constantCoeff.(GenFieldName(varNames{m})).(anatFields{n}).(animalDirs{k}(13:18)){j} = ...
                            model.coeffs(m,goodChans)';
                    end
                end
                %%%%%% categMeans %%%%%%%%
                if ~isempty(model.categMeans)
                    for q = 1:length(model.categMeans)
                        varNames = model.categNames{q};
                        for m=1:length(varNames);
                            %                             categMeans{q}.(GenFieldName(varNames{m})).(anatFields{n}).(animalDirs{k}(13:18)) = ...
                            %                                 squeeze(model.categMeans{q}(m,1,goodChans)-...
                            %                                 mean(model.categMeans{q}(:,1,goodChans)));
                            categMeans{q}.(GenFieldName(varNames{m})).(anatFields{n}).(animalDirs{k}(13:18)){j} = ...
                                squeeze(model.categMeans{q}(m,1,goodChans));
                            %- mean(model.categMeans{q}(:,1,goodChans)));
                        end
                    end
                end
                %%%% residNormPs %%%%%
                tempData = MatStruct2StructMat2(assumTest.residNormPs);
                cellData = Struct2CellArray(tempData,[],1);
                tempData = cat(1,cellData{:,end});
                clear varNames;
                for m=1:size(cellData,1)
                    varNames{m,1} = cat(2,cellData{m,1:end-1});
                end
                for m=1:length(varNames);
                    assumPlot.residNormPs.(GenFieldName(varNames{m})).(anatFields{n}).(animalDirs{k}(13:18)){j} = ...
                        tempData(m,goodChans)';
                    %                 if m==1
                    %                 size(tempData(m,goodChans)')
                    %                 j
                    %                 end
                end
                %%%% residMeanPs %%%%%
                tempData = MatStruct2StructMat2(assumTest.residMeanPs);
                cellData = Struct2CellArray(tempData,[],1);
                tempData = cat(1,cellData{:,end});
                clear varNames;
                for m=1:size(cellData,1)
                    varNames{m,1} = cat(2,cellData{m,1:end-1});
                end
                for m=1:length(varNames);
                    assumPlot.residMeanPs.(GenFieldName(varNames{m})).(anatFields{n}).(animalDirs{k}(13:18)){j} = ...
                        tempData(m,goodChans)';
                end
                %                 %%%%%% residNormPs %%%%%%%%
                %                 varNames = fieldnames(assumTest.residNormPs);
                %                 for m=1:length(varNames);
                %                     temp = MatStruct2StructMat2(assumTest.residNormPs);
                %                     residNormPs.(GenFieldName(varNames{m})).(anatFields{n}).(animalDirs{k}(13:18)){j} = ...
                %                         temp.(varNames{m})(goodChans);
                %                 end
                %                 %%%%%% residMeanPs %%%%%%%%
                %                 varNames = fieldnames(assumTest.residMeanPs);
                %                 for m=1:length(varNames);
                %                     temp = MatStruct2StructMat2(assumTest.residMeanPs);
                %                     residMeanPs.(GenFieldName(varNames{m})).(anatFields{n}).(animalDirs{k}(13:18)){j} = ...
                %                         temp.(varNames{m})(goodChans);
                %                end
                %%%% contDwPvals %%%%%
                tempData = MatStruct2StructMat2(assumTest.contDwPvals);
                cellData = Struct2CellArray(tempData,[],1);
                tempData = cat(1,cellData{:,end});
                clear varNames;
                if size(cellData,1)>1
                    for m=1:size(cellData,1)
                        varNames{m,1} = cat(2,cellData{m,1:end-1});
                    end
                else
                    varNames{1,1} = 'none';
                end
                for m=1:length(varNames);
                    assumPlot.contDwPvals.(GenFieldName(varNames{m})).(anatFields{n}).(animalDirs{k}(13:18)){j} = ...
                        tempData(m,goodChans)';
                end
                %%%% categDwPvals %%%%%
                tempData = MatStruct2StructMat2(assumTest.categDwPvals);
                cellData = Struct2CellArray(tempData,[],1);
                tempData = cat(1,cellData{:,end});
                clear varNames;
                for m=1:size(cellData,1)
                    varNames{m,1} = cat(2,cellData{m,1:end-1});
                end
                for m=1:length(varNames);
                    assumPlot.categDwPvals.(GenFieldName(varNames{m})).(anatFields{n}).(animalDirs{k}(13:18)){j} = ...
                        tempData(m,goodChans)';
                end
                %%%% prllPvals %%%%%
                tempData = MatStruct2StructMat2(assumTest.prllPvals);
                cellData = Struct2CellArray(tempData,[],1);
                tempData = cat(1,cellData{:,end});
                clear varNames;
                if size(cellData,1)>1
                    for m=1:size(cellData,1)
                        varNames{m,1} = cat(2,cellData{m,1:end-1});
                    end
                else
                    varNames{1,1} = 'none';
                end
                for m=1:length(varNames);
                    assumPlot.prllPvals.(GenFieldName(varNames{m})).(anatFields{n}).(animalDirs{k}(13:18)){j} = ...
                        tempData(m,goodChans)';
                end
                %%%%%% prllPvals %%%%%%%%
                %                         if isstruct(assumTest.prllPvals)
                %                             varNames = fieldnames(assumTest.prllPvals);
                %                             for m=1:length(varNames);
                %                                 temp = MatStruct2StructMat2(assumTest.prllPvals);
                %                                 assumPlot.prllPvals.(GenFieldName(varNames{m})).(anatFields{n}).(animalDirs{k}(13:18)){j} = ...
                %                                     temp.(varNames{m})(goodChans);
                %
                %                             end
                %                         else
                %                             assumPlot.prllPvals.(GenFieldName(varNames{m})).(anatFields{n}).(animalDirs{k}(13:18)){j} = ...
                %                                 assumTest.prllPvals(goodChans);
                %                         end
            end
        end
    end
    [mu.coeffs p.coeffs] = CalcMuP(coeffs,0,0,depVarType);
    if ~isempty(model.categMeans)
        for q = 1:length(model.categMeans)
            [mu.categMeans{q}] = CalcMuP(categMeans{q},1,0,depVarType,constantCoeff.Constant);
        end
    end
%     [subtjunk] = CalcMuP(categMeans{1},1,0,depVarType,constantCoeff.Constant);
%     [junk] = CalcMuP(categMeans{1},1,0,depVarType);
%     keyboard
%    % function [mu p] = CalcMuP(analData,transMuBool,log10Bool,depVarType,constantCoeff)
% junkConst = CalcMuP(constantCoeff,1,0,depVarType);

    coeffNormP = CalcNormP(coeffs);
    mu.residNormPs = CalcMuP(assumPlot.residNormPs,0,1,depVarType);
    mu.residMeanPs = CalcMuP(assumPlot.residMeanPs,0,1,depVarType);
    mu.contDwPvals = CalcMuP(assumPlot.contDwPvals,0,1,depVarType);
    mu.categDwPvals = CalcMuP(assumPlot.categDwPvals,0,1,depVarType);
    mu.prllPvals = CalcMuP(assumPlot.prllPvals,0,1,depVarType);
    
    nextFig = 1;
    %%%%%%% Betas %%%%%%%%
    plotData = mu.coeffs;
    log10Bool = 0;
    commonCLim = 1;
    colorLimits = [];
    titleBase = 'Beta';
    nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,depVar,titleBase,commonCLim,colorLimits,anatFields,selChanNames);
    plotData = p.coeffs;
    log10Bool = 1;
    commonCLim = 1;
    colorLimits = [0 -5];
    titleBase = 'pVal';
    nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,depVar,titleBase,commonCLim,colorLimits,anatFields,selChanNames);
    %%%%%%% categMeans %%%%%%%%
    for q = 1:length(model.categMeans)
        plotData = mu.categMeans{q};
        log10Bool = 0;
        commonCLim = 1;
        colorLimits = [];
        titleBase = 'categMeans';
        nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,depVar,titleBase,commonCLim,colorLimits,anatFields,selChanNames);
    end
    %%%%%%% coeffNormP %%%%%%%%
    plotData = coeffNormP;
    log10Bool = 1;
    commonCLim = 2;
    colorLimits = [0 -3];
    titleBase = 'coeffNormP';
    nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,depVar,titleBase,commonCLim,colorLimits,anatFields,selChanNames);
    %%%%%%% residNormPs %%%%%%%%
    plotData = mu.residNormPs;
    log10Bool = 0;
    commonCLim = 1;
    colorLimits = [0 -3];
    titleBase = 'residNormPs';
    nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,depVar,titleBase,commonCLim,colorLimits,anatFields,selChanNames);
    %%%%%%% residMeanPs %%%%%%%%
    plotData = mu.residMeanPs;
    log10Bool = 0;
    commonCLim = 1;
    colorLimits = [0 -3];
    titleBase = 'residMeanPs';
    nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,depVar,titleBase,commonCLim,colorLimits,anatFields,selChanNames);
    %%%%%%% contDwPvals %%%%%%%%
    plotData = mu.contDwPvals;
    log10Bool = 0;
    commonCLim = 1;
    colorLimits = [0 -3];
    titleBase = 'contDwPvals';
    nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,depVar,titleBase,commonCLim,colorLimits,anatFields,selChanNames);
    %%%%%%% categDwPvals %%%%%%%%
    plotData = mu.categDwPvals;
    log10Bool = 0;
    commonCLim = 1;
    colorLimits = [0 -3];
    titleBase = 'categDwPvals';
    nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,depVar,titleBase,commonCLim,colorLimits,anatFields,selChanNames);
    %%%%%%% prllPvals %%%%%%%%
    plotData = mu.prllPvals;
    log10Bool = 0;
    commonCLim = 1;
    colorLimits = [0 -3];
    titleBase = 'prllPvals';
    nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,depVar,titleBase,commonCLim,colorLimits,anatFields,selChanNames);
    
    cd(origDir)
    if reportFigBool
        ReportFigSM(1:nextFig-1,Dot2Underscore(['/u12/smm/public_html/NewFigs/' dirname '/' inNameNote '/' fileExt '/']));
    end

end


return
end

function nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,figName,titleBase,commonCLim,colorLimits,yTickLabels,xTickLabels)
figure(nextFig )
clf
nextFig = nextFig + 1;
resizeWinBool = 1;
figSizeFactor = 2.5;
figVertOffset = 0.5;
figHorzOffset = 0;

defaultAxesPosition = [0.1,0.15,0.85,0.70];
set(gcf,'DefaultAxesPosition',defaultAxesPosition);
set(gcf,'name',figName)
analNames = fieldnames(plotData);

if resizeWinBool
    set(gcf, 'Units', 'inches')
    set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(length(analNames)),figSizeFactor])
end
if isempty(colorLimits)
    colorLimits = [NaN NaN];
    autoCLim = 1;
else
    autoCLim = 0;
end
%keyboard
for j=1:length(analNames)
    if log10Bool
        plotData.(analNames{j}) = log10(plotData.(analNames{j}));
    end
    if ~strcmp(analNames{j},'Constant') & commonCLim > 0 & autoCLim
        temp = max([abs(colorLimits(1)) max(max(abs(plotData.(analNames{j}))))]);
        colorLimits = [-temp temp];
    end
end
for j=1:length(analNames)
    subplot(1,length(analNames),j)
    hold on
    if commonCLim == 0  & autoCLim
        colorLimits = [min(min(plotData.(analNames{j}))) max(max(plotData.(analNames{j})))];
    end
    if strcmp(analNames{j},'Constant') & commonCLim ~=2
        ImageScMask(plotData.(analNames{j}));
    else
        ImageScMask(plotData.(analNames{j}),[],colorLimits);
    end
    title(SaveTheUnderscores([titleBase, ' ' analNames{j}]),'fontsize',3);
    set(gca,'fontsize',3,'ytick',[1:length(yTickLabels)],'yticklabel',yTickLabels,'ylim',[0.5 length(yTickLabels)+0.5])
    set(gca,'fontsize',3,'xtick',[1:length(xTickLabels)],'xticklabel',xTickLabels,'xlim',[0.5 length(xTickLabels)+0.5])
    plot(0:length(xTickLabels)+1,1:length(yTickLabels),'-','color',[0.5 0.5 0.5])
end
return
end

function [mu p] = CalcMuP(analData,transMuBool,log10Bool,depVarType,constantCoeff)
if ~exist('log10Bool','var') | isempty(log10Bool)
    log10Bool = 0;
end
analNames = fieldnames(analData);
for n=1:length(analNames)
    anatNames = fieldnames(analData.(analNames{n}));
    for k=1:length(anatNames)%length(anatNames):-1:1
        animalNames = fieldnames(analData.(analNames{n}).(anatNames{k}));
        for j=1:size(analData.(analNames{n}).(anatNames{k}).(animalNames{1}),2);
            ttestData = [];
            constantData = [];
            for m=1:length(animalNames)
                a = analData.(analNames{n}).(anatNames{k}).(animalNames{m}){j};
                a = a(isfinite(a));
                if log10Bool
                    a = log10(a);
                end
                ttestData = [ttestData; a];
                if exist('constantCoeff')
                    a = constantCoeff.(anatNames{k}).(animalNames{m}){j};
                    a = a(isfinite(a));
                    if log10Bool
                        a = log10(a);
                    end
                    constantData = [constantData; a];
                end
            end
            %%%%% calc pval %%%%%
            if strcmp(analNames{n},'Constant')
                p.(analNames{n})(k,j) = NaN;
            else
                [h p.(analNames{n})(k,j)] = ttest(ttestData,[],0.01);
            end
            if strcmp(analNames{n},'Constant') | transMuBool
                if strcmp(depVarType,'coh')
                    if ~isempty(constantData)
                        mu.(analNames{n})(k,j) = UnATanCoh(mean(ttestData))-UnATanCoh(mean(constantData));
%                         mu.(analNames{n})(k,j) = ((tanh(mean(ttestData))./1.999)+0.5)...
%                             - ((tanh(mean(constantData))./1.999)+0.5);
                    else
                        mu.(analNames{n})(k,j) = UnATanCoh(mean(ttestData));
%                         mu.(analNames{n})(k,j) = ((tanh(mean(ttestData))./1.999)+0.5);
                    end
                end
                if strcmp(depVarType,'phase')
                    mu.(analNames{n})(k,j) = mean(ttestData)./pi.*360;
                end
            else
                if ~isempty(constantData)
                    mu.(analNames{n})(k,j) = mean(ttestData)-mean(constantData);
                else
                    mu.(analNames{n})(k,j) = mean(ttestData);
                end
            end
        end
    end
end
return
end

function [p] = CalcNormP(analData)
analNames = fieldnames(analData);
for n=1:length(analNames)
    anatNames = fieldnames(analData.(analNames{n}));
    for k=1:length(anatNames)%length(anatNames):-1:1
        animalNames = fieldnames(analData.(analNames{n}).(anatNames{k}));
        for j=1:size(analData.(analNames{n}).(anatNames{k}).(animalNames{1}),2);
            ttestData = [];
            constantData = [];
            for m=1:length(animalNames)
                a = analData.(analNames{n}).(anatNames{k}).(animalNames{m}){j};
                a = a(isfinite(a));
                ttestData = [ttestData; a];
            end
            %%%%% calc pval %%%%%
            [h p.(analNames{n})(k,j)] = jbtest(ttestData);

        end
    end
end
return
end
