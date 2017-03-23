function PlotAnatMazeRegionZ6(fileNameBase,taskType,fileBaseMat,fileNameFormat,fileExt,chanMat,badchan,...
    depVar,minSpeed,midPointsBool,winLength,thetaNW,gammaNW,samescale,dbscale,plotAnatBool,textBool)
% function PlotAnatMazeRegionZ4(taskType,fileBaseMat,fileNameFormat,fileExt,chanMat,badchan,lowCut,highCut,onePointBool,samescale,dbscale,plotAnatBool,textBool)


if ~exist('samescale','var')
    samescale = 0;
end
if ~exist('badchan','var')
    badchan = 0;
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
    textBool = 1;
end
interpFunc = 'linear';
%interpFunc = [];

if 1
    %depVar = 'gammaPowIntg';
    %depVar = 'thetaPowPeak';
    %inName = [taskType midPtext '_MazeMeas_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) ...
    %'thetaNW' num2str(thetaNW) 'gammaNW' num2str(gammaNW) '.mat'];

%fprintf('Loading: %s\n',inName);
%load(inName);
    if midPointsBool
        midPointsText = '_midPoints';
    else
        midPointsText = '';
    end
    inName = [fileNameBase midPointsText '_MazeMeas_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength)...
        'thetaNW' num2str(thetaNW) 'gammaNW' num2str(gammaNW) '.mat'];
    load(inName)
    if strcmp(depVar,'gammaPowIntg')
        lowCut = mazeMeasStruct.info.gammaFreqRange(1);
        highCut = mazeMeasStruct.info.gammaFreqRange(2);
    end
    if strcmp(depVar,'thetaPowPeak')
        lowCut = mazeMeasStruct.info.thetaFreqRange(1);
        highCut = mazeMeasStruct.info.thetaFreqRange(2);
    end
    task = getfield(mazeMeasStruct,'taskType');
    trialType = getfield(mazeMeasStruct,'trialType');
    mazeRegion = getfield(mazeMeasStruct,'mazeLocation');

    selectedTrials = zeros(length(task),1);
    trialDesigCell = cell(cat(2,{taskType},{[1 0 1 0 0 0 0 0 0 0 0 0 0]},{[0 0 0 0 0 0 0 1 1]}));
    for m=1:size(trialDesigCell,1)
        selectedTrials = selectedTrials | ...
            (strcmp(trialDesigCell{m,1},task) & trialType*trialDesigCell{m,2}'>0.6 & mazeRegion*trialDesigCell{m,3}'>0.5);
    end
    returnArmPowMat = getfield(mazeMeasStruct,depVar,{1:max(max(chanMat)),selectedTrials})';
        
    selectedTrials = zeros(length(task),1);
    trialDesigCell = cell(cat(2,{taskType},{[1 0 1 0 0 0 0 0 0 0 0 0 0]},{[0 0 0 0 1 0 0 0 0]}));
    for m=1:size(trialDesigCell,1)
        selectedTrials = selectedTrials | ...
            (strcmp(trialDesigCell{m,1},task) & trialType*trialDesigCell{m,2}'>0.6 & mazeRegion*trialDesigCell{m,3}'>0.5);
    end
    centerArmPowMat = getfield(mazeMeasStruct,depVar,{1:max(max(chanMat)),selectedTrials})';
    
    selectedTrials = zeros(length(task),1);
    trialDesigCell = cell(cat(2,{taskType},{[1 0 1 0 0 0 0 0 0 0 0 0 0]},{[0 0 0 1 0 0 0 0 0]}));
    for m=1:size(trialDesigCell,1)
        selectedTrials = selectedTrials | ...
            (strcmp(trialDesigCell{m,1},task) & trialType*trialDesigCell{m,2}'>0.6 & mazeRegion*trialDesigCell{m,3}'>0.5);
    end
    TjunctionPowMat = getfield(mazeMeasStruct,depVar,{1:max(max(chanMat)),selectedTrials})';

    selectedTrials = zeros(length(task),1);
    trialDesigCell = cell(cat(2,{taskType},{[1 0 1 0 0 0 0 0 0 0 0 0 0]},{[0 0 0 0 0 1 1 0 0]}));
    for m=1:size(trialDesigCell,1)
        selectedTrials = selectedTrials | ...
            (strcmp(trialDesigCell{m,1},task) & trialType*trialDesigCell{m,2}'>0.6 & mazeRegion*trialDesigCell{m,3}'>0.9);
    end
    goalArmPowMat = getfield(mazeMeasStruct,depVar,{1:max(max(chanMat)),selectedTrials})';
end

meanReturnArmPowMat = mean(returnArmPowMat,1);
meanCenterArmPowMat = mean(centerArmPowMat,1);
meanTjunctionPowMat = mean(TjunctionPowMat,1);
meanGoalArmPowMat = mean(goalArmPowMat,1);
%keyboard
%meanPowPerTrial = mean(cat(3,returnArmPowMat, centerArmPowMat, TjunctionPowMat, goalArmPowMat),3);
%meanPowPerChan = mean(meanPowPerTrial,1);
meanPowPerChan = mean(cat(1,returnArmPowMat, centerArmPowMat, TjunctionPowMat, goalArmPowMat),1);
sdPowerPerChan = mean([std(returnArmPowMat,1); std(centerArmPowMat,1); std(TjunctionPowMat,1); std(goalArmPowMat,1)],1);

sdReturnArmPowMat = std(returnArmPowMat,1);
sdCenterArmPowMat = std(centerArmPowMat,1);
sdTjunctionPowMat = std(TjunctionPowMat,1);
sdGoalArmPowMat = std(goalArmPowMat,1);

if dbscale
    normReturnArmPowMat = meanReturnArmPowMat - meanPowPerChan;
    normCenterArmPowMat = meanCenterArmPowMat - meanPowPerChan;
    normTjunctionPowMat = meanTjunctionPowMat - meanPowPerChan;
    normGoalArmPowMat = meanGoalArmPowMat - meanPowPerChan;
else
    normReturnArmPowMat = meanReturnArmPowMat ./ meanPowPerChan;
    normCenterArmPowMat = meanCenterArmPowMat ./ meanPowPerChan;
    normTjunctionPowMat = meanTjunctionPowMat ./ meanPowPerChan;
    normGoalArmPowMat = meanGoalArmPowMat ./ meanPowPerChan;
end

zReturnArmPowMat = (meanReturnArmPowMat - meanPowPerChan) ./ sdPowerPerChan;
zCenterArmPowMat = (meanCenterArmPowMat - meanPowPerChan) ./ sdPowerPerChan;
zTjunctionPowMat = (meanTjunctionPowMat - meanPowPerChan) ./ sdPowerPerChan;
zGoalArmPowMat = (meanGoalArmPowMat - meanPowPerChan) ./ sdPowerPerChan;

% reshape matrices for imagesc plotting
meanReturnArmPowMat = Make2DPlotMat(meanReturnArmPowMat,chanMat,badchan,interpFunc);
meanCenterArmPowMat = Make2DPlotMat(meanCenterArmPowMat,chanMat,badchan,interpFunc);
meanTjunctionPowMat = Make2DPlotMat(meanTjunctionPowMat,chanMat,badchan,interpFunc);
meanGoalArmPowMat = Make2DPlotMat(meanGoalArmPowMat,chanMat,badchan,interpFunc);

sdReturnArmPowMat = Make2DPlotMat(sdReturnArmPowMat,chanMat,badchan,interpFunc);
sdCenterArmPowMat = Make2DPlotMat(sdCenterArmPowMat,chanMat,badchan,interpFunc);
sdTjunctionPowMat = Make2DPlotMat(sdTjunctionPowMat,chanMat,badchan,interpFunc);
sdGoalArmPowMat = Make2DPlotMat(sdGoalArmPowMat,chanMat,badchan,interpFunc);

sdPowerPerChan = Make2DPlotMat(sdPowerPerChan,chanMat,badchan,interpFunc);
meanPowPerChan = Make2DPlotMat(meanPowPerChan,chanMat,badchan,interpFunc);

normReturnArmPowMat = Make2DPlotMat(normReturnArmPowMat,chanMat,badchan,interpFunc);
normCenterArmPowMat = Make2DPlotMat(normCenterArmPowMat,chanMat,badchan,interpFunc);
normTjunctionPowMat = Make2DPlotMat(normTjunctionPowMat,chanMat,badchan,interpFunc);
normGoalArmPowMat = Make2DPlotMat(normGoalArmPowMat,chanMat,badchan,interpFunc);

zReturnArmPowMat = Make2DPlotMat(zReturnArmPowMat,chanMat,badchan,interpFunc);
zCenterArmPowMat = Make2DPlotMat(zCenterArmPowMat,chanMat,badchan,interpFunc);
zTjunctionPowMat = Make2DPlotMat(zTjunctionPowMat,chanMat,badchan,interpFunc);
zGoalArmPowMat = Make2DPlotMat(zGoalArmPowMat,chanMat,badchan,interpFunc);

badChanMask = ~isnan(Make2DPlotMat(ones(size(zReturnArmPowMat)),chanMat));
%badChanMask = [];

% plot
if strcmp(taskType, 'circle')
    mazeRegions = {'quad 1','quad 2','quad 3','quad 4'};
end
if strcmp(taskType(1:5), 'alter') | strcmp(taskType(1:5), 'force')
    mazeRegions = {'return','center','choice','goal'};
end

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
    if strcmp(fileExt,'.csd1') | strcmp(fileExt,'.csd.1')
        plotOffset = [1 0];
    end
    if strcmp(fileExt,'.csd121') | strcmp(fileExt,'.csd.121')
       plotOffset = [2 0];
    end
    %plotOffset
    %plotOffset(2) = 2;
    plotSize = [16.5,6.5];
    %plotSize = size(chanMat) + plotOffset.*2;
else
    anatOverlayName = [];
end


figureMats = {meanReturnArmPowMat, meanCenterArmPowMat, ...
              meanTjunctionPowMat, meanGoalArmPowMat};
subplotTitles = {[taskType ' mean ' mazeRegions{1}],[taskType ' mean ' mazeRegions{2}], ...
          [taskType ' mean ' mazeRegions{3}],[taskType ' mean ' mazeRegions{4}]};
figure(1)
clf
%colorLimits = [43 60];
axesHandles = XYFImageScMask(figureMats,badChanMask,[],1,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName, anatOverlayName,...
                      anatOverlayName, anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end                


figureMats = {sdReturnArmPowMat, sdCenterArmPowMat, ...
              sdTjunctionPowMat, sdGoalArmPowMat};
subplotTitles = {[taskType ' sd ' mazeRegions{1}],[taskType ' sd ' mazeRegions{2}], ...
          [taskType ' sd ' mazeRegions{3}],[taskType ' sd ' mazeRegions{4}]};
figure(2)
clf
axesHandles = XYFImageScMask(figureMats,badChanMask,[],1,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName, anatOverlayName,...
                      anatOverlayName, anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end                


figureMats = {normReturnArmPowMat, normCenterArmPowMat, ...
              normTjunctionPowMat, normGoalArmPowMat};
subplotTitles = {[taskType ' norm ' mazeRegions{1}],[taskType ' norm ' mazeRegions{2}], ...
          [taskType ' norm ' mazeRegions{3}],[taskType ' norm ' mazeRegions{4}]};
figure(3)
clf
if dbscale
    if strcmp(depVar,'gammaPowIntg')
        colorLimits = [-1.55 1.55];
    end
    if strcmp(depVar,'thetaPowPeak')
        colorLimits = [-2.2 2.2];
    end
else
    %colorLimits = [0.4 1.6];
    colorLimits = [0.8 1.2];
end
axesHandles = XYFImageScMask(figureMats,badChanMask,[colorLimits],1,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName, anatOverlayName,...
                      anatOverlayName, anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end                


figureMats = {zReturnArmPowMat, zCenterArmPowMat, ...
              zTjunctionPowMat, zGoalArmPowMat};
subplotTitles = {[taskType ' z ' mazeRegions{1}],[taskType ' z ' mazeRegions{2}], ...
          [taskType ' z ' mazeRegions{3}],[taskType ' z ' mazeRegions{4}]};
figure(4)
%cl
if strcmp(depVar,'gammaPowIntg')
    colorLimits = [-1.0 1.0];
end
if strcmp(depVar,'thetaPowPeak')
    colorLimits = [-2.3 2.3];
end
axesHandles = XYFImageScMask(figureMats,badChanMask,[colorLimits],1,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName, anatOverlayName,...
                      anatOverlayName, anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end  


figure(5)
clf
figureMats = {meanPowPerChan, sdPowerPerChan};
subplotTitles = {[taskType ' meanPowPerChan'], [taskType ' mean(std(PowerPerChan2))']};
axesHandles = XYFImageScMask(figureMats,badChanMask,[],0,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName,anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end                


if textBool
    if 1
        for i=1:5
            figure(i);
            if i==5
                plotSize = [9,3];
                set(gcf,'PaperPosition',[(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)]);
                set(gcf, 'Units', 'inches')
                set(gcf, 'Position', [(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)])
            else
                plotSize = [18,3];
                set(gcf,'PaperPosition',[(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)]);
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

