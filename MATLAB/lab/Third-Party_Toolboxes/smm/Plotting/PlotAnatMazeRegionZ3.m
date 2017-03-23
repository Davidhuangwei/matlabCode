function PlotAnatMazeRegionZ3(taskType,fileBaseMat,fileNameFormat,fileExt,chanMat,badchan,lowCut,highCut,onePointBool,samescale,dbscale,plotAnatBool,textBool)


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
    textBool = 0;
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
meanReturnArmPowMat = Make2DPlotMat(meanReturnArmPowMat,chanMat,badchan);
meanCenterArmPowMat = Make2DPlotMat(meanCenterArmPowMat,chanMat,badchan);
meanTjunctionPowMat = Make2DPlotMat(meanTjunctionPowMat,chanMat,badchan);
meanGoalArmPowMat = Make2DPlotMat(meanGoalArmPowMat,chanMat,badchan);

sdReturnArmPowMat = Make2DPlotMat(sdReturnArmPowMat,chanMat,badchan);
sdCenterArmPowMat = Make2DPlotMat(sdCenterArmPowMat,chanMat,badchan);
sdTjunctionPowMat = Make2DPlotMat(sdTjunctionPowMat,chanMat,badchan);
sdGoalArmPowMat = Make2DPlotMat(sdGoalArmPowMat,chanMat,badchan);

sdPowerPerChan = Make2DPlotMat(sdPowerPerChan,chanMat,badchan);

normReturnArmPowMat = Make2DPlotMat(normReturnArmPowMat,chanMat,badchan);
normCenterArmPowMat = Make2DPlotMat(normCenterArmPowMat,chanMat,badchan);
normTjunctionPowMat = Make2DPlotMat(normTjunctionPowMat,chanMat,badchan);
normGoalArmPowMat = Make2DPlotMat(normGoalArmPowMat,chanMat,badchan);

zReturnArmPowMat = Make2DPlotMat(zReturnArmPowMat,chanMat,badchan);
zCenterArmPowMat = Make2DPlotMat(zCenterArmPowMat,chanMat,badchan);
zTjunctionPowMat = Make2DPlotMat(zTjunctionPowMat,chanMat,badchan);
zGoalArmPowMat = Make2DPlotMat(zGoalArmPowMat,chanMat,badchan);

% plot

if strcmp(taskType, 'circle')
    mazeRegions = {'quad 1','quad 2','quad 3','quad 4'};
end
if strcmp(taskType, 'alter') | strcmp(taskType, 'force')
    mazeRegions = {'return','center','choice','goal'};
end

if plotAnatBool
    anatFileName = [fileBaseMat(1,1:6) 'AnatCurvScaled.mat'];
else
    anatFileName = [];
end

figureMats = {{meanReturnArmPowMat,[taskType ' mean ' mazeRegions{1}]},{meanCenterArmPowMat,[taskType ' mean ' mazeRegions{2}]};...
              {meanTjunctionPowMat,[taskType ' mean ' mazeRegions{3}]},{meanGoalArmPowMat,[taskType ' mean ' mazeRegions{4}]}};
nimagesc(figureMats,1,[39.99 63],1,anatFileName);
 
aveabsmin = 0;
aveabsmax = 4*10^5;
figureMats = {{sdReturnArmPowMat,[taskType ' sd return' mazeRegions{1}]},{sdCenterArmPowMat,[taskType ' sd center' mazeRegions{2}]};...
              {sdTjunctionPowMat,[taskType ' sd choice' mazeRegions{3}]},{sdGoalArmPowMat,[taskType ' sd reward' mazeRegions{4}]}};
nimagesc(figureMats,1,[],2,anatFileName);

figureMats = {{sdPowerPerChan,[taskType ' mean(std(PowerPerChan2))']}};
nimagesc(figureMats,1,[],3,anatFileName);

aveabsmin = 0.40;
aveabsmax = 1.6;
if dbscale
aveabsmin = -2.5;
aveabsmax = 2.5;
end
figureMats = {{normReturnArmPowMat,[taskType ' norm ' mazeRegions{1}]},{normCenterArmPowMat,[taskType ' norm ' mazeRegions{2}]};...
              {normTjunctionPowMat,[taskType ' norm ' mazeRegions{3}]},{normGoalArmPowMat,[taskType ' norm ' mazeRegions{4}]}};
nimagesc(figureMats,1,[aveabsmin aveabsmax],4,anatFileName);

zabsmin = -3.01;
zabsmax = 3.01;
figureMats = {{zReturnArmPowMat,[taskType ' z ' mazeRegions{1}]},{zCenterArmPowMat,[taskType ' z ' mazeRegions{2}]};...
              {zTjunctionPowMat,[taskType ' z ' mazeRegions{3}]},{zGoalArmPowMat,[taskType ' z ' mazeRegions{4}]}};
nimagesc(figureMats,1,[zabsmin zabsmax],5,anatFileName);    


if textBool
    if 1
        for i=1:5
            figure(i);
            if fileNameFormat == 0
                text(0,0,{[num2str(lowCut) '-' num2str(highCut) 'Hz Power'],fileExt,'',...
                    taskType,fileBaseMat(1,1:6),[fileBaseMat(1,[7 10:12 14 17:19]) '-'],fileBaseMat(end,[7 10:12 14 17:19])})
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

