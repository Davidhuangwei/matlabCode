function CheckChanLoc02(fileExt,varargin)
%function CheckChanLoc02(fileExt,chanLocVersion)
chanLocVersion = DefaultArgs(varargin,{'junk'});
addpath /u12/smm/matlab/Plotting/Bar/
chanInfoDir = 'ChanInfo/';
chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']);
badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);
selChansStruct = LoadVar([chanInfoDir 'SelChan' fileExt '.mat']);
anatFields = fieldnames(selChansStruct);
for j=1:length(anatFields)
    selChans(j) = selChansStruct.(anatFields{j});
end

plotAnatBool = 1;
anatOverlayName = [chanInfoDir 'AnatCurves.mat'];
plotSize = size(LoadVar([chanInfoDir 'ChanMat' '.eeg' '.mat']));
plotOffset = load([chanInfoDir 'Offset' fileExt '.txt']);
plotMat(odd(chanMat(:,odd(1:size(chanMat,2)-1))-1)+1) = 0;
plotMat(odd(chanMat(:,odd(1:size(chanMat,2)-1))-1)) = 1;
plotMat(odd(chanMat(:,odd(1:size(chanMat,2)-1)+1)-1)) = 0;
plotMat(odd(chanMat(:,odd(1:size(chanMat,2)-1)+1)-1)+1) = 1;
plotMat(selChans) = -2;
plotMat(badChans) = inf;

%figure(1)
try set(0,'CurrentFigure',1)
catch
    figure(1)
end
clf
colormap(LoadVar('ColorMapSean6.mat'));
imagesc(Make2DPlotMat(plotMat,chanMat));
set(gca,'clim',[-4 3])
XYPlotAnatCurves({anatOverlayName},gca,plotSize,0.5-plotOffset);
for m=1:size(chanMat,2)
    for k=1:size(chanMat,1)
        text(m,k,num2str(chanMat(k,m)),'color','k');
    end
end
set(gca,'ytick',1:size(chanMat,1))
grid on

%figure(2)
try set(0,'CurrentFigure',2)
catch
    figure(2)
end
clf
colormap(LoadVar('ColorMapSean6.mat'));
if exist([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat'],'file')
    chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
else
    fprintf(['This ChanLoc file does not yet exist: ' chanLocVersion  fileExt '\n'])
    return
end
fields = fieldnames(chanLoc);
for j=1:length(fields)
    h = subplot(1,length(fields),j);
    %hold on
    %temp = Make2DPlotMat(plotMat,chanMat,chanLoc.(fields{j}));
    %temp = temp(:);
    %temp(isnan(temp)) = 2;
    %imagesc(Make2DPlotMat(temp,chanMat,badChans));
    %if chanLoc.(fields{j}) == 0


    newPlotMat = plotMat;
    for k=1:length(chanLoc.(fields{j}))
        newPlotMat(setdiff(chanLoc.(fields{j}){k},badChans)) = -4;
        newPlotMat(intersect(chanLoc.(fields{j}){k},badChans)) = -3;
        imagesc(Make2DPlotMat(newPlotMat,chanMat));
        %imagesc(Make2DPlotMat(plotMat,chanMat,setdiff(chanLoc.(fields{j}),badChans)));
        set(gca,'clim',[-4 3])
        XYPlotAnatCurves({anatOverlayName},h,plotSize,0.5-plotOffset);
        title(fields{j})
        set(gca,'ytick',1:size(chanMat,1))
        grid on
    end
end
% get(1,'WindowStyle')
% get(2,'WindowStyle')
% get(1,'visible')
% get(2,'visible')
% set(1,'visible','off')
% set(2,'visible','off')
% set(1,'visible','on')
% set(2,'visible','on')

% set(1,'WindowStyle','normal')
% set(2,'WindowStyle','normal')
% 
% for j=1:max(max(chanMat))
%     text(floor((j-1)/size(chanMat,1))+1,mod(j,size(chanMat,1))+1,num2str(j));
% end
