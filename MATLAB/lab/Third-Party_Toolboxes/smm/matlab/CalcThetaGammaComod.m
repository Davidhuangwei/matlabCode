function regressStruct = CalcThetaGammaComod(taskType,minSpeed,winLength,midPointsBool,thetaNW,gammaNW,varargin)
%function regressStruct = CalcSpeedAccelPowRegress(taskType,mazeMeasStruct,channels,stdev)
[trialDesigCell, channels, stdev] = DefaultArgs(varargin,{...
    cat(2,{'alter';'circle';'z'},repmat({[1 1 1 1 1 1 1 1 1 1 1 1 1]},3,1),repmat({[1 1 1 1 1 1 1 1 1]},3,1)),...
    1:96,2.0});

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
        for l=1:length(depVars)
            %keyboard
            xVar = getfield(mazeMeasStruct,indepVars{1},{channels(k),1:nPoints});
            xVar = xVar(selectedTrials)';

            yVar = getfield(mazeMeasStruct,depVars{l},{channels(k),1:nPoints});
            yVar = yVar(selectedTrials)';
            [b,bint,r,rint,stats] = regress(yVar, [ones(size(xVar)) xVar], 0.01);

            %[b,bint,r,rint,stats] = regress(yVar(notOutliers), [ones(size(xVar(notOutliers))) xVar(notOutliers)], 0.01);

            regressStruct = setfield(regressStruct,indepVars{1},depVars{l},'b',{channels(k),1:2},b);
            %regressStruct = setfield(regressStruct,indepVars{i},lags{j},depVars{l},'bint',{channels(k),1:2,1:2},bint);
            %regressStruct = setfield(regressStruct,indepVars{i},lags{j},depVars{l},'r',{channels(k),1:length(notOutliers)},r);
            %regressStruct = setfield(regressStruct,indepVars{i},lags{j},depVars{l},'rint',{channels(k),1:length(notOutliers),1:2},rint);
            regressStruct = setfield(regressStruct,indepVars{1},depVars{l},'stats',{channels(k),1:3},stats);

            %regressStruct = setfield(regressStruct,indepVars{i},lagName,depVars{l},['chan' num2str(channels(k))],'b',b);
            %regressStruct = setfield(regressStruct,indepVars{i},lagName,['chan' num2str(channels(k))],depVars{l},'bint',bint);
            %regressStruct = setfield(regressStruct,indepVars{i},lagName,['chan' num2str(channels(k))],depVars{l},'r',r);
            %regressStruct = setfield(regressStruct,indepVars{i},lagName,['chan' num2str(channels(k))],depVars{l},'rint',rint);
            %regressStruct = setfield(regressStruct,indepVars{i},lagName,depVars{l},['chan' num2str(channels(k))],'stats',stats);


        end
    end
end

    r = Make2DPlotMat(b(:,2),chanMat,badChan);
    rSquare = Make2DPlotMat(stats(:,1),chanMat,badChan);
    pVal = Make2DPlotMat(stats(:,3),chanMat,badChan);
    badChanMask = ~isnan(Make2DPlotMat(ones(size(stats(:,1))),chanMat,badChan));

    
    subplot(3,columnsPerFig,mod(j-1,columnsPerFig)+1)
    %subplot(2,6,j-5)
    %colorLimits = [-1*max([abs(min(r)) max(abs(max(r)))]) max([abs(min(r)) max(abs(max(r)))])];
    colorLimits = [-bColorLim bColorLim];
    axesHandles = ImageScMask(r,badChanMask,colorLimits);
    title(['r ' indepVar ' ' lagName ' vs. ' depVar  ]);
    if plotAnatBool
        XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
    end
    set(axesHandles,'yticklabel',[],'xticklabel',[])


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