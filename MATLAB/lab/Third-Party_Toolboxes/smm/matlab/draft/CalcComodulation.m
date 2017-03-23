function PlotSparseWhl(fileBaseMat,newFs)

whlFs = 39.065;
sampInterval = round(39.065/newFs);
lowCut1 = 6;
highCut1 = 14;
lowCut2 = 40;
highCut2 = 100;
nchannels = 97;
fileExt = '.eeg';
plotAnatBool = 1;
figure(10)
clf
hold on;
channels = 1:96;
centerArmComodData = [];
rReturnArmComodData = [];
lReturnArmComodData = [];
rGoalArmComodData = [];
lGoalArmComodData = [];
TjunctionComodData = [];
for i=1:size(fileBaseMat,1)
    whldat = LoadMazeTrialTypes(fileBaseMat(i,:));
        notMinusOnes = whldat(:,1)~=-1;

    plot(whldat(notMinusOnes,1),whldat(notMinusOnes,2),'.','color',[0.5 0.5 0.5]);
end
for i=1:size(fileBaseMat,1)
    whldat = LoadMazeTrialTypes(fileBaseMat(i,:));
    centerArm = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  1   0   0   0  0]);
                                                     % rwp lwp  da Tj ca rga lga rra lra
    rReturnArm = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  0  0   0  1   0]);
    lReturnArm = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  0  0   0  0   1]);
    rGoalArm = LoadMazeTrialTypes(fileBaseMat(i,:),  [],[0   0   0  0  0  1   0   0  0]);
    LGoalArm = LoadMazeTrialTypes(fileBaseMat(i,:),  [],[0   0   0  0  0  0   1   0  0]);
    Tjunction = LoadMazeTrialTypes(fileBaseMat(i,:), [],[0   0   0  1  0  0   0   0  0]);
    dspowname1 = [fileBaseMat(i,:) '_' num2str(lowCut1) '-' num2str(highCut1) 'Hz' fileExt '.100DBdspow'];
    fprintf('Loading: %s\n',dspowname1);
    powerdat1 = ((bload(dspowname1,[nchannels inf],0,'int16')')/100);
  
    dspowname2 = [fileBaseMat(i,:) '_' num2str(lowCut2) '-' num2str(highCut2) 'Hz' fileExt '.100DBdspow'];
    fprintf('Loading: %s\n',dspowname2);
    powerdat2 = ((bload(dspowname2,[nchannels inf],0,'int16')')/100);
zGoalArmPowMat = Make2DPlotMat(zGoalArmPowMat,chanMat);

badChanMask = ~isnan(Make2DPlotMat(ones(size(zReturnArmPowMat)),chanMat,badchan));


    sampledPoints = zeros(size(whldat,1),1);
    sampledPoints(1:sampInterval:end) = 1;
    notMinusOnes = whldat(:,1)~=-1;
    figure(10)
    plot(whldat(notMinusOnes & sampledPoints,1),whldat(notMinusOnes & sampledPoints,2),'.','color',[1 0 0]);

    centerArmComodData = cat(1,centerArmComodData, cat(3,powerdat1(centerArm(:,1)~=-1 & sampledPoints,:), powerdat2(centerArm(:,1)~=-1 & sampledPoints,:)));
    rReturnArmComodData = cat(1,rReturnArmComodData, cat(3,powerdat1(rReturnArm(:,1)~=-1 & sampledPoints,:), powerdat2(rReturnArm(:,1)~=-1 & sampledPoints,:)));
    lReturnArmComodData = cat(1,lReturnArmComodData, cat(3,powerdat1(lReturnArm(:,1)~=-1 & sampledPoints,:), powerdat2(lReturnArm(:,1)~=-1 & sampledPoints,:)));
    rGoalArmComodData = cat(1,rGoalArmComodData, cat(3,powerdat1(rGoalArm(:,1)~=-1 & sampledPoints,:), powerdat2(rGoalArm(:,1)~=-1 & sampledPoints,:)));
    lGoalArmComodData = cat(1,lGoalArmComodData, cat(3,powerdat1(LGoalArm(:,1)~=-1 & sampledPoints,:), powerdat2(LGoalArm(:,1)~=-1 & sampledPoints,:)));
    TjunctionComodData = cat(1,TjunctionComodData, cat(3,powerdat1(Tjunction(:,1)~=-1 & sampledPoints,:), powerdat2(Tjunction(:,1)~=-1 & sampledPoints,:)));
end
keyboard

for j=1:length(channels)
    [centerArmCorrCoefs(:,:,j), centerArmP(:,:,j)] = corrcoef(centerArmComodData(:,j,1),centerArmComodData(:,j,2));
    [rReturnArmCorrCoefs(:,:,j), rReturnArmP(:,:,j)] = corrcoef(rReturnArmComodData(:,j,1),rReturnArmComodData(:,j,2));
    [lReturnArmCorrCoefs(:,:,j), lReturnArmP(:,:,j)] = corrcoef(lReturnArmComodData(:,j,1),lReturnArmComodData(:,j,2));
    [rGoalArmCorrCoefs(:,:,j), rGoalArmP(:,:,j)] = corrcoef(rGoalArmComodData(:,j,1),rGoalArmComodData(:,j,2));
    [lGoalArmCorrCoefs(:,:,j), lGoalArmP(:,:,j)] = corrcoef(lGoalArmComodData(:,j,1),lGoalArmComodData(:,j,2));
    [TjunctionCorrCoefs(:,:,j), TjunctionP(:,:,j)] = corrcoef(TjunctionComodData(:,j,1),TjunctionComodData(:,j,2));
end
keyboard
    
if plotAnatBool
    anatOverlayName = [fileBaseMat(1,1:6) 'AnatCurves.mat'];
    anatLineWidth = 3;
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

centerArmCorrCoefsPowMat = Make2DPlotMat(centerArmCorrCoefs(2,1,:),chanMat);
rReturnArmCorrCoefsPowMat = Make2DPlotMat(rReturnArmCorrCoefs(2,1,:),chanMat);
lReturnArmCorrCoefsPowMat = Make2DPlotMat(lReturnArmCorrCoefs(2,1,:),chanMat);
rGoalArmCorrCoefsPowMat = Make2DPlotMat(rGoalArmCorrCoefs(2,1,:),chanMat);
lGoalArmCorrCoefsPowMat = Make2DPlotMat(lGoalArmCorrCoefs(2,1,:),chanMat);
TjunctionCorrCoefsPowMat = Make2DPlotMat(TjunctionCorrCoefs(2,1,:),chanMat);

centerArmPPowMat = Make2DPlotMat(centerArmP(2,1,:),chanMat);
rReturnArmPPowMat = Make2DPlotMat(rReturnArmP(2,1,:),chanMat);
lReturnArmPPowMat = Make2DPlotMat(lReturnArmP(2,1,:),chanMat);
rGoalArmPPowMat = Make2DPlotMat(rGoalArmP(2,1,:),chanMat);
lGoalArmPPowMat = Make2DPlotMat(lGoalArmP(2,1,:),chanMat);
TjunctionPPowMat = Make2DPlotMat(TjunctionP(2,1,:),chanMat);


badChanMask = ~isnan(Make2DPlotMat(ones(size(centerArmCorrCoefs)),chanMat,badchan));
figure(100)
clf
figureMats = {centerArmCorrCoefsPowMat,rReturnArmCorrCoefsPowMat,lReturnArmCorrCoefsPowMat,rGoalArmCorrCoefsPowMat,lGoalArmCorrCoefsPowMat,TjunctionCorrCoefsPowMat};
subplotTitles = {[ 'center corr coefs'], 'rReturn corr coefs', 'lReturn corr coefs', 'rGoal corr coefs', 'lGoal corr coefs','Tjunction corr coefs'};
axesHandles = XYFImageScMask(figureMats,badChanMask,[-.5 .5],0,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName,anatOverlayName,anatOverlayName,anatOverlayName,anatOverlayName,anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end                

figure(101)
clf
figureMats = {centerArmPPowMat,rReturnArmPPowMat,lReturnArmPPowMat,rGoalArmPPowMat,lGoalArmPPowMat,TjunctionPPowMat};
subplotTitles = {[ 'center p'], 'rReturn p', 'lReturn p', 'rGoal p', 'lGoal p','Tjunction p'};
axesHandles = XYFImageScMask(figureMats,badChanMask,[-.5 .5],0,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName,anatOverlayName,anatOverlayName,anatOverlayName,anatOverlayName,anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end                
subplot(1,2,2)
figureMats = centerArmPPowMat;
subplotTitles = {[ ' center arm p ']};
axesHandles = ImageScMask(figureMats,badChanMask,[],[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end                


figureMats = {, , ...
              , };
subplotTitles = {[taskType ' z ' mazeRegions{1}],[taskType ' z ' mazeRegions{2}], ...
          [taskType ' z ' mazeRegions{3}],[taskType ' z ' mazeRegions{4}]};
figure(4)
%cl
colorLimits = [-1.3 1.3];
%colorLimits = [-.75 .75];
axesHandles = XYFImageScMask(figureMats,badChanMask,[colorLimits],1,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName, anatOverlayName,...
                      anatOverlayName, anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end  



figure(10+j)
clf
subplot(3,3,5)
plot(centerArmComodData(:,3),centerArmComodData(:,4),'.')
subplot(3,3,9)
plot(rReturnArmComodData(:,3),rReturnArmComodData(:,4),'.')
subplot(3,3,7)
plot(lReturnArmComodData(:,3),lReturnArmComodData(:,4),'.')
subplot(3,3,3)
plot(rGoalArmComodData(:,3),rGoalArmComodData(:,4),'.')
subplot(3,3,1)
plot(lGoalArmComodData(:,3),lGoalArmComodData(:,4),'.')
subplot(3,3,2)
plot(TjunctionComodData(:,3),TjunctionComodData(:,4),'.')
centerArmComodData = [];
rReturnArmComodData = [];
lReturnArmComodData = [];
rGoalArmComodData = [];
lGoalArmComodData = [];
TjunctionComodData = [];

end
