function PlotSpeedAccelPowRegress(taskType,fileBaseMat,fileExt,fileNameFormat,chanMat,badChan,minSpeed,winLength,NW,indepVar,depVar)
%PlotSpeedAccelPowRegress(taskType,mazeMeasStruct,channels,stdev)

%try
%[channels, stdev] = DefaultArgs(varargin,{1:96,});
%   depVars = {'thetaPowPeak';'gammaPowIntg'};
%   indepVars = {'speeds','accels'};

inName = [taskType '_RegressPowSpeedAccel_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) 'NW' num2str(NW) '.mat'];
fprintf('Loading: %s\n',inName);
load(inName);
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



firstFig = 1;
columnsPerFig = length(lags);
for j=1:ceil(length(lags)/columnsPerFig)
    figure(firstFig -1 +j)
    clf
end

b = [];
stats = [];
for j=1:length(lags)
        if lags(j)<0
        lagName = ['n' num2str(abs(lags(j)))];
    else
        lagName = ['p' num2str(abs(lags(j)))];
    end
    b = cat(1,b,getfield(regressStruct,indepVar,lagName,depVar,'b'));
    stats = cat(1,stats,getfield(regressStruct,indepVar,lagName,depVar,'stats'));
    %bAbsMax = max([bAbsMax max(abs(b(:,2)))]);
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
bColorLim = 2*std(b(:,2));
rSqColorLim = 2.5^2*std(stats(:,1));

for j=1:length(lags)
    %for j=6:11
    figure(firstFig + floor(j/(columnsPerFig+1)))

    if lags(j)<0
        lagName = ['n' num2str(abs(lags(j)))];
    else
        lagName = ['p' num2str(abs(lags(j)))];
    end
    b = getfield(regressStruct,indepVar,lagName,depVar,'b');
    stats = getfield(regressStruct,indepVar,lagName,depVar,'stats');

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
 
    %figureMats = {rSquare, pVal};
    %subplotTitles = {[indepVar ' ' lagName ' vs. ' depVar 'r^2' ], [indepVar lagName ' vs. ' depVar 'pVal']};
    %cl
    subplot(3,columnsPerFig,mod(j-1,columnsPerFig)+1+columnsPerFig)
    %subplot(2,6,j-5)
    colorLimits = [0 rSqColorLim];
    %colorLimits = [-.75 .75];
    axesHandles = ImageScMask(rSquare,badChanMask,colorLimits);
    title(['r^2 ' indepVar ' ' lagName ' vs. ' depVar  ]);
    if plotAnatBool
        XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
    end
        set(axesHandles,'yticklabel',[],'xticklabel',[])

    subplot(3,columnsPerFig,mod(j-1,columnsPerFig)+1+2*columnsPerFig)
    %subplot(2,6,j+1)
    colorLimits = [1.0 10^-10];
    %colorLimits = [-.75 .75];
    axesHandles = ImageScMask(log10(pVal),badChanMask,log10(colorLimits));
    title(['pVal ' indepVar ' ' lagName ' vs. ' depVar ]);
    if plotAnatBool
        XYPlotAnatCurves({anatOverlayName},  axesHandles,plotSize,[plotOffset],[],anatLineWidth);
    end
        set(axesHandles,'yticklabel',[],'xticklabel',[])

end

set(gcf,'name',['PlotSpeedAccelPowRegress' '_' fileExt '_' taskType '_minspeed' num2str(minSpeed) '_win' num2str(winLength) '_NW' num2str(NW)]);
