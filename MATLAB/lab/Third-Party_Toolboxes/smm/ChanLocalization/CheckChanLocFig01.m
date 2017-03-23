function CheckChanLoc(fileExt,chanLocVersion)
addpath /u12/smm/matlab/Plotting/Bar/
chanInfoDir = 'ChanInfo/';
chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']);
badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);
if exist([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat'],'file')
    chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
else
    ERROR
end
%chanLoc.rad(find(chanLoc.rad==37)) = 36;
%chanLoc.gran(find(chanLoc.gran==59)) = 58;
 %colormap('default')
 %cMap = colormap;
% map = [1 1 1; map];
% colormap(map);
cMap = LoadVar('ColorMapSean5.mat');
%cMap(1,:) = [0 0 0];
cMap(1,:) = [1 1 1];
colormap(cMap);

selChans = load([chanInfoDir 'SelectedChannels' fileExt '.txt']);

plotAnatBool = 1;
anatOverlayName = [chanInfoDir 'AnatCurves.mat'];
plotSize = [16.5,6.5];
plotOffset = load([chanInfoDir 'OffSet' fileExt '.txt']);
 
plotMat(odd(chanMat(:,odd(1:size(chanMat,2)-1))-1)+1) = -inf;
plotMat(odd(chanMat(:,odd(1:size(chanMat,2)-1))-1)) = -inf;
plotMat(odd(chanMat(:,odd(1:size(chanMat,2)-1)+1)-1)) = -inf;
plotMat(odd(chanMat(:,odd(1:size(chanMat,2)-1)+1)-1)+1) = -inf;
%plotMat(selChans) = -2;
%plotMat(badChans) = inf;
%plotMat(setdiff(chanLoc.(fields{j}),badChans)) = inf;
%figure

figure(1)
clf
imagesc(Make2DPlotMat(plotMat,chanMat));
set(gca,'clim',[-4 3])
XYPlotAnatCurves({anatOverlayName},gca,plotSize,plotOffset);
for m=1:size(chanMat,2)
    for k=1:size(chanMat,1)
        text(m,k,num2str(chanMat(k,m)),'color','w');
    end
end
set(gca,'ytick',1:size(chanMat,1))
grid on

figure(1)
clf
fields = fieldnames(chanLoc);
newPlotMat = plotMat;
%chanLocCscaling = [-8 -4 -7 -3 -6 -2 -5 -1];
%chanLocCscaling = [-1 -5 -2 -6 -3 -7 -8 -4];
chanLocCscaling = [-8 -7 -6 -5 -4 -3 -2 -1];
cMap = [...
    1.0, 1.0, 1.0;...
    1.0, 0.0, 0.0;...
    0.0, 1.0, 0.0;...
    0.0, 1.0, 1.0;...
    0.4, 0.4, 0.0;...
    1.0, 0.4, 0.0;...
    0.0, 0.0, 1.0;...
    1.0, 0.0, 1.0;...
    1.0, 1.0, 0.0;...
    ];
    colormap(cMap);
for j=1:length(fields)
    %h = subplot(1,length(fields),j);
    %hold on
    %temp = Make2DPlotMat(plotMat,chanMat,chanLoc.(fields{j}));
    %temp = temp(:);
    %temp(isnan(temp)) = 2;
    %imagesc(Make2DPlotMat(temp,chanMat,badChans));
    %if chanLoc.(fields{j}) == 0
    if mod(j,2)
    newPlotMat( chanLoc.(fields{j})) = chanLocCscaling(j);
    else
    newPlotMat( chanLoc.(fields{j})) = chanLocCscaling(j);        
    end

end
%     newPlotMat = plotMat;
%     newPlotMat(chanLocations) = -2;
    imagesc(Make2DPlotMat(newPlotMat,chanMat));
    %imagesc(Make2DPlotMat(plotMat,chanMat,setdiff(chanLoc.(fields{j}),badChans)));
    set(gca,'clim',[-9 -1])
%     XYPlotAnatCurves({anatOverlayName},gca,plotSize,plotOffset,[0.5 0.5 0.5],5);
%     DrawElectrodes(chanMat,[1 1 1],2)
    DrawElectrodes(chanMat,[0 0 0],1,2,[],.26)
    PlotAnatCurves(anatOverlayName,plotSize,plotOffset)
%     XYPlotAnatCurves({anatOverlayName},gca,plotSize,plotOffset,[0.5 0.5 0.5],5);
%     DrawElectrodes(chanMat,[0 0 0],2)
    title(fields{j})
    set(gca,'ytick',0.5+1:size(chanMat,1),'xtick',0.5+1:size(chanMat,2),'yticklabel',[],'xticklabel',[])
    grid on
return
