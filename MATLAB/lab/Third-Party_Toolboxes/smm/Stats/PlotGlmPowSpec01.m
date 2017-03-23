function PlotGlmPowSpec01(chanLocVersion,depVarCell,fileExt,inNameNote,animalDirs,varargin)
[dirname saveDir reportFigBool,selChanLoc] = DefaultArgs(varargin,{'GlmWholeModel05/','MazePaper/new/',1,[]});
chanInfoDir = 'ChanInfo/';

for analBattery=1:length(depVarCell)
    switch depVarCell{analBattery}
%         case 'thetaPowPeak6-12Hz'
%             depVar = 'thetaPowPeak6-12Hz'; categMeansYlim = [-4 4]; selChan = 0;
%         case 'thetaPowIntg6-12Hz'
%             depVar = 'thetaPowIntg6-12Hz'; categMeansYlim = [-4 4]; selChan = 0;
%         case 'gammaPowIntg60-120Hz'
%             depVar = 'gammaPowIntg60-120Hz'; categMeansYlim = [-2 2]; selChan = 0;
%         case 'thetaPowIntg6-12Hz'
%             depVar = 'thetaPowIntg6-12Hz'; categMeansYlim = [-2 2]; selChan = 0;
%         case 'gammaPowIntg40-100Hz'
%             depVar = 'gammaPowIntg40-100Hz'; categMeansYlim = [-2 2]; selChan = 0;
%         case 'gammaPowIntg40-120Hz'
%             depVar = 'gammaPowIntg40-120Hz'; categMeansYlim = [-2 2]; selChan = 0;
%         case 'gammaPowIntg50-100Hz'
%             depVar = 'gammaPowIntg50-100Hz'; categMeansYlim = [-2 2]; selChan = 0;
%         case 'gammaPowIntg50-120Hz'
%             depVar = 'gammaPowIntg50-120Hz'; categMeansYlim = [-2 2]; selChan = 0;
         case 'powSpec.yo'
            depVar = 'powSpec.yo'; selChan = 0;
 
%         case 'thetaCohPeakLMF6-12Hz'
%             depVar = 'thetaCohPeakLMF6-12Hz'; categMeansYlim = [-1 1]; selChan = 1;
%         case 'thetaCohPeakLMF6-12Hz'
%             depVar = 'thetaCohPeakLMF6-12Hz'; categMeansYlim = [-1 1]; selChan = 2;
%         case'thetaCohPeakLMF6-12Hz'
%             depVar = 'thetaCohPeakLMF6-12Hz'; categMeansYlim = [-1 1]; selChan = 3;
%         case 'thetaCohPeakLMF6-12Hz'
%             depVar = 'thetaCohPeakLMF6-12Hz'; categMeansYlim = [-1 1]; selChan = 4;
%         case 'thetaCohPeakLMF6-12Hz'
%             depVar = 'thetaCohPeakLMF6-12Hz'; categMeansYlim = [-1 1]; selChan = 5;
%         case 'thetaCohPeakLMF6-12Hz'
%             depVar = 'thetaCohPeakLMF6-12Hz'; categMeansYlim = [-1 1]; selChan = 6;
%         case 'gammaCohMean60-120Hz'
%             depVar = 'gammaCohMean60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 1;
%         case 'gammaCohMean60-120Hz'
%             depVar = 'gammaCohMean60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 2;
%         case 'gammaCohMean60-120Hz'
%             depVar = 'gammaCohMean60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 3;
%         case 'gammaCohMean60-120Hz'
%             depVar = 'gammaCohMean60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 4;
%         case 'gammaCohMean60-120Hz'
%             depVar = 'gammaCohMean60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 5;
%         case 'gammaCohMean60-120Hz'
%             depVar = 'gammaCohMean60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 6;
%         case 'thetaPhaseMean6-12Hz'
%             depVar = 'thetaPhaseMean6-12Hz'; categMeansYlim = []; selChan = 1;
%         case 'thetaPhaseMean6-12Hz'
%             depVar = 'thetaPhaseMean6-12Hz'; categMeansYlim = []; selChan = 2;
%         case 'thetaPhaseMean6-12Hz'
%             depVar = 'thetaPhaseMean6-12Hz'; categMeansYlim = []; selChan = 3;
%         case 'thetaPhaseMean6-12Hz'
%             depVar = 'thetaPhaseMean6-12Hz'; categMeansYlim = []; selChan = 4;
%         case 'thetaPhaseMean6-12Hz'
%             depVar = 'thetaPhaseMean6-12Hz'; categMeansYlim = []; selChan = 5;
%         case 'thetaPhaseMean6-12Hz'
%             depVar = 'thetaPhaseMean6-12Hz'; categMeansYlim = []; selChan = 6;

%         case 'thetaCohMean6-12Hz'
%             depVar = 'thetaCohMean6-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 1;
%         case 'thetaCohMean6-12Hz'
%             depVar = 'thetaCohMean6-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 2;
%         case 'thetaCohMean6-12Hz'
%             depVar = 'thetaCohMean6-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 3;
%         case 'thetaCohMean6-12Hz'
%             depVar = 'thetaCohMean6-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 4;
%         case 'thetaCohMean6-12Hz'
%             depVar = 'thetaCohMean6-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 5;
%         case 'thetaCohMean6-12Hz'
%             depVar = 'thetaCohMean6-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 6;
%        case7
%             depVar = 'thetaCohPeakSelChF4-12Hz'; categMeansYlim = [-1 1]; selChan = 1;
%        case 8
%             depVar = 'thetaCohPeakSelChF4-12Hz'; categMeansYlim = [-1 1]; selChan = 2;
%        case 9
%             depVar = 'thetaCohPeakSelChF4-12Hz'; categMeansYlim = [-1 1]; selChan = 3;
%        case 10
%             depVar = 'thetaCohPeakSelChF4-12Hz'; categMeansYlim = [-1 1]; selChan = 4;
%        case 11
%             depVar = 'thetaCohPeakSelChF4-12Hz'; categMeansYlim = [-1 1]; selChan = 5;
%        case 12
%             depVar = 'thetaCohPeakSelChF4-12Hz'; categMeansYlim = [-1 1]; selChan = 6;
% 
%         case 1
%             depVar = 'thetaPowPeak4-12Hz'; categMeansYlim = [-4 4]; selChan = 0;
%         case 2
%             depVar = 'gammaPowIntg60-120Hz'; categMeansYlim = [-2 2]; selChan = 0;
%         case 3
%             depVar = 'thetaCohMedian4-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 1;
%         case 4
%             depVar = 'thetaCohMedian4-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 2;
%         case 5
%             depVar = 'thetaCohMedian4-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 3;
%         case 6
%             depVar = 'thetaCohMedian4-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 4;
%         case 7
%             depVar = 'thetaCohMedian4-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 5;
%         case 8
%             depVar = 'thetaCohMedian4-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 6;
%         case 9
%             depVar = 'gammaCohMedian60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 1;
%         case 10
%             depVar = 'gammaCohMedian60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 2;
%         case 11
%             depVar = 'gammaCohMedian60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 3;
%         case 12
%             depVar = 'gammaCohMedian60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 4;
%         case 13
%             depVar = 'gammaCohMedian60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 5;
%         case 14
%             depVar = 'gammaCohMedian60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 6;
%         case 15
%             depVar = 'thetaPhaseMean4-12Hz'; categMeansYlim = [-1 1]; selChan = 1;
%         case 16
%             depVar = 'thetaPhaseMean4-12Hz'; categMeansYlim = [-1 1]; selChan = 2;
%         case 17
%             depVar = 'thetaPhaseMean4-12Hz'; categMeansYlim = [-1 1]; selChan = 3;
%         case 18
%             depVar = 'thetaPhaseMean4-12Hz'; categMeansYlim = [-1 1]; selChan = 4;
%         case 19
%             depVar = 'thetaPhaseMean4-12Hz'; categMeansYlim = [-1 1]; selChan = 5;
%         case 20
%             depVar = 'thetaPhaseMean4-12Hz'; categMeansYlim = [-1 1]; selChan = 6;
%         case 21
%             depVar = 'gammaPhaseMean60-120Hz'; categMeansYlim = [-1 1]; selChan = 1;
%         case 22
%             depVar = 'gammaPhaseMean60-120Hz'; categMeansYlim = [-1 1]; selChan = 2;
%         case 23
%             depVar = 'gammaPhaseMean60-120Hz'; categMeansYlim = [-1 1]; selChan = 3;
%         case 24
%             depVar = 'gammaPhaseMean60-120Hz'; categMeansYlim = [-1 1]; selChan = 4;
%         case 25
%             depVar = 'gammaPhaseMean60-120Hz'; categMeansYlim = [-1 1]; selChan = 5;
%         case 26
%             depVar = 'gammaPhaseMean60-120Hz'; categMeansYlim = [-1 1]; selChan = 6;
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

%    animalDirs = {...
%        '/BEEF01/smm/sm9601_Analysis/analysis03/',...
%        '/BEEF01/smm/sm9603_Analysis/analysis04/',...
%        '/BEEF02/smm/sm9614_Analysis/analysis02'...
%        '/BEEF02/smm/sm9608_Analysis/analysis02/',...
%        };
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
            %%%%%%% contBetas %%%%%%%%
            varNames = model.coeffNames;
            for m=1:length(varNames);
                coeffs.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    permute(model.coeffs(m,setdiff(chanLoc.(anatFields{j}),badChans),:),[2,3,1]);
            end
            %%%%%% categMeans %%%%%%%%
            if 0
            for n = 1:length(model.categMeans)
                varNames = model.categNames{n};
                for m=1:length(varNames);
                    %                 categMeans{n}.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    %                     squeeze(model.categMeans{n}(m,1,setdiff(chanLoc.(anatFields{j}),badChans))-...
                    %                     mean(model.categMeans{n}(:,1,setdiff(chanLoc.(anatFields{j}),badChans))));
                    categMeans{n}.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                        permute(squeeze(model.categMeans{n}(m,1,setdiff(chanLoc.(anatFields{j}),badChans))-...
                        mean(model.categMeans{n}(:,1,setdiff(chanLoc.(anatFields{j}),badChans),:))),[2,3,1]);
                end
            end
            end
            %%%%% rSq %%%%%% 
            varNames = model.rSqNames;
            for m=1:length(varNames);
                rSqs.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    permute(model.rSq(m,setdiff(chanLoc.(anatFields{j}),badChans),:),[2,3,1]);
            end
            %%%%% p-values %%%%%% 
            varNames = model.varNames;
            for m=1:length(varNames);
                pVals.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    permute(model.pVals(m,setdiff(chanLoc.(anatFields{j}),badChans),:),[2,3,1]);
            end
            %keyboard
            %try
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
                    permute(tempData(m,setdiff(chanLoc.(anatFields{j}),badChans),:),[2,3,1]);
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
                    permute(tempData(m,setdiff(chanLoc.(anatFields{j}),badChans),:),[2,3,1]);
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
                    permute(tempData(m,setdiff(chanLoc.(anatFields{j}),badChans),:),[2,3,1]);
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
                    permute(tempData(m,setdiff(chanLoc.(anatFields{j}),badChans),:),[2,3,1]);
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
                    permute(tempData(m,setdiff(chanLoc.(anatFields{j}),badChans),:),[2,3,1]);
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
                    permute(tempData(m,setdiff(chanLoc.(anatFields{j}),badChans),:),[2,3,1]);
            end
            %%%% residCategVarPs %%%%%
            tempData = MatStruct2StructMat2(assumTest.residCategVarPs);
            cellData = Struct2CellArray(tempData,[],1);
            tempData = cat(1,cellData{:,end});
            clear varNames;
            varNames{1,1} = 'all';
            for m=1:length(varNames);
                assumPlot.residCategVarPs.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    permute(tempData(m,setdiff(chanLoc.(anatFields{j}),badChans),:),[2,3,1]);
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
                    permute(tempData(m,setdiff(chanLoc.(anatFields{j}),badChans),:),[2,3,1]);
            end
              %catch keyboard
            %end
        end
    end

    nextFig = 1;
    %%%%%%%% plot contBetas %%%%%%%%
    plotData = coeffs;
    titlesExt = 'beta';
    log10Bool = 0;
    if isempty(selChanLoc)
    yLimits = [-3 3];
    else
        yLimits = [-5 5];
    end
    ttestBool = 1;
    nextFig = ScatPlotHelper(nextFig,fs,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool,selChanLoc);
    %%%%%%%% plot categMeans %%%%%%%%
    if 0
    for j=1:length(categMeans)
        plotData = categMeans{j};
        titlesExt = 'categMeans';
        log10Bool = 0;
        yLimits = [categMeansYlim];
        ttestBool = 1;
        nextFig = ScatPlotHelper(nextFig,fs,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool,selChanLoc);
    end
    end
    %%%%% plot rSq %%%%%%
    plotData = rSqs;
    titlesExt = 'rSq';
    log10Bool = 0;
    yLimits = [0 1];
    ttestBool = 0;
    nextFig = ScatPlotHelper(nextFig,fs,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool,selChanLoc);
    %%%%% plot p-values %%%%%%
    plotData = pVals;
    titlesExt = 'pVals';
    log10Bool = 1;
    yLimits = [-10 0];
    ttestBool = 0;
    nextFig = ScatPlotHelper(nextFig,fs,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool,selChanLoc);
    %%%% residNormPs %%%%%
    for j=1:length(assumPlot.residNormPs)
        plotData = assumPlot.residNormPs;
        titlesExt = 'residNormPs';
        log10Bool = 1;
        yLimits = [-3 0];
        ttestBool = 0;
        nextFig = ScatPlotHelper(nextFig,fs,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool,selChanLoc);
    end
    %%%% residMeanPs %%%%%
    for j=1:length(assumPlot.residMeanPs)
        plotData = assumPlot.residMeanPs;
        titlesExt = 'residMeanPs';
        log10Bool = 1;
        yLimits = [-3 0];
        ttestBool = 0;
        nextFig = ScatPlotHelper(nextFig,fs,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool,selChanLoc);
    end
    %%%% contDwPvals %%%%%
    for j=1:length(assumPlot.contDwPvals)
        plotData = assumPlot.contDwPvals;
        titlesExt = 'contDwPvals';
        log10Bool = 1;
        yLimits = [-3 0];
        ttestBool = 0;
        nextFig = ScatPlotHelper(nextFig,fs,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool,selChanLoc);
    end
    %%%% categDwPvals %%%%%
    for j=1:length(assumPlot.categDwPvals)
        plotData = assumPlot.categDwPvals;
        titlesExt = 'categDwPvals';
        log10Bool = 1;
        yLimits = [-3 0];
        ttestBool = 0;
        nextFig = ScatPlotHelper(nextFig,fs,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool,selChanLoc);
    end
    %%%% prllPvals %%%%%
    for j=1:length(assumPlot.prllPvals)
        plotData = assumPlot.prllPvals;
        titlesExt = 'prllPvals';
        log10Bool = 1;
        yLimits = [-3 0];
        ttestBool = 0;
        nextFig = ScatPlotHelper(nextFig,fs,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool,selChanLoc);
    end
    %%%% residContVarPs %%%%%
    for j=1:length(assumPlot.residContVarPs)
        plotData = assumPlot.residContVarPs;
        titlesExt = 'residContVarPs';
        log10Bool = 1;
        yLimits = [-3 0];
        ttestBool = 0;
        nextFig = ScatPlotHelper(nextFig,fs,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool,selChanLoc);
    end
    %%%% residCategVarPs %%%%%
    for j=1:length(assumPlot.residCategVarPs)
        plotData = assumPlot.residCategVarPs;
        titlesExt = 'residCategVarPs';
        log10Bool = 1;
        yLimits = [-3 0];
        ttestBool = 0;
        nextFig = ScatPlotHelper(nextFig,fs,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool,selChanLoc);
    end
    %%%% residCategVarZs %%%%%
    for j=1:length(assumPlot.residCategVarZs)
        plotData = assumPlot.residCategVarZs;
        titlesExt = 'residCategVarZs';
        log10Bool = 0;
        yLimits = [-5 5];
        ttestBool = 0;
        nextFig = ScatPlotHelper(nextFig,fs,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool,selChanLoc);
    end
    cd(origDir)
    figureNums = [1 2 3]
    figureNames = {'_beta','_rsq','_pVal'}
    %keyboard
    keyboard
    if reportFigBool
        for j=1:length(animalDirs)
            comment{j} = [animalDirs{j} ' = ' num2str(plotColors(j,:))];
        end
        ReportFigSM(1:nextFig-1,Dot2Underscore(['/u12/smm/public_html/NewFigs/' saveDir dirname chanLocVersion '/' inNameNote '/' fileExt '/']),[],[],comment);
    else
        for z=1:length(figureNums)
            SaveFigure(figureNums(z),['/u12/smm/public_html/NewFigs/' saveDir dirname chanLocVersion '/' inNameNote '/' fileExt '/' depVar figureNames{z}])
            ReportFigSM(figureNums(z),Dot2Underscore(['/u12/smm/public_html/NewFigs/' saveDir dirname chanLocVersion '/' inNameNote '/' fileExt '/']));
        end
    end
end
return



function nextFig = ScatPlotHelper(nextFig,fs,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName,ttestBool,selChanLoc)
resizeWinBool = 1;
baseAlpha = 0.01;
% chanInfoDir = 'ChanInfo/';
% chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']);
% chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
% badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);
figSizeFactor = 2.5;
figVertOffset = 0.5;
figHorzOffset = 0;
plotNames=fieldnames(plotData);

figure(nextFig)
clf
set(gcf,'name',fileName);
defaultAxesPosition = [0.1,0.1,0.85,0.70];
set(gcf,'DefaultAxesPosition',defaultAxesPosition);
if resizeWinBool
    set(gcf, 'Units', 'inches')
    set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(length(plotNames)),figSizeFactor])
end
if ttestBool
    figure(nextFig+1)
    clf
    set(gcf,'name',fileName);
    defaultAxesPosition = [0.1,0.1,0.85,0.70];
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(length(plotNames)),figSizeFactor])
    end
end

%nextFig = nextFig + 1;
%fields = fieldnames(chanLoc);
%plotNames=fieldnames(plotData);
for j=1:length(plotNames)
    %     if ~isempty(xLimits)
    %         set(gca,'xlim',xLimits)
    %     end

    temp = {};
    meanTemp = [];
    stdTemp = [];
    tempNames = {};
    anatNames = fieldnames(plotData.(plotNames{j}));
    for k=1:length(anatNames)%length(anatNames):-1:1
        animalNames = fieldnames(plotData.(plotNames{j}).(anatNames{k}));
        ttestData = [];
        temp{k} = [];
        for m=1:length(animalNames)
            if ~isempty(plotData.(plotNames{j}).(anatNames{k}).(animalNames{m}))
                dataSize = size(plotData.(plotNames{j}).(anatNames{k}).(animalNames{m}),1);

                if exist('selChanLoc','var') & ~isempty(selChanLoc)
                    subplot(1,length(plotNames),j)
                    hold on
                    if log10Bool
                        plot(fs(1:size(plotData.(plotNames{j}).(selChanLoc).(animalNames{m}),2)),...
                            log10(plotData.(plotNames{j}).(selChanLoc).(animalNames{m})),'o','color',plotColors(m,:),'markersize',4);
                    else
                        plot(fs(1:size(plotData.(plotNames{j}).(selChanLoc).(animalNames{m}),2)),...
                            plotData.(plotNames{j}).(selChanLoc).(animalNames{m}),'o','color',plotColors(m,:),'markersize',4);
                    end
                end
                if log10Bool
                    temp{k}(end+1:end+dataSize,:) = [log10(plotData.(plotNames{j}).(anatNames{k}).(animalNames{m}))];
                    %plot(log10(plotData.(plotNames{j}).(anatNames{k}).(animalNames{m})),-k,'o','color',plotColors(m,:));
                else
                    temp{k}(end+1:end+dataSize,:) = [plotData.(plotNames{j}).(anatNames{k}).(animalNames{m})];
                    %plot(plotData.(plotNames{j}).(anatNames{k}).(animalNames{m}),-k,'o','color',plotColors(m,:));
                end
            end
            %keyboard
            ttestData = [ttestData; plotData.(plotNames{j}).(anatNames{k}).(animalNames{m})];
        end
        meanTemp(k,:) = mean(temp{k});
        %stdTemp(k) = std(temp{k});
        for n=1:size(ttestData,2)
            [h(k,n) p(k,n)] = ttest(ttestData(:,n),[],baseAlpha./size(meanTemp,1)/size(meanTemp,2));
        end

    end
    if ~exist('selChanLoc','var') | isempty(selChanLoc)
        xTickLabels = [10 20 40 80 120];
        xTickLabels(xTickLabels>fs(size(meanTemp,2))) = [];
        xTicks = [];
        for n=1:length(xTickLabels)
            xTicks(n) = find(abs(fs-xTickLabels(n)) == min(abs(fs-xTickLabels(n))),1);
        end
        if strcmp(plotNames{j},'Constant')
            figure(nextFig)
            subplot(1,length(plotNames),j)
            imagesc(meanTemp)
            colorbar
            set(gca,'fontsize',5)
            title(SaveTheUnderscores([plotNames{j} ' ' titlesExt ]))
        else
            figure(nextFig)
            subplot(1,length(plotNames),j)
            title(SaveTheUnderscores([plotNames{j} ' ' titlesExt ]))
            imagesc(meanTemp)
            set(gca,'clim',[yLimits])
            colorbar
            title(SaveTheUnderscores([plotNames{j} ' ' titlesExt ]))
        end
        set(gca,'fontsize',5,'ytick',1:length(anatNames),'yticklabel',anatNames)
        set(gca,'xtick',xTicks,'xticklabel',xTickLabels)
        if log10Bool
            colormap(flipud(LoadVar('ColorMapSean6.mat')));
        else
            colormap(LoadVar('ColorMapSean6.mat'));
        end
        if ttestBool
            figure(nextFig+1)
            subplot(1,length(plotNames),j)
            imagesc((log10(p)))
            set(gca,'clim',[-8 0])
            set(gca,'fontsize',5,'ytick',1:length(anatNames),'yticklabel',anatNames)
            set(gca,'xtick',xTicks,'xticklabel',xTickLabels)
            colormap(flipud(LoadVar('ColorMapSean6.mat')));
            colorbar
            title(SaveTheUnderscores([plotNames{j} ' ' titlesExt ' p<' num2str(baseAlpha./size(meanTemp,1)/size(meanTemp,2))]))
        end
    else
        if strcmp(plotNames{j},'Constant')
            set(gca,'ylim',yLimits,'fontsize',5)
            title(SaveTheUnderscores([plotNames{j} ' ' titlesExt ]))
        else
            %yLimits = [-5 5];
            set(gca,'ylim',yLimits,'fontsize',5)
            title(SaveTheUnderscores([selChanLoc ': ' plotNames{j} ' ' titlesExt ' p<' num2str(baseAlpha./size(meanTemp,1)/size(meanTemp,2))]))
            plot(get(gca,'xlim'),zeros(size(get(gca,'xlim'))),'--','linewidth',10,'color',[0.5 0.5 0.5])
            if ttestBool
                hPlotTemp = yLimits(2)*ones(1,size(h,2))-0.01;
                plot(fs(find(h(strcmp(anatNames,selChanLoc),:))),hPlotTemp(logical(h(strcmp(anatNames,selChanLoc),:))),'r*','markersize',5 )
            end
        end
    end
end
nextFig = nextFig + 1;
if ttestBool
    nextFig = nextFig + 1;
end

return


