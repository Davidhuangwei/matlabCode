function CalcSpatialComodulation5(taskType,fileBaseMat,fileExt,nchannels,channels,winLength,nOverlap,NW,thetaFreq,gammaFreq,binSize)

whlFs = 39.065;
spectDir = 'spectrograms/';
videoRes = [368,240];
gridYoffset = 15;
trialTypesBool = [1 0 1 0 0 0 0 0 0 0 0 0 0];

figure(1)
clf
set(gcf,'name','CalcSpatialComodulation')
hold on;
%plotBool = 1;

for i=1:size(fileBaseMat,1)
    whldat = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool);
    notMinusOnes = whldat(:,1)~=-1;    

    plot(whldat(notMinusOnes,1),whldat(notMinusOnes,2),'.','color',[0.5 0.5 0.5]);
    for m=1:binSize:videoRes(1)
        plot([m,m],[0,videoRes(2)])
    end
    for n=gridYoffset:binSize:videoRes(2)
        plot([videoRes(1),0],[n,n])
    end
end
 
in = [];
while ~strcmp(in,'n') & ~strcmp(in,'y') & ~strcmp(in,'')
    in = input('\nIs this grid good? [y]/n: ','s');
    if strcmp(in,'n')
        return
    end
end

spatialComodData = cell(ceil(videoRes(1)/binSize),ceil(videoRes(2)/binSize));
nPoints = ones(ceil(videoRes(1)/binSize),ceil(videoRes(2)/binSize));
whlTimes = cell(ceil(videoRes(1)/binSize),ceil(videoRes(2)/binSize));
fileNames = cell(ceil(videoRes(1)/binSize),ceil(videoRes(2)/binSize));
spectTimes = cell(ceil(videoRes(1)/binSize),ceil(videoRes(2)/binSize));

for i=1:size(fileBaseMat,1)
    whldat = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool);
    binnedWhlDat = whldat(:,1:2); % bin the spatial information and offset to make bins fit nicely
    binnedWhlDat(whldat(:,1)~=-1,1:2) = [ceil(whldat(whldat(:,1)~=-1,1)./binSize) ceil((whldat(whldat(:,1)~=-1,2)+gridYoffset)./binSize)];
    
    allMazeRegions = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,[0 0 0 1 1 1 1 1 1]);
    atports = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,[1 1 0 0 0 0 0 0 0]);
    wholeMaze = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,[1 1 1 1 1 1 1 1 1]);
     
    inName = [spectDir fileBaseMat(1,:) fileExt 'Win' num2str(winLength) 'Ovrlp' num2str(nOverlap) 'NW' num2str(NW) '_mtpsg_' num2str(channels(1)) '.mat'];
    fprintf('\nLoading: %s', inName);
    spect = load(inName);
    to = spect.to;
    toIndexes = cell(ceil(videoRes(1)/binSize),ceil(videoRes(2)/binSize));

    trialbegin = find(allMazeRegions(:,1)~=-1);
    while ~isempty(trialbegin),

        trialend = trialbegin(1) + find(atports((trialbegin(1)+1):end,1)~=-1);
        if isempty(trialend),
            breaking = 1
            break;
        end

        for m=1:ceil(videoRes(1)/binSize)
            for n=1:ceil(videoRes(2)/binSize)
                indexes = trialbegin(1)-1+find(binnedWhlDat(trialbegin(1):trialend(1),1)==m & binnedWhlDat(trialbegin(1):trialend(1),2)==n);
                if ~isempty(indexes)
                    toIndex = find(to <= (indexes(1)-1)/whlFs);
                    toIndexes{m,n} = [toIndexes{m,n}; toIndex(end)];
                    whlTimes{m,n} = [whlTimes{m,n}; indexes(1)];
                    fileNames{m,n} = [fileNames{m,n}; fileBaseMat(i,:)];
                    spectTimes{m,n} = [spectTimes{m,n}; to(toIndex(end)) to(min(length(to),toIndex(end)+1))];
                    
                    figure(1)
                    plot(whldat(indexes(1),1),whldat(indexes(1),2),'.');
                    try plotWhl = [wholeMaze(round(spectTimes{m,n}(end,1)*whlFs+1):min(length(wholeMaze),round(spectTimes{m,n}(end,2)*whlFs+1)),1),...
                                   wholeMaze(round(spectTimes{m,n}(end,1)*whlFs+1):min(length(wholeMaze),round(spectTimes{m,n}(end,2)*whlFs+1)),2)];
                    catch
                        keyboard
                    end
                    plot(plotWhl(plotWhl(:,1)~=-1,1),plotWhl(plotWhl(:,1)~=-1,2),'r:')
                    %plot(whldat(round(to(toIndex(end))*whlFs+1):round(to(toIndex(end)+1)*whlFs+1),1),...
                    %     whldat(round(to(toIndex(end))*whlFs+1):round(to(toIndex(end)+1)*whlFs+1),2),'r:')
                    %plot(whldat(whldat(:,1)==whldat(round(to(toIndex(end))*whlFs+1):round(to(toIndex(end)+1)*whlFs+1),1) & whldat(:,1)~=1,1),...
                    %     whldat(whldat(:,1)==whldat(round(to(toIndex(end))*whlFs+1):round(to(toIndex(end)+1)*whlFs+1),1) & whldat(:,1)~=1,2),'r:')
                end
            end
        end
        trialbegin = trialend(1)-1+find(allMazeRegions(trialend(1):end,1)~=-1);
    end
    
    for k=1:length(channels)
        inName = [spectDir fileBaseMat(i,:) fileExt 'Win' num2str(winLength) 'Ovrlp' num2str(nOverlap) 'NW' num2str(NW) '_mtpsg_' num2str(channels(k)) '.mat'];
        fprintf('\nLoading: %s', inName);
        spect = load(inName);
        %if median(diff(to))~=median(diff(spect.to))
        %    fprintf('\n\nwe gots problems to~=spect.to')
        %    keyboard
        %end
        thetaPow = 10.*log10(max(spect.yo(thetaFreq(1):thetaFreq(2),:),[],1));
        gammaPow = 10.*log10(sum(spect.yo(gammaFreq(1):gammaFreq(2),:),1));
        for m=1:ceil(videoRes(1)/binSize)
            for n=1:ceil(videoRes(2)/binSize)
                %1=freq,2=channel,3=trial
                if ~isempty(toIndexes{m,n})
                    spatialComodData{m,n}([1:2],k,nPoints(m,n):nPoints(m,n)+length(toIndexes{m,n})-1) ...
                        = cat(1,thetaPow(toIndexes{m,n}), gammaPow(toIndexes{m,n}));
                    
                end
            end
        end
    end
    for m=1:ceil(videoRes(1)/binSize)
        for n=1:ceil(videoRes(2)/binSize)
            nPoints(m,n) = nPoints(m,n) + length(toIndexes{m,n});
        end
    end
    figure(2)
    clf
    imagesc(nPoints)
    colorbar
end


spatialCorrCoefs = NaN*ones(size(spatialComodData,1),size(spatialComodData,2),nchannels,2,2);
spatialPvalues = NaN*ones(size(spatialComodData,1),size(spatialComodData,2),nchannels,2,2);
warning off MATLAB:divideByZero
for m=1:size(spatialComodData,1)
    for n=1:size(spatialComodData,2)
        if size(spatialComodData{m,n})==0 %| size(spatialComodData{m,n},3)==1
            %spatialCorrCoefs(m,n,:,:,:) = NaN;
            %spatialPvalues(m,n,:,:,:) = NaN;
        else
            %fprintf('m=%i,n=%i; ',m,n)
            for j=1:length(channels)
                %fprintf('%i,',j)
              
                try
                    [spatialCorrCoefs(m,n,channels(j),:,:) spatialPvalues(m,n,channels(j),:,:)] = corrcoef(spatialComodData{m,n}(1,channels(j),:),spatialComodData{m,n}(2,channels(j),:));

                catch
                    fprintf('\ncaught again')
                    keyboard
                end
            end
        end
    end
end

outName = ['SpatialComod_' taskType fileExt '_Win' num2str(winLength) '_NW' num2str(NW) '_' ...
    num2str(thetaFreq(1)) '-' num2str(thetaFreq(2)) 'Hz_vs_' num2str(gammaFreq(1)) '-' num2str(gammaFreq(2)) ...
    'Hz_grid_' num2str(binSize) '.mat']

spatialComodStruct = [];
spatialComodStruct = setfield(spatialComodStruct,'spatialComodData',spatialComodData);
spatialComodStruct = setfield(spatialComodStruct,'spatialCorrCoefs',spatialCorrCoefs);
spatialComodStruct = setfield(spatialComodStruct,'spatialPvalues',spatialPvalues);
spatialComodStruct = setfield(spatialComodStruct,'nPoints',nPoints);
spatialComodStruct = setfield(spatialComodStruct,'whlTime',whlTimes);
spatialComodStruct = setfield(spatialComodStruct,'spectTime',spectTimes);
spatialComodStruct = setfield(spatialComodStruct,'fileName',fileNames);
spatialComodStruct = setfield(spatialComodStruct,'info','taskType',taskType);
spatialComodStruct = setfield(spatialComodStruct,'info','fileBaseMat',fileBaseMat);
spatialComodStruct = setfield(spatialComodStruct,'info','fileExt',fileExt);
spatialComodStruct = setfield(spatialComodStruct,'info','nchannels',nchannels);
spatialComodStruct = setfield(spatialComodStruct,'info','channels',channels);
spatialComodStruct = setfield(spatialComodStruct,'info','winLength',winLength);
spatialComodStruct = setfield(spatialComodStruct,'info','nOverlap',nOverlap);
spatialComodStruct = setfield(spatialComodStruct,'info','NW',NW);
spatialComodStruct = setfield(spatialComodStruct,'info','thetaFreq',thetaFreq);
spatialComodStruct = setfield(spatialComodStruct,'info','gammaFreq',gammaFreq);
spatialComodStruct = setfield(spatialComodStruct,'info','binSize',binSize);
spatialComodStruct = setfield(spatialComodStruct,'info','saveName',outName);
spatialComodStruct = setfield(spatialComodStruct,'info','whlFs',whlFs);
spatialComodStruct = setfield(spatialComodStruct,'info','spectDir',spectDir);
spatialComodStruct = setfield(spatialComodStruct,'info','videoRes',videoRes);
spatialComodStruct = setfield(spatialComodStruct,'info','gridYoffset',gridYoffset);

save(outName,'spatialComodStruct');


return

smoothRad = 8;
newNPoints = NaN*zeros(size(spatialComodData,1),size(spatialComodData,2));
newSpatialCorrCoefs = NaN*zeros(size(spatialCorrCoefs));
newSpatialPvalues = NaN*zeros(size(spatialPvalues));
%goodIndexes = zeros(size(spatialComodData,1),size(spatialComodData,2));
for m=1:size(spatialComodData,1)
    for n=1:size(spatialComodData,2)
        if size(spatialComodData{m,n},3)>=10
            newNPoints(m,n) = size(spatialComodData{m,n},3);
            newSpatialCorrCoefs(m,n,:,:,:) = spatialCorrCoefs(m,n,:,:,:);
            newSpatialPvalues(m,n,:,:,:) = spatialPvalues(m,n,:,:,:);

        end
        %if size(spatialComodData{m,n},3) ~=1
        %    newNPoints(m,n) = size(spatialComodData{m,n},3);
        %end
    end
end
%smoothLen = 1;
%plot_low_thresh = 0.1
%    smooth_newNPoints = Smooth(newNPoints, smoothLen); % smooth position data
%    norm_smooth_pos_sum = smooth_newNPoints/sum(sum(smooth_newNPoints));
%    norm_plot_low_thresh = plot_low_thresh/sum(sum(smooth_newNPoints));
 %   [below_thresh_indexes] = find(norm_smooth_pos_sum<=norm_plot_low_thresh);
    %[above_thresh_x above_thresh_y] = find(norm_smooth_pos_sum>norm_plot_low_thresh);
 %   smooth_pos_sum_nan = smooth_newNPoints;
 %   smooth_pos_sum_nan(below_thresh_indexes)= NaN;

figure(4)
clf
%[m,n] = find(goodIndexes);
imagesc(newNPoints)
set(gcf,'name','CalcSpatialComodulation')
colorbar
figure(5)
clf
imagesc(SmoothSkipNaN(newNPoints,smoothRad))
set(gcf,'name','CalcSpatialComodulation')
colorbar
[x,y,z] = size(chanMat);
for i=1:x
    for j=1:y
        for k=1:z
            if isempty(find(badchan==chanMat(i,j,k)))
    %[m1 n1] = find(~isnan(spatialCorrCoefs(:,:,channels(j),2,1)));
    %figureCell{i,j,k} = Smooth(newSpatialCorrCoefs(:,:,channels(j),2,1).*newNPoints,smoothLen)./smooth_pos_sum_nan;
    %figureCell{j} = spatialCorrCoefs(:,:,channels(j),2,1);
figureCell{i,j,k} = TrimBorderNaNs(SmoothSkipNaN(newSpatialCorrCoefs(:,:,chanMat(i,j,k),2,1),smoothRad),2);
    %figureCell{i,j,k} = TrimBorderNaNs(SmoothSkipNaN(spatialCorrCoefs(:,:,chanMat(i,j,k),2,1).*SmoothSkipNaN(newNPoints,smoothRad),smoothRad)./SmoothSkipNaN(newNPoints,smoothRad),2);
figureCell2{i,j,k} = log10(SmoothSkipNaN(TrimBorderNaNs(newSpatialPvalues(:,:,chanMat(i,j,k),2,1),2),8));
    %figure(1)
     %ImageScRmNaN(spatialCorrCoefs(:,:,channels(j),2,1),[-1 1],[0 0 1]);
            end
        end
    end
end
figure(2)
clf
axesHandles = XYFImageScRmNaN(figureCell,[-.6 .6], 1,[gcf],[0 0 1]);
XYSetAxesProperties('set(gca,''xtick'',[],''ytick'',[])',axesHandles);
set(gcf,'name','CalcSpatialComodulation')
figure(3)
clf
axesHandles = XYFImageScRmNaN(figureCell2,[log10([1,0.05])], 1,[gcf],[0 0 1]);
XYSetAxesProperties('set(gca,''xtick'',[],''ytick'',[])',axesHandles);
set(gcf,'name','CalcSpatialComodulation')

keyboard

for j=1:length(channels)
    subplot(1,length(channels),j)
    figure(2)
    imagesc(figureCell{j})
    %set(gca,'clim',[-.5 .5]);
    colorbar
end
%ImageScRmNaN(spatialCorrCoefs(:,:,channels(j),2,1),[-1 1],[0 0 1]);


npoints = zeros(size(spatialComodData,1),size(spatialComodData,4))
for m=1:size(spatialComodData,1)
    for n=1:size(spatialComodData,2)
        npoints(m,n) = size(spatialComodData{m,n},3);
    end
end
npoints

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

figure(102)
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



figure(103)
clf
plotChan = [49:64];
colors = [1 0 0;0 0 1; 0.5 0.5 0.5; 0 0 0];

for k=1:size(mazeRegionsWhlDat,1)
    for j=1:length(plotChan)
        subplot(size(mazeRegionsWhlDat,1)+1,length(plotChan),(k-1)*length(plotChan)+j)
        if j==1
            ylabel(mazeRegionNames{k})
        end

        plot(comodData{k}(:,plotChan(j),1),comodData{k}(:,plotChan(j),2),'.');
        set(gca,'xlim',[45 65],'ylim',[34 55]);

        subplot(size(mazeRegionsWhlDat,1)+1,length(plotChan),size(mazeRegionsWhlDat,1)*length(plotChan)+j)
        if j==1
            ylabel('whole maze')
        end

        hold on
        plot(comodData{k}(:,plotChan(j),1),comodData{k}(:,plotChan(j),2),'.','color',colors(k,:));
        
        set(gca,'xlim',[45 65],'ylim',[34 55]);

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