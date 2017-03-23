function PlotRemThetaGammaComod(taskType,animal,nPoints,winLength,thetaNW,gammaNW,varargin)
%function regressStruct = CalcSpeedAccelPowRegress(taskType,remMeasStruct,channels,stdev)
[chanMat,badChan,channels, stdev] = DefaultArgs(varargin,{MakeChanMat(6,16),load([animal 'EEGBadChan.txt']),...
    1:96,3.0});

interpFunc = 'linear';

anatLineWidth = 2;
load 'SelectedChannels.mat';
selectedChannels = [selectedChannels];
%trialDesigCell
%channels
inName = [taskType '_Meas' 'Win' num2str(winLength) ...
    'thetaNW' num2str(thetaNW) 'gammaNW' num2str(gammaNW) '.mat'];

fprintf('Loading: %s\n',inName);
load(inName);

plotAnatBool = 1;
anatOverlayName = [animal 'AnatCurves.mat'];

if strcmp(getfield(remMeasStruct,'info','fileExt'),'.eeg');
    plotOffset = [0 0];
    plotSize = [16.5,6.5];
end

depVar = 'gammaPowIntg';
indepVar = 'thetaPowPeak';
%lags = fieldnames(eval(['remMeasStruct' '.' indepVars{1}]));
%junk = getfield(remMeasStruct,indepVars{1});
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
nCalcedPoints = length(getfield(remMeasStruct,'time'))
if nCalcedPoints <= nPoints
    selectedTrials = [1:nCalcedPoints];
else
    selectedTrials = round(1:nCalcedPoints/nPoints:nCalcedPoints);
end

figure(2)
clf
figure(1)
clf
hold on
plot([1:nCalcedPoints],ones(size([1:nCalcedPoints])),'.')
plot(selectedTrials,ones(size(selectedTrials)),'r.')

for k=1:length(channels)
    %keyboard
    xVar = getfield(remMeasStruct,indepVar,{channels(k),1:nCalcedPoints});
    xVar = xVar(selectedTrials)';

    yVar = getfield(remMeasStruct,depVar,{channels(k),1:nCalcedPoints});
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

            %keyboard
            figText = SaveTheUnderscores({animal,taskType,indepVar,'vs.',depVar,...
                ['win=' num2str(winLength)],...
                ['thetaNW=' num2str(thetaNW)],['gammaNW', num2str(gammaNW)],['stdev=' num2str(stdev)],['n=' num2str(length(selectedTrials))]});
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

if 0
r = SmoothSkipNaN(Make2DPlotMat(b(:,2),chanMat,badChan,interpFunc),[1,0]);
rSquare = SmoothSkipNaN(Make2DPlotMat(stats(:,1),chanMat,badChan,interpFunc),[1,0]);
pVal = SmoothSkipNaN(log10(Make2DPlotMat(stats(:,3),chanMat,badChan,interpFunc)),[1,0]);
%badChanMask = ~isnan(Make2DPlotMat(ones(size(stats(:,1))),chanMat,badChan));
badChanMask = [];
else
r = Make2DPlotMat(b(:,2),chanMat,badChan,interpFunc);
rSquare = Make2DPlotMat(stats(:,1),chanMat,badChan,interpFunc);
pVal = log10(Make2DPlotMat(stats(:,3),chanMat,badChan,interpFunc));
%badChanMask = ~isnan(Make2DPlotMat(ones(size(stats(:,1))),chanMat,badChan));
badChanMask = [];
end


figure(3)
if 0
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
end
if winLength==626
    bColorLim = 0.45; 
    rSqColorLim = 0.16;
    pColorLim = log10([1.0 10^-5]);
end
if winLength==312
    bColorLim = 0.3; %speed-theta
    rSqColorLim = 0.06;
    pColorLim = log10([1.0 10^-2]);
end

anatColor = [0 0 0];


subplot(1,3,1)
%subplot(2,6,j-5)
%colorLimits = [-1*max([abs(min(r)) max(abs(max(r)))]) max([abs(min(r)) max(abs(max(r)))])];
colorLimits = [-bColorLim bColorLim];
axesHandles = ImageScMask(r,badChanMask,colorLimits);
title(['r ' indepVar ' vs. ' depVar  ]);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],anatColor,anatLineWidth);
end
set(axesHandles,'yticklabel',[],'xticklabel',[])

subplot(1,3,2)
%subplot(2,6,j-5)
%colorLimits = [-1*max([abs(min(r)) max(abs(max(r)))]) max([abs(min(r)) max(abs(max(r)))])];
colorLimits = [0 rSqColorLim];
axesHandles = ImageScMask(rSquare,badChanMask,colorLimits);
title(['rSquare '   indepVar ' vs. ' depVar]);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],anatColor,anatLineWidth);
end
set(axesHandles,'yticklabel',[],'xticklabel',[])

subplot(1,3,3)
%subplot(2,6,j-5)
%colorLimits = [-1*max([abs(min(r)) max(abs(max(r)))]) max([abs(min(r)) max(abs(max(r)))])];
colorLimits = pColorLim;
axesHandles = ImageScMask(pVal,badChanMask,colorLimits);
title(['pVal '   indepVar ' vs. ' depVar]);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],anatColor,anatLineWidth);
end
set(axesHandles,'yticklabel',[],'xticklabel',[])

figName = ['PlotThetaGammaComod3_' taskType '_Win' num2str(winLength)...
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

if isfield(remMeasStruct,'times');
    regressStruct = setfield(regressStruct,'times',getfield(remMeasStruct,'times'));
end
if isfield(remMeasStruct,'info');
    regressStruct = setfield(regressStruct,'info',getfield(remMeasStruct,'info'));
end

regressStruct = setfield(regressStruct,'info','channels',channels);
regressStruct = setfield(regressStruct,'info','fileName',outName);


save(outName, 'regressStruct');
keyboard
return
%catch
keyboard
%end