function regressStruct = PlotThetaGammaComod2(taskType,animal,minSpeed,winLength,midPointsBool,thetaNW,gammaNW,varargin)
%function regressStruct = CalcSpeedAccelPowRegress(taskType,mazeMeasStruct,channels,stdev)
[chanMat,badChan,trialDesigCell, channels, stdev] = DefaultArgs(varargin,{MakeChanMat(6,16),load([animal 'EEGBadChan.txt']),...
    cat(2,{'alter';'circle';'z'},repmat({[1 1 1 1 1 1 1 1 1 1 1 1 1]},3,1),repmat({[1 1 1 1 1 1 1 1 1]},3,1)),...
    1:96,3.0});

interpFunc = 'linear';

plotAnatBool = 1;
anatOverlayName = [animal 'AnatCurves.mat'];
plotOffset = [0 0];
plotSize = [16.5,6.5];
anatLineWidth = 2;

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
depVars = {'gammaPowIntg'};
indepVars = {'thetaPowPeak'};
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

figure(1)
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
    
    [b,bint,r,rint,stats] = regress(yVar, [ones(size(xVar)) xVar], 0.01);
    if ~isemtpy(find(channels(k)==selectedChannels))
        
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

r = Make2DPlotMat(b(:,2),chanMat,badChan,interpFunc);
rSquare = Make2DPlotMat(stats(:,1),chanMat,badChan,interpFunc);
pVal = log10(Make2DPlotMat(stats(:,3),chanMat,badChan,interpFunc));
badChanMask = ones(Make2DPlotMat(ones(size(stats(:,1))),chanMat,0));

figure((i-1)*(length(depVars))+l+1)

bColorLim = 0.4; %speed-theta
rSqColorLim = 0.3;
pColorLim = log10([1.0 10^-10]);

subplot(3,1,1)
%subplot(2,6,j-5)
%colorLimits = [-1*max([abs(min(r)) max(abs(max(r)))]) max([abs(min(r)) max(abs(max(r)))])];
colorLimits = [-bColorLim bColorLim];
axesHandles = ImageScMask(r,badChanMask,colorLimits);
title(['r ' indepVar ' vs. ' depVar  ]);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end
set(axesHandles,'yticklabel',[],'xticklabel',[])

subplot(3,1,2)
%subplot(2,6,j-5)
%colorLimits = [-1*max([abs(min(r)) max(abs(max(r)))]) max([abs(min(r)) max(abs(max(r)))])];
colorLimits = [0 rSqColorLim];
axesHandles = ImageScMask(rSquare,badChanMask,colorLimits);
title(['rSquare '   indepVar ' vs. ' depVar]);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end
set(axesHandles,'yticklabel',[],'xticklabel',[])

subplot(3,1,3)
%subplot(2,6,j-5)
%colorLimits = [-1*max([abs(min(r)) max(abs(max(r)))]) max([abs(min(r)) max(abs(max(r)))])];
colorLimits = pColorLim;
axesHandles = ImageScMask(pVal,badChanMask,colorLimits);
title(['pVal '   indepVar ' vs. ' depVar]);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end
set(axesHandles,'yticklabel',[],'xticklabel',[])

%figName = [PlotThetaGammaComod2 
%set(1,'name',
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