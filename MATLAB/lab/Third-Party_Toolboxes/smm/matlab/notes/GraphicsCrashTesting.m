colorStyle = LoadVar('ColorMapSean6');
defaultAxesPosition = [0.05,0.05,0.92,0.80+.1];
for m=1:10
    figure(m)
    clf
    set(gcf,'name','junkyeah');
    set(gcf,'DefaultAxesPosition',defaultAxesPosition);
    set(gcf, 'Units', 'inches')
    set(gcf, 'Position', [1,1,8,5])
    
    
    cd /BEEF01/smm/sm9603_Analysis/analysis04/
PlotGLMResults01('GlmWholeModel01','Alter_firstRun_','powSpec.yo','_LinNear.eeg',1,[],1)

    figure
    clf
    yLabels = model.varNames;
    for j=1:4
        for k=1:6
            subplot(4,6,(j-1)*6+k);
            a = rand(100);
            a(find(a<0.01)) = NaN;
            a(find(a>0.99)) = inf;
            pcolor([1:100].^2,1./[1:100],a)
            %pcolor(rand(100))
            shading interp
            set(gca,'clim',[.5 1.5])
            colorbar
            set(gca,'fontsize',8)
            if k == 1
                ylabel(yLabels{j});
            end
            if j == 1
                title('joy' );
            end

        end
        colormap(colorStyle)
    end

print -dpng junk





    plotData = model.pVals;
    titlesBase = [model.varNames];
    titlesExt = 'pVals';
    log10Bool = 1;
    colorLimits = [-10 1];
    invCscaleBool = 1;
    commonCLim = 2;
    cCenter = [];
    nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);

    for j=1:size(plotData,1)
        subplot(
    
    
    