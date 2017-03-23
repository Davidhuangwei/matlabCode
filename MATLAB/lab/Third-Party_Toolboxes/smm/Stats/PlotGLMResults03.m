function PlotGLMResults03(dirname,inNameNote,depVar,fileExt,multiFreqBool,interpFunc,reportFigBool,categMeansCLim)
%function PlotGLMResults01(dirname,inNameNote,depVar,fileExt,multiFreqBool,interpFunc,reportFigBool)
filename = depVar;
load([dirname '/' inNameNote '/' fileExt '/' depVar '.mat'])
chansDir = 'ChanInfo/';
chanMat = LoadVar([chansDir 'ChanMat' fileExt '.mat']);
badChans = load([chansDir 'BadChan' fileExt '.txt']);
plotAnatBool = 1;
anatOverlayName = [chansDir 'AnatCurves.mat'];
plotSize = [16.5,6.5];
plotOffset = load([chansDir 'OffSet' fileExt '.txt']);
maxFreq = 150;
addpath /u12/smm/matlab/sm_Copies/bar/
if ~exist('categMeansCLim')
    categMeansCLim =[];
end

if ~isempty(interpFunc)
    badChanMask = [];
else
    badChanMask = Make2DPlotMat(ones(size([1:max(max(chanMat))])),chanMat,badChans);
    badChanMask(isnan(badChanMask)) = 0;
    badChanMask = logical(badChanMask);
end

nextFig = 1;
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
    figure(nextFig)
    nextFig = nextFig +1;
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

    %%%%%%%%%%%%%%%%%%%%%%%%%%%% Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% plot p-values %%%%%% 
    plotData = model.pVals;
    titlesBase = [model.varNames];
    titlesExt = 'pVals';
    log10Bool = 1;
    colorLimits = [0 -5];
    commonCLim = 2;
    cCenter = [];
    nextFig = PlotHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,titlesBase,titlesExt,resizeWinBool,filename,interpFunc);
    %%%%% plot rSq %%%%%% 
    plotData = model.rSq;
    titlesBase = [model.rSqNames];
    titlesExt = 'rSq';
    log10Bool = 0;
    colorLimits = [];
    commonCLim = 0;
    cCenter = [];
    nextFig = PlotHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,titlesBase,titlesExt,resizeWinBool,filename,interpFunc);
   %%%%%%% plot contBetas %%%%%%%%
   keyboard
    plotData = model.coeffs(2:length(model.contVarNames)+1,:);
    titlesBase = [model.coeffNames(2:length(model.contVarNames)+1)];%!!!!!
    titlesExt = 'beta';
    log10Bool = 0;
    colorLimits = [];
    commonCLim = 0;
    cCenter = 0;
    nextFig = PlotHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,titlesBase,titlesExt,resizeWinBool,filename,interpFunc);
    %%%%%% plot categMeans %%%%%%%%
    for j=1:length(model.categMeans)
        plotData = squeeze(model.categMeans{j}(:,1,:)-repmat(mean(model.categMeans{j}(:,1,:)),size(model.categMeans{j}(:,1,:),1),1));
        titlesBase = [model.categNames{j}];
        titlesExt = 'categMeans';
        log10Bool = 0;
        colorLimits = [categMeansCLim];
        commonCLim = 2;
        cCenter = 0;
        nextFig = PlotHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,titlesBase,titlesExt,resizeWinBool,filename,interpFunc);
    end

    %%%%%%%%%%%%%%%%%%%%%%% plot assumTests %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% residNormPs %%%%%
    plotData = MatStruct2StructMat2(assumTest.residNormPs);
    cellData = Struct2CellArray(plotData,[],1);
    plotData = cat(1,cellData{:,end});
    titlesBase = {};
    for j=1:size(cellData,1)
        titlesBase{j,1} = cat(2,cellData{j,1:end-1});
    end
    titlesExt = 'residNormPs';
    log10Bool = 1;
    colorLimits = [0 -2];
    commonCLim = [];
    cCenter = [];
    nextFig = PlotHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,titlesBase,titlesExt,resizeWinBool,filename,interpFunc);
    %%%% residMeanPs %%%%%
    plotData = MatStruct2StructMat2(assumTest.residMeanPs);
    cellData = Struct2CellArray(plotData,[],1);
    plotData = cat(1,cellData{:,end});
    titlesBase = {};
    for j=1:size(cellData,1)
        titlesBase{j,1} = cat(2,cellData{j,1:end-1});
    end
    titlesExt = 'residMeanPs';
    log10Bool = 1;
    colorLimits = [0 -2];
    commonCLim = [];
    cCenter = [];
    nextFig = PlotHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,titlesBase,titlesExt,resizeWinBool,filename,interpFunc);
    %%%% residContVarPs %%%%%
    plotData = MatStruct2StructMat2(assumTest.residContVarPs);
    cellData = Struct2CellArray(plotData,[],1);
    plotData = cat(1,cellData{:,end});
    titlesBase = {};
    for j=1:size(cellData,1)
        titlesBase{j,1} = cat(2,cellData{j,1:end-1});
    end
    titlesExt = 'residContVarPs';
    log10Bool = 1;
    colorLimits = [0 -2];
    commonCLim = [];
    cCenter = [];
    nextFig = PlotHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,titlesBase,titlesExt,resizeWinBool,filename,interpFunc);
    %%%% residCategVarPs %%%%%
    plotData = MatStruct2StructMat2(assumTest.residCategVarPs);
    cellData = Struct2CellArray(plotData,[],1);
    plotData = cat(1,cellData{:,end});
    titlesBase = {'All'};
    titlesExt = 'residCategVarPs';
    log10Bool = 1;
    colorLimits = [0 -2];
    commonCLim = [];
    cCenter = [];
    nextFig = PlotHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,titlesBase,titlesExt,resizeWinBool,filename,interpFunc);
    %%%% residCategVarZs %%%%%
    plotData = MatStruct2StructMat2(assumTest.residCategVarZs);
    cellData = Struct2CellArray(plotData,[],1);
    plotData = cat(1,cellData{:,end});
    titlesBase = {};
    for j=1:size(cellData,1)
        titlesBase{j,1} = cat(2,cellData{j,1:end-1});
    end
    titlesExt = 'residCategVarZs';
    log10Bool = 0;
    colorLimits = [-3 3];
    commonCLim = [];
    cCenter = [];
    nextFig = PlotHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,titlesBase,titlesExt,resizeWinBool,filename,interpFunc);
    %%%% prllPvals %%%%%
    plotData = MatStruct2StructMat2(assumTest.prllPvals);
    cellData = Struct2CellArray(plotData,[],1);
    plotData = cat(1,cellData{:,end});
    titlesBase = {};
    for j=1:size(cellData,1)
        titlesBase{j,1} = cat(2,cellData{j,1:end-1});
    end
    titlesExt = 'prllPvals';
    log10Bool = 1;
    colorLimits = [0 -2];
    commonCLim = [];
    cCenter = [];
    nextFig = PlotHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,titlesBase,titlesExt,resizeWinBool,filename,interpFunc);
    %%%% contDwPvals %%%%%
    plotData = MatStruct2StructMat2(assumTest.contDwPvals);
    cellData = Struct2CellArray(plotData,[],1);
    plotData = cat(1,cellData{:,end});
    titlesBase = {};
    for j=1:size(cellData,1)
        titlesBase{j,1} = cat(2,cellData{j,1:end-1});
    end
    titlesExt = 'contDwPvals';
    log10Bool = 1;
    colorLimits = [0 -2];
    commonCLim = [];
    cCenter = [];
    nextFig = PlotHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,titlesBase,titlesExt,resizeWinBool,filename,interpFunc);
    %%%% categDwPvals %%%%%
    plotData = MatStruct2StructMat2(assumTest.categDwPvals);
    cellData = Struct2CellArray(plotData,[],1);
    plotData = cat(1,cellData{:,end});
    titlesBase = {};
    for j=1:size(cellData,1)
        titlesBase{j,1} = cat(2,cellData{j,1:end-1});
    end
    titlesExt = 'categDwPvals';
    log10Bool = 1;
    colorLimits = [0 -2];
    commonCLim = [];
    cCenter = [];
    nextFig = PlotHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,titlesBase,titlesExt,resizeWinBool,filename,interpFunc);

else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for multi freq %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %fs = LoadVar('sm9603m2_211_s1_254/CalcRunningSpectra6_noExp_MidPoints_MinSpeed0Win626W08_LinNear.eeg/fo.mat');
    defaultAxesPosition = [0.15,0.05,0.75,0.85];
    %%%% Plot outliers %%%%%
    figure(nextFig)
    clf
    nextFig = nextFig + 1;
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
        subplot(3,size(outliersCell,1),j);
        h = ImageScMask(Make2DPlotMat(squeeze(sum(sum(outliers,1),3)),chanMat,badChans,[]),badChanMask);
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset)
        end
        title([{'Outliers per channel'} outlierCategs]);
        
        subplot(3,size(outliersCell,1),j+size(outliersCell,1));
        bar(fs(fs<=maxFreq),squeeze(sum(sum(outliers,1),2)),1,'r')
        title([{'Outliers per freq'} outlierCategs]);
        %h = ImageScMask(squeeze(sum(outliers,1)));
        %pcolor(fs(find(fs<=maxFreq)),max(max(chanMat)):-1:1,squeeze(sum(outliers(:,:,find(fs<=maxFreq)),1)));
% pcolor(fs(1:find(abs(fs-maxFreq)==min(abs(fs-maxFreq)),1)),max(max(chanMat)):-1:1,squeeze(sum(outliers,1)));
        %h = ImageScMask(Make2DPlotMat(log10((j,:)),chanMat,badChans,interpFunc),badChanMask,colorLimits);
        %shading 'interp'
        %colorbar        
        
        subplot(3,size(outliersCell,1),j+2*size(outliersCell,1));
        bar(sum(sum(outliers,2),3),'r')
        title([{'Outliers Per Trial'} outlierCategs])
    end
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*j,2*figSizeFactor])
    end    
    set(gcf,'name',filename);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% plot p-values %%%%%%
    plotData = model.pVals;
    titlesBase = model.varNames;
    titlesExt = 'pVals';
    log10Bool = 1;
    colorLimits = [-10 1];
    invCscaleBool = 1;
    commonCLim = 2;
    cCenter = [];
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
    %%%%% plot rSq %%%%%%
    plotData = model.rSq;
    titlesBase = model.rSqNames;
    titlesExt = 'rSq';
    log10Bool = 0;
    colorLimits = [];
    invCscaleBool = 0;
    commonCLim = 1;
    cCenter = [];
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
    %%%%%%%% plot contBetas %%%%%%%%
    plotData = model.coeffs(2:length(model.contVarNames)+1,:,:);
    titlesBase = [model.coeffNames(2:length(model.contVarNames)+1)];
    titlesExt = 'beta';
    log10Bool = 0;
    colorLimits = [];
    invCscaleBool = 0;
    commonCLim = 1;
    cCenter = 0;
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
    %%%%%%%% plot categMeans %%%%%%%%
    for j=1:length(model.categMeans)
        plotData = squeeze(model.categMeans{j}(:,1,:,:)-repmat(mean(model.categMeans{j}(:,1,:,:)),[size(model.categMeans{j},1),1,1,1]));
        titlesBase = [model.categNames{j}];
        titlesExt = 'categMeans';
        log10Bool = 0;
        colorLimits = [categMeansCLim];
        invCscaleBool = 0;
        commonCLim = 2;
        cCenter = 0;
        nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
    end

%%%%%%%%%%%%%%%%%%%%%%%% plot assumTests %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% residNormPs %%%%%
    plotData = MatStruct2StructMat2(assumTest.residNormPs);
    cellData = Struct2CellArray(plotData);
    plotData = cat(1,cellData{:,end});
    titlesBase = {};
    for j=1:size(cellData,1)
        titlesBase{j,1} = cat(2,cellData{j,1:end-1});
    end    
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
    plotData = cat(1,cellData{:,end});
    titlesBase = {};
    for j=1:size(cellData,1)
        titlesBase{j,1} = cat(2,cellData{j,1:end-1});
    end    
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
    plotData = cat(1,cellData{:,end});
     titlesBase = {};
    for j=1:size(cellData,1)
        titlesBase{j,1} = cat(2,cellData{j,1:end-1});
    end   
    titlesExt = 'residCategVarZs AssumTest';
    log10Bool = 0;
    colorLimits = [-3 3];
    invCscaleBool = 0;
    commonCLim = 2;
    cCenter = [];
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);

    %%%% residContVarPs %%%%%
        plotData = MatStruct2StructMat2(assumTest.residContVarPs);
    cellData = Struct2CellArray(plotData,[],1);
    plotData = cat(1,cellData{:,end});
    titlesBase = {};
    for j=1:size(cellData,1)
        titlesBase{j,1} = cat(2,cellData{j,1:end-1});
    end
% plotData = MatStruct2StructMat2(assumTest.residContVarPs);
%     cellData = Struct2CellArray(plotData);
%     plotData = cat(1,cellData{:,end});
%     titlesBase = contXvarNames;
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
    plotData = cat(1,cellData{:,end});
     titlesBase = {};
    for j=1:size(cellData,1)
        titlesBase{j,1} = cat(2,cellData{j,1:end-1});
    end   
    titlesExt = 'prllPvals AssumTest';
    log10Bool = 1;
    colorLimits = [-2 0];
    invCscaleBool = 1;
    commonCLim = 2;
    cCenter = [];
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);

    %%%% contDwPvals %%%%%
    plotData = MatStruct2StructMat2(assumTest.contDwPvals);
    cellData = Struct2CellArray(plotData);
    plotData = cat(1,cellData{:,end});
    titlesBase = {};
    for j=1:size(cellData,1)
        titlesBase{j,1} = cat(2,cellData{j,1:end-1});
    end
    titlesExt = 'contDwPvals AssumTest';
    log10Bool = 1;
    colorLimits = [-2 0];
    invCscaleBool = 1;
    commonCLim = 2;
    cCenter = [];
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);

    %%%% categDwPvals %%%%%
    plotData = MatStruct2StructMat2(assumTest.categDwPvals);
    cellData = Struct2CellArray(plotData);
    plotData = cat(1,cellData{:,end});
     titlesBase = {};
    for j=1:size(cellData,1)
        titlesBase{j,1} = cat(2,cellData{j,1:end-1});
    end   
    titlesExt = 'categDwPvals AssumTest';
    log10Bool = 1;
    colorLimits = [-2 0];
    invCscaleBool = 1;
    commonCLim = 2;
    cCenter = [];
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);

end

if reportFigBool
    %fprintf('%s',[pwd '/NewFigs/' dirName])
    ReportFigSM(1:nextFig-1,Dot2Underscore([pwd '/NewFigs/' dirname '/' inNameNote '/' fileExt '/']));
end

return



selChans = load(['ChanInfo/SelectedChannels' fileExt '.txt']);

figure(20)
clf
for j=1:length(selChans)
    subplot(length(selChans),1,j)
    %plot(data2.rem(:,34),data1.rem(:,selChans(j)),'.')
    hist(goodDepStruct(selChans(j)).rem)
end


figure(21)
clf
for j=1:length(selChans)
    subplot(length(selChans),1,j)
    %plot(data2.rem(:,34),data1.rem(:,selChans(j)),'.')
    hist(depStruct.rem(:,selChans(j)))
end


