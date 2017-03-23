function PlotGLMResults(dirname,inNameNote,depVar,fileExt,multiFreqBool,interpFunc)
%function PlotGLMResults(dirname,inNameNote,depVar,fileExt,multiFreqBool)
filename = [inNameNote depVar fileExt]
load([dirname '/' filename],'-mat')
chansDir = 'ChanInfo/';
chanMat = LoadVar([chansDir 'ChanMat' fileExt '.mat']);
badChans = load([chansDir 'BadChan' fileExt '.txt']);
plotAnatBool = 1;
anatOverlayName = [chansDir 'AnatCurves.mat'];
plotSize = [16.5,6.5];
plotOffset = [0 0];
maxFreq = 150;

if ~isempty(interpFunc)
    badChanMask = [];
else
    badChanMask = Make2DPlotMat(ones(size([1:max(max(chanMat))])),chanMat,badChans);
    badChanMask(isnan(badChanMask)) = 0;
    badChanMask = logical(badChanMask);
end

nextFig = 0;
colorStyle = LoadVar('ColorMapSean6');
colormap(colorStyle)
resizeWinBool = 1;
figSizeFactor = 2.5;
figVertOffset = .25;
figHorzOffset = 0;
%figHorzSubt = -1;
%colorStyle = 'bone';

if ~multiFreqBool
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for single freq %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    defaultAxesPosition = [0.05,0.15,0.92,0.65];
    %%%% Plot outliers %%%%%
    nextFig = nextFig +1;
    figure(nextFig)
    clf
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    if isstruct(outlierStruct)
        outliersCell = Struct2CellArray(MatStruct2StructMat(outlierStruct),[],1);
    else
        outliersCell = Struct2CellArray(outlierStruct,[],1);
    end
    for j=1:size(outliersCell,1)
        outliers = outliersCell{j,end};
        if size(outliersCell,2) > 1
            outlierCategs = cat(2,outliersCell(j,1:end-1));
        else outlierCategs = {'all'};
        end
        subplot(2,size(outliersCell,1),j);
        h = ImageScMask(Make2DPlotMat(sum(outliers,1),chanMat,badChans,[]),badChanMask);
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset)
        end
        title([{'Outliers per Channel'} outlierCategs]);
        subplot(2,size(outliersCell,1),j+size(outliersCell,1));
        bar(sum(outliers,2)','r')
        title([{'Outliers Per Trial'} outlierCategs])
    end
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*j,2*figSizeFactor])
    end
    set(gcf,'name',filename);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%% partial Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% plot p-values %%%%%% 
    nextFig = nextFig +1;
    figure(nextFig)
    colorLimits = [1 -5];
    titles = [contXvarNames, categStats(1).coeffnames'];
    clf
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    for j=2:size(partialPs,1)
        subplot(1,size(partialPs,1)-1,j-1);
        h = ImageScMask(Make2DPlotMat(log10(partialPs(j,:)),chanMat,badChans,interpFunc),badChanMask,colorLimits);
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset)
        end
        title([titles(j) {'PartialModel pVal'}] );
    end
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(j-1),figSizeFactor])
    end
    set(gcf,'name',filename);
    %%%%%%%% plot contBetas %%%%%%%%
    nextFig = nextFig +1;
    figure(nextFig)
    titles = [contXvarNames];
    clf
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    for j=1:size(contBetas,1)
        subplot(1,size(contBetas,1),j);
        colorLimits = [-max(abs(contBetas(j,:))) max(abs(contBetas(j,:)))];
        h = ImageScMask(Make2DPlotMat(contBetas(j,:),chanMat,badChans,interpFunc),badChanMask,colorLimits);
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset)
        end
        title([titles(j) {'PartialModel beta'}] );
    end
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(j),figSizeFactor])
    end
    set(gcf,'name',filename);
    %%%%%%%% plot categMeans %%%%%%%%
    for k=1:length(categMeans)
        nextFig = nextFig +1;
        figure(nextFig);
        colorLimits = [-1.2 1.2];
        titles = groupCompNames{k}(:,1);
        clf
        set(gcf,'DefaultAxesPosition',defaultAxesPosition);
        for j=1:size(categMeans{k},1)
            subplot(1,size(categMeans{k},1),j);
            h = ImageScMask(Make2DPlotMat(categMeans{k}(j,1,:),chanMat,badChans,interpFunc),badChanMask,colorLimits);
            if plotAnatBool
                XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset)
            end
            title([titles(j) {'PartialModel categMeans'}] );
        end
        if resizeWinBool
            set(gcf, 'Units', 'inches')
            set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(j),figSizeFactor])
        end
    end
    set(gcf,'name',filename);

    %%%%%%%%%%%%%%%%%%%%%%%% Whole Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% plot p-values %%%%%%
    nextFig = nextFig +1;
    figure(nextFig)
    plotData = wholeModelPs;
    colorLimits = [1 -15];
    titles = [wholeModelStats(1).varnames];
    clf
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    for j=1:size(plotData,1)
        subplot(1,size(plotData,1),j);
        h = ImageScMask(Make2DPlotMat(log10(plotData(j,:)),chanMat,badChans,interpFunc),badChanMask,colorLimits);
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset)
        end
        title([titles(j) {'WholeModel pVal'}] );
    end
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(j),figSizeFactor])
    end
    set(gcf,'name',filename);
    %%%%%%%% plot cont coeffs %%%%%%%%
    nextFig = nextFig +1;
    figure(nextFig)
    tempData = MatStruct2StructMat(wholeModelStats);
    plotData = tempData.coeffs(1:length(contXvarNames),:);
    titles = tempData.coeffnames(1:length(contXvarNames));
    clf
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    for j=1:size(plotData,1)
        subplot(1,size(plotData,1),j);
        colorLimits = [-max(abs(plotData(j,:))) max(abs(plotData(j,:)))];
        h = ImageScMask(Make2DPlotMat(plotData(j,:),chanMat,badChans,interpFunc),badChanMask,colorLimits);
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset)
        end
        title([titles(j) {'WholeModel coeffs'}] );
    end
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(j),figSizeFactor])
    end
    set(gcf,'name',filename);
    %%%%%%%% plot categ coeffs %%%%%%%%
    nextFig = nextFig +1;
    figure(nextFig)
    tempData = MatStruct2StructMat(wholeModelStats);
    plotData = tempData.coeffs(length(contXvarNames)+1:end,:);
    titles = tempData.coeffnames(length(contXvarNames)+1:end);
    colorLimits = [-1.75 1.75];
    clf
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    for j=1:size(plotData,1)
        subplot(1,size(plotData,1),j);
        h = ImageScMask(Make2DPlotMat(plotData(j,:),chanMat,badChans,interpFunc),badChanMask,colorLimits);
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset)
        end
        title([titles(j) {'WholeModel coeffs'}] );
    end
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(j),figSizeFactor])
    end
    set(gcf,'name',filename);

    %%%%%%%%%%%%%%%%%%%%%%%% plot assumTests %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% residNormPs %%%%%
    plotData = MatStruct2StructMat(assumTest.residNormPs);
    nextFig = nextFig +1;
    figure(nextFig)
    clf;
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    colorLimits = [0 -2];
    titles = fieldnames(plotData);
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    for j=1:length(titles)
        subplot(1,length(titles),j);
        h = ImageScMask(Make2DPlotMat(log10(plotData.(titles{j})),chanMat,badChans,interpFunc),badChanMask,colorLimits);
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset);
        end
        %colorbar;
        title([titles(j) {'residNormPs AssumTest'}]);
    end
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(j),figSizeFactor])
    end
    set(gcf,'name',filename);
    %%%% residMeanPs %%%%%
    plotData = MatStruct2StructMat(assumTest.residMeanPs);
    nextFig = nextFig +1;
    figure(nextFig)
    clf;
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    colorLimits = [0 -2];
    titles = fieldnames(plotData);
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    for j=1:length(titles)
        subplot(1,length(titles),j);
        h = ImageScMask(Make2DPlotMat(log10(plotData.(titles{j})),chanMat,badChans,interpFunc),badChanMask,colorLimits);
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset);
        end
        %colorbar;
        title([titles(j) {'residMeanPs AssumTest'}]);
    end
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(j),figSizeFactor])
    end
    set(gcf,'name',filename);
    %%%% residCategVarPs %%%%%
    plotData = assumTest.residCategVarPs;
    nextFig = nextFig +1;
    figure(nextFig)
    clf;
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    colorLimits = [0 -2];
    titles = {'All'};
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    for j=1:length(titles)
        subplot(1,length(titles),j);
        h = ImageScMask(Make2DPlotMat(log(plotData),chanMat,badChans,interpFunc),badChanMask,colorLimits);
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset);
        end
        %colorbar;
        title([titles(j) {'residCategVarPs AssumTest'}]);
    end
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(j),figSizeFactor])
    end
    set(gcf,'name',filename);
    %%%% residCategVarZs %%%%%
    plotData = MatStruct2StructMat(assumTest.residCategVarZs);
    nextFig = nextFig +1;
    figure(nextFig)
    clf;
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    colorLimits = [-3 3];
    titles = fieldnames(plotData);
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    for j=1:length(titles)
        subplot(1,length(titles),j);
        h = ImageScMask(Make2DPlotMat(plotData.(titles{j}),chanMat,badChans,interpFunc),badChanMask,colorLimits);
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset);
        end
        %colorbar;
        title([titles(j) {'residCategVarZs AssumTest'}]);
    end
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(j),figSizeFactor])
    end
    set(gcf,'name',filename);
    %%%% residContVarPs %%%%%
    plotData = MatStruct2StructMat(assumTest.residContVarPs);
    nextFig = nextFig +1;
    figure(nextFig)
    clf;
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    colorLimits = [0 -2];
    titles = fieldnames(plotData);
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    for j=1:length(titles)
        subplot(1,length(titles),j);
        h = ImageScMask(Make2DPlotMat(log(plotData.(titles{j})),chanMat,badChans,interpFunc),badChanMask,colorLimits);
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset);
        end
        %colorbar;
        title([titles(j) {'residContVarPs AssumTest'}]);
    end
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(j),figSizeFactor])
    end
    set(gcf,'name',filename);
    %%%% prllPvals %%%%%
    plotData = MatStruct2StructMat(assumTest.prllPvals);
    nextFig = nextFig +1;
    figure(nextFig)
    clf;
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    colorLimits = [0 -3];
    titles = fieldnames(plotData);
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    for j=1:length(titles)
        subplot(1,length(titles),j);
        h = ImageScMask(Make2DPlotMat(log10(plotData.(titles{j})),chanMat,badChans,interpFunc),badChanMask,colorLimits);
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset);
        end
        %colorbar;
        title(SaveTheUnderscores([titles(j) {'prllPvals AssumTest'}]));
    end
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(j),figSizeFactor])
    end
    set(gcf,'name',filename);
    %%%% categDwPvals %%%%%
    plotData = MatStruct2StructMat(assumTest.categDwPvals);
    nextFig = nextFig +1;
    figure(nextFig)
    clf;
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    colorLimits = [0 -2];
    titles = fieldnames(plotData);
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    for j=1:length(titles)
        subplot(1,length(titles),j);
        h = ImageScMask(Make2DPlotMat(log(plotData.(titles{j})),chanMat,badChans,interpFunc),badChanMask,colorLimits);
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset);
        end
        %colorbar;
        title([titles(j) {'categDwPvals AssumTest'}]);
    end
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(j),figSizeFactor])
    end
    set(gcf,'name',filename);
    %%%% contDwPvals %%%%%
    plotData = MatStruct2StructMat(assumTest.contDwPvals);
    nextFig = nextFig +1;
    figure(nextFig)
    clf;
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    colorLimits = [0 -2];
    titles = fieldnames(plotData);
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    for j=1:length(titles)
        subplot(1,length(titles),j);
        h = ImageScMask(Make2DPlotMat(log(plotData.(titles{j})),chanMat,badChans,interpFunc),badChanMask,colorLimits);
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset);
        end
        %colorbar;
        title([titles(j) {'contDwPvals AssumTest'}]);
    end
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(j),figSizeFactor])
    end
    set(gcf,'name',filename);

else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for multi freq %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %fs = LoadVar('sm9603m2_211_s1_254/CalcRunningSpectra6_noExp_MidPoints_MinSpeed0Win626W08_LinNear.eeg/fo.mat');
    defaultAxesPosition = [0.05,0.05,0.92,0.85];
    %%%% Plot outliers %%%%%
    nextFig = nextFig +1;
    figure(nextFig)
    clf
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    if isstruct(outlierStruct)
        outliersCell = Struct2CellArray(MatStruct2StructMat(outlierStruct),[],1);
    else
        outliersCell = Struct2CellArray(outlierStruct,[],1);
    end
    for j=1:size(outliersCell,1)
        outliers = outliersCell{j,end};
        if size(outliersCell,2) > 1
            outlierCategs = cat(2,outliersCell(j,1:end-1));
        else outlierCategs = {'all'};
        end
        subplot(2,size(outliersCell,1),j);
        %h = ImageScMask(squeeze(sum(outliers,1)));
        pcolor(fs(find(fs<=maxFreq)),max(max(chanMat)):-1:1,squeeze(sum(outliers(:,:,find(fs<=maxFreq)),1)));
% pcolor(fs(1:find(abs(fs-maxFreq)==min(abs(fs-maxFreq)),1)),max(max(chanMat)):-1:1,squeeze(sum(outliers,1)));
        %h = ImageScMask(Make2DPlotMat(log10((j,:)),chanMat,badChans,interpFunc),badChanMask,colorLimits);
        shading 'interp'
        colorbar
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},gca,plotSize,plotOffset)
        end
        title([{'Outliers per Channel'} outlierCategs]);
        subplot(2,size(outliersCell,1),j+size(outliersCell,1));
        bar(sum(sum(outliers,2),3),'r')
        title([{'Outliers Per Trial'} outlierCategs])
    end
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*j,2*figSizeFactor])
    end    
    set(gcf,'name',filename);
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% partial Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% plot p-values %%%%%%
    plotData = partialPs;
    titlesBase = [contXvarNames, categStats(1,1).coeffnames'];
    titlesExt = 'PartialModel pVal';
    log10Bool = 1;
    colorLimits = [-15 1];
    invCscaleBool = 1;
    commonCLim = 2;
    cCenter = [];
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);

    %%%%%%%% plot contBetas %%%%%%%%
    plotData = contBetas;
    titlesBase = [contXvarNames, categStats(1,1).coeffnames'];
    titlesExt = 'PartialModel beta';
    log10Bool = 0;
    colorLimits = [];
    invCscaleBool = 0;
    commonCLim = 1;
    cCenter = 0;
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);

    %%%%%%%% plot categMeans %%%%%%%%
    for j=1:length(categMeans)
        plotData = squeeze(categMeans{j}(:,1,:,:));
        titlesBase = [groupCompNames{j}(:,1)];
        titlesExt = 'PartialModel categMeans';
        log10Bool = 0;
        colorLimits = [-1.5 1.5];
        invCscaleBool = 0;
        commonCLim = 2;
        cCenter = 0;
        nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
    end

    %%%%%%%%%%%%%%%%%%%%%%%% Whole Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% plot p-values %%%%%%
    plotData = wholeModelPs;
    titlesBase = [wholeModelStats(1).varnames];
    titlesExt = 'WholeModel pVal';
    log10Bool = 1;
    colorLimits = [-15 1];
    invCscaleBool = 1;
    commonCLim = 2;
    cCenter = [];
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);

    %%%%%%%% plot cont coeffs %%%%%%%%
    %tempData = MatStruct2StructMat(wholeModelStats);
    tempData = MatStruct2StructMat2(wholeModelStats,{'coeffs'});
    plotData = tempData.coeffs(1:length(contXvarNames),:,:);
    titlesBase = wholeModelStats(1,1).coeffnames(1:length(contXvarNames));
    titlesExt = 'WholeModel coeffs';
    log10Bool = 0;
    colorLimits = [];
    invCscaleBool = 0;
    commonCLim = 1;
    cCenter = 0;
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);

    %%%%%%%% plot categ coeffs %%%%%%%%
    plotData = tempData.coeffs(length(contXvarNames)+1:end,:,:);
    titlesBase = wholeModelStats(1,1).coeffnames(length(contXvarNames)+1:end);
    titlesExt = 'WholeModel coeffs';
    log10Bool = 0;
    colorLimits = [];
    invCscaleBool = 0;
    commonCLim = 2;
    cCenter = 0;
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);

%%%%%%%%%%%%%%%%%%%%%%%% plot assumTests %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% residNormPs %%%%%
    plotData = MatStruct2StructMat2(assumTest.residNormPs);
    cellData = Struct2CellArray(plotData);
    plotData = cat(1,cellData{:,2});
    titlesBase = cellData(:,1);
    titlesExt = 'residNormPs AssumTest';
    log10Bool = 1;
    colorLimits = [-2 0];
    invCscaleBool = 1;
    commonCLim = 2;
    cCenter = [];
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
    
    %%%% residMeanPs %%%%%
    plotData = MatStruct2StructMat2(assumTest.residMeanPs);
    cellData = Struct2CellArray(plotData);
    plotData = cat(1,cellData{:,2});
    titlesBase = cellData(:,1);
    titlesExt = 'residMeanPs AssumTest';
    log10Bool = 1;
    colorLimits = [-2 0];
    invCscaleBool = 1;
    commonCLim = 2;
    cCenter = [];
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);

    %%%% residCategVarPs %%%%%
    plotData = MatStruct2StructMat2(assumTest.residCategVarPs);
    cellData = Struct2CellArray(plotData);
    plotData = cat(1,cellData{:});
    titlesBase = {'all'};
    titlesExt = 'residCategVarPs AssumTest';
    log10Bool = 1;
    colorLimits = [-2 0];
    invCscaleBool = 1;
    commonCLim = 2;
    cCenter = [];
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);

    %%%% residCategVarZs %%%%%
    plotData = MatStruct2StructMat2(assumTest.residCategVarZs);
    cellData = Struct2CellArray(plotData);
    plotData = cat(1,cellData{:,2});
    titlesBase = cellData(:,1);
    titlesExt = 'residCategVarZs AssumTest';
    log10Bool = 0;
    colorLimits = [-3 3];
    invCscaleBool = 0;
    commonCLim = 2;
    cCenter = [];
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);

    %%%% residContVarPs %%%%%
    plotData = MatStruct2StructMat2(assumTest.residContVarPs);
    cellData = Struct2CellArray(plotData);
    plotData = cat(1,cellData{:,2});
    titlesBase = contXvarNames;
    titlesExt = 'residContVarPs AssumTest';
    log10Bool = 1;
    colorLimits = [-2 0];
    invCscaleBool = 1;
    commonCLim = 2;
    cCenter = [];
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);

    %%%% prllPvals %%%%%
    plotData = MatStruct2StructMat2(assumTest.prllPvals);
    cellData = Struct2CellArray(plotData);
    plotData = cat(1,cellData{:,2});
    titlesBase = cellData(:,1);
    titlesExt = 'prllPvals AssumTest';
    log10Bool = 1;
    colorLimits = [-5 0];
    invCscaleBool = 1;
    commonCLim = 2;
    cCenter = [];
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);

    %%%% categDwPvals %%%%%
    plotData = MatStruct2StructMat2(assumTest.categDwPvals);
    cellData = Struct2CellArray(plotData);
    plotData = cat(1,cellData{:,2});
    titlesBase = cellData(:,1);
    titlesExt = 'categDwPvals AssumTest';
    log10Bool = 1;
    colorLimits = [-2 0];
    invCscaleBool = 1;
    commonCLim = 2;
    cCenter = [];
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);

    %%%% contDwPvals %%%%%
    plotData = MatStruct2StructMat2(assumTest.contDwPvals);
    cellData = Struct2CellArray(plotData);
    plotData = cat(1,cellData{:,2});
    titlesBase = contXvarNames;
    titlesExt = 'contDwPvals AssumTest';
    log10Bool = 1;
    colorLimits = [-2 0];
    invCscaleBool = 1;
    commonCLim = 2;
    cCenter = [];
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
    
end

return
