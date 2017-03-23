trialDesig.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
trialDesig.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
trialDesig.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
trialDesig.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
 files = LoadVar('AlterFiles');
 %files = files(1,:);
   
trialDesig.circle.q1 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5},...
    {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5});
trialDesig.circle.q2 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5},...
    {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5});
trialDesig.circle.q3 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5},...
    {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5});
trialDesig.circle.q4 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5},...
    {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5});
files = LoadVar('CircleFiles');
 files = files(1,:);

fileExt = '.eeg'
%fileExt = '_LinNearCSD121.csd'
selChans = load(['ChanInfo/SelectedChannels' fileExt '.txt']);
chanMat = LoadVar(['ChanInfo/ChanMat' fileExt '.mat']);
badChans = load(['ChanInfo/BadChan' fileExt '.txt']);
analDir = ['CalcRunningSpectra8_noExp_MidPoints_MinSpeed0Win626' fileExt];
anatCurvesName = 'ChanInfo/AnatCurves.mat';
offset = load(['ChanInfo/OffSet' fileExt '.txt']);
normBool = 1;

for j=1:length(selChans)
    selChanNames{j} = ['ch' num2str(selChans(j))];
    data.(selChanNames{j}) = LoadDesigVar(files,analDir,['gammaCohMean65-100Hz.' selChanNames{j}] ,trialDesig);
end
%cd([alterFiles(1,:) '/' analDir]);
%fo = LoadField('cohSpec.fo');
%cd('../..')
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        data.(selChanNames{j}).(fields{k}) = sqrt(data.(selChanNames{j}).(fields{k}));
    end
end

if normBool
    for j=1:length(selChans)
        fields = fieldnames(data.(selChanNames{j}));
        meanTemp = [];
        stdTemp = [];
        for k=1:length(fields)
            meanTemp = cat(1,meanTemp,mean(data.(selChanNames{j}).(fields{k})));
            stdTemp = cat(1,stdTemp,std(data.(selChanNames{j}).(fields{k}),[],1));
        end
        %size(meanTemp)
        %keyboard
        meanData.(selChanNames{j}) = mean(meanTemp);
        stdData.(selChanNames{j}) = mean(stdTemp);
    end
end

figure(1)
colormap(LoadVar('ColorMapSean6.mat'))
set(gcf,'DefaultAxesPosition',[0.05,0.15,0.92,0.75]);
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        subplot(length(fields),length(selChans),(k-1)*length(selChans)+j);
        imagesc(Make2DPlotMat(squeeze(mean(data.(selChanNames{j}).(fields{k}))),chanMat,badChans,'linear'));
        title([selChanNames{j} ': ' fields{k}])
        set(gca,'clim',[0 1])
        PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
        colorbar
    end
end

if normBool
    figure(2)
    colormap(LoadVar('ColorMapSean6.mat'))
    set(gcf,'DefaultAxesPosition',[0.05,0.15,0.92,0.75]);
    for j=1:length(selChans)
        fields = fieldnames(data.(selChanNames{j}));
        for k=1:length(fields)
            %             if j==2
            %                 junk = mean(data.(selChanNames{j}).(fields{k}))-meanData.(selChanNames{j});
            %             end
            %             junk(37)
            subplot(length(fields),length(selChans),(k-1)*length(selChans)+j);
            imagesc(Make2DPlotMat(squeeze((mean(data.(selChanNames{j}).(fields{k}))-meanData.(selChanNames{j}))./stdData.(selChanNames{j}))',chanMat,badChans,'linear'));
            title([selChanNames{j} ': ' fields{k}])
            set(gca,'clim',[-1 1])
             PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
            colorbar
        end
    end
end


figure(1)
colormap(LoadVar('CircularColorMap.mat'))
set(gcf,'DefaultAxesPosition',[0.05,0.15,0.92,0.75]);
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        subplot(length(fields),length(selChans),(k-1)*length(selChans)+j);
        imagesc(Make2DPlotMat(angle(squeeze(mean(data.(selChanNames{j}).(fields{k})))),chanMat,badChans,'linear'));
        title([selChanNames{j} ': ' fields{k}])
        set(gca,'clim',[-pi pi])
        %set(gca,'clim',[0.5 1])
        PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
        colorbar
    end
end


if normBool
    figure(2)
    colormap(LoadVar('CircularColorMap'))
    set(gcf,'DefaultAxesPosition',[0.05,0.15,0.92,0.75]);
    for j=1:length(selChans)
        fields = fieldnames(data.(selChanNames{j}));
        for k=1:length(fields)
            %             if j==2
            %                 junk = mean(data.(selChanNames{j}).(fields{k}))-meanData.(selChanNames{j});
            %             end
            %             junk(37)
            subplot(length(fields),length(selChans),(k-1)*length(selChans)+j);
            imagesc(Make2DPlotMat(angle(squeeze((mean(data.(selChanNames{j}).(fields{k}))-meanData.(selChanNames{j})))),chanMat,badChans,'linear'));
            title([selChanNames{j} ': ' fields{k}])
            set(gca,'clim',[-pi pi])
             PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
            colorbar
        end
    end
end
