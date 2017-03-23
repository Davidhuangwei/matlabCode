function CalcComodulation3(fileBaseMat,nchannels,channels,chanMat,badchan,averageRLbool)

newFs = 2;
whlFs = 39.065;
sampInterval = round(39.065/newFs);
lowCut1 = 6;
highCut1 = 14;
lowCut2 = 40;
highCut2 = 100;
%nchannels = 97;
%chanMat = MakeChanMat(6,16);
%badchan = load('sm9603EEGBadChan.txt');
fileExt = '.eeg';
plotAnatBool = 1;
figure(100)
clf
set(gcf,'name','CalcComodulation2');
hold on;
%channels = 1:96;
%comodData = [];
onePointBool = 1;
plotBool = 1;

for i=1:size(fileBaseMat,1)
    whldat = LoadMazeTrialTypes(fileBaseMat(i,:));
        notMinusOnes = whldat(:,1)~=-1;

    plot(whldat(notMinusOnes,1),whldat(notMinusOnes,2),'.','color',[0.5 0.5 0.5]);
end
for i=1:size(fileBaseMat,1)
    whldat = LoadMazeTrialTypes(fileBaseMat(i,:));
    mazeRegionsWhlDat = [];

    
    allMazeRegions = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0 0 0 1 1 1 1 1 1]);
    atports = LoadMazeTrialTypes(fileBaseMat(i,:),[],[1 1 0 0 0 0 0 0 0]);

    if  ~averageRLbool
                                                                       % rwp lwp  da Tj ca rga lga rra lra
        mazeRegionsWhlDat(1,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  0  0   0   1  0]);
        mazeRegionsWhlDat(2,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  0  0   0   0  1]);
        mazeRegionsWhlDat(3,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  1  0   0   0  0]);
        mazeRegionsWhlDat(4,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  1  0  0   0   0  0]);
        mazeRegionsWhlDat(5,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  0  1   0   0  0]);
        mazeRegionsWhlDat(6,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  0  0   1   0  0]);
        mazeRegionNames = {'center','Rreturn','Lreturn','Rgoal','Lgoal','Tjunction'};
    else
        mazeRegionsWhlDat(1,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  0  0   0   1   1]);
        mazeRegionsWhlDat(2,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  1  0   0   0   0]);
        mazeRegionsWhlDat(3,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  1  0  0   0   0  0]);
        mazeRegionsWhlDat(4,:,:) = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  0  1   1   0  0]);
        mazeRegionNames = {'return','center','Tjunction','goal'};
    end
    
    sampledPoints = zeros(size(whldat,1),1);
    
    if onePointBool
        trialbegin = find(allMazeRegions(:,1)~=-1);
        while ~isempty(trialbegin),
            trialend = trialbegin(1) + find(atports((trialbegin(1)+1):end,1)~=-1);
            if isempty(trialend),
                breaking = 1
                break;
            end
            for k=1:size(mazeRegionsWhlDat,1)
                trialMazeRegions{k} = trialbegin(1)-1+find(mazeRegionsWhlDat(k,trialbegin(1):(trialend(1)-1),1)~=-1);
                if ~isempty(trialMazeRegions{k})
                    if strcmp(mazeRegionNames{k},'center') 
                            trialMidX{k} = min(mazeRegionsWhlDat(k,trialMazeRegions{k},1)) ...
                                + (max(mazeRegionsWhlDat(k,trialMazeRegions{k},1)) - min(mazeRegionsWhlDat(k,trialMazeRegions{k},1)))*2/4;
                            %trialMidIndex{k} = find(abs(mazeRegionsWhlDat(k,trialMazeRegions{k},1) - trialMidX{k}) < 20);
                            trialMidIndex{k} = find(abs(mazeRegionsWhlDat(k,trialMazeRegions{k},1) - trialMidX{k}) ...
                                == min(abs(mazeRegionsWhlDat(k,trialMazeRegions{k},1) - trialMidX{k})));

                            trialMidPoint{k} = trialMidIndex{k}(1);
                    else
                        trialMidPointDist{k} = (mazeRegionsWhlDat(k,trialMazeRegions{k},1) ...
                            - mean([max(mazeRegionsWhlDat(k,trialMazeRegions{k},1)), min(mazeRegionsWhlDat(k,trialMazeRegions{k},1))])).^2 ...
                            + (mazeRegionsWhlDat(k,trialMazeRegions{k},2) ...
                            - mean([max(mazeRegionsWhlDat(k,trialMazeRegions{k},2)), min(mazeRegionsWhlDat(k,trialMazeRegions{k},2))])).^2;
                        trialMidPoint{k} = find(trialMidPointDist{k} == min(trialMidPointDist{k}));
                        trialMidPoint{k} = trialMidPoint{k}(1);
                        
                    end
                    sampledPoints(trialMazeRegions{k}(trialMidPoint{k}(:))) = 1;

                    if 0
                        plot(mazeRegionsWhlDat(k,trialMazeRegions{k}(trialMidPoint{k}(1)),1), mazeRegionsWhlDat(k,trialMazeRegions{k}(trialMidPoint{k}(1)),2),'r.','markersize',20);
                    end

                else
                    fprintf('\nSkipping trial because of bad indexing!\n')
                    %keyboard
                end
            end
            trialbegin = trialend(1)-1+find(allMazeRegions(trialend(1):end,1)~=-1);
        end
    else
        sampledPoints(1:sampInterval:end) = 1;
    end

    dspowname1 = [fileBaseMat(i,:) '_' num2str(lowCut1) '-' num2str(highCut1) 'Hz' fileExt '.100DBdspow'];
    fprintf('Loading: %s\n',dspowname1);
    powerdat1 = ((bload(dspowname1,[nchannels inf],0,'int16')')/100);
  
    dspowname2 = [fileBaseMat(i,:) '_' num2str(lowCut2) '-' num2str(highCut2) 'Hz' fileExt '.100DBdspow'];
    fprintf('Loading: %s\n',dspowname2);
    powerdat2 = ((bload(dspowname2,[nchannels inf],0,'int16')')/100);

    notMinusOnes = whldat(:,1)~=-1;
    figure(100)
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
    if exist('wholeMazeComodData','var')
        wholeMazeComodData = cat(1, wholeMazeComodData, comodData{k});
        %wholeMazeComodData(:,channels(j),2) = cat(1, wholeMazeComodData(:,channels(j),2), comodData{k}(:,channels(j),2));
    else
        wholeMazeComodData = comodData{k};
        %wholeMazeComodData(:,channels(j),2) = comodData{k}(:,channels(j),2);
    end
end

for j=1:length(channels)
    for k=1:size(mazeRegionsWhlDat,1)

        [corrCoefs(k,:,:,channels(j)), corrPvalues(k,:,:,channels(j))] = corrcoef(comodData{k}(:,channels(j),1),comodData{k}(:,channels(j),2));
    end
    [wholeMazeCorrCoefs(:,:,channels(j)) wholeMazeCorrPvalues(:,:,channels(j))] = corrcoef( wholeMazeComodData(:,channels(j),1),  wholeMazeComodData(:,channels(j),2));
end

for k=1:size(mazeRegionsWhlDat,1)
    corrCoefsPlotMats(k,:,:) = Make2DPlotMat(corrCoefs(k,2,1,:),chanMat);
    corrPvaluesPlotMats(k,:,:) = Make2DPlotMat(log10(corrPvalues(k,2,1,:)),chanMat);
end
wholeMazeCorrCoefsPlotMat = Make2DPlotMat(wholeMazeCorrCoefs(2,1,:),chanMat);
wholeMazeCorrPvaluesPlotMat = Make2DPlotMat(log10(wholeMazeCorrPvalues(2,1,:)),chanMat);   

 if plotAnatBool
     if strcmp(fileBaseMat(1,1:6),'sm9603') | strcmp(fileBaseMat(1,1:6),'sm9608') | strcmp(fileBaseMat(1,1:6),'sm9614')
         anatOverlayName = [fileBaseMat(1,1:6) 'AnatCurves.mat'];
     else
         anatOverlayName = ['sm9601AnatCurves.mat'];
     end
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
figure(101)
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
set(gcf,'name','CalcComodulation2');

figure(102)
clf
for k=1:size(mazeRegionsWhlDat,1)
    figureMats{k} = corrPvaluesPlotMats(k,:,:);
    subplotTitles{k} = [mazeRegionNames{k} ' pVal'];
    if plotAnatBool  
        anatOverlayCell{k} = anatOverlayName;
    end
end
axesHandles = XYFImageScMask(figureMats,badChanMask,[log10(0.05) log10(0.01)],0,gcf,[1 0 1]);
XYTitle(subplotTitles,axesHandles);
if plotAnatBool
    XYPlotAnatCurves(anatOverlayCell,  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end    
set(gcf,'name','CalcComodulation2');

figure(103)
clf
subplot(1,2,1)
figureMats = wholeMazeCorrCoefsPlotMat;
subplotTitles = ['whole maze corr coef'];
if plotAnatBool
    anatOverlayCell = {anatOverlayName};
end
axesHandles = ImageScMask(figureMats,badChanMask,[-.25 .25],[1 0 1]);
title(subplotTitles);
if plotAnatBool
    PlotAnatCurves(anatOverlayName,  plotSize,[plotOffset],[],anatLineWidth);
end    
set(gcf,'name','CalcComodulation2');

subplot(1,2,2)
figureMats = wholeMazeCorrPvaluesPlotMat;
subplotTitles = ['whole maze corr coef'];
axesHandles = ImageScMask(figureMats,badChanMask,[log10(0.05) log10(0.01)],[1 0 1]);
title(subplotTitles);
if plotAnatBool
    PlotAnatCurves(anatOverlayName,  plotSize,[plotOffset],[],anatLineWidth);
end    
set(gcf,'name','CalcComodulation2');



figure(104)
clf
plotChan = [49:64];
colors = [1 0 0;0 0 1; 0.5 0.5 0.5; 0 0 0];

for k=1:size(mazeRegionsWhlDat,1)
    for j=1:length(plotChan)

        subplot(size(mazeRegionsWhlDat,1)+1,length(plotChan),(k-1)*length(plotChan)+j)
        plot(comodData{k}(:,plotChan(j),1),comodData{k}(:,plotChan(j),2),'.');
        set(gca,'xlim',[45 66],'ylim',[34 56]);
        if j==1
            ylabel(mazeRegionNames{k})
        end


        subplot(size(mazeRegionsWhlDat,1)+1,length(plotChan),size(mazeRegionsWhlDat,1)*length(plotChan)+j)

        hold on
        plot(comodData{k}(:,plotChan(j),1),comodData{k}(:,plotChan(j),2),'.','color',colors(k,:));

        set(gca,'xlim',[45 66],'ylim',[34 56]);

        if j==1
            ylabel('whole maze')
        end
    end
end
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
