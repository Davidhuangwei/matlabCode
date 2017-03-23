function regressStruct = PlotThetaGammaComod(taskType,fileNameFormat,chanMat,badChan,minSpeed,winLength,midPointsBool,thetaNW,gammaNW,varargin)
%function regressStruct = CalcSpeedAccelPowRegress(taskType,mazeMeasStruct,channels,stdev)
[trialDesigCell, channels, stdev] = DefaultArgs(varargin,{...
    cat(2,{'alter';'circle';'z'},repmat({[1 1 1 1 1 1 1 1 1 1 1 1 1]},3,1),repmat({[1 1 1 1 1 1 1 1 1]},3,1)),...
    1:96,2.0});
newTrialDesigCell = {};
mazeRegions = zeros(2,9);
for m=1:size(trialDesigCell,1)
    if strcmp(trialDesigCell{m,1},'circle') & size(trialDesigCell{m,3},2) == 4
        if trialDesigCell{m,3}(1)
            mazeRegions(1,:) = mazeRegions(1,:) | [0 0 0 0 0 0 0 0 1];
            mazeRegions(2,:) = mazeRegions(2,:) | [0 0 0 0 0 0 0 1 0];
        end
        if trialDesigCell{m,3}(2)
            mazeRegions(1,:) = mazeRegions(1,:) | [0 0 0 0 0 0 1 0 0];
            mazeRegions(2,:) = mazeRegions(2,:) | [0 0 0 0 0 1 0 0 0];
        end
        if trialDesigCell{m,3}(3)
            mazeRegions(1,:) = mazeRegions(1,:) | [0 0 0 0 0 1 0 0 0];
            mazeRegions(2,:) = mazeRegions(2,:) | [0 0 0 0 0 0 1 0 0];
        end
        if trialDesigCell{m,3}(4)
            mazeRegions(1,:) = mazeRegions(1,:) | [0 0 0 0 0 0 0 1 0];
            mazeRegions(2,:) = mazeRegions(2,:) | [0 0 0 0 0 0 0 0 1];
        end

        newTrialDesigCell = cat(1,newTrialDesigCell,...
            cat(2,{trialDesigCell{m,1}},{trialDesigCell{m,2}&[1 0 0 1 1 0 0 1 1 0 0 1 1]},{mazeRegions(1,:)}), ...
            cat(2,{trialDesigCell{m,1}},{trialDesigCell{m,2}&[0 1 1 0 0 1 1 0 0 1 1 0 1]},{mazeRegions(2,:)}));
    else
        newTrialDesigCell = cat(1,newTrialDesigCell,trialDesigCell{m,:});
    end
end
trialDesigCell = newTrialDesigCell;

plotAnatBool = 1;
stdev = 3;

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

fileExt = getfield(mazeMeasStruct,'info','fileExt');
fileBaseMat = getfield(mazeMeasStruct,'info','fileBaseMat');

depVars = {'thetaPowPeak'};
indepVars = {'gammaPowIntg'};
%lags = fieldnames(eval(['mazeMeasStruct' '.' indepVars{1}]));
%junk = getfield(mazeMeasStruct,indepVars{1});
%lags = fieldnames(junk);
%[-2000 -1000 -500 -250 0 250 500 1000 2000];
regressStruct = [];

figure(2);
clf;
load('SelectedChannels')

for i=1:length(indepVars)
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
%keyboard
    selectedTrials = zeros(length(task),1);
    for m=1:size(trialDesigCell,1)
        selectedTrials = selectedTrials | ...
            (strcmp(trialDesigCell{m,1},task) & trialType*trialDesigCell{m,2}'>0.6 & mazeRegion*trialDesigCell{m,3}'>0.5);
    end
    selectedTrials = find(selectedTrials);

    nPoints = size(mazeRegion,1);
    for k=1:length(channels)
        for l=1:length(depVars)
            %keyboard
            xVar = getfield(mazeMeasStruct,indepVars{1},{channels(k),1:nPoints});
            xVar = xVar(selectedTrials)';
            xNotOutliers = xVar < mean(xVar)+stdev*std(xVar) & xVar > mean(xVar)-stdev*std(xVar);

            yVar = getfield(mazeMeasStruct,depVars{l},{channels(k),1:nPoints});
            yVar = yVar(selectedTrials)';
            yNotOutliers = yVar < mean(yVar)+stdev*std(yVar) & yVar > mean(yVar)-stdev*std(yVar);
            
            notOutliers = yNotOutliers & xNotOutliers;
            yOutliers = yVar(~notOutliers);
            xOutliers = xVar(~notOutliers);
            yVar = yVar(notOutliers);
            xVar = xVar(notOutliers);
            
            [b,bint,r,rint,stats] = regress(yVar, [ones(size(xVar)) xVar], 0.01);
            

            regressStruct = setfield(regressStruct,indepVars{1},depVars{l},'b',{channels(k),1:2},b);
            regressStruct = setfield(regressStruct,indepVars{1},depVars{l},'stats',{channels(k),1:3},stats);

            selChanNum = find(selectedChannels == channels(k));
            if ~isempty(selChanNum)
                figure(2)
                subplot(length(selectedChannels),1,selChanNum)
                hold on
                plot(xVar,yVar,'.');
                plot(xOutliers,yOutliers,'.','color',[0.75 0.75 0.75]);
                set(gca,'xlim',[mean(xVar)-8 mean(xVar)+8],'ylim',[mean(yVar)-8 mean(yVar)+8]);
                xLim = get(gca,'xlim');
                yLim = get(gca,'ylim');
                plot([xLim(1) xLim(2)],b(2).*[xLim(1) xLim(2)]+b(1),'r','linewidth',2);
                title(['channel: ' num2str(channels(k))]);
                
                %plot([xLim],[mean(yVar)-3*std(yVar) mean(yVar)-3*std(yVar)],':k');
                %plot([xLim],[mean(yVar)+3*std(yVar) mean(yVar)+3*std(yVar)],':k');
                %plot([mean(xVar)-3*std(xVar) mean(xVar)-3*std(xVar)],[yLim],':k');
                %plot([mean(xVar)+3*std(xVar) mean(xVar)+3*std(xVar)],[yLim],':k');
            end

        end
    end
end
fprintf('\nn=%i\n\n',size(selectedTrials,1));

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
%end

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


figure(1);
clf

b = getfield(regressStruct,indepVars{1},depVars{1},'b');
stats = getfield(regressStruct,indepVars{1},depVars{1},'stats');

%bAbsMax = max([bAbsMax max(abs(b(:,2)))]);
%bColorLim = 0.28; %accel-theta
%rSqColorLim = 0.42;
%bColorLim = 0.11; %speed-theta
%rSqColorLim = 0.68;
%bColorLim = 0.051; %speed-theta
%rSqColorLim = 0.51
%bColorLim = 0.012; %accel-theta
%rSqColorLim = 0.29
bColorLim = 0.5 %speed-gamma
rSqColorLim = 0.2
%bColorLim = 4.6*10^(-3) %accel-gamma
%rSqColorLim = 0.042
%bColorLim = 2*std(b(:,2));
%rSqColorLim = 2.5^2*std(stats(:,1));

r = Make2DPlotMat(b(:,2),chanMat,badChan);
rSquare = Make2DPlotMat(stats(:,1),chanMat,badChan);
pVal = Make2DPlotMat(stats(:,3),chanMat,badChan);
badChanMask = ~isnan(Make2DPlotMat(ones(size(stats(:,1))),chanMat,badChan));


subplot(1,3,1)
%subplot(2,6,j-5)
%colorLimits = [-1*max([abs(min(r)) max(abs(max(r)))]) max([abs(min(r)) max(abs(max(r)))])];
colorLimits = [-bColorLim bColorLim];
axesHandles = ImageScMask(r,badChanMask,colorLimits);
%title(['r ' indepVar ' ' lagName ' vs. ' depVar  ]);
title(SaveTheUnderscores(inName));
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end
set(axesHandles,'yticklabel',[],'xticklabel',[])

%figureMats = {rSquare, pVal};
%subplotTitles = {[indepVar ' ' lagName ' vs. ' depVar 'r^2' ], [indepVar lagName ' vs. ' depVar 'pVal']};
%cl
subplot(1,3,2)
%subplot(2,6,j-5)
colorLimits = [0 rSqColorLim];
%colorLimits = [-.75 .75];
axesHandles = ImageScMask(rSquare,badChanMask,colorLimits);
%title(['r^2 ' indepVar ' ' lagName ' vs. ' depVar  ]);

if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end
set(axesHandles,'yticklabel',[],'xticklabel',[])

subplot(1,3,3)
%subplot(2,6,j+1)
colorLimits = [1.0 10^-5];
%colorLimits = [-.75 .75];
axesHandles = ImageScMask(log10(pVal),badChanMask,log10(colorLimits));
%title(['pVal ' indepVar ' ' lagName ' vs. ' depVar ]);
if plotAnatBool
    XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
end
set(axesHandles,'yticklabel',[],'xticklabel',[])
%set(gcf,'name',['PlotSpeedAccelPowRegress' '_' fileExt '_' taskType '_minspeed' num2str(minSpeed) '_win' num2str(winLength) '_NW' num2str(NW)]);

set(gcf,'name','test');