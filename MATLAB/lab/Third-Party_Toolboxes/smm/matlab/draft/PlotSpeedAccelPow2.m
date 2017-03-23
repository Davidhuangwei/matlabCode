function PlotSpeedAccelPow2(mazeMeasStruct,chans,varargin)
%function PlotSpeedAccelPow2(mazeMeasStruct,chans,taskTypes,overlayBool,plotColor,indepVar1,depVar,trialTypesBool,mazeRegionsBool)

[trialDesigCell,indepVar1, depVar,overlayBool, plotColor ,xStd,yStd] = ...
    DefaultArgs(varargin,{...
        cat(2,{'alter';'circle';'z'},repmat({[1 1 1 1 1 1 1 1 1 1 1 1 1]},3,1),repmat({0.6},3,1),repmat({[1 1 1 1 1 1 1 1 1]},3,1),repmat({0.5},3,1)),...
        {'speed'},{'thetaPowPeak'},0,'b',2.5,3});

indepVar2 = {};
for i=[-400 -200 0 200 400]
    if i<0
        indepVar2 = cat(1,indepVar2,{['n' num2str(abs(i))]});
    else
        indepVar2 = cat(1,indepVar2,{['p' num2str(abs(i))]});
    end
end

niceFigBool = 1;
plotMarker = 8;
%indepVar1
%indepVar1 = {'accels'}
%indepVar1 = {'speeds'}
%indepVar = {'speed';'speed';'accel';'accel'};
%depVar = {'thetaPowPeak'};

%depVar = {'thetaPowPeak';'gammaPowIntg';'thetaPowPeak';'gammaPowIntg'};
%depVar = {'thetaPowPeak';'thetaPowIntg';'gammaPowPeak';'gammaPowIntg';'thetaPowPeak';'gammaPowIntg'};
if ~exist('speedXLim') | isempty(speedXLim)
    %speedXLim = [45,140];
    speedXLim = [25,120];
end
if ~exist('accelXlim') | isempty(accelXlim)
    accelXlim = [-250,200];
end
%xLimMat = [speedXLim; speedXLim; accelXlim; accelXlim];
%xLimMat = [speedXLim; speedXLim; accelXlim; accelXlim];
task = getfield(mazeMeasStruct,'taskType');
trialType = getfield(mazeMeasStruct,'trialType');
mazeRegion = getfield(mazeMeasStruct,'mazeLocation');

selectedTrials = zeros(length(task),1);
for m=1:size(trialDesigCell,1)
    selectedTrials = (selectedTrials | ...
        ((strcmp(trialDesigCell{m,1},task)) & (trialType*trialDesigCell{m,2}'>trialDesigCell{m,3})...
        & (mazeRegion*trialDesigCell{m,4}'>trialDesigCell{m,5})));
end
selectedTrials = find(selectedTrials);
%keyboard
figure(1)
if ~overlayBool
    clf
    plot(mazeMeasStruct.position.p0(:,1),mazeMeasStruct.position.p0(:,2),'k.')
end
hold on
plot(mazeMeasStruct.position.p0(selectedTrials,1),mazeMeasStruct.position.p0(selectedTrials,2),'.','color',plotColor)
fprintf('n=%i\n',length(selectedTrials))

for j=1:size(indepVar2,1)
    figure(j+1);
    if ~overlayBool
        clf
    end


    for i=1:length(chans)
        subplot(1,length(chans),i)
        hold on
        if i==1
            ylabel([indepVar1{1} ' ' indepVar2{j,:} ' vs. ' depVar{1} ]);
            %xlabel([indepVar1{1} ' ' indepVar2{j,:} ' vs. ' depVar{1} ]);
        end

        plotChan = chans(i);

        %nPoints = length(getfield(mazeMeasStruct,indepVar1{1},indepVar2{1}));
        if strcmp(indepVar1,'speed')
            xLim = speedXLim;
        else
            xLim = accelXlim;
        end
        %for ii=1:nPoints
        %keyboard

        %ypoints = getfield(mazeMeasStruct,depVar{1},{plotChan,1:nPoints});
        %xpoints = getfield(mazeMeasStruct,indepVar1{1},indepVar2{j});
        ypoints = getfield(mazeMeasStruct,depVar{1},{plotChan,selectedTrials});
        xpoints = getfield(mazeMeasStruct,indepVar1{1},indepVar2{j},{selectedTrials});
%keyboard
        ypoints = ypoints';
        xpoints = xpoints';
            
            xOutliers = xpoints > mean(xpoints)+xStd*std(xpoints) | xpoints < mean(xpoints)-xStd*std(xpoints) & ~isnan(xpoints);
            yOutliers = ypoints > mean(ypoints)+yStd*std(ypoints) | ypoints < mean(ypoints)-yStd*std(ypoints) & ~isnan(ypoints);
            outliers = xOutliers | yOutliers;
            if niceFigBool & overlayBool
                plot(xpoints,ypoints,'.','color', plotColor,'markersize',plotMarker);                
            else
                plot(xpoints(~outliers),ypoints(~outliers),'.','color', plotColor,'markersize',plotMarker);
            end
                if j==3
                %keyboard
                end
                if ~niceFigBool
                    if ~isempty(outliers)
                        plot(xpoints(outliers),ypoints(outliers),'.','color', mean([mean([plotColor; [1 1 1]]);[1 1 1]]),'markersize',plotMarker);
                        %mean([mean([plotColor; [1 1 1]]);[1 1 1]])
                    end
                end
               
                [b,bint,r,rint,stats] = regress(ypoints(~outliers), [ones(size(xpoints(~outliers))) xpoints(~outliers)], 0.01);

                %         [p s] = polyfit(getfield(speedPowStruct,mazeRegionNames{k},'speed',{1:nPoints,1}),getfield(speedPowStruct,mazeRegionNames{k},'power',{1:nPoints,plotChan}),1);
                %    endPoints = [min(getfield(speedPowStruct,mazeRegionNames{k},'speed')) max(getfield(speedPowStruct,mazeRegionNames{k},'speed'))];
                %         plot(endPoints,p(1).*endPoints+p(2),'k')
                set(gca,'xlim',[xLim(1) xLim(2)]);
                if ~overlayBool
                    set(gca,'ylim',[mean(ypoints)-5 mean(ypoints)+5]);
                    %set(gca,'ylim',[mean(ypoints)-1.5*yStd*std(ypoints) mean(ypoints)+1.5*yStd*std(ypoints)]);
                    xlabel(['[' num2str(plotColor) ']:' 'r2=' num2str(stats(1),4) ',p=' num2str(stats(3),4)]);%1.4f %1.20f',plotChan,stats(1),stats(3)
                else
                    if iscell(get(get(gca,'xlabel'),'string'))
                        oldXlabel = get(get(gca,'xlabel'),'string');
                    else
                        oldXlabel = {get(get(gca,'xlabel'),'string')};
                    end
                    %keyboard
                    xlabel(cat(1,oldXlabel,{['[' num2str(plotColor) ']:' 'r2=' num2str(stats(1),4) ',p=' num2str(stats(3),4)]}));%1.4f %1.20f',plotChan,stats(1),stats(3)
                end
                if ~overlayBool | ~niceFigBool
                    plot([xLim(1) xLim(2)],b(2).*[xLim(1) xLim(2)]+b(1),'color',plotColor,'linewidth',2);
                end
                yLimits = get(gca,'ylim');
                xLimits = get(gca,'xlim');
                if ~niceFigBool
                    plot([ mean(xpoints)-xStd*std(xpoints) mean(xpoints)-xStd*std(xpoints)],yLimits,'--','color',plotColor);
                    plot([ mean(xpoints)+xStd*std(xpoints) mean(xpoints)+xStd*std(xpoints)],yLimits,'--','color',plotColor);
                    plot(xLimits,[ mean(ypoints)-yStd*std(ypoints) mean(ypoints)-yStd*std(ypoints)],'--','color',plotColor);
                    plot(xLimits,[ mean(ypoints)+yStd*std(ypoints) mean(ypoints)+yStd*std(ypoints)],'--','color',plotColor);
                end
                title(['channel: ' num2str(plotChan)]);
                %allRegionsPow = [allRegionsPow; getfield(mazeMeasStruct,mazeRegionNames{k},depVar{j,:},{ii,plotChan})];
                %allRegionsSpeed = [allRegionsSpeed; getfield(mazeMeasStruct,mazeRegionNames{k},indepVar{j,:},{ii})];
            %end
        %[p s] = polyfit(allRegionsSpeed,allRegionsPow,1);
        %plot([35 130],p(1).*[35 130]+p(2),'k','linewidth',2)
    end
    xloc = get(gca,'xlim');
    text(xloc(2),mean(ypoints),trialDesigCell(:,1))
end
return
keyboard
