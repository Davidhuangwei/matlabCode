%  PlotAnatRemMazePow

alpha = 0.01;
depVar = 'gammaPowIntg';
%depVar = 'thetaPowPeak';

plotChans = [49:64];
%figure(1)
n=size(remMeasStruct.gammaPowIntg,1);
corrCoefs = zeros(2,2,96);
corrPvalues =  zeros(2,2,96);
for i=1:96
    
    [corrCoefs(:,:,i) corrPvalues(:,:,i)] = corrcoef(getfield(remMeasStruct,'gammaPowIntg',{1:n,i}),getfield(remMeasStruct,'thetaPowPeak',{1:n,i}));
    %subplot(1,16,i)
    %plot(getfield(remMeasStruct,'gammaPowIntg',{1:n,plotChans(i)}),getfield(remMeasStruct,'thetaPowPeak',{1:n,plotChans(i)}),'.');
end

figure(10)
clf
chans = [33;37;39;42;59;62];
for i=1:length(chans)
    subplot(length(chans),1,i)
    plotChan = chans(i);
    hold on
    plot(10.*log10(mean(getfield(remMeasStruct,'thetaNWYo',{1:80,1:100,chans(i)}),1)),'r')
    mazeYo = mean([10.*log10(mean(getfield(mazeMeasStruct,'returnArm','thetaNWYo',{1:38,1:100,chans(i)}),1));...
                10.*log10(mean(getfield(mazeMeasStruct,'centerArm','thetaNWYo',{1:38,1:100,chans(i)}),1));...
                10.*log10(mean(getfield(mazeMeasStruct,'Tjunction','thetaNWYo',{1:38,1:100,chans(i)}),1));...
                10.*log10(mean(getfield(mazeMeasStruct,'goalArm','thetaNWYo',{1:38,1:100,chans(i)}),1))],1);
    plot(mazeYo,'b')
    set(gca,'ylim',[40 85]);
end

chanMat = MakeChanMat(6,16);
badchan = load('sm9603EEGBadChan.txt');
mazeRegionNames = fieldnames(mazeMeasStruct(1));
wholeMaze = cat(1,getfield(mazeMeasStruct,mazeRegionNames{1},depVar),...
    getfield(mazeMeasStruct,mazeRegionNames{2},depVar),...
    getfield(mazeMeasStruct,mazeRegionNames{3},depVar),...
    getfield(mazeMeasStruct,mazeRegionNames{4},depVar));
mazePowMean = mean(wholeMaze,1);
remPowMean = mean(getfield(remMeasStruct,depVar),1);
sdRemPow = std(getfield(remMeasStruct,depVar),1);
sdMazePow = mean([std(getfield(mazeMeasStruct,'returnArm',depVar),1); ...
                    std(getfield(mazeMeasStruct,'centerArm',depVar),1); ...
                    std(getfield(mazeMeasStruct,'Tjunction',depVar),1); ...
                    std(getfield(mazeMeasStruct,'goalArm',depVar),1)],1);
meanSdPow = mean([sdRemPow; sdMazePow],1);
diffPowMean = mazePowMean-remPowMean;

zPowMean = (mazePowMean-remPowMean)./meanSdPow;


returnArmMean = mean(getfield(mazeMeasStruct,'returnArm',depVar),1);
centerArmMean = mean(getfield(mazeMeasStruct,'centerArm',depVar),1);
TjunctionMean = mean(getfield(mazeMeasStruct,'Tjunction',depVar),1);
goalArmMean = mean(getfield(mazeMeasStruct,'goalArm',depVar),1);

normReturnArmMean = returnArmMean-remPowMean;
normCenterArmMean = centerArmMean-remPowMean;
normTjunctionMean = TjunctionMean-remPowMean;
normGoalArmMean = goalArmMean-remPowMean;

zReturnArmMean = (returnArmMean-remPowMean)./meanSdPow;
zCenterArmMean = (centerArmMean-remPowMean)./meanSdPow;
zTjunctionMean = (TjunctionMean-remPowMean)./meanSdPow;
zGoalArmMean = (goalArmMean-remPowMean)./meanSdPow;

[mMaze n] = size(getfield(mazeMeasStruct,'returnArm',depVar));
[mRem n] = size(getfield(remMeasStruct,depVar));

hCenterArm = NaN*zeros(n);
hGoalArm = NaN*zeros(n);
hReturnArm = NaN*zeros(n);
hTjunction = NaN*zeros(n);
hMaze = NaN*zeros(n);

pCenterArm = NaN*zeros(n);
pGoalArm = NaN*zeros(n);
pReturnArm = NaN*zeros(n);
pTjunction = NaN*zeros(n);
pMaze = NaN*zeros(n);

for i = 1:n
    [hCenterArm(i), pCenterArm(i)] = ttest2(getfield(mazeMeasStruct,'returnArm',depVar,{1:mMaze,i}),getfield(remMeasStruct,depVar,{1:mRem,i}),alpha,'both');
    [hGoalArm(i), pGoalArm(i)] = ttest2(getfield(mazeMeasStruct,'centerArm',depVar,{1:mMaze,i}),getfield(remMeasStruct,depVar,{1:mRem,i}),alpha,'both');
    [hReturnArm(i), pReturnArm(i)] = ttest2(getfield(mazeMeasStruct,'Tjunction',depVar,{1:mMaze,i}),getfield(remMeasStruct,depVar,{1:mRem,i}),alpha,'both');
    [hTjunction(i), pTjunction(i)] = ttest2(getfield(mazeMeasStruct,'goalArm',depVar,{1:mMaze,i}),getfield(remMeasStruct,depVar,{1:mRem,i}),alpha,'both');
    [hMaze(i), pMaze(i)] = ttest2(wholeMaze(:,i),getfield(remMeasStruct,depVar,{1:mRem,i}),alpha,'both');
end
pCenterArm = log10(pCenterArm);
pGoalArm = log10(pGoalArm);
pReturnArm = log10(pReturnArm);
pTjunction = log10(pTjunction);
pMaze = log10(pMaze);


%%% make 2-d plot mats
corrCoefs = Make2DPlotMat(corrCoefs(2,1,:),chanMat,badchan);
corrPvalues = Make2DPlotMat(log10(corrPvalues(2,1,:)),chanMat,badchan);

meanSdPow = Make2DPlotMat(meanSdPow,chanMat,badchan);
sdMazePow = Make2DPlotMat(sdMazePow,chanMat,badchan);
sdRemPow = Make2DPlotMat(sdRemPow,chanMat,badchan);

zReturnArmMean = Make2DPlotMat(zReturnArmMean,chanMat,badchan);
zCenterArmMean = Make2DPlotMat(zCenterArmMean,chanMat,badchan);
zTjunctionMean = Make2DPlotMat(zTjunctionMean,chanMat,badchan);
zGoalArmMean = Make2DPlotMat(zGoalArmMean,chanMat,badchan);
zPowMean = Make2DPlotMat(zPowMean,chanMat,badchan);

hCenterArm = Make2DPlotMat(hCenterArm,chanMat,badchan);
hGoalArm = Make2DPlotMat(hGoalArm,chanMat,badchan);
hReturnArm = Make2DPlotMat(hReturnArm,chanMat,badchan);
hTjunction = Make2DPlotMat(hTjunction,chanMat,badchan);
hMaze = Make2DPlotMat(hMaze,chanMat,badchan);

pCenterArm = Make2DPlotMat(pCenterArm,chanMat,badchan);
pGoalArm = Make2DPlotMat(pGoalArm,chanMat,badchan);
pReturnArm = Make2DPlotMat(pReturnArm,chanMat,badchan);
pTjunction = Make2DPlotMat(pTjunction,chanMat,badchan);
pMaze = Make2DPlotMat(pMaze,chanMat,badchan);

normReturnArmMean = Make2DPlotMat(normReturnArmMean,chanMat);
normCenterArmMean = Make2DPlotMat(normCenterArmMean,chanMat);
normTjunctionMean = Make2DPlotMat(normTjunctionMean,chanMat);
normGoalArmMean = Make2DPlotMat(normGoalArmMean,chanMat);

mazePowMean = Make2DPlotMat(mazePowMean,chanMat);
remPowMean = Make2DPlotMat(remPowMean,chanMat);
diffPowMean = Make2DPlotMat(diffPowMean,chanMat);



badChanMask = ~isnan(Make2DPlotMat(ones(size(mazePowMean)),chanMat,badchan));
plotAnatBool = 1;
plotSize = [16.5,6.5];
plotOffset = [0 0];
anatLineWidth = 2;

anatOverlayName = ['sm9603AnatCurves.mat'];


figure(14)
clf
figureMats = {mazePowMean,remPowMean};
subplotTitles = {['mazePowMean'], ['remPowMean']};
axesHandles = XYFImageScMask(figureMats,badChanMask,[],1,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName,anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end  
set(gcf,'name',['maze_vs_rem_' depVar])

figure(15)
clf
figureMats = {diffPowMean};
subplotTitles = { ['maze-remPowMean']};
axesHandles = XYFImageScMask(figureMats,badChanMask,[-6 6],1,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end  
set(gcf,'name',['maze_vs_rem_' depVar])

figure(16)
clf
figureMats = {sdMazePow,sdRemPow,meanSdPow};
subplotTitles = {['sdMazePow'], ['sdRemPow'],['meanSdPow']};
axesHandles = XYFImageScMask(figureMats,badChanMask,[],1,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName,anatOverlayName,anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end  
set(gcf,'name',['maze_vs_rem_' depVar])


figure(17)
clf
figureMats = {zPowMean};
subplotTitles = { ['maze-remPowZ']};
axesHandles = XYFImageScMask(figureMats,badChanMask,[-3.5 3.5],1,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end  
set(gcf,'name',['maze_vs_rem_' depVar])

figure(18)
clf
colorLimits = [-1 1];
figureMats = {hMaze};
subplotTitles = { ['hMaze']};
axesHandles = XYFImageScMask(figureMats,badChanMask,[colorLimits],0,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end  
set(gcf,'name',['maze_vs_rem_' depVar])

figure(19)
clf
colorLimits = [-5 0];
figureMats = {pMaze};
subplotTitles = { ['pMaze']};
axesHandles = XYFImageScMask(figureMats,badChanMask,[colorLimits],0,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end  
set(gcf,'name',['maze_vs_rem_' depVar])

figure(20)
clf
figureMats = {normReturnArmMean,normCenterArmMean,normTjunctionMean,normGoalArmMean};
subplotTitles = {['normReturnArmMean'], ['normCenterArmMean'], ['normTjunctionMean'], ['normGoalArmMean']};
axesHandles = XYFImageScMask(figureMats,badChanMask,[-5 5],1,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName,anatOverlayName,anatOverlayName,anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end  
set(gcf,'name',['maze_vs_rem_' depVar])

figure(21)
clf
figureMats = {zReturnArmMean,zCenterArmMean,zTjunctionMean,zGoalArmMean};
subplotTitles = {['zeturnArmMean'], ['zCenterArmMean'], ['zTjunctionMean'], ['zGoalArmMean']};
axesHandles = XYFImageScMask(figureMats,badChanMask,[-4 4],1,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName,anatOverlayName,anatOverlayName,anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end  
set(gcf,'name',['maze_vs_rem_' depVar])

figure(22);
clf;
colorLimits = [-1 1];
figureMats = {hReturnArm, hCenterArm,hTjunction, hGoalArm};
subplotTitles = {'hReturnArm', 'hCenterArm','hTjunction', 'hGoalArm'};
axesHandles = XYFImageScMask(figureMats,badChanMask,colorLimits,1,[gcf],[1 0 1]);
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName,anatOverlayName,anatOverlayName,anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end                
set(gcf,'name',['maze_vs_rem_' depVar])

figure(23);
clf
colorLimits = [-5 0];
figureMats = {pReturnArm, pCenterArm,pTjunction, pGoalArm};
subplotTitles = {'pReturnArm', 'pCenterArm','pTjunction', 'pGoalArm'};
axesHandles = XYFImageScMask(figureMats,badChanMask,colorLimits,1,[gcf],[1 0 1]);
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName,anatOverlayName,anatOverlayName,anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end                
set(gcf,'name',['maze_vs_rem_' depVar])


figure(24)
clf
colorLimits = [0 1];
figureMats = {corrCoefs};
subplotTitles = { ['corrCoefs']};
axesHandles = XYFImageScMask(figureMats,badChanMask,[colorLimits],0,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end  
set(gcf,'name',['maze_vs_rem_' depVar])

figure(25)
clf
colorLimits = [-5 0];
figureMats = {corrPvalues};
subplotTitles = { ['corrPvalues']};
axesHandles = XYFImageScMask(figureMats,badChanMask,[colorLimits],0,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end  
set(gcf,'name',['maze_vs_rem_' depVar])

return




load alter-test3_sm9603m211s254-m244s290.eeg_Win600_thetaF5-10NW2_gammaF65-85NW4_MazeRegionsSpeedPow.mat
figure(10)
clf
chans = [33;37;39;42;59;62];
for i=1:length(chans)
    subplot(length(chans),1,i)
    plotChan = chans(i);
    hold on
    mazeYo = mean([10.*log10(mean(getfield(mazeMeasStruct,mazeRegionNames{1},'thetaNWYo',{1:38,1:100,chans(i)}),1));...
        10.*log10(mean(getfield(mazeMeasStruct,mazeRegionNames{2},'thetaNWYo',{1:38,1:100,chans(i)}),1));...
        10.*log10(mean(getfield(mazeMeasStruct,mazeRegionNames{3},'thetaNWYo',{1:38,1:100,chans(i)}),1));...
        10.*log10(mean(getfield(mazeMeasStruct,mazeRegionNames{4},'thetaNWYo',{1:38,1:100,chans(i)}),1))],1);

    plot(10.*log10(mean(getfield(mazeMeasStruct,mazeRegionNames{1},'thetaNWYo',{1:38,1:100,chans(i)}),1))./mazeYo,'b')
    plot(10.*log10(mean(getfield(mazeMeasStruct,mazeRegionNames{2},'thetaNWYo',{1:38,1:100,chans(i)}),1))./mazeYo,'r')
    plot(10.*log10(mean(getfield(mazeMeasStruct,mazeRegionNames{3},'thetaNWYo',{1:38,1:100,chans(i)}),1))./mazeYo,'k')
    plot(10.*log10(mean(getfield(mazeMeasStruct,mazeRegionNames{4},'thetaNWYo',{1:38,1:100,chans(i)}),1))./mazeYo,'c')
    set(gca,'ylim',[0.9 1.1]);
end


for j=1:4
    figure(j)
    clf
end
load alter-test3_sm9603m211s254-m244s290.eeg_Win600_thetaF5-10NW2_gammaF65-85NW4_MazeRegionsSpeedPow.mat
mazeRegionNames = {'returnArm','centerArm','Tjunction','goalArm'};
figure(10)
clf
chans = [33;37;39;42;59;62];
for i=1:length(chans)
    for j=1:4
        figure(j)
        subplot(length(chans),1,i)
        plotChan = chans(i);
        hold on
        plot(10.*log10(mean(getfield(mazeMeasStruct,mazeRegionNames{j},'thetaNWYo',{1:38,1:100,chans(i)}),1)),'r')
        set(gca,'ylim',[45 90]);
    end
end

load circle-test3_sm9603m209s252-m243s289.eeg_Win626_thetaF5-10NW2_gammaF65-85NW4_MazeRegionsSpeedPow.mat
mazeRegionNames = {'quad2','quad1','quad3','quad4'};
figure(10)
clf
chans = [33;37;39;42;59;62];
for i=1:length(chans)
    for j=1:4
        figure(j)
        subplot(length(chans),1,i)
        plotChan = chans(i);
        hold on
        plot(10.*log10(mean(getfield(mazeMeasStruct,mazeRegionNames{j},'thetaNWYo',{1:38,1:100,chans(i)}),1)),'b')
    end
end

