function PlotSpeedAccelPowRegress3(taskType,animal,fileBaseMat,fileExt,fileNameFormat,...
    midPointsBool,minSpeed,winLength,thetaNW,gammaNW,chanMat,badChan,trialDesigCell,varargin)
%

figName = ['PlotSpeedAccelPowRegress' '_' fileExt '_' taskType '_minspeed' num2str(minSpeed) '_win' num2str(winLength) '_thetaNW' num2str(thetaNW) '_thetaNW' num2str(thetaNW)];

[channels, xStdev,yStdev] = DefaultArgs(varargin,{1:96,2.5,3.0});
if midPointsBool
    midPtext = '_midPoints';
else
    midPtext = '';
end
inName = [taskType midPtext '_MazeMeas_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength)...
    'thetaNW' num2str(thetaNW) 'gammaNW' num2str(gammaNW) '.mat'];
fprintf('Loading: %s\n',inName);
load(inName);

interpFunc = 'spline';
load SelectedChannels
depVars = {'thetaPowPeak';'gammaPowIntg'};
indepVars = {'speed','accel'};
lags = fieldnames(eval(['mazeMeasStruct' '.' indepVars{1}]));
%junk = getfield(mazeMeasStruct,indepVars{1});
%lags = fieldnames(junk);
%[-2000 -1000 -500 -250 0 250 500 1000 2000];
regressStruct = [];

task = getfield(mazeMeasStruct,'taskType');
trialType = getfield(mazeMeasStruct,'trialType');
mazeRegion = getfield(mazeMeasStruct,'mazeLocation');

selectedTrials = zeros(length(task),1);
for m=1:size(trialDesigCell,1)
    selectedTrials = selectedTrials | ...
        (strcmp(trialDesigCell{m,1},task) & trialType*trialDesigCell{m,2}'>0.6 & mazeRegion*trialDesigCell{m,3}'>0.5);
end
selectedTrials = find(selectedTrials);

figure(2)
clf
set(gcf,'name',figName);
figure(1)
clf
set(gcf,'name',figName);
hold on
plot(mazeMeasStruct.position.p0(:,1),mazeMeasStruct.position.p0(:,2),'.')
plot(mazeMeasStruct.position.p0(selectedTrials,1),mazeMeasStruct.position.p0(selectedTrials,2),'r.')


nPoints = size(mazeRegion,1);

for i=1:length(indepVars)
    for j=1:length(lags)
        xVar = getfield(mazeMeasStruct,indepVars{i},lags{j},{selectedTrials});
        xVar = xVar(:);
        xOutliers = xVar > mean(xVar)+xStdev*std(xVar) | xVar < mean(xVar)-xStdev*std(xVar);
        for k=1:length(channels)
            for l=1:length(depVars)

                yVar = getfield(mazeMeasStruct,depVars{l},{channels(k),selectedTrials});
                yVar = yVar(:);
                yOutliers = yVar > mean(yVar)+yStdev*std(yVar) | yVar < mean(yVar)-yStdev*std(yVar);
                
                notOutliers = ~(xOutliers | yOutliers);

                [b,bint,r,rint,stats] = regress(yVar(notOutliers), [ones(size(xVar(notOutliers))) xVar(notOutliers)], 0.01);

                regressStruct = setfield(regressStruct,indepVars{i},lags{j},depVars{l},'b',{channels(k),1:2},b);
                regressStruct = setfield(regressStruct,indepVars{i},lags{j},depVars{l},'stats',{channels(k),1:3},stats);
                
                selChNum = find(channels(k)==selectedChannels);
                if strcmp(lags{j},'p0') & ~isempty(selChNum) 
                    figure(2)
                    try
                    subplot(length(indepVars)*length(depVars),length(selectedChannels),...
                        (i-1)*length(selectedChannels)+(l-1)*2*length(selectedChannels)+selChNum)
                    catch
                        keyboard
                    end
                    hold on
                    yPlotWin = 20;
                    xPlotWin = 2.5*xStdev*std(xVar);
                    markerSize = 5;
                    plot(xVar(notOutliers),yVar(notOutliers),'.','markersize',markerSize)
                    plot(xVar(~notOutliers),yVar(~notOutliers),'.','color',[0.7 0.7 0.7],'markersize',markerSize)
                    xLimits = [mean(xVar)-xPlotWin mean(xVar)+xPlotWin];
                    yLimits = [mean(yVar)-yPlotWin mean(yVar)+yPlotWin];
                    plot(xLimits,[mean(yVar)-yStdev*std(yVar) mean(yVar)-yStdev*std(yVar)],':k')
                    plot(xLimits,[mean(yVar)+yStdev*std(yVar) mean(yVar)+yStdev*std(yVar)],':k')

                    plot([mean(xVar)-xStdev*std(xVar) mean(xVar)-xStdev*std(xVar)],yLimits,':k')
                    plot([mean(xVar)+xStdev*std(xVar) mean(xVar)+xStdev*std(xVar)],yLimits,':k')
                    plot(xlim,xlim*b(2)+b(1),'r')
                    title(['Channel: ' num2str(channels(k))]);
                    xlabel(indepVars{i})
                    if channels(k)==selectedChannels(1) 
                        ylabel(depVars{l})
                        if i==2 & l==1
                            [M N] = size(trialDesigCell);
                            trialDesigText = {};
                            for m=1:M
                                for n=1:N
                                    if n==1
                                        trialDesigText = cat(2, trialDesigText, {trialDesigCell{m,n}});
                                    else
                                        trialDesigText = cat(2,trialDesigText, {num2str(trialDesigCell{m,n})});
                                    end
                                end
                            end
                            %keyboard
                            figText = SaveTheUnderscores(cat(2,{animal,taskType,indepVars{i},'vs.',depVars{l},['minSpeed=' num2str(minSpeed)],...
                                ['nPoints=' num2str(length(selectedTrials))],['win=' num2str(winLength)],['midPoints=' num2str(midPointsBool)],...
                                ['thetaNW=' num2str(thetaNW)],['gammaNW', num2str(gammaNW)],['xStdev=' num2str(xStdev)],['yStdev=' num2str(yStdev)]},...
                                trialDesigText));
                            text(xLimits(1)-xPlotWin*2,mean(yVar),figText,'fontsize',2);
                        end
                    end
                    set(gca,'xlim',xLimits,'ylim',yLimits)
                    %keyboard
                end
            end
        end
    end
end



%try
%[channels, stdev] = DefaultArgs(varargin,{1:96,});
%   depVars = {'thetaPowPeak';'gammaPowIntg'};
%   indepVars = {'speeds','accels'};

%inName = [taskType '_RegressPowSpeedAccel_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) 'NW' num2str(NW) '.mat'];
%fprintf('Loading: %s\n',inName);
%load(inName);
lags = [1000:-100:-1000];
plotAnatBool = 1;

if plotAnatBool
    if fileNameFormat == 1
        anatOverlayName = ['sm9601' 'AnatCurves.mat'];
    else
        anatOverlayName = [fileBaseMat(1,1:6) 'AnatCurves.mat'];
    end
    anatLineWidth = 2;
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



firstFig = 3;

for i=1:length(indepVars)
    for l=1:length(depVars)
        figure(firstFig +i-1+(l-1)*2)
        set(gcf,'name',figName);
        columnsPerFig = length(lags);
        %for j=1:ceil(length(lags)/columnsPerFig)
        %    figure(firstFig -1 +j)
        %    clf
        %end

        b = [];
        stats = [];
        for j=1:length(lags)
            if lags(j)<0
                lagName = ['n' num2str(abs(lags(j)))];
            else
                lagName = ['p' num2str(abs(lags(j)))];
            end
            b = cat(1,b,getfield(regressStruct,indepVars{i},lagName,depVars{l},'b'));
            stats = cat(1,stats,getfield(regressStruct,indepVars{i},lagName,depVars{l},'stats'));
            %bAbsMax = max([bAbsMax max(abs(b(:,2)))]);
        end
        if strcmp(indepVars{i},'speed') & strcmp(depVars{l},'thetaPowPeak')
            if winLength==626
                bColorLim = 0.1; %speed-theta
                rSqColorLim = 0.6;
            else
                bColorLim = 0.051; %speed-theta
                rSqColorLim = 0.51;
            end
        end
        if strcmp(indepVars{i},'speed') & strcmp(depVars{l},'gammaPowIntg')
            bColorLim = 0.032; %speed-gamma
            rSqColorLim = 0.11;
        end
        if strcmp(indepVars{i},'accel') & strcmp(depVars{l},'thetaPowPeak')
            if winLength==626
                bColorLim = 0.015; %accel-theta
                rSqColorLim = 0.3;
            else
                bColorLim = 0.28; %accel-theta
                rSqColorLim = 0.42;
            end
        end
        if strcmp(indepVars{i},'accel') & strcmp(depVars{l},'gammaPowIntg')
            bColorLim = 7.5*10^(-3); %accel-gamma
            rSqColorLim = 0.1;
        end

        %bColorLim = 0.28; %accel-theta
        %rSqColorLim = 0.42;
        %bColorLim = 0.11; %speed-theta
        %rSqColorLim = 0.68;
        %bColorLim = 0.051; %speed-theta
        %rSqColorLim = 0.51
        %bColorLim = 0.012; %accel-theta
        %rSqColorLim = 0.29
        %bColorLim = 0.0201 %speed-gamma
        %rSqColorLim = 0.1
        %bColorLim = 4.6*10^(-3) %accel-gamma
        %rSqColorLim = 0.042
        %bColorLim = 2*std(b(:,2));
        %rSqColorLim = 2.5^2*std(stats(:,1));

        for j=1:length(lags)
            %for j=6:11
            %(firstFig + floor(j/(columnsPerFig+1)))

            if lags(j)<0
                lagName = ['n' num2str(abs(lags(j)))];
            else
                lagName = ['p' num2str(abs(lags(j)))];
            end
            b = getfield(regressStruct,indepVars{i},lagName,depVars{l},'b');
            stats = getfield(regressStruct,indepVars{i},lagName,depVars{l},'stats');

            r = Make2DPlotMat(b(:,2),chanMat,badChan,interpFunc);
            rSquare = Make2DPlotMat(stats(:,1),chanMat,badChan,interpFunc);
            pVal = Make2DPlotMat(stats(:,3),chanMat,badChan,interpFunc);
            badChanMask = ~isnan(Make2DPlotMat(ones(size(stats(:,1))),chanMat,badChan));


            subplot(3,columnsPerFig,mod(j-1,columnsPerFig)+1)
            %subplot(2,6,j-5)
            %colorLimits = [-1*max([abs(min(r)) max(abs(max(r)))]) max([abs(min(r)) max(abs(max(r)))])];
            colorLimits = [-bColorLim bColorLim];
            axesHandles = ImageScMask(r,badChanMask,colorLimits);
            title(['r ' indepVars{i} ' ' lagName ' vs. ' depVars{l}  ]);
            if plotAnatBool
                XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
            end
            set(axesHandles,'yticklabel',[],'xticklabel',[])

            %figureMats = {rSquare, pVal};
            %subplotTitles = {[indepVars{i} ' ' lagName ' vs. ' depVars{l} 'r^2' ], [indepVars{i} lagName ' vs. ' depVars{l} 'pVal']};
            %cl
            subplot(3,columnsPerFig,mod(j-1,columnsPerFig)+1+columnsPerFig)
            %subplot(2,6,j-5)
            colorLimits = [0 rSqColorLim];
            %colorLimits = [-.75 .75];
            axesHandles = ImageScMask(rSquare,badChanMask,colorLimits);
            title(['r^2 ' indepVars{i} ' ' lagName ' vs. ' depVars{l}  ]);
            if plotAnatBool
                XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
            end
            set(axesHandles,'yticklabel',[],'xticklabel',[])

            subplot(3,columnsPerFig,mod(j-1,columnsPerFig)+1+2*columnsPerFig)
            %subplot(2,6,j+1)
            colorLimits = [1.0 10^-10];
            %colorLimits = [-.75 .75];
            axesHandles = ImageScMask(log10(pVal),badChanMask,log10(colorLimits));
            title(['pVal ' indepVars{i} ' ' lagName ' vs. ' depVars{l} ]);
            if plotAnatBool
                XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
            end
            set(axesHandles,'yticklabel',[],'xticklabel',[])

        end
    end
end

in = [];
while ~strcmp(in,'y') & ~strcmp(in,'n')
    in = input('Report Figs? (y/n): ','s');
    if strcmp(in,'y')
        ReportFigSM(1,[],[4 4],[],[],75)
        ReportFigSM(2,[],[20 15],[],[],60)
        ReportFigSM(3:6,[],[50 5.5],[],[],75)
    end
end