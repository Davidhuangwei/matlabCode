function PlotAnatMazeRegionZ7(description,fileBaseMat,fileNameFormat,fileExt,chanMat,badChans,...
    depVar,minSpeed,midPointsBool,winLength,thetaNW,gammaNW,samescale,dbscale,plotAnatBool,textBool)
% function PlotAnatMazeRegionZ4(taskType,fileBaseMat,fileNameFormat,fileExt,chanMat,badChans,lowCut,highCut,onePointBool,samescale,dbscale,plotAnatBool,textBool)


if ~exist('samescale','var')
    samescale = 0;
end
if ~exist('badChans','var')
    badChans = 0;
end
if ~exist('dbscale','var')
    dbscale = 0;
end
if ~exist('onePointBool','var')
    onePointBool = 0;
end
if ~exist('plotAnatBool','var')
    plotAnatBool = 1;
end
if ~exist('textBool','var')
    textBool = 0;
end
interpFunc = 'linear';
%interpFunc = [];


normByTrial = 1;
outlierStdev = 3;
nOutlierThresh = 6;
%colormap(LoadVar('ColorMapSean.mat'));

%interpFunc = [];


    %depVar = 'gammaPowIntg';
    %depVar = 'thetaPowPeak';
    %inName = [taskType midPtext '_MazeMeas_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) ...
    %'thetaNW' num2str(thetaNW) 'gammaNW' num2str(gammaNW) '.mat'];

%fprintf('Loading: %s\n',inName);
%load(inName);
if 0    
trialDesigCell = cat(2,cat(3,{'circle';[1 0 0 0 0 0 0 0 0 0 0 0 0];0.6;[0 0 0 0 0 0 0 0 1];0.5;'quad1'},...
                             {'circle';[1 0 0 0 0 0 0 0 0 0 0 0 0];0.6;[0 0 0 0 0 0 1 0 0];0.5;'quad2'},...
                             {'circle';[1 0 0 0 0 0 0 0 0 0 0 0 0];0.6;[0 0 0 0 0 1 0 0 0];0.5;'quad3'},...
                             {'circle';[1 0 0 0 0 0 0 0 0 0 0 0 0];0.6;[0 0 0 0 0 0 0 1 0];0.5;'quad4'}),...
                       cat(3,{'circle';[0 0 1 0 0 0 0 0 0 0 0 0 0];0.6;[0 0 0 0 0 0 0 1 0];0.5;'quad1'},...
                             {'circle';[0 0 1 0 0 0 0 0 0 0 0 0 0];0.6;[0 0 0 0 0 1 0 0 0];0.5;'quad2'},...
                             {'circle';[0 0 1 0 0 0 0 0 0 0 0 0 0];0.6;[0 0 0 0 0 0 1 0 0];0.5;'quad3'},...
                             {'circle';[0 0 1 0 0 0 0 0 0 0 0 0 0];0.6;[0 0 0 0 0 0 0 0 1];0.5;'quad4'}));
end

if 0
    trialDesigCell = cat(3,{'alter';[1 0 1 0 0 0 0 0 0 0 0 0 0];0.6;[0 0 0 0 0 0 0 1 1];0.5;'returnArm'},...
                           {'alter';[1 0 1 0 0 0 0 0 0 0 0 0 0];0.6;[0 0 0 0 1 0 0 0 0];0.5;'centerArm'},...
                           {'alter';[1 0 1 0 0 0 0 0 0 0 0 0 0];0.6;[0 0 0 1 0 0 0 0 0];0.4;'Tjunction'},...
                           {'alter';[1 0 1 0 0 0 0 0 0 0 0 0 0];0.6;[0 0 0 0 0 1 1 0 0];0.5;'goalArm'});
end
if 0
    trialDesigCell = cat(3,{'alter';[0 1 0 1 0 0 0 0 0 0 0 0 0];0.6;[0 0 0 0 0 0 0 1 1];0.5;'returnArm'},...
                           {'alter';[0 1 0 1 0 0 0 0 0 0 0 0 0];0.6;[0 0 0 0 1 0 0 0 0];0.5;'centerArm'},...
                           {'alter';[0 1 0 1 0 0 0 0 0 0 0 0 0];0.6;[0 0 0 1 0 0 0 0 0];0.4;'Tjunction'},...
                           {'alter';[0 1 0 1 0 0 0 0 0 0 0 0 0];0.6;[0 0 0 0 0 1 1 0 0];0.5;'goalArm'});
end
if 0
    trialDesigCell = cat(3,{'alter';[0 1 0 1 0 1 0 1 0 1 0 1 0];0.6;[0 0 0 0 0 0 0 1 1];0.5;'returnArm'},...
                           {'alter';[0 1 0 1 0 1 0 1 0 1 0 1 0];0.6;[0 0 0 0 1 0 0 0 0];0.5;'centerArm'},...
                           {'alter';[0 1 0 1 0 1 0 1 0 1 0 1 0];0.6;[0 0 0 1 0 0 0 0 0];0.4;'Tjunction'},...
                           {'alter';[0 1 0 1 0 1 0 1 0 1 0 1 0];0.6;[0 0 0 0 0 1 1 0 0];0.5;'goalArm'});
end
if 0
    trialDesigCell = cat(3,{'alter';[0 0 0 0 0 0 0 0 0 1 0 1 0];0.6;[0 0 0 0 0 0 0 1 1];0.5;'returnArm'},...
                           {'alter';[0 0 0 0 0 0 0 0 0 1 0 1 0];0.6;[0 0 0 0 1 0 0 0 0];0.5;'centerArm'},...
                           {'alter';[0 0 0 0 0 0 0 0 0 1 0 1 0];0.6;[0 0 0 1 0 0 0 0 0];0.4;'Tjunction'},...
                           {'alter';[0 0 0 0 0 0 0 0 0 1 0 1 0];0.6;[0 0 0 0 0 1 1 0 0];0.5;'goalArm'});
end
if 0
    trialDesigCell = cat(3,{'alter';[0 0 0 0 1 1 1 1 0 0 0 0 0];0.6;[0 0 0 0 0 0 0 1 1];0.5;'returnArm'},...
                           {'alter';[0 0 0 0 1 1 1 1 0 0 0 0 0];0.6;[0 0 0 0 1 0 0 0 0];0.5;'centerArm'},...
                           {'alter';[0 0 0 0 1 1 1 1 0 0 0 0 0];0.6;[0 0 0 1 0 0 0 0 0];0.4;'Tjunction'},...
                           {'alter';[0 0 0 0 1 1 1 1 0 0 0 0 0];0.6;[0 0 0 0 0 1 1 0 0];0.5;'goalArm'});
end
if 0
    trialDesigCell = cat(3,{'alter';[0 0 0 0 0 1 0 1 0 0 0 0 0];0.6;[0 0 0 0 0 0 0 1 1];0.5;'returnArm'},...
                           {'alter';[0 0 0 0 0 1 0 1 0 0 0 0 0];0.6;[0 0 0 0 1 0 0 0 0];0.5;'centerArm'},...
                           {'alter';[0 0 0 0 0 1 0 1 0 0 0 0 0];0.6;[0 0 0 1 0 0 0 0 0];0.4;'Tjunction'},...
                           {'alter';[0 0 0 0 0 1 0 1 0 0 0 0 0];0.6;[0 0 0 0 0 1 1 0 0];0.5;'goalArm'});
end
if 1
    trialDesig.returnArm = {'alter',[0 0 0 0 0 1 0 1 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.centerArm = {'alter',[0 0 0 0 0 1 0 1 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.Tjunction = {'alter',[0 0 0 0 0 1 0 1 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
    trialDesig.goalArm =   {'alter',[0 0 0 0 0 1 0 1 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
end

mazeRegionNames = fieldnames(trialDesig);
for i=1:length(mazeRegionNames)
    taskTypes(i) = getfield(trialDesig,mazeRegionNames{i},{1});
end

if midPointsBool
    midPointsText = '_MidPoints';
else
    midPointsText = '';
end


dirName = [description midPointsText '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength)...
    'ThetaNW' num2str(thetaNW) 'GammaNW' num2str(gammaNW) fileExt];

load([fileBaseMat(1,:) '/' dirName '/infoStruct.mat']);
if strcmp(depVar,'gammaPowIntg')
    lowCut = getfield(infoStruct,'gammaFreqRange',{1});
    highCut = getfield(infoStruct,'gammaFreqRange',{2});
end
if strcmp(depVar,'thetaPowPeak')
    lowCut = getfield(infoStruct,'thetaFreqRange',{1});
    highCut = getfield(infoStruct,'thetaFreqRange',{2});
end


regionPow = LoadDesigVar(fileBaseMat,dirName,depVar,trialDesigCell)


if normByTrial
    regionPow = RemoveOutlierTrials(regionPow,chanMat,badChans,outlierStdev,nOutlierThresh)

    for i=1:size(getfield(regionPow,mazeRegionNames{1}),1)
        temp = [];
        for j=1:length(mazeRegionNames)
            temp = cat(1,temp,getfield(regionPow,mazeRegionNames{j},{i,1:size(getfield(regionPow,mazeRegionNames{1}),2)}));
        end
        meanTrialPow(i,:) = mean(temp);
    end
end

allRegionPow = [];
meanRegionPow = [];
sdRegionPow = [];
allRegionSDs = [];
for i=1:length(mazeRegionNames)
    allRegionPow = cat(1,allRegionPow, getfield(regionPow,mazeRegionNames{i}));
    meanRegionPow = setfield(meanRegionPow,mazeRegionNames{i},mean(getfield(regionPow,mazeRegionNames{i})));
    sdRegionPow = setfield(sdRegionPow,mazeRegionNames{i},std(getfield(regionPow,mazeRegionNames{i})));
    allRegionSDs = cat(1,allRegionSDs,getfield(sdRegionPow,mazeRegionNames{i}));
end

meanPowPerChan = mean(allRegionPow);
sdPowPerChan = mean(allRegionSDs);

normTrialRegionPow = [];
sdTrialRegionPow = [];
zTrialRegionPow = [];
normRegionPow = [];
zRegionPow = [];
trialVariation = [];
for i=1:length(mazeRegionNames)
    if dbscale
        normRegionPow = setfield(normRegionPow,mazeRegionNames{i},getfield(meanRegionPow,mazeRegionNames{i}) - meanPowPerChan);
        if normByTrial
            normTrialRegionPow = setfield(normTrialRegionPow,mazeRegionNames{i},mean(getfield(regionPow,mazeRegionNames{i}) - meanTrialPow));
            sdTrialRegionPow = setfield(sdTrialRegionPow,mazeRegionNames{i},std(getfield(regionPow,mazeRegionNames{i}) - meanTrialPow));
        end
    else
        normRegionPow = setfield(normRegionPow,mazeRegionNames{i},getfield(meanRegionPow,mazeRegionNames{i}) ./ meanPowPerChan);
        if normByTrial
            normTrialRegionPow = setfield(normTrialRegionPow,mazeRegionNames{i},mean(getfield(regionPow,mazeRegionNames{i}) ./ meanTrialPow));
            sdTrialRegionPow = setfield(sdTrialRegionPow,mazeRegionNames{i},std(getfield(regionPow,mazeRegionNames{i}) ./ meanTrialPow));
        end
    end
    
    zRegionPow = setfield(zRegionPow,mazeRegionNames{i},...
        (getfield(meanRegionPow,mazeRegionNames{i}) - meanPowPerChan) ./ sdPowPerChan);

    if normByTrial
        zTrialRegionPow = setfield(zTrialRegionPow,mazeRegionNames{i},...
            mean(getfield(regionPow,mazeRegionNames{i}) - meanTrialPow) ./ getfield(sdTrialRegionPow,mazeRegionNames{i}));

        trialVariation = setfield(trialVariation,mazeRegionNames{i},...
            getfield(sdRegionPow,mazeRegionNames{i}) - getfield(sdTrialRegionPow,mazeRegionNames{i}));
    end
    % reshape matrices for imagesc plotting
    meanRegionPow = setfield(meanRegionPow,mazeRegionNames{i},...
        Make2DPlotMat(getfield(meanRegionPow,mazeRegionNames{i}),chanMat,badChans,interpFunc));
     
    sdRegionPow = setfield(sdRegionPow,mazeRegionNames{i},...
        Make2DPlotMat(getfield(sdRegionPow,mazeRegionNames{i}),chanMat,badChans,interpFunc));
   
    normRegionPow = setfield(normRegionPow,mazeRegionNames{i},...
        Make2DPlotMat(getfield(normRegionPow,mazeRegionNames{i}),chanMat,badChans,interpFunc));

    zRegionPow = setfield(zRegionPow,mazeRegionNames{i},...
        Make2DPlotMat(getfield(zRegionPow,mazeRegionNames{i}),chanMat,badChans,interpFunc));

    if normByTrial
        normTrialRegionPow = setfield(normTrialRegionPow,mazeRegionNames{i},...
            Make2DPlotMat(getfield(normTrialRegionPow,mazeRegionNames{i}),chanMat,badChans,interpFunc));

        sdTrialRegionPow = setfield(sdTrialRegionPow,mazeRegionNames{i},...
            Make2DPlotMat(getfield(sdTrialRegionPow,mazeRegionNames{i}),chanMat,badChans,interpFunc));

        zTrialRegionPow = setfield(zTrialRegionPow,mazeRegionNames{i},...
            Make2DPlotMat(getfield(zTrialRegionPow,mazeRegionNames{i}),chanMat,badChans,interpFunc));

        trialVariation = setfield(trialVariation,mazeRegionNames{i},...
            Make2DPlotMat(getfield(trialVariation,mazeRegionNames{i}),chanMat,badChans,interpFunc));
    end
end

sdPowPerChan = Make2DPlotMat(sdPowPerChan,chanMat,badChans,interpFunc);
meanPowPerChan = Make2DPlotMat(meanPowPerChan,chanMat,badChans,interpFunc);

badChanMask = ~isnan(Make2DPlotMat(ones(size(meanPowPerChan)),chanMat));
%badChanMask = [];

% plot
%if strcmp(taskType, 'circle')
%    mazeRegions = {'quad 1','quad 2','quad 3','quad 4'};
%end
%if strcmp(taskType(1:5), 'alter') | strcmp(taskType(1:5), 'force')
%    mazeRegions = {'return','center','choice','goal'};
%end

if plotAnatBool
    if fileNameFormat == 1
        anatOverlayName = ['sm9601' 'AnatCurves.mat'];
    else
        anatOverlayName = [fileBaseMat(1,1:6) 'AnatCurves.mat'];
    end
    anatLineWidth = 2;
    if strcmp(fileExt,'.eeg')
        plotOffset = [0 0];
    end
    if strcmp(fileExt,'.csd1') | strcmp(fileExt,'.csd.1') | strcmp(fileExt,'_NearAveCSD1.csd')
        plotOffset = [1 0];
    end
    if strcmp(fileExt,'.csd121') | strcmp(fileExt,'.csd.121') | strcmp(fileExt,'_LinNearCSD121.csd')
       plotOffset = [2 0];
    end
    %plotOffset
    %plotOffset(2) = 2;
    plotSize = [16.5,6.5];
    %plotSize = size(chanMat) + plotOffset.*2;
else
    anatOverlayName = [];
end



figure(1)
clf
%colorLimits = [43 60];
figureMats = {};
subplotTitles = {};
anatOverlayCell = {};
for i=1:length(mazeRegionNames)
    figureMats = cat(2,figureMats,{getfield(meanRegionPow,mazeRegionNames{i})});
    subplotTitles = cat(2,subplotTitles,{[taskTypes{i} ' mean ' mazeRegionNames{i}]});
    anatOverlayCell = cat(2,anatOverlayCell,{anatOverlayName});
end
axesHandles = XYFImageScRmNaN(figureMats,[],1,gcf); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves(anatOverlayCell,  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end                

figure(2)
clf
if strcmp(depVar,'gammaPowIntg')
    colorLimits = [0.75 1.5];
end
if strcmp(depVar,'thetaPowPeak')
    colorLimits = [0.25 2];
end
figureMats = {};
subplotTitles = {};
anatOverlayCell = {};
for i=1:length(mazeRegionNames)
    figureMats = cat(2,figureMats,{getfield(sdRegionPow,mazeRegionNames{i})});
    subplotTitles = cat(2,subplotTitles,{[taskTypes{i} ' sd ' mazeRegionNames{i}]});
    anatOverlayCell = cat(2,anatOverlayCell,{anatOverlayName});
end
axesHandles = XYFImageScRmNaN(figureMats,[colorLimits],1,gcf); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves(anatOverlayCell,  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end   


figure(3)
clf
if dbscale
    if strcmp(depVar,'gammaPowIntg')
        colorLimits = [-2 2];
    end
    if strcmp(depVar,'thetaPowPeak')
        colorLimits = [-2.2 2.2];
    end
else
    %colorLimits = [0.4 1.6];
    colorLimits = [0.8 1.2];
end
figureMats = {};
subplotTitles = {};
anatOverlayCell = {};
for i=1:length(mazeRegionNames)
    figureMats = cat(2,figureMats,{getfield(normRegionPow,mazeRegionNames{i})});
    subplotTitles = cat(2,subplotTitles,{[taskTypes{i} ' norm ' mazeRegionNames{i}]});
    anatOverlayCell = cat(2,anatOverlayCell,{anatOverlayName});
end
axesHandles = XYFImageScRmNaN(figureMats,colorLimits,1,gcf); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves(anatOverlayCell,  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end   


figure(4)
clf
if strcmp(depVar,'gammaPowIntg')
    colorLimits = [-1.3 1.3];
end
if strcmp(depVar,'thetaPowPeak')
    colorLimits = [-2.3 2.3];
end
figureMats = {};
subplotTitles = {};
anatOverlayCell = {};
for i=1:length(mazeRegionNames)
    figureMats = cat(2,figureMats,{getfield(zRegionPow,mazeRegionNames{i})});
    subplotTitles = cat(2,subplotTitles,{[taskTypes{i} ' z ' mazeRegionNames{i}]});
    anatOverlayCell = cat(2,anatOverlayCell,{anatOverlayName});
end
axesHandles = XYFImageScRmNaN(figureMats,colorLimits,1,gcf); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves(anatOverlayCell,  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end   


figure(5)
clf
colorLimits = [];
figureMats = {meanPowPerChan, sdPowPerChan};
subplotTitles = {[taskTypes{1} ' meanPowPerChan'], [taskTypes{1} ' mean(std(regionPow))']};
axesHandles = XYFImageScRmNaN(figureMats,colorLimits,0,gcf);
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName,anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end


if normByTrial

    figure(6)
    clf
    if strcmp(depVar,'gammaPowIntg')
        colorLimits = [0.75 1.5];
    end
    if strcmp(depVar,'thetaPowPeak')
        colorLimits = [0.25 2];
    end
    figureMats = {};
    subplotTitles = {};
    anatOverlayCell = {};
    for i=1:length(mazeRegionNames)
        figureMats = cat(2,figureMats,{getfield(sdTrialRegionPow,mazeRegionNames{i})});
        subplotTitles = cat(2,subplotTitles,{[taskTypes{i} ' sdTrial ' mazeRegionNames{i}]});
        anatOverlayCell = cat(2,anatOverlayCell,{anatOverlayName});
    end
    axesHandles = XYFImageScRmNaN(figureMats,[colorLimits],1,gcf);
    XYTitle(subplotTitles,axesHandles);
    if plotAnatBool
        XYPlotAnatCurves(anatOverlayCell,  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
    end


    figure(7)
    clf
    if dbscale
        if strcmp(depVar,'gammaPowIntg')
            colorLimits = [-2 2];
        end
        if strcmp(depVar,'thetaPowPeak')
            colorLimits = [-2.2 2.2];
        end
    else
        %colorLimits = [0.4 1.6];
        colorLimits = [0.8 1.2];
    end
    figureMats = {};
    subplotTitles = {};
    anatOverlayCell = {};
    for i=1:length(mazeRegionNames)
        figureMats = cat(2,figureMats,{getfield(normTrialRegionPow,mazeRegionNames{i})});
        subplotTitles = cat(2,subplotTitles,{[taskTypes{i} ' normTrial ' mazeRegionNames{i}]});
        anatOverlayCell = cat(2,anatOverlayCell,{anatOverlayName});
    end
    axesHandles = XYFImageScRmNaN(figureMats,colorLimits,1,gcf);
    XYTitle(subplotTitles,axesHandles);
    if plotAnatBool
        XYPlotAnatCurves(anatOverlayCell,  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
    end


    figure(8)
    clf
    if strcmp(depVar,'gammaPowIntg')
        colorLimits = [-2 2];
    end
    if strcmp(depVar,'thetaPowPeak')
        colorLimits = [-3 3];
    end
    figureMats = {};
    subplotTitles = {};
    anatOverlayCell = {};
    for i=1:length(mazeRegionNames)
        figureMats = cat(2,figureMats,{getfield(zTrialRegionPow,mazeRegionNames{i})});
        subplotTitles = cat(2,subplotTitles,{[taskTypes{i} ' zTrial ' mazeRegionNames{i}]});
        anatOverlayCell = cat(2,anatOverlayCell,{anatOverlayName});
    end
    axesHandles = XYFImageScRmNaN(figureMats,colorLimits,1,gcf);
    XYTitle(subplotTitles,axesHandles);
    if plotAnatBool
        XYPlotAnatCurves(anatOverlayCell,  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
    end

    figure(9)
    clf
    if strcmp(depVar,'gammaPowIntg')
        colorLimits = [-1 1];
    end
    if strcmp(depVar,'thetaPowPeak')
        colorLimits = [-1 1];
    end
    %colorLimits = [];
    figureMats = {};
    subplotTitles = {};
    anatOverlayCell = {};
    for i=1:length(mazeRegionNames)
        figureMats = cat(2,figureMats,{getfield(trialVariation,mazeRegionNames{i})});
        subplotTitles = cat(2,subplotTitles,{[taskTypes{i} ' trialVariation ' mazeRegionNames{i}]});
        anatOverlayCell = cat(2,anatOverlayCell,{anatOverlayName});
    end
    axesHandles = XYFImageScRmNaN(figureMats,colorLimits,1,gcf);
    XYTitle(subplotTitles,axesHandles);
    if plotAnatBool
        XYPlotAnatCurves(anatOverlayCell,  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
    end
end

if textBool
    if 1
        for i=1:5
            figure(i);
            if i==5
                plotSize = [9,3];
                %set(gcf,'PaperPosition',[(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)]);
                set(gcf, 'Units', 'inches')
                set(gcf, 'Position', [(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)])
            else
                plotSize = [18,3];
                %set(gcf,'PaperPosition',[(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)]);
                set(gcf, 'Units', 'inches')
                set(gcf, 'Position', [(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)])
            end
            set(gcf,'name',['PlotAnatMazeRegionZ6_' taskType fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz']);


            if fileNameFormat == 0
                text(-33,8,{[num2str(lowCut) '-' num2str(highCut) 'Hz Power'],fileExt,'',...
                    taskType,[fileBaseMat(1,1:6),[fileBaseMat(1,[7 10:12 14 17:19]) '-'],fileBaseMat(end,[7 10:12 14 17:19])]})
            end
            if fileNameFormat == 2
                text(-33,8,{[num2str(lowCut) '-' num2str(highCut) 'Hz Power'],fileExt,'',...
                    taskType,[fileBaseMat(1,1:6),[fileBaseMat(1,[8:10]) '-'],fileBaseMat(end,[8:10])]})
            end

        end
    end
end


if 0
    avecenterAnatPowMat(16) = avecenterAnatPowMat(15);
    avecenterAnatPowMat(81) = avecenterAnatPowMat(82);
    bscnoe =  [21 23 25 27 29 31 55 69 71 73 86 93]; % bad single channels not on end of shank
    for i=1:length(bscnoe)
        avecenterAnatPowMat(bscnoe(i)) = (avecenterAnatPowMat(bscnoe(i)-1) + avecenterAnatPowMat(bscnoe(i)+1))/2;
    end
    tempchan = (avecenterAnatPowMat(74) + avecenterAnatPowMat(77))/2;
    avecenterAnatPowMat(75) = (tempchan + avecenterAnatPowMat(74))/2;
    avecenterAnatPowMat(76) = (tempchan + avecenterAnatPowMat(77))/2;
    
    avechoiceAnatPowmat(16) = avechoiceAnatPowmat(15);
    avechoiceAnatPowmat(81) = avechoiceAnatPowmat(82);
    bscnoe =  [21 23 25 27 29 31 55 69 71 73 86 93]; % bad single channels not on end of shank
    for i=1:length(bscnoe)
        avechoiceAnatPowmat(bscnoe(i)) = (avechoiceAnatPowmat(bscnoe(i)-1) + avechoiceAnatPowmat(bscnoe(i)+1))/2;
    end
    tempchan = (avechoiceAnatPowmat(74) + avechoiceAnatPowmat(77))/2;
    avechoiceAnatPowmat(75) = (tempchan + avechoiceAnatPowmat(74))/2;
    avechoiceAnatPowmat(76) = (tempchan + avechoiceAnatPowmat(77))/2;

end

