function CalcComodulation2(fileBaseMat,newFs,badchan)

whlFs = 39.065;
sampInterval = round(39.065/newFs);
lowCut1 = 6;
highCut1 = 14;
lowCut2 = 40;
highCut2 = 100;
nchannels = 97;
chanMat = MakeChanMat(6,16);
%badchan = load('sm9603EEGBadChan.txt');
fileExt = '.eeg';
plotAnatBool = 1;
figure(10)
clf
hold on;
channels = 1:96;
%comodData = [];

for i=1:size(fileBaseMat,1)
    whldat = LoadMazeTrialTypes(fileBaseMat(i,:));
        notMinusOnes = whldat(:,1)~=-1;

    plot(whldat(notMinusOnes,1),whldat(notMinusOnes,2),'.','color',[0.5 0.5 0.5]);
end
for i=1:size(fileBaseMat,1)
    whldat = LoadMazeTrialTypes(fileBaseMat(i,:));
    mazeRegionsWhlDat = [];

    if 1 
                                                                       % rwp lwp  da Tj ca rga lga rra lra
        mazeRegionsWhlDat(1,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  1  0   0   0  0]);
        mazeRegionsWhlDat(2,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  0  0   0   1  0]);
        mazeRegionsWhlDat(3,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  0  0   0   0  1]);
        mazeRegionsWhlDat(4,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  0  1   0   0  0]);
        mazeRegionsWhlDat(5,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  0  0   1   0  0]);
        mazeRegionsWhlDat(6,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  1  0  0   0   0  0]);
        mazeRegionNames = {'center','Rreturn','Lreturn','Rgoal','Lgoal','Tjunction'};
    end
    if 0 % commented out
        mazeRegionsWhlDat(1,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  1  0   0   0  0]);
        mazeRegionsWhlDat(2,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  0  0   0   1   1]);
        mazeRegionsWhlDat(3,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  0  1   1   0  0]);
        mazeRegionsWhlDat(4,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  1  0  0   0   0  0]);
        mazeRegionNames = {'center','return','goal','Tjunction'};
    end
    dspowname1 = [fileBaseMat(i,:) '_' num2str(lowCut1) '-' num2str(highCut1) 'Hz' fileExt '.100DBdspow'];
    fprintf('Loading: %s\n',dspowname1);
    powerdat1 = ((bload(dspowname1,[nchannels inf],0,'int16')')/100);
  
    dspowname2 = [fileBaseMat(i,:) '_' num2str(lowCut2) '-' num2str(highCut2) 'Hz' fileExt '.100DBdspow'];
    fprintf('Loading: %s\n',dspowname2);
    powerdat2 = ((bload(dspowname2,[nchannels inf],0,'int16')')/100);

    sampledPoints = zeros(size(whldat,1),1);
    sampledPoints(1:sampInterval:end) = 1;
    notMinusOnes = whldat(:,1)~=-1;
    figure(10)
    plot(whldat(notMinusOnes & sampledPoints,1),whldat(notMinusOnes & sampledPoints,2),'.','color',[1 0 0]);
    
    for k=1:size(mazeRegionsWhlDat,1)
        %k
        if i==2
            %keyboard
        end
        if exist('comodData','var') & k <= size(comodData,2)
            try
                comodData{k} = cat(1,comodData{k}(:,:,:),cat(3,powerdat1(mazeRegionsWhlDat(k,:,1)'~=-1 & sampledPoints,:), powerdat2(mazeRegionsWhlDat(k,:,1)'~=-1 & sampledPoints,:)));
            catch
                k
                keyboard
            end
        else
            comodData{k} = cat(3,powerdat1(mazeRegionsWhlDat(k,:,1)'~=-1 & sampledPoints,:), powerdat2(mazeRegionsWhlDat(k,:,1)'~=-1 & sampledPoints,:));
        end
    end
end
for k=1:size(mazeRegionsWhlDat,1)
    for j=1:length(channels)
        [corrCoefs(k,:,:,j), corrPvalues(k,:,:,j)] = corrcoef(comodData{k}(:,j,1),comodData{k}(:,j,2));
    end
end
for k=1:size(mazeRegionsWhlDat,1)
    corrCoefsPlotMats(k,:,:) = Make2DPlotMat(corrCoefs(k,2,1,:),chanMat);
    corrPvaluesPlotMats(k,:,:) = Make2DPlotMat(log10(corrPvalues(k,2,1,:)),chanMat);
end

    
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


badChanMask = ~isnan(Make2DPlotMat(ones(size(corrCoefs(1,2,1,:))),chanMat,badchan));
figure(100)
clf
for k=1:size(mazeRegionsWhlDat,1)
    figureMats{k} = corrCoefsPlotMats(k,:,:);
    subplotTitles{k} = [mazeRegionNames{k} ' corrCoef'];
    if plotAnatBool  
        anatOverlayCell{k} = anatOverlayName;
    end
end
axesHandles = XYFImageScMask(figureMats,badChanMask,[-.5 .5],0,gcf,[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves(anatOverlayCell,  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end                

figure(101)
clf
for k=1:size(mazeRegionsWhlDat,1)
    figureMats{k} = corrPvaluesPlotMats(k,:,:);
    subplotTitles{k} = [mazeRegionNames{k} ' pVal'];
    if plotAnatBool  
        anatOverlayCell{k} = anatOverlayName;
    end
end
axesHandles = XYFImageScMask(figureMats,badChanMask,[log10(0.01) log10(0.02)],0,gcf,[1 0 1]);
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves(anatOverlayCell,  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end    
set(gcf,'name','CalcComodulation2');
keyboard
return


subplot(1,2,2)
figureMats = centerArmPPowMat;
subplotTitles = {[ ' center arm p ']};
axesHandles = ImageScMask(figureMats,badChanMask,[],[1 0 1]); 
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end                


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
