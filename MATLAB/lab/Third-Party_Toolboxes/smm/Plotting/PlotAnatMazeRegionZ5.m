function PlotAnatMazeRegionZ5(taskType,fileBaseMat,fileNameFormat,fileExt,chanMat,badchan,lowCut,highCut,onePointBool,samescale,dbscale,plotAnatBool,textBool)
% function PlotAnatMazeRegionZ4(taskType,fileBaseMat,fileNameFormat,fileExt,chanMat,badchan,lowCut,highCut,onePointBool,samescale,dbscale,plotAnatBool,textBool)


if fileNameFormat == 1,
    if onePointBool
        fileName = [taskType '_' fileBaseMat(1,[1:8]) '-' fileBaseMat(end,[1:8]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_point_AnatMazeRegionPow.mat'];
    else
        fileName = [taskType '_' fileBaseMat(1,[1:8]) '-' fileBaseMat(end,[1:8]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_mean_AnatMazeRegionPow.mat'];
    end
end
if fileNameFormat == 0,
    if onePointBool
        fileName = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_point_AnatMazeRegionPow.mat'];
    else
        fileName = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_mean_AnatMazeRegionPow.mat'];
    end
end
if fileNameFormat == 2,
    if onePointBool
        fileName = [taskType '_' fileBaseMat(1,[1:10]) '-' fileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_point_AnatMazeRegionPow.mat'];
    else
        fileName = [taskType '_' fileBaseMat(1,[1:10]) '-' fileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_mean_AnatMazeRegionPow.mat'];
    end
end

if exist(fileName,'file')
    fprintf('loading %s\n',fileName)
    load(fileName);
else
    fileName
    ERROR_RUN_CalcAnatMazeRegionPow
end


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

if 0
    returnArmPowMat = returnarmPowMat;
    centerArmPowMat = centerarmPowMat;
    TjunctionPowMat = choicepointPowMat;
    goalArmPowMat = choicearmPowMat;
end

if dbscale
    returnArmPowMat = 10.*log10(returnArmPowMat);
    centerArmPowMat = 10.*log10(centerArmPowMat);
    TjunctionPowMat = 10.*log10(TjunctionPowMat);
    goalArmPowMat = 10.*log10(goalArmPowMat);
end


if 1
    depVar = 'gammaPowIntg';
    %depVar = 'thetaPowPeak';
    load('alter-test3_sm9603m211s254-m244s290.eeg_Win600_thetaF5-10NW2_gammaF65-85NW4_MazeRegionsSpeedPow.mat')
    returnArmPowMat = getfield(mazeMeasStruct,'returnArm',depVar);
    centerArmPowMat = getfield(mazeMeasStruct,'centerArm',depVar);
    TjunctionPowMat = getfield(mazeMeasStruct,'Tjunction',depVar);
    goalArmPowMat = getfield(mazeMeasStruct,'goalArm',depVar);
end

meanReturnArmPowMat = mean(returnArmPowMat,1);
meanCenterArmPowMat = mean(centerArmPowMat,1);
meanTjunctionPowMat = mean(TjunctionPowMat,1);
meanGoalArmPowMat = mean(goalArmPowMat,1);

meanPowPerTrial = mean(cat(3,returnArmPowMat, centerArmPowMat, TjunctionPowMat, goalArmPowMat),3);
meanPowPerChan = mean(meanPowPerTrial,1);
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
meanReturnArmPowMat = Make2DPlotMat(meanReturnArmPowMat,chanMat);
meanCenterArmPowMat = Make2DPlotMat(meanCenterArmPowMat,chanMat);
meanTjunctionPowMat = Make2DPlotMat(meanTjunctionPowMat,chanMat);
meanGoalArmPowMat = Make2DPlotMat(meanGoalArmPowMat,chanMat);

sdReturnArmPowMat = Make2DPlotMat(sdReturnArmPowMat,chanMat);
sdCenterArmPowMat = Make2DPlotMat(sdCenterArmPowMat,chanMat);
sdTjunctionPowMat = Make2DPlotMat(sdTjunctionPowMat,chanMat);
sdGoalArmPowMat = Make2DPlotMat(sdGoalArmPowMat,chanMat);

sdPowerPerChan = Make2DPlotMat(sdPowerPerChan,chanMat);
meanPowPerChan = Make2DPlotMat(meanPowPerChan,chanMat);

normReturnArmPowMat = Make2DPlotMat(normReturnArmPowMat,chanMat);
normCenterArmPowMat = Make2DPlotMat(normCenterArmPowMat,chanMat);
normTjunctionPowMat = Make2DPlotMat(normTjunctionPowMat,chanMat);
normGoalArmPowMat = Make2DPlotMat(normGoalArmPowMat,chanMat);

zReturnArmPowMat = Make2DPlotMat(zReturnArmPowMat,chanMat);
zCenterArmPowMat = Make2DPlotMat(zCenterArmPowMat,chanMat);
zTjunctionPowMat = Make2DPlotMat(zTjunctionPowMat,chanMat);
zGoalArmPowMat = Make2DPlotMat(zGoalArmPowMat,chanMat);

badChanMask = ~isnan(Make2DPlotMat(ones(size(zReturnArmPowMat)),chanMat,badchan));

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
    colorLimits = [-1.55 1.55];
    %colorLimits = [-1 1];
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
colorLimits = [-1.0 1.0];
%colorLimits = [-.75 .75];
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
            set(gcf,'name',[taskType fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_PlotAnatMazeRegionZ4']);


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

