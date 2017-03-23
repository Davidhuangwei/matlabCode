function PlotSpeedAccelPow(mazeMeasStruct,chans)

indepVar = {'speed';'speed';'speed';'speed';'accel';'accel'};
depVar = {'thetaPowPeak';'thetaPowIntg';'gammaPowPeak';'gammaPowIntg';'thetaPowPeak';'gammaPowIntg'};
mazeRegionNames = fieldnames(mazeMeasStruct);

xLimMat = [35 130;35 130;35 130;35 130;-250 130;-250 130];
for j=1:6
    figure(4+j);
    clf
    for i=1:length(chans)
        subplot(1,length(chans),i)
        if i==1
            ylabel(depVar{j,:});
            xlabel(indepVar{j,:});
        end
        plotChan = chans(i);
        hold on
        colors = [0 0 1;1 0 0;0 1 0;0.5 0.5 0.5];
        allRegionsPow = [];
        allRegionsSpeed = [];
        nPoints = length(mazeMeasStruct);
        xLim = xLimMat(j,:);
        for k=1:size(mazeRegionNames,1)
            for ii=1:nPoints
                plot(getfield(mazeMeasStruct(ii),mazeRegionNames{k},indepVar{j,:}),getfield(mazeMeasStruct(ii),mazeRegionNames{k},depVar{j,:},{plotChan}),'.','color',colors(k,:));
                %         [p s] = polyfit(getfield(speedPowStruct,mazeRegionNames{k},'speed',{1:nPoints,1}),getfield(speedPowStruct,mazeRegionNames{k},'power',{1:nPoints,plotChan}),1);
                %    endPoints = [min(getfield(speedPowStruct,mazeRegionNames{k},'speed')) max(getfield(speedPowStruct,mazeRegionNames{k},'speed'))];
                %         plot(endPoints,p(1).*endPoints+p(2),'k')
                set(gca,'xlim',[xLim(1) xLim(2)]);
                %set(gca,'ylim',[68,84],'xlim',[35 130]);

                title(['channel: ' num2str(plotChan)]);
                allRegionsPow = [allRegionsPow; getfield(mazeMeasStruct(ii),mazeRegionNames{k},depVar{j,:},{plotChan})];
                allRegionsSpeed = [allRegionsSpeed; getfield(mazeMeasStruct(ii),mazeRegionNames{k},indepVar{j,:})];
            end
        end
        %[p s] = polyfit(allRegionsSpeed,allRegionsPow,1);
        %plot([35 130],p(1).*[35 130]+p(2),'k','linewidth',2)


        [b,bint,r,rint,stats] = regress(allRegionsPow, [ones(size(allRegionsSpeed)) allRegionsSpeed], 0.01);
        plot([xLim(1) xLim(2)],b(2).*[xLim(1) xLim(2)]+b(1),'k','linewidth',2);
        title(['channel:' num2str(plotChan) ', r=' num2str(stats(1),'%0.4f') ', p=' num2str(stats(3),'%0.4f')]);
        set(gca,'xlim',[xLim(1) xLim(2)],'ylim',[mean(allRegionsPow)-5 mean(allRegionsPow)+5]);
        fprintf('\nchan:%i, r2=%1.4f %1.20f',plotChan,stats(1),stats(3));
    end
    text(mean(allRegionsSpeed),mean(allRegionsPow),{depVar{j,:},'vs',indepVar{j,:}})
    set(gcf,'name','MazeMeasStruct_behavior_vs_power')
end
