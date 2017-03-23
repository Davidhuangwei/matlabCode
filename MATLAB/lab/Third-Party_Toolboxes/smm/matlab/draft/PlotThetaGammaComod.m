function PlotThetaGammaComod(mazeMeasStruct,chans,varargin)
%function PlotThetaGammaComod(mazeMeasStruct,chans,taskTypes,overlayBool,plotColor,indepVar1,depVar,trialTypesBool,mazeRegionsBool)

[trialDesigCell,indepVar1, depVar,overlayBool, plotColor ] = ...
    DefaultArgs(varargin,{...
        cat(2,{'alter';'circle';'z'},repmat({[1 1 1 1 1 1 1 1 1 1 1 1 1]},3,1),repmat({[1 1 1 1 1 1 1 1 1]},3,1)),...
        {'thetaPowPeak'},{'gammaPowIntg'},0,[0 0 1]});

%indepVar2 = {};
%for i=[-400 -200 0 200 400]
%    if i<0
%        indepVar2 = cat(1,indepVar2,{['n' num2str(abs(i))]});
%    else
%        indepVar2 = cat(1,indepVar2,{['p' num2str(abs(i))]});
%    end
%end
%indepVar1
%indepVar1 = {'accels'}
%indepVar1 = {'speeds'}
%indepVar = {'speed';'speed';'accel';'accel'};
%depVar = {'thetaPowPeak'};

%depVar = {'thetaPowPeak';'gammaPowIntg';'thetaPowPeak';'gammaPowIntg'};
%depVar = {'thetaPowPeak';'thetaPowIntg';'gammaPowPeak';'gammaPowIntg';'thetaPowPeak';'gammaPowIntg'};
if ~exist('speedXLim') | isempty(speedXLim)
    speedXLim = [0,150];
end
if ~exist('accelXlim') | isempty(accelXlim)
    accelXlim = [-250,200];
end
%xLimMat = [speedXLim; speedXLim; accelXlim; accelXlim];
%xLimMat = [speedXLim; speedXLim; accelXlim; accelXlim];
    for i=1:length(chans)
        subplot(1,length(chans),i)
        
        if i==1
            %ylabel([indepVar1{1} ' ' indepVar2{j,:} ' vs. ' depVar{1} ]);
            %xlabel([indepVar1{1} ' ' indepVar2{j,:} ' vs. ' depVar{1} ]);
        end
        plotChan = chans(i);
        hold on
        %keyboard
        nPoints = size(getfield(mazeMeasStruct,indepVar1{1}),2);
        if strcmp(indepVar1,'speed')
            xLim = speedXLim;
        else
            %xLim = accelXlim;
        end
            %for ii=1:nPoints
            %keyboard
            
            ypoints = getfield(mazeMeasStruct,depVar{1},{plotChan,1:nPoints});
            xpoints = getfield(mazeMeasStruct,indepVar1{1},{plotChan,1:nPoints});
            
            task = getfield(mazeMeasStruct,'taskType');
            trialType = getfield(mazeMeasStruct,'trialType');
            mazeRegion = getfield(mazeMeasStruct,'mazeLocation');
            
            selectedTrials = zeros(length(task),1);
            for m=1:size(trialDesigCell,1)
                    selectedTrials = selectedTrials | ...
                        (strcmp(trialDesigCell{m,1},task) & trialType*trialDesigCell{m,2}'>0.6 & mazeRegion*trialDesigCell{m,3}'>0.5); 
            end
            selectedTrials = find(selectedTrials);
            ypoints = ypoints(selectedTrials)';
            xpoints = xpoints(selectedTrials)';
            
            stdev = 3;
            notOutliers = find(xpoints < mean(xpoints)+stdev*std(xpoints) & xpoints > mean(xpoints)-stdev*std(xpoints) & ~isnan(xpoints));
            
                try plot(xpoints,ypoints,'.','color', plotColor);
                catch 
                    keyboard
                end
                %         [p s] = polyfit(getfield(speedPowStruct,mazeRegionNames{k},'speed',{1:nPoints,1}),getfield(speedPowStruct,mazeRegionNames{k},'power',{1:nPoints,plotChan}),1);
                %    endPoints = [min(getfield(speedPowStruct,mazeRegionNames{k},'speed')) max(getfield(speedPowStruct,mazeRegionNames{k},'speed'))];
                %         plot(endPoints,p(1).*endPoints+p(2),'k')
                %set(gca,'xlim',[xLim(1) xLim(2)]);
                xLim = get(gca,'xlim');
                if ~overlayBool
                    set(gca,'ylim',[mean(ypoints)-10 mean(ypoints)+10]);
                    set(gca,'xlim',[mean(xpoints)-5 mean(xpoints)+5]);
                end
                %set(gca,'ylim',[68,84],'xlim',[35 130]);
                [b,bint,r,rint,stats] = regress(ypoints(notOutliers(:)), [ones(size(xpoints(notOutliers(:)))) xpoints(notOutliers(:))], 0.01);
                %plot([xLim(1) xLim(2)],b(2).*[xLim(1) xLim(2)]+b(1),'r','linewidth',2);
                plot([xLim(1) xLim(2)],b(2).*[xLim(1) xLim(2)]+b(1),'color',plotColor.*0.5,'linewidth',2);
                xlabel(['r2=' num2str(stats(1),4) ',p=' num2str(stats(3),4)]);%1.4f %1.20f',plotChan,stats(1),stats(3)         
                yLimits = get(gca,'ylim');
                plot([ mean(xpoints)-stdev*std(xpoints) mean(xpoints)-stdev*std(xpoints)],yLimits,'color',plotColor.*0.5);
                plot([ mean(xpoints)+stdev*std(xpoints) mean(xpoints)+stdev*std(xpoints)],yLimits,'color',plotColor.*0.5);
                title(['channel: ' num2str(plotChan)]);
                %allRegionsPow = [allRegionsPow; getfield(mazeMeasStruct,mazeRegionNames{k},depVar{j,:},{ii,plotChan})];
                %allRegionsSpeed = [allRegionsSpeed; getfield(mazeMeasStruct,mazeRegionNames{k},indepVar{j,:},{ii})];
            %end
        %[p s] = polyfit(allRegionsSpeed,allRegionsPow,1);
        %plot([35 130],p(1).*[35 130]+p(2),'k','linewidth',2)
    end
    xloc = get(gca,'xlim');
    text(xloc(2),mean(ypoints),trialDesigCell(:,1))

return
keyboard
