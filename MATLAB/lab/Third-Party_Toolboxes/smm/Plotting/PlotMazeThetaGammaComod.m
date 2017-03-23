function PlotMazeThetaGammaComod(taskType,animal,minSpeed,winLength,midPointsBool,thetaNW,gammaNW,varargin)
%function regressStruct = CalcSpeedAccelPowRegress(taskType,mazeMeasStruct,channels,stdev)
[chanMat,badChan,trialDesigCell,channels, stdev] = DefaultArgs(varargin,{MakeChanMat(6,16),load([animal 'EEGBadChan.txt']),...
    cat(2,{'alter';'circle';'z'},repmat({[1 1 1 1 1 1 1 1 1 1 1 1 1]},3,1),repmat({[1 1 1 1 1 1 1 1 1]},3,1)),...
    1:96,3.0});

anatLineWidth = 2;
load 'SelectedChannels.mat';
selectedChannels = [selectedChannels];
if midPointsBool
    midPtext = '_midPoints';
else
    midPtext = [];
end
%trialDesigCell
%channels
inName = [taskType midPtext '_MazeMeas_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) ...
    'thetaNW' num2str(thetaNW) 'gammaNW' num2str(gammaNW) '.mat'];

fprintf('Loading: %s\n',inName);
load(inName);

plotAnatBool = 1;
anatOverlayName = [animal 'AnatCurves.mat'];

if strcmp(getfield(mazeMeasStruct,'info','fileExt'),'.eeg');
    plotOffset = [0 0];
    plotSize = [16.5,6.5];
end

depVar = 'gammaPowIntg';
indepVar = 'thetaPowPeak';
%lags = fieldnames(eval(['mazeMeasStruct' '.' indepVars{1}]));
%junk = getfield(mazeMeasStruct,indepVars{1});
%lags = fieldnames(junk);
%[-2000 -1000 -500 -250 0 250 500 1000 2000];
regressStruct = [];
figure(1)
clf
%for j=1:length(lags)
%if lags(j)<0
%    lagName = ['n' num2str(abs(lags(j)))];
%else
%    lagName = ['p' num2str(abs(lags(j)))];
%end
%notOutliers = find(xVar < mean(xVar)+stdev*std(xVar) & xVar > mean(xVar)-stdev*std(xVar));

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
figure(1)
clf
hold on
plot(mazeMeasStruct.position.p0(:,1),mazeMeasStruct.position.p0(:,2),'.')
plot(mazeMeasStruct.position.p0(selectedTrials,1),mazeMeasStruct.position.p0(selectedTrials,2),'r.')

nPoints = size(mazeRegion,1);
for k=1:length(channels)
    %keyboard
    xVar = getfield(mazeMeasStruct,indepVar,{channels(k),1:nPoints});
    xVar = xVar(selectedTrials)';

    yVar = getfield(mazeMeasStruct,depVar,{channels(k),1:nPoints});
    yVar = yVar(selectedTrials)';
    
    notOutliers = yVar>mean(yVar)-stdev*std(yVar) & yVar<mean(yVar)+stdev*std(yVar) ...
        & xVar>mean(xVar)-stdev*std(xVar) & xVar<mean(xVar)+stdev*std(xVar);
    
    [b,bint,r,rint,stats] = regress(yVar(notOutliers), [ones(size(xVar(notOutliers))) xVar(notOutliers)], 0.01);
    
    selChNum = find(channels(k)==selectedChannels);
    if ~isempty(selChNum)
        figure(2)
        subplot(1,length(selectedChannels),selChNum)
        hold on
        plotWin = 20;
        markerSize = 5;
        plot(xVar(notOutliers),yVar(notOutliers),'.','markersize',markerSize)
        plot(xVar(~notOutliers),yVar(~notOutliers),'.','color',[0.7 0.7 0.7],'markersize',markerSize)
        xLimits = [mean(xVar)-plotWin mean(xVar)+plotWin];
        yLimits = [mean(yVar)-plotWin mean(yVar)+plotWin];
        plot(xLimits,[mean(yVar)-stdev*std(yVar) mean(yVar)-stdev*std(yVar)],':k')
        plot(xLimits,[mean(yVar)+stdev*std(yVar) mean(yVar)+stdev*std(yVar)],':k')

        plot([mean(xVar)-stdev*std(xVar) mean(xVar)-stdev*std(xVar)],yLimits,':k')
        plot([mean(xVar)+stdev*std(xVar) mean(xVar)+stdev*std(xVar)],yLimits,':k')
        plot(xlim,xlim*b(2)+b(1),'r')
        title(['Channel: ' num2str(channels(k))]);
        xlabel(indepVar)
        if channels(k)==selectedChannels(1)
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
            figText = SaveTheUnderscores(cat(2,{animal,taskType,indepVar,'vs.',depVar,['minSpeed=' num2str(minSpeed)],...
                ['win=' num2str(winLength)],['midPoints=' num2str(midPointsBool)],...
                ['thetaNW=' num2str(thetaNW)],['gammaNW', num2str(gammaNW)],['stdev=' num2str(stdev)],['n=' num2str(length(selectedTrials))]},...
                trialDesigText));
            text(xLimits(1)-20,mean(yVar),figText,'fontsize',2);

            ylabel(depVar)
        end
        set(gca,'xlim',xLimits,'ylim',yLimits)
    end
    %[b,bint,r,rint,stats] = regress(yVar(notOutliers), [ones(size(xVar(notOutliers))) xVar(notOutliers)], 0.01);

    regressStruct = setfield(regressStruct,indepVar,depVar,'b',{channels(k),1:2},b);
    %regressStruct = setfield(regressStruct,indepVar,lags{j},depVar,'bint',{channels(k),1:2,1:2},bint);
    %regressStruct = setfield(regressStruct,indepVar,lags{j},depVar,'r',{channels(k),1:length(notOutliers)},r);
    %regressStruct = setfield(regressStruct,indepVar,lags{j},depVar,'rint',{channels(k),1:length(notOutliers),1:2},rint);
    regressStruct = setfield(regressStruct,indepVar,depVar,'stats',{channels(k),1:3},stats);

    %regressStruct = setfield(regressStruct,indepVar,lagName,depVar,['chan' num2str(channels(k))],'b',b);
    %regressStruct = setfield(regressStruct,indepVar,lagName,['chan' num2str(channels(k))],depVar,'bint',bint);
    %regressStruct = setfield(regressStruct,indepVar,lagName,['chan' num2str(channels(k))],depVar,'r',r);
    %regressStruct = setfield(regressStruct,indepVar,lagName,['chan' num2str(channels(k))],depVar,'rint',rint);
    %regressStruct = setfield(regressStruct,indepVar,lagName,depVar,['chan' num2str(channels(k))],'stats',stats);


end

b = getfield(regressStruct,indepVar,depVar,'b');
stats = getfield(regressStruct,indepVar,depVar,'stats');

r = Make2DPlotMat(b(:,2),chanMat,badChan);
rSquare = Make2DPlotMat(stats(:,1),chanMat,badChan);
pVal = log10(Make2DPlotMat(stats(:,3),chanMat,badChan));
badChanMask = ~isnan(Make2DPlotMat(ones(size(stats(:,1))),chanMat,badChan));

figure(3)

if winLength==626
    bColorLim = 0.45; 
    rSqColorLim = 0.18;
    pColorLim = log10([1.0 10^-5]);
end
if winLength==312
    bColorLim = 0.22; %speed-theta
    rSqColorLim = 0.1;
    pColorLim = log10([1.0 10^-5]);
end

subplot(1,3,1)
%subplot(2,6,j-5)
%colorLimits = [-1*max([abs(min(r)) max(abs(max(r)))]) max([abs(min(r)) max(abs(max(r)))])];
colorLimits = [-bColorLim bColorLim];
axesHandles = ImageScMask(r,badChanMask,colorLimits);
title(['r ' indepVar ' vs. ' depVar  ]);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end
set(axesHandles,'yticklabel',[],'xticklabel',[])

subplot(1,3,2)
%subplot(2,6,j-5)
%colorLimits = [-1*max([abs(min(r)) max(abs(max(r)))]) max([abs(min(r)) max(abs(max(r)))])];
colorLimits = [0 rSqColorLim];
axesHandles = ImageScMask(rSquare,badChanMask,colorLimits);
title(['rSquare '   indepVar ' vs. ' depVar]);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end
set(axesHandles,'yticklabel',[],'xticklabel',[])

subplot(1,3,3)
%subplot(2,6,j-5)
%colorLimits = [-1*max([abs(min(r)) max(abs(max(r)))]) max([abs(min(r)) max(abs(max(r)))])];
colorLimits = pColorLim;
axesHandles = ImageScMask(pVal,badChanMask,colorLimits);
title(['pVal '   indepVar ' vs. ' depVar]);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end
set(axesHandles,'yticklabel',[],'xticklabel',[])

if midPointsBool
    midPtext = '_midPoints';
else
    midPtext = [];
end
figName = ['PlotThetaGammaComod3_' taskType midPtext '_minSpeed' num2str(minSpeed) '_Win' num2str(winLength)...
    '_thetaNW' num2str(thetaNW) 'gammaNW' num2str(gammaNW)];
set([1:3],'name',figName)

in=[];
while ~strcmp(in,'y') & ~strcmp(in,'n')
    in = input('Report the Figs to file? (y/n): ','s');
    if strcmp(in,'y')
        ReportFigSM(1,[],[4 4],[],[],75)
        ReportFigSM(2,[],[35 4],[],[],65)
        ReportFigSM(3,[],[14 3],[],[],75)
    end
end
return







outName = [taskType '_RegressThetaGammaComod_MinSpeed' num2str(minSpeed) midPtext 'Win' num2str(winLength) ...
    'thetaNW' num2str(thetaNW) 'gammaNW' num2str(gammaNW) '.mat'];
fprintf('Saving: %s\n',outName)

if isfield(mazeMeasStruct,'times');
    regressStruct = setfield(regressStruct,'times',getfield(mazeMeasStruct,'times'));
end
if isfield(mazeMeasStruct,'info');
    regressStruct = setfield(regressStruct,'info',getfield(mazeMeasStruct,'info'));
end

regressStruct = setfield(regressStruct,'info','channels',channels);
regressStruct = setfield(regressStruct,'info','fileName',outName);


save(outName, 'regressStruct');
keyboard
return
%catch
keyboard
%end