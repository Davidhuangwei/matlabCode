function PlotSpeedAccelPow(taskType,mazeMeasStruct,chans,overlayBool,colorBool,speedXLim,accelXlim)

for i=-2000:250:2000
    if i<0
        indepVar(i) = {'speeds.n' num2str(abs(i))};
    else
        indepVar(i) = {'speeds.p' num2str(abs(i))};
    end
end
keyboard
indepVar = {'speeds.n2000';'speeds.n2000'};
%indepVar = {'speed';'speed';'accel';'accel'};
depVar = {'thetaPowPeak';'gammaPowIntg';'thetaPowPeak';'gammaPowIntg'};
%depVar = {'thetaPowPeak';'thetaPowIntg';'gammaPowPeak';'gammaPowIntg';'thetaPowPeak';'gammaPowIntg'};
mazeRegionNames = fieldnames(mazeMeasStruct);
if ~exist('speedXLim') | isempty(speedXLim)
    speedXLim = [35,130];
end
if ~exist('accelXlim') | isempty(accelXlim)
    accelXlim = [-250,130];
end
xLimMat = [speedXLim; speedXLim; accelXlim; accelXlim];
for j=1:size(depVar,1)
    figure(4+j);
    if ~overlayBool
        clf
    end
    for i=1:length(chans)
        subplot(1,length(chans),i)
        if i==1
            ylabel(depVar{j,:});
            xlabel(indepVar{j,:});
        end
        plotChan = chans(i);
        hold on
        if colorBool
            colors = [0 0 1;1 0 0;0 1 0;0.5 0.5 0.5];
        else
            colors = [0 0 0;0 0 0;0 0 0;0 0 0];
        end
        allRegionsPow = [];
        allRegionsSpeed = [];
        nPoints = length(getfield(mazeMeasStruct,mazeRegionNames{1},indepVar{1,:}));
        xLim = xLimMat(j,:);
        for k=1:size(mazeRegionNames,1)
            for ii=1:nPoints
                plot(getfield(mazeMeasStruct,mazeRegionNames{k},indepVar{j,:},{ii}),getfield(mazeMeasStruct,mazeRegionNames{k},depVar{j,:},{ii,plotChan}),'.','color',colors(k,:));
                %         [p s] = polyfit(getfield(speedPowStruct,mazeRegionNames{k},'speed',{1:nPoints,1}),getfield(speedPowStruct,mazeRegionNames{k},'power',{1:nPoints,plotChan}),1);
                %    endPoints = [min(getfield(speedPowStruct,mazeRegionNames{k},'speed')) max(getfield(speedPowStruct,mazeRegionNames{k},'speed'))];
                %         plot(endPoints,p(1).*endPoints+p(2),'k')
                set(gca,'xlim',[xLim(1) xLim(2)]);
                %set(gca,'ylim',[68,84],'xlim',[35 130]);

                title(['channel: ' num2str(plotChan)]);
                allRegionsPow = [allRegionsPow; getfield(mazeMeasStruct,mazeRegionNames{k},depVar{j,:},{ii,plotChan})];
                allRegionsSpeed = [allRegionsSpeed; getfield(mazeMeasStruct,mazeRegionNames{k},indepVar{j,:},{ii})];
            end
        end
        %[p s] = polyfit(allRegionsSpeed,allRegionsPow,1);
        %plot([35 130],p(1).*[35 130]+p(2),'k','linewidth',2)

%keyboard
        [b,bint,r,rint,stats] = regress(allRegionsPow, [ones(size(allRegionsSpeed)) allRegionsSpeed], 0.01);
        if colorBool
            plot([xLim(1) xLim(2)],b(2).*[xLim(1) xLim(2)]+b(1),'color',[0.5 0.5 0.5],'linewidth',2);
        else
            plot([xLim(1) xLim(2)],b(2).*[xLim(1) xLim(2)]+b(1),'k','linewidth',2);
        end
        title(['channel:' num2str(plotChan) ', r=' num2str(stats(1),'%0.4f') ', p=' num2str(stats(3),'%0.4f')]);
        set(gca,'xlim',[xLim(1) xLim(2)],'ylim',[mean(allRegionsPow)-5 mean(allRegionsPow)+5]);
        fprintf('\nchan:%i, r2=%1.4f %1.20f',plotChan,stats(1),stats(3));
    end
    text(mean(allRegionsSpeed)+4*std(allRegionsSpeed),mean(allRegionsPow),{taskType,depVar{j,:},'vs',indepVar{j,:}})
    set(gcf,'name',['MazeMeasStruct_behavior_vs_power'])
end
