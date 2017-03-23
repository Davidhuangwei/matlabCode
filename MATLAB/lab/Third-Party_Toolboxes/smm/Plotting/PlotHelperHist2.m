function nextFig = PlotHelperHist2(nextFig,xPlotData,yPlotData,xBins,yBins,cLimits,fileExt,titlesBase,titlesExt,resizeWinBool,filename)
%colormap('bone')

if 0
    nextFig
    fileExt
    titlesBase
titlesExt
resizeWinBool
filename
end
junk = [];
%function nextFig = PlotScatHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,titlesBase,titlesExt,resizeWinBool,filename,interpFunc)
chanInfoDir = 'ChanInfo/';
chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']);
badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);
plotAnatBool = 1;
%anatOverlayName = [chanInfoDir 'AnatCurves.mat'];
plotSize = [16.5,6.5];
plotOffset = load([chanInfoDir 'OffSet' fileExt '.txt']);
badChanMask = Make2DPlotMat(ones(max(max(chanMat)),1),chanMat,badChans);
badChanMask(isnan(badChanMask)) = 0;
badChanMask = logical(badChanMask);

figSizeFactor = 1.5;
figVertOffset = 0.5;
figHorzOffset = 0;
defaultAxesPosition = [0.1,0.05,0.80,0.70];


figure(nextFig)
nextFig = nextFig +1;
clf
%colormap('bone')
set(gcf,'name',filename);
% set(gcf,'DefaultAxesPosition',defaultAxesPosition);
if resizeWinBool
    set(gcf, 'Units', 'inches')
    set(gcf, 'Position', [figHorzOffset,figVertOffset,10,10])
end


nShanks = size(chanMat,2);
chansPerShank = size(chanMat,1);
for m=1:chansPerShank
    for n=1:nShanks
        subplot(chansPerShank,nShanks,(m-1)*nShanks+n)
        if badChanMask(m,n)
            try hist2([xPlotData(:,chanMat(m,n)),yPlotData(:,chanMat(m,n))],xBins,yBins);
                %set(gca,'clim',cLimits)
                %colorbar
            catch
                plot([0 0],[0 1],'r')
            end
            if m==1
                title([titlesBase ' ' titlesExt]);
            end
%             if ~isempty(xLim)
%                 set(gca,'xlim',xLim)
%             end
%              if ~isempty(yLim)
%                 set(gca,'ylim',yLim)
%             end
           
            %plot(xPlotData(:,chanMat(m,n)),yPlotData(:,chanMat(m,n)),'.');
        else
            hold on
            plot([0 1],[0 1],'k')
            plot([0 1],[1 0],'k')
        end            
    end
end
colormap(flipud(colormap('bone')))



return



for j=1:size(plotData,1)
    subplot(1,size(plotData,1),j);
    set(gca,'fontsize',8)
    if commonCLim ~=2
        colorLimits = [];
    end
    a = plotData(j,:);
    if log10Bool
        a(find(a==0)) = 1.1e-16;
        a = log10(a);
    end
    
    if commonCLim == 0
        colorLimits = [];
    end
    if isempty(colorLimits)
        if isempty(cCenter)
            colorLimits = [median(abs(a(isfinite(a))))-1*std(a(isfinite(a))) median(abs(a(isfinite(a))))+1*std(a(isfinite(a)))];
        else
            colorLimits = [cCenter-median(abs(a(isfinite(a))))-1*std(a(isfinite(a))) cCenter+median(abs(a(isfinite(a))))+1*std(a(isfinite(a)))];
        end
    end
try
    h = ImageScRmNaN(Make2DPlotMat(squeeze(a),chanMat,badChans,interpFunc),colorLimits);
catch
    fprintf('\nBAD VALUES: %s\n',[titlesBase{j} titlesExt])
    h = ImageScRmNaN(Make2DPlotMat(squeeze(a),chanMat,badChans),colorLimits);
end
    if plotAnatBool
        XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset);
    end
    title(SaveTheUnderscores([titlesBase(j) titlesExt]));

end
    set(gcf,'name',filename);
return