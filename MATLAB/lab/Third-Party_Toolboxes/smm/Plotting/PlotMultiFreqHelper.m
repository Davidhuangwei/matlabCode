function nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,yLabels,figTitle,resizeWinBool,fs,maxFreq,filename,interpFunc)
    prevGL = opengl;
    opengl('neverselect')

    addpath /u12/smm/matlab/sm_Copies/barh/

    chanInfoDir = 'ChanInfo/';
    chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']);
    badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);
    plotAnatBool = 1;
    anatOverlayName = [chanInfoDir 'AnatCurves.mat'];
    plotSize = [-16.5,6.5]; % adjusted for inversion of pcolor
    temp = load([chanInfoDir 'OffSet' fileExt '.txt']);
    plotOffset = [plotSize(1)+temp(1) temp(2)];% adjusted for inversion of pcolor
    if invCscaleBool
        colorStyle = flipud(LoadVar('ColorMapSean6'));
    else
        colorStyle = LoadVar('ColorMapSean6');
    end
    %figSizeFactor = 0.5;
    figSizeFactor = 1.5;
    %figVertOffset = 2;
    figVertOffset = 0.5;
    %figHorzOffset = 2;
    figHorzOffset = 0;
    defaultAxesPosition = [0.05,0.05,0.92,0.80+.1*size(plotData,1)/6];
    sitesPerShank = size(chanMat,1);
    nShanks = size(chanMat,2);
    if ~isempty(colorLimits)
        commonCLim = 2;
    end

    figure(nextFig)
    %set(gcf,'renderer','OpenGL')
    nextFig = nextFig +1;
    clf
    colormap(colorStyle)
    set(gcf,'name',filename);
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(nShanks)*1.6,figSizeFactor*(size(plotData,1))*1.3])
    end

    for j=1:size(plotData,1)
        if commonCLim ~=2
            colorLimits = [];
        end
        for k=1:nShanks
            subplot(size(plotData,1),nShanks,(j-1)*nShanks+k);
            a = plotData(j,chanMat(:,k),find(fs<=maxFreq));
            %a = plotData(j,(k-1)*sitesPerShank+1:(k)*sitesPerShank,find(fs<=maxFreq));
            %a = plotData(j,(k-1)*sitesPerShank+1:(k)*sitesPerShank,length(fs):-1:find(abs(fs-maxFreq)==min(abs(fs-maxFreq)),1));
            if log10Bool
                a(find(a==0)) = 1.1e-16;
                a = log10(a);
            end
            %pcolor(fs(length(fs):-1:find(abs(fs-maxFreq)==min(abs(fs-maxFreq)),1)),sitesPerShank:-1:1,squeeze(a));
            pcolor(fs(find(fs<=maxFreq)),sitesPerShank:-1:1,squeeze(a));
            shading 'interp'
            %h = ImageScMask(Make2DPlotMat(log10((j,:)),chanMat,badChans,interpFunc),badChanMask,colorLimits);
            %imagesc(fs(1:find(abs(fs-maxFreq)==min(abs(fs-maxFreq)),1)),1:sitesPerShank,squeeze(a));

            set(gca,'fontsize',8)
            if k == 1
                ylabel(yLabels{j});
            end
            if j == 1
                title(figTitle);
                %title([yLabels{j} ' ' titles]);
            end

            if isempty(interpFunc) & ~isempty(badChans) & badChans~=0
                hold on
                try 
                    barh(flipud(Accumulate([intersect(chanMat(:,k), badChans)-min(chanMat(:,k))+1]',maxFreq,sitesPerShank)),1,'w');
                catch barh(flipud(Accumulate([1:sitesPerShank]',maxFreq,sitesPerShank)),1,'w');
                end
            end
            if plotAnatBool
                PlotShankAnatCurves(anatOverlayName,k,get(gca,'xlim'),plotSize,plotOffset)
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
            if ~isempty(colorLimits)
                set(gca,'clim',colorLimits)
            end
            colorbar
        end
    end
    opengl(prevGL)
return
