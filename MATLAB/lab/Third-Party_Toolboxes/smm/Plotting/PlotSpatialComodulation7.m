function PlotSpatialComodulation7(taskType,fileExt,fileNameFormat,chanMat,badchan,winLength,NW,thetaFreq,gammaFreq,binSize,smoothRad,blurRad)

occupThresh = 10;
plotAnatBool = 1;
%smoothRad = 8;

inName = ['SpatialComod_' taskType fileExt '_Win' num2str(winLength) '_NW' num2str(NW) '_' ...
    num2str(thetaFreq(1)) '-' num2str(thetaFreq(2)) 'Hz_vs_' num2str(gammaFreq(1)) '-' num2str(gammaFreq(2)) ...
    'Hz_grid_' num2str(binSize) '.mat']

load(inName)


figTitle = ['SpatialComod_' taskType fileExt '_win' num2str(winLength) 'NW' num2str(NW) '_' num2str(thetaFreq(1)) '-' num2str(thetaFreq(2)) ...
    'Hz_vs_' num2str(gammaFreq(1)) '-' num2str(gammaFreq(2)) 'Hz'];


figure(1)
clf
set(gcf,'name',figTitle)
hold on;

warning off MATLAB:divideByZero

fileBaseMat = getfield(spatialComodStruct,'info','fileBaseMat');
spatialComodData = getfield(spatialComodStruct,'spatialComodData');
spatialSlopes = getfield(spatialComodStruct,'spatialSlopes');
spatialRSquare = getfield(spatialComodStruct,'spatialRSquare');
spatialPvalues = getfield(spatialComodStruct,'spatialPvalues');
nPoints = getfield(spatialComodStruct,'nPoints');
whlTimes = getfield(spatialComodStruct,'whlTime');
spectTimes = getfield(spatialComodStruct,'spectTime');
fileNames = getfield(spatialComodStruct,'fileName');
whlFs = getfield(spatialComodStruct,'info','whlFs');
videoRes = getfield(spatialComodStruct,'info','videoRes');
gridYoffset = getfield(spatialComodStruct,'info','gridYoffset');


for i=1:size(fileBaseMat,1)
    whldat = LoadMazeTrialTypes(fileBaseMat(i,:));
    notMinusOnes = whldat(:,1)~=-1;    

    plot(whldat(notMinusOnes,1),whldat(notMinusOnes,2),'.','color',[0.5 0.5 0.5]);
    for m=1:binSize:videoRes(1)
        plot([m,m],[0,videoRes(2)])
    end
    for n=gridYoffset:binSize:videoRes(2)
        plot([videoRes(1),0],[n,n])
    end
end

for i=1:size(fileBaseMat,1)
    whldat = LoadMazeTrialTypes(fileBaseMat(i,:));
    wholeMaze = LoadMazeTrialTypes(fileBaseMat(i,:),[],[1 1 1 1 1 1 1 1 1]);
    notMinusOnes = whldat(:,1)~=-1;
    for m=1:ceil(videoRes(1)/binSize)
        for n=1:ceil(videoRes(2)/binSize)
            indexes = find(strcmp(mat2cell(fileNames{m,n},ones(size(fileNames{m,n},1),1),size(fileNames{m,n},2)), fileBaseMat(i,:)));
            plot(whldat(whlTimes{m,n}(indexes),1),whldat(whlTimes{m,n}(indexes),2),'.');
            
            for j=1:length(indexes)
                try plotWhl = [wholeMaze(round(spectTimes{m,n}(indexes(j),1)*whlFs+1):min(length(wholeMaze),round(spectTimes{m,n}(indexes(j),2)*whlFs+1)),1),...
                        wholeMaze(round(spectTimes{m,n}(indexes(j),1)*whlFs+1):min(length(wholeMaze),round(spectTimes{m,n}(indexes(j),2)*whlFs+1)),2)];
                catch
                    keyboard
                end
                plot(plotWhl(plotWhl(:,1)~=-1,1),plotWhl(plotWhl(:,1)~=-1,2),'r:')
            end    
        end
    end
end

%keyboard

newNPoints = NaN*zeros(size(spatialComodData,1),size(spatialComodData,2));
newSpatialSlopes = NaN*zeros(size(spatialSlopes));
newSpatialRSquare = NaN*zeros(size(spatialRSquare));
newSpatialPvalues = NaN*zeros(size(spatialPvalues));
%goodIndexes = zeros(size(spatialComodData,1),size(spatialComodData,2));
for m=1:size(spatialComodData,1)
    for n=1:size(spatialComodData,2)
        if size(spatialComodData{m,n},3)>=occupThresh
            newNPoints(m,n) = size(spatialComodData{m,n},3);
            newSpatialSlopes(m,n,:) = spatialSlopes(m,n,:);
            newSpatialRSquare(m,n,:) = spatialRSquare(m,n,:);
            newSpatialPvalues(m,n,:) = spatialPvalues(m,n,:);

        end
        %if size(spatialComodData{m,n},3) ~=1
        %    npoints(m,n) = size(spatialComodData{m,n},3);
        %end
    end
end
%smoothLen = 1;
%plot_low_thresh = 0.1
%    smooth_npoints = Smooth(npoints, smoothLen); % smooth position data
%    norm_smooth_pos_sum = smooth_npoints/sum(sum(smooth_npoints));
%    norm_plot_low_thresh = plot_low_thresh/sum(sum(smooth_npoints));
 %   [below_thresh_indexes] = find(norm_smooth_pos_sum<=norm_plot_low_thresh);
    %[above_thresh_x above_thresh_y] = find(norm_smooth_pos_sum>norm_plot_low_thresh);
 %   smooth_pos_sum_nan = smooth_npoints;
 %   smooth_pos_sum_nan(below_thresh_indexes)= NaN;
figure(2)
clf
subplot(1,3,1)
imagesc(nPoints)
set(gcf,'name',figTitle)
cLimits = get(gca,'clim');
set(gca,'clim',[0 cLimits(2)]);
colorbar
title('All Pixels')

figure(2)
subplot(1,3,2)
%[m,n] = find(goodIndexes);
imagesc(newNPoints)
set(gca,'clim',[0 cLimits(2)]);
colorbar
title(['Pixels > ' num2str(occupThresh)])

figure(2)
subplot(1,3,3)
imagesc(SmoothSkipNaN(SmoothSkipNaN(newNPoints,smoothRad,0),blurRad,1))
set(gca,'clim',[0 cLimits(2)]);
colorbar
title(['smoothRad=' num2str(smoothRad) 'blurRad=' num2str(blurRad)])

[x,y,z] = size(chanMat);
for i=1:x
    for j=1:y
        for k=1:z
            if isempty(find(badchan==chanMat(i,j,k)))
    %[m1 n1] = find(~isnan(spatialCorrCoefs(:,:,channels(j),2,1)));
    %figureCell{i,j,k} = Smooth(newSpatialCorrCoefs(:,:,channels(j),2,1).*npoints,smoothLen)./smooth_pos_sum_nan;
    %figureCell{j} = spatialCorrCoefs(:,:,channels(j),2,1);
    titles{i,j,k} = ['Channel:' num2str(chanMat(i,j,k))];
figureCell{i,j,k} = SmoothSkipNaN(SmoothSkipNaN(TrimBorderNaNs(newSpatialSlopes(:,:,chanMat(i,j,k)),2),smoothRad,0),blurRad,1);
figureCell2{i,j,k} = SmoothSkipNaN(SmoothSkipNaN(TrimBorderNaNs(newSpatialRSquare(:,:,chanMat(i,j,k)),2),smoothRad,0),blurRad,1);
    %figureCell{i,j,k} = TrimBorderNaNs(SmoothSkipNaN(spatialCorrCoefs(:,:,chanMat(i,j,k),2,1).*SmoothSkipNaN(npoints,smoothRad),smoothRad)./SmoothSkipNaN(npoints,smoothRad),2);
figureCell3{i,j,k} = SmoothSkipNaN(SmoothSkipNaN(log10(TrimBorderNaNs(newSpatialPvalues(:,:,chanMat(i,j,k)),2)),smoothRad,0),blurRad,1);
    %figure(1)
     %ImageScRmNaN(spatialCorrCoefs(:,:,channels(j),2,1),[-1 1],[0 0 1]);
            end
        end
    end
end

outText = {taskType,fileExt,GetFileNamesInfo(fileBaseMat,fileNameFormat),['win=' num2str(winLength)], ['NW=' num2str(NW)],...
    [num2str(thetaFreq(1)) '-' num2str(thetaFreq(2)) 'Hz'],[num2str(gammaFreq(1)) '-' num2str(gammaFreq(2)) 'Hz'],...
    ['bin=' num2str(binSize)],['smoothRad=' num2str(smoothRad)],['blurRad=' num2str(blurRad)]};

figure(3)
clf
axesHandles = XYFImageScRmNaN(figureCell,[-.6 .6], 1,[gcf],[0 0 1]);
XYTitle(titles,axesHandles);
XYSetAxesProperties('set(gca,''xtick'',[],''ytick'',[])',axesHandles);
set(gcf,'name',figTitle)
yLimits = get(gca,'ylim');
xLimits = get(gca,'xlim');
text(0,yLimits(2)+round(yLimits(2)),cat(2,{'Slope'},outText)),
figure(4)
clf
axesHandles = XYFImageScRmNaN(figureCell2,[0 .3], 1,[gcf],[0 0 1]);
XYTitle(titles,axesHandles);
XYSetAxesProperties('set(gca,''xtick'',[],''ytick'',[])',axesHandles);
set(gcf,'name',figTitle)
text(0,yLimits(2)+round(yLimits(2)),cat(2,{'rSquare'},outText)),

figure(5)
clf
axesHandles = XYFImageScRmNaN(figureCell3,[log10([1,0.01])], 1,[gcf],[0 0 1]);
XYTitle(titles,axesHandles);
XYSetAxesProperties('set(gca,''xtick'',[],''ytick'',[])',axesHandles);
set(gcf,'name',figTitle)
text(0,yLimits(2)+round(yLimits(2)),cat(2,{'p Values'},outText)),

in = [];
while ~strcmp(in,'y') & ~strcmp(in,'n')
    in = input('Report Figs? (y/n): ','s');
    if strcmp(in,'y')
        ReportFigSM(1,[],[4 4],[],[],75)
        ReportFigSM(2,[],[15 4],[],[],75)
        ReportFigSM(3:5,[],[15 20],[],[],75)
    end
end

return
