function PlotGlmScat03(chanLocVersion,inNameNote,fileExt,dirname,reportFigBool)
chanInfoDir = 'ChanInfo/';
reportFigBool = 0;

%dirname = 'GlmWholeModel01';
%inNameNote = 'Alter_secondRun_';
dirname = 'GlmWholeModel05';
%dirname = 'GlmPartialModel03';
%inNameNote = 'Alter_Vs_Control_EachRegion_firstRun';
%inNameNote = 'Alter_groupAnal1';
%inNameNote = 'RemVsThetaFreq_01';
%inNameNote = 'RemVsRun_01';
%inNameNote = 'RemVsRun_allTrials_01';
%inNameNote = 'RemVsRun_thetaFreq_01';
%inNameNote = 'RemVsRun_thetaFreq_allTrials_01';
%inNameNote = 'RemVsRunXthetaFreq_01';
%inNameNote = 'RemVsRunXthetaFreq_allTrials_01';
%inNameNote = 'RemVsRun_thetaFreq_X_01';
inNameNote = 'RemVsRun_thetaFreq_X_allTrials_01';

%inNameNote = 'RemVsRun_01';
fileExt = '.eeg';
%fileExt = '_LinNearCSD121.csd';
%fileExt = '_LinNearCSD121.csd';

for analBattery=1:1
    switch analBattery
        case 1
            depVar = 'thetaPowPeak4-12Hz'; categMeansYlim = [-4 4]; selChan = 0;
        case 2
            depVar = 'gammaPowIntg60-120Hz'; categMeansYlim = [-2 2]; selChan = 0;
        case 3
            depVar = 'thetaCohMedian4-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 1;
        case 4
            depVar = 'thetaCohMedian4-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 2;
        case 5
            depVar = 'thetaCohMedian4-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 3;
        case 6
            depVar = 'thetaCohMedian4-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 4;
        case 7
            depVar = 'thetaCohMedian4-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 5;
        case 8
            depVar = 'thetaCohMedian4-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 6;
        case 9
            depVar = 'gammaCohMedian60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 1;
        case 10
            depVar = 'gammaCohMedian60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 2;
        case 11
            depVar = 'gammaCohMedian60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 3;
        case 12
            depVar = 'gammaCohMedian60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 4;
        case 13
            depVar = 'gammaCohMedian60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 5;
        case 14
            depVar = 'gammaCohMedian60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 6;
        case 15
            depVar = 'thetaPhaseMean4-12Hz'; categMeansYlim = [-1 1]; selChan = 1;
        case 16
            depVar = 'thetaPhaseMean4-12Hz'; categMeansYlim = [-1 1]; selChan = 2;
        case 17
            depVar = 'thetaPhaseMean4-12Hz'; categMeansYlim = [-1 1]; selChan = 3;
        case 18
            depVar = 'thetaPhaseMean4-12Hz'; categMeansYlim = [-1 1]; selChan = 4;
        case 19
            depVar = 'thetaPhaseMean4-12Hz'; categMeansYlim = [-1 1]; selChan = 5;
        case 20
            depVar = 'thetaPhaseMean4-12Hz'; categMeansYlim = [-1 1]; selChan = 6;
        case 21
            depVar = 'gammaPhaseMean60-120Hz'; categMeansYlim = [-1 1]; selChan = 1;
        case 22
            depVar = 'gammaPhaseMean60-120Hz'; categMeansYlim = [-1 1]; selChan = 2;
        case 23
            depVar = 'gammaPhaseMean60-120Hz'; categMeansYlim = [-1 1]; selChan = 3;
        case 24
            depVar = 'gammaPhaseMean60-120Hz'; categMeansYlim = [-1 1]; selChan = 4;
        case 25
            depVar = 'gammaPhaseMean60-120Hz'; categMeansYlim = [-1 1]; selChan = 5;
        case 26
            depVar = 'gammaPhaseMean60-120Hz'; categMeansYlim = [-1 1]; selChan = 6;
    end
%depVar = 'gammaCohMedian60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 5;
%depVar = 'thetaCohMedian6-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 2;
%depVar = 'thetaCohMedian4-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 6;
%depVar = 'thetaPhaseMean4-12Hz'; categMeansYlim = [-1 1]; selChan = 1;
%depVar = 'gammaCohMedian60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 6;
%depVar = 'thetaCohMedian6-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 6;
%depVar = 'gammaPowIntg60-120Hz'; categMeansYlim = [-2 2]; selChan = 0;
%depVar = 'thetaPowPeak6-12Hz'; categMeansYlim = [-4 4]; selChan = 0;
%depVar = 'thetaPowPeak4-12Hz'; categMeansYlim = [-4 4]; selChan = 0;

% for a=1:length(depVarCell)
%     depVar = depVarCell{a};
% 
    fileName = [depVar '_selChan=' num2str(selChan)];
    % switch selChan
    %     case 2
    %         fileName = [depVar '_ref-rad'];
    %     case 6
    %         fileName = [depVar '_ref-Ca3'];
    %     otherwise
    %         fileName = depVar;
    % end

    animalDirs = {...
        '/BEEF01/smm/sm9601_Analysis/analysis03/',...
        '/BEEF01/smm/sm9603_Analysis/analysis04/',...
        '/BEEF02/smm/sm9614_Analysis/analysis02'...
        '/BEEF02/smm/sm9608_Analysis/analysis02/',...
        };
    origDir = pwd;

    % for k=1:10
    %     figure(k)
    %     clf
    % end
    %close all
    plotColors = [1 0 0;0 0 1;0 1 0;0 0 0];
    for k=1:length(animalDirs)
        fprintf('\ncd %s',animalDirs{k})
        cd(animalDirs{k})
        if selChan
            selChans = load([chanInfoDir 'SelectedChannels' fileExt '.txt']);
            selChanName = ['.ch' num2str(selChans(selChan))];
        else
            selChanName = '';
        end
        fprintf('\nLoading %s',[dirname '/' inNameNote '/' fileExt '/' depVar selChanName '.mat'])
        load([dirname '/' inNameNote '/' fileExt '/' depVar selChanName '.mat']);
        chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']);
        chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
        badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);

        anatFields = fieldnames(chanLoc);
        for j=1:length(anatFields)
            %%%%% p-values %%%%%% 
            varNames = model.varNames;
            for m=1:length(varNames);
                pVals.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    model.pVals(m,setdiff(chanLoc.(anatFields{j}),badChans))';
            end
            %%%%% rSq %%%%%% 
            varNames = model.rSqNames;
            for m=1:length(varNames);
                rSqs.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    model.rSq(m,setdiff(chanLoc.(anatFields{j}),badChans))';
            end
            %%%%%%% contBetas %%%%%%%%
            varNames = model.coeffNames;
            for m=1:length(varNames);
                coeffs.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    model.coeffs(m,setdiff(chanLoc.(anatFields{j}),badChans))';
            end
            %keyboard
            %try
            %%%%%% categMeans %%%%%%%%
            if 0
            for n = 1:length(model.categMeans)
                varNames = model.categNames{n};
                for m=1:length(varNames);
                    %                 categMeans{n}.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    %                     squeeze(model.categMeans{n}(m,1,setdiff(chanLoc.(anatFields{j}),badChans))-...
                    %                     mean(model.categMeans{n}(:,1,setdiff(chanLoc.(anatFields{j}),badChans))));
                    categMeans{n}.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                        squeeze(model.categMeans{n}(m,1,setdiff(chanLoc.(anatFields{j}),badChans))-...
                        mean(model.categMeans{n}(:,1,setdiff(chanLoc.(anatFields{j}),badChans))));
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
                assumPlot.residNormPs.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    tempData(m,setdiff(chanLoc.(anatFields{j}),badChans))';
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
                assumPlot.residMeanPs.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    tempData(m,setdiff(chanLoc.(anatFields{j}),badChans))';
            end
            %%%% residContVarPs %%%%%
            tempData = MatStruct2StructMat2(assumTest.residContVarPs);
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
                assumPlot.residContVarPs.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    tempData(m,setdiff(chanLoc.(anatFields{j}),badChans))';
            end
            %%%% residCategVarPs %%%%%
            tempData = MatStruct2StructMat2(assumTest.residCategVarPs);
            cellData = Struct2CellArray(tempData,[],1);
            tempData = cat(1,cellData{:,end});
            clear varNames;
            varNames{1,1} = 'all';
            for m=1:length(varNames);
                assumPlot.residCategVarPs.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    tempData(setdiff(chanLoc.(anatFields{j}),badChans))';
            end
            %%%% residCategVarZs %%%%%
            tempData = MatStruct2StructMat2(assumTest.residCategVarZs);
            cellData = Struct2CellArray(tempData,[],1);
            tempData = cat(1,cellData{:,end});
            clear varNames;
            for m=1:size(cellData,1)
                varNames{m,1} = cat(2,cellData{m,1:end-1});
            end
            for m=1:length(varNames);
                assumPlot.residCategVarZs.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    tempData(m,setdiff(chanLoc.(anatFields{j}),badChans))';
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
                assumPlot.prllPvals.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    tempData(m,setdiff(chanLoc.(anatFields{j}),badChans))';
            end
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
                assumPlot.contDwPvals.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    tempData(m,setdiff(chanLoc.(anatFields{j}),badChans))';
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
                assumPlot.categDwPvals.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    tempData(m,setdiff(chanLoc.(anatFields{j}),badChans))';
            end
            %catch keyboard
            %end
        end
    end

    nextFig = 1;

    %%%%% plot p-values %%%%%%
    plotData = pVals;
    titlesExt = 'pVals';
    log10Bool = 1;
    yLimits = [];
    ttestBool = 0;
    nextFig = ScatPlotHelper(nextFig,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool);
    %%%%% plot rSq %%%%%%
    plotData = rSqs;
    titlesExt = 'rSq';
    log10Bool = 0;
    yLimits = [];
    ttestBool = 0;
    nextFig = ScatPlotHelper(nextFig,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool);
    %%%%%%%% plot contBetas %%%%%%%%
    plotData = coeffs;
    titlesExt = 'beta';
    log10Bool = 0;
    yLimits = [];
    ttestBool = 1;
    nextFig = ScatPlotHelper(nextFig,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool);
    %%%%%%%% plot categMeans %%%%%%%%
    if 0
    for j=1:length(categMeans)
        plotData = categMeans{j};
        titlesExt = 'categMeans';
        log10Bool = 0;
        yLimits = [categMeansYlim];
        ttestBool = 1;
        nextFig = ScatPlotHelper(nextFig,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool);
    end
    end
    %%%% residNormPs %%%%%
    for j=1:length(assumPlot.residNormPs)
        plotData = assumPlot.residNormPs;
        titlesExt = 'residNormPs';
        log10Bool = 1;
        yLimits = [-3 0];
        ttestBool = 0;
        nextFig = ScatPlotHelper(nextFig,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool);
    end
    %%%% residMeanPs %%%%%
    for j=1:length(assumPlot.residMeanPs)
        plotData = assumPlot.residMeanPs;
        titlesExt = 'residMeanPs';
        log10Bool = 1;
        yLimits = [-3 0];
        ttestBool = 0;
        nextFig = ScatPlotHelper(nextFig,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool);
    end
    %%%% residContVarPs %%%%%
    for j=1:length(assumPlot.residContVarPs)
        plotData = assumPlot.residContVarPs;
        titlesExt = 'residContVarPs';
        log10Bool = 1;
        yLimits = [-3 0];
        ttestBool = 0;
        nextFig = ScatPlotHelper(nextFig,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool);
    end
    %%%% residCategVarPs %%%%%
    for j=1:length(assumPlot.residCategVarPs)
        plotData = assumPlot.residCategVarPs;
        titlesExt = 'residCategVarPs';
        log10Bool = 1;
        yLimits = [-3 0];
        ttestBool = 0;
        nextFig = ScatPlotHelper(nextFig,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool);
    end
    %%%% residCategVarZs %%%%%
    for j=1:length(assumPlot.residCategVarZs)
        plotData = assumPlot.residCategVarZs;
        titlesExt = 'residCategVarZs';
        log10Bool = 0;
        yLimits = [-10 10];
        ttestBool = 0;
        nextFig = ScatPlotHelper(nextFig,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool);
    end
    %%%% prllPvals %%%%%
    for j=1:length(assumPlot.prllPvals)
        plotData = assumPlot.prllPvals;
        titlesExt = 'prllPvals';
        log10Bool = 1;
        yLimits = [-3 0];
        ttestBool = 0;
        nextFig = ScatPlotHelper(nextFig,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool);
    end
    %%%% contDwPvals %%%%%
    for j=1:length(assumPlot.contDwPvals)
        plotData = assumPlot.contDwPvals;
        titlesExt = 'contDwPvals';
        log10Bool = 1;
        yLimits = [-3 0];
        ttestBool = 0;
        nextFig = ScatPlotHelper(nextFig,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool);
    end
    %%%% categDwPvals %%%%%
    for j=1:length(assumPlot.categDwPvals)
        plotData = assumPlot.categDwPvals;
        titlesExt = 'categDwPvals';
        log10Bool = 1;
        yLimits = [-3 0];
        ttestBool = 0;
        nextFig = ScatPlotHelper(nextFig,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool);
    end
    cd(origDir)
    if reportFigBool
        for j=1:length(animalDirs)
            comment{j} = [animalDirs{j} ' = ' num2str(plotColors(j,:))];
        end
        ReportFigSM(1:nextFig-1,Dot2Underscore(['/u12/smm/public_html/NewFigs/' dirname '/' inNameNote '/' fileExt '/']),[],[],comment);
    end
end
return



function nextFig = ScatPlotHelper(nextFig,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool)
resizeWinBool = 1;

% chanInfoDir = 'ChanInfo/';
% chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']);
% chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
% badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);
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
end

%nextFig = nextFig + 1;
%fields = fieldnames(chanLoc);
%plotNames=fieldnames(plotData);
for j=1:length(plotNames)
    subplot(1,length(plotNames),j)
    if ~isempty(yLimits)
        set(gca,'ylim',yLimits)
    end
    hold on

    anatNames = fieldnames(plotData.(plotNames{j}));
    for k=1:length(anatNames)
        animalNames = fieldnames(plotData.(plotNames{j}).(anatNames{k}));
        ttestData = [];
        for m=1:length(animalNames)
            if ~isempty(plotData.(plotNames{j}).(anatNames{k}).(animalNames{m}))
                if log10Bool
                    plot(k,log10(plotData.(plotNames{j}).(anatNames{k}).(animalNames{m})),'o','color',plotColors(m,:));
                else
                    plot(k,plotData.(plotNames{j}).(anatNames{k}).(animalNames{m}),'o','color',plotColors(m,:));
                end
            end
            %keyboard
            ttestData = [ttestData; plotData.(plotNames{j}).(anatNames{k}).(animalNames{m})];
        end
        [h(k) p(k)] = ttest(ttestData,[],0.01);
    end
    title(SaveTheUnderscores([plotNames{j} ' ' titlesExt]))
    set(gca,'fontsize',8,'xtick',[1:length(anatNames)],'xticklabel',anatNames)
    %     for k=1:length(anatNames)
    %         get(gca,'ylim')
    %          end
    if ttestBool
        for k=1:length(anatNames)
            if ~isnan(h(k)) & h(k)
                if isempty(yLimits)
                    ylims = get(gca,'ylim');
                else
                    ylims = yLimits;
                end
                if log10Bool
                    plot(k,ylims(1),'*','color',[1 0 0])
                else
                    plot(k,ylims(2),'*','color',[1 0 0])
                end
            end
        end
    end
    plot(0:length(anatNames),zeros(size(0:length(anatNames))),'k:')

end
return



fields = []
for j=1:size(plotData,1)
    subplot(1,size(plotData,1),j)
    hold on
    for k=1:length(fields)
        if ~isempty(chanLoc.(fields{k}))
            if log10Bool
                plot(k,log10(plotData{j,setdiff(chanLoc.(fields{k}),badChans),:}),'o');
            else
                plot(k,plotData{j,setdiff(chanLoc.(fields{k}),badChans),:},'o');
            end
        end
    end
    title(SaveTheUnderscores([titlesBase(j) titlesExt]))
    set(gca,'fontsize',8,'xtick',[1:length(fields)],'xticklabel',fields)
    if ~isempty(yLimits)
        set(gca,'ylim',yLimits)
    end
end

return

