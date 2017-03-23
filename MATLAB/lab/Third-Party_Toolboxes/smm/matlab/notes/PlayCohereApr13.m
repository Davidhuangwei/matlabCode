trialDesig.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
trialDesig.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
trialDesig.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
trialDesig.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
 files = LoadVar('AlterFiles');
 %files = files(1,:);
   
trialDesig.circle.q1 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5},...
    {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5});
trialDesig.circle.q2 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5},...
    {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5});
trialDesig.circle.q3 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5},...
    {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5});
trialDesig.circle.q4 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5},...
    {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5});
files = LoadVar('CircleFiles');
 files = files(1,:);

fileExt = '_LinNear.eeg'
%fileExt = '_LinNearCSD121.csd'
selChans = load(['ChanInfo/SelectedChannels' fileExt '.txt']);
chanMat = LoadVar(['ChanInfo/ChanMat' fileExt '.mat']);
badChans = load(['ChanInfo/BadChan' fileExt '.txt']);
analDir = ['CalcRunningSpectra8_noExp_MidPoints_MinSpeed0Win626' fileExt];
anatCurvesName = 'ChanInfo/AnatCurves.mat';
offset = load(['ChanInfo/OffSet' fileExt '.txt']);
normBool = 1;
fs = LoadField([files(1,:) '/' analDir '/cohSpec.fo']);
maxFreq = 150;
thetaFreqRange = [6 12];
gammaFreqRange = [65 100];
%y = atanh(x*2-1)./(max(atanh(x*2-1))*2) + 0.5



data = LoadDesigVar(files,analDir,'powSpec.yo.' ,trialDesig);

for j=1:length(selChans)
    selChanNames{j} = ['ch' num2str(selChans(j))];
    data.(selChanNames{j}) = LoadDesigVar(files,analDir,['cohSpec.yo.' selChanNames{j}] ,trialDesig);
end

clf
hold on

plot(fs,squeeze(mean(data.centerArm(:,37,:))),'r')
plot(fs,squeeze(mean(data.returnArm(:,37,:))),'b')
plot(fs,squeeze(mean(data.Tjunction(:,37,:))),'g')
plot(fs,squeeze(mean(data.goalArm(:,37,:))),'k')



[beta hajCorr] = hajexpfit(squeeze(fs),log(10.^(squeeze(data.centerArm(1,37,:))./10)),1);

yData = squeeze(mean([data.centerArm(:,37,:); data.returnArm(:,37,:); data.Tjunction(:,37,:); data.goalArm(:,37,:)]))';
%yData = squeeze(data.centerArm(1,37,:))';
xData = squeeze(fs);
nDeg = 2;
p = polyfit(fs,yData,nDeg)
polyCorr = yData;
fittedData = 0;
for j=0:nDeg
    p(nDeg-j+1)
    polyCorr = polyCorr - p(nDeg-j+1).*xData.^j;
    fittedData = fittedData + p(nDeg-j+1).*xData.^j;
end
figure
subplot(1,2,1);
hold on
plot(fs,yData,'b')
plot(fs,fittedData,':r')
subplot(1,2,2);
plot(fs,polyCorr,'k')

for j=1:size(data.centerArm,1)
    clf
    subplot(1,2,1);
    hold on
    plot(fs,squeeze(data.centerArm(j,37,:)),'r')
    plot(fs,squeeze(data.returnArm(j,37,:)),'b')
    plot(fs,squeeze(data.Tjunction(j,37,:)),'g')
    plot(fs,squeeze(data.goalArm(j,37,:)),'k')
    set(gca,'xlim',[30 130])
    
    subplot(1,2,2);
    hold on
    plot(fs,squeeze(data.centerArm(j,37,:))-fittedData','r')
    plot(fs,squeeze(data.returnArm(j,37,:))-fittedData','b')
    plot(fs,squeeze(data.Tjunction(j,37,:))-fittedData','g')
    plot(fs,squeeze(data.goalArm(j,37,:))-fittedData','k')
    set(gca,'xlim',[30 130])
    in = input('anything quits:','s')
    if ~isempty(in)
        break
    end
end
   

    polyCorr = fs*p(1).^3

allThetaMed = [];
allGammaMed = [];
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        dataAtanh.(selChanNames{j}).(fields{k}) = atanh((data.(selChanNames{j}).(fields{k})-0.5)*1.999);
        dataAtanhSq.(selChanNames{j}).(fields{k}) = atanh(((data.(selChanNames{j}).(fields{k})).^2-0.5)*1.999);
        %thetaMed.(selChanNames{j}).(fields{k}) = squeeze(atanh((median(data.(selChanNames{j}).(fields{k})(:,:,find(fs>=thetaFreqRange(1) & fs<=thetaFreqRange(2))),3)-0.5)*1.999));
        %thetaMed.(selChanNames{j}).(fields{k}) = squeeze(median(data.(selChanNames{j}).(fields{k})(:,:,find(fs>=thetaFreqRange(1) & fs<=thetaFreqRange(2))),3));
        %thetaMed.(selChanNames{j}).(fields{k}) = squeeze(median(data.(selChanNames{j}).(fields{k})(:,:,find(fs>=thetaFreqRange(1) & fs<=thetaFreqRange(2))),3));
        %allThetaMed = cat(1,allThetaMed,thetaMed.(selChanNames{j}).(fields{k}));
        %gammaMed.(selChanNames{j}).(fields{k}) = squeeze(atanh((median(data.(selChanNames{j}).(fields{k})(:,:,find(fs>=gammaFreqRange(1) & fs<=gammaFreqRange(2))),3)-0.5)*1.999));
        %gammaMed.(selChanNames{j}).(fields{k}) = squeeze(median(data.(selChanNames{j}).(fields{k})(:,:,find(fs>=gammaFreqRange(1) & fs<=gammaFreqRange(2))),3));
        %gammaMed.(selChanNames{j}).(fields{k}) = squeeze(median(data.(selChanNames{j}).(fields{k})(:,:,find(fs>=gammaFreqRange(1) & fs<=gammaFreqRange(2))),3));
        %allGammaMed = cat(1,allGammaMed,gammaMed.(selChanNames{j}).(fields{k}));           
    end
end
speed = LoadDesigVar(files,analDir,'speed.p0',trialDesig);
accel = LoadDesigVar(files,analDir,'accel.p0',trialDesig);
plotColors = [0 0 1;1 0 0;0 1 0;0 0 0];
clf
f = 37;
selChans2 = [40 53 55 57 46 79];
for j=1:length(selChans)
    for k=1:length(selChans2)
        subplot(length(selChans),length(selChans2),(k-1)*length(selChans)+j);
        hold on
        fields = fieldnames(data.(selChanNames{j}));
        for m=1:length(fields)
            plot(accel.(fields{m}),data.(selChanNames{j}).(fields{m})(:,selChans2(k),f),'.','color',plotColors(m,:));
        end
        if k==1
            title(selChanNames{j});
        end
        if j==1
            ylabel(num2str(selChans2(k)));
        end
        %ylabel(selChanNames{j});
        %title(num2str(selChans2(k)));
        %set(gca,'xlim',[0 150],'ylim',[-2 3]);
        %set(gca,'xlim',[0 150])
        set(gcf,'name',num2str(fs(f)));
    end
end




for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        sigCoh.(selChanNames{j}).(fields{k}) = atanh((data.(selChanNames{j}).(fields{k})-0.5)*1.999);
    end
end
hist(sigCoh.(selChanNames{1}).(fields{1})(:,37,39))
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        for ch=1:96
            for f=1:109
                yNormPsSigCoh.(selChanNames{j}).(fields{k})(ch,f) = TestNormality(sigCoh.(selChanNames{j}).(fields{k})(:,ch,f));
                yNormPs.(selChanNames{j}).(fields{k})(ch,f) = TestNormality(data.(selChanNames{j}).(fields{k})(:,ch,f));
            end
        end
    end
end

%for j=2:2
for j=1:length(selChans)
    nextFig = j;
    for k=1:length(fields)
        a = yNormPsSigCoh.(selChanNames{j}).(fields{k});
        a(find(a==0)) = 1.1e-16;
        plotData(k,:,:) =  log10(a);
    end
    %log10Bool = 1;
    colorLimits = [-3 0];
    commonCLim = [];
    cCenter = [];
    invCscaleBool = 1;
    titlesBase = fields;
    titlesExt = 'sigCoh';
    resizeWinBool = 1;
    filename = selChanNames{j};
    interpFunc = [];
    PlotMultiFreqHelper(nextFig,plotData,fileExt,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
end
%for j=2:2
for j=1:length(selChans)
    nextFig = j+6;
    for k=1:length(fields)
        a = yNormPs.(selChanNames{j}).(fields{k});
        a(find(a==0)) = 1.1e-16;
        plotData(k,:,:) =  log10(a);
    end
    %log10Bool = 1;
    colorLimits = [-3 0];
    commonCLim = [];
    cCenter = [];
    invCscaleBool = 1;
    titlesBase = fields;
    titlesExt = [];
    resizeWinBool = 1;
    filename = selChanNames{j};
    interpFunc = [];
    PlotMultiFreqHelper(nextFig,plotData,fileExt,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
end



for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        thetaMed.(selChanNames{j}).(fields{k}) = squeeze(median(data.(selChanNames{j}).(fields{k})(:,:,find(fs>=thetaFreqRange(1) & fs<=thetaFreqRange(2))),3));
        thetaATanMed.(selChanNames{j}).(fields{k}) = atanh((thetaMed.(selChanNames{j}).(fields{k})-0.5)*1.999);
        gammaMed.(selChanNames{j}).(fields{k}) = squeeze(median(data.(selChanNames{j}).(fields{k})(:,:,find(fs>=gammaFreqRange(1) & fs<=gammaFreqRange(2))),3));
        gammaATanMed.(selChanNames{j}).(fields{k}) = atanh((gammaMed.(selChanNames{j}).(fields{k})-0.5)*1.999);
    end
end
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        for ch=1:96
            thetayNormPs.(selChanNames{j}).(fields{k})(ch) = TestNormality(thetaMed.(selChanNames{j}).(fields{k})(:,ch));
            thetaAtanNormPs.(selChanNames{j}).(fields{k})(ch) = TestNormality(thetaATanMed.(selChanNames{j}).(fields{k})(:,ch));
            gammayNormPs.(selChanNames{j}).(fields{k})(ch) = TestNormality(gammaMed.(selChanNames{j}).(fields{k})(:,ch));
            gammaAtanNormPs.(selChanNames{j}).(fields{k})(ch) = TestNormality(gammaATanMed.(selChanNames{j}).(fields{k})(:,ch));
            %yNormPsSqrt.(selChanNames{j}).(fields{k})(ch) = TestNormality(dataSqrt.(selChanNames{j}).(fields{k})(:,ch));
            %yNormPsATanH.(selChanNames{j}).(fields{k})(ch) = TestNormality(dataATanH.(selChanNames{j}).(fields{k})(:,ch));
        end
    end
end
%for j=2:2
for j=1:length(selChans)
    nextFig = j+10;
    a = [];
    plotData = [];
    for k=1:length(fields)
        a = gammaAtanNormPs.(selChanNames{j}).(fields{k});
        a(find(a==0)) = 1.1e-16;
        plotData(k,:) =  log10(a);
    end
    %log10Bool = 1;
    colorLimits = [-5 0];
    commonCLim = [];
    cCenter = [];
    invCscaleBool = 1;
    titlesBase = fields;
    titlesExt = [];
    resizeWinBool = 0;
    filename = selChanNames{j};
    interpFunc = [];
    PlotHelper(nextFig,plotData,fileExt,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
end





figure(1)
colormap(LoadVar('ColorMapSean6.mat'))
set(gcf,'DefaultAxesPosition',[0.05,0.15,0.92,0.75]);
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        subplot(length(fields),length(selChans),(k-1)*length(selChans)+j);
        imagesc(Make2DPlotMat(log10(gammayNormPs.(selChanNames{j}).(fields{k})),chanMat,badChans,'linear'));
        title([selChanNames{j} ': ' fields{k}])
        set(gca,'clim',[-2 0])
        PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
        colorbar
    end
end





%cd([alterFiles(1,:) '/' analDir]);
%fo = LoadField('cohSpec.fo');
%cd('../..')
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        dataATanH.(selChanNames{j}).(fields{k}) = atanh(data.(selChanNames{j}).(fields{k}));
    end
end
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        for ch=1:96
            for f=1:109
                yNormPs.(selChanNames{j}).(fields{k})(ch,f) = TestNormality(data.(selChanNames{j}).(fields{k})(:,ch,f));
                yNormPsAtanhSq.(selChanNames{j}).(fields{k})(ch,f) = TestNormality(dataAtanhSq.(selChanNames{j}).(fields{k})(:,ch,f));
                yNormPsATanh.(selChanNames{j}).(fields{k})(ch,f) = TestNormality(dataAtanh.(selChanNames{j}).(fields{k})(:,ch,f));
            end
        end
    end
end
for j=2:2
%for j=1:length(selChans)
    nextFig = j;
    fields = fieldnames(yNormPs.(selChanNames{j}));
    plotData = [];
    for k=1:length(fields)
        a = yNormPs.(selChanNames{j}).(fields{k});
        a(find(a==0)) = 1.1e-16;
        %size(a)
        plotData(k,:,:) =  log10(a);
    end
    colorLimits = [-5 0];
    commonCLim = [];
    cCenter = [];
    invCscaleBool = 1;
    titlesBase = fields;
    titlesExt = [];
    resizeWinBool = 1;
    filename = selChanNames{j};
    interpFunc = [];
    PlotMultiFreqHelper(nextFig,plotData,fileExt,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
end
%for j=2:2
for j=1:length(selChans)
    nextFig = j+6;
    fields = fieldnames(yNormPsAtanhSq.(selChanNames{j}));
    plotData = [];
    for k=1:length(fields)
        a = yNormPsAtanhSq.(selChanNames{j}).(fields{k});
        a(find(a==0)) = 1.1e-16;
        %size(a)
        plotData(k,:,:) =  log10(a);
    end
    colorLimits = [-3 0];
    commonCLim = [];
    cCenter = [];
    invCscaleBool = 1;
    titlesBase = fields;
    titlesExt = ['yNormPsAtanhSq'];
    resizeWinBool = 1;
    filename = selChanNames{j};
    interpFunc = [];
    PlotMultiFreqHelper(nextFig,plotData,fileExt,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
end
%for j=2:2
for j=1:length(selChans)
    nextFig = j;
    fields = fieldnames(yNormPsATanh.(selChanNames{j}));
    plotData = [];
    for k=1:length(fields)
        a = yNormPsATanh.(selChanNames{j}).(fields{k});
        a(find(a==0)) = 1.1e-16;
        %size(a)
        plotData(k,:,:) =  log10(a);
    end
    colorLimits = [-3 0];
    commonCLim = [];
    cCenter = [];
    invCscaleBool = 1;
    titlesBase = fields;
    titlesExt = ['yNormPsATanh'];
    resizeWinBool = 1;
    filename = selChanNames{j};
    interpFunc = [];
    PlotMultiFreqHelper(nextFig,plotData,fileExt,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
end

function nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc)
chanMat = LoadVar(['ChanMat' fileExt '.mat']);
badChans = load(['BadChan' fileExt '.txt']);
plotAnatBool = 1;
anatOverlayName = 'AnatCurves.mat';
plotSize = [-16.5,6.5]; % adjusted for inversion of pcolor
plotOffset = [-16.5 0];% adjusted for inversion of pcolor
if invCscaleBool
    colorStyle = flipud(LoadVar('ColorMapSean6'));
else
    colorStyle = LoadVar('ColorMapSean6');
end
figSizeFactor = 1.5;
figVertOffset = 0.5;
figHorzOffset = 0;
defaultAxesPosition = [0.05,0.05,0.92,0.80+.1*size(plotData,1)/6];
sitesPerShank = size(chanMat,1);
nShanks = size(chanMat,2);
if ~isempty(colorLimits)
    commonCLim = 2;
end

nextFig = nextFig +1;
figure(nextFig)
clf
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
        a = plotData(j,(k-1)*sitesPerShank+1:(k)*sitesPerShank,:);
        a(find(a==0)) = 1.1e-16;
        if log10Bool
            a = log10(a);
        end
        pcolor(fs(1:find(abs(fs-maxFreq)==min(abs(fs-maxFreq)),1)),sitesPerShank:-1:1,squeeze(a));
        shading 'interp'
        %h = ImageScMask(Make2DPlotMat(log10((j,:)),chanMat,badChans,interpFunc),badChanMask,colorLimits);
        %imagesc(fs(1:find(abs(fs-maxFreq)==min(abs(fs-maxFreq)),1)),1:sitesPerShank,squeeze(a));
        if commonCLim == 0
            colorLimits = [];
        end
        if isempty(colorLimits)
            if isempty(cCenter)
                colorLimits = [median(abs(a(:)))-1*std(a(:)) median(abs(a(:)))+1*std(a(:))];
            else
                colorLimits = [cCenter-median(abs(a(:)))-1*std(a(:)) cCenter+median(abs(a(:)))+1*std(a(:))];
            end
        end
        if ~isempty(colorLimits)
            set(gca,'clim',colorLimits)
        end
        colorbar
        if isempty(interpFunc)
            hold on
            barh(flipud(Accumulate([intersect(chanMat(:,k), badChans)-min(chanMat(:,k))+1]',maxFreq,16)),1,'w');
        end
        if plotAnatBool
            PlotShankAnatCurves(anatOverlayName,k,get(gca,'xlim'),plotSize,plotOffset)
        end
        set(gca,'fontsize',8)
        if k == 1
            ylabel(titlesBase(j));
        end
        if j == 1
            title([{titlesExt}] );
        end
    end
    colormap(colorStyle)
end
return



if normBool
    for j=1:length(selChans)
        fields = fieldnames(data.(selChanNames{j}));
        meanTemp = [];
        stdTemp = [];
        for k=1:length(fields)
            meanTemp = cat(1,meanTemp,mean(data.(selChanNames{j}).(fields{k})));
            stdTemp = cat(1,stdTemp,std(data.(selChanNames{j}).(fields{k}),[],1));
        end
        %size(meanTemp)
        %keyboard
        meanData.(selChanNames{j}) = mean(meanTemp);
        stdData.(selChanNames{j}) = mean(stdTemp);
    end
end

figure(1)
colormap(LoadVar('ColorMapSean6.mat'))
set(gcf,'DefaultAxesPosition',[0.05,0.15,0.92,0.75]);
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        subplot(length(fields),length(selChans),(k-1)*length(selChans)+j);
        imagesc(Make2DPlotMat(squeeze(mean(data.(selChanNames{j}).(fields{k}))),chanMat,badChans,'linear'));
        title([selChanNames{j} ': ' fields{k}])
        set(gca,'clim',[0 1])
        PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
        colorbar
    end
end

if normBool
    figure(2)
    colormap(LoadVar('ColorMapSean6.mat'))
    set(gcf,'DefaultAxesPosition',[0.05,0.15,0.92,0.75]);
    for j=1:length(selChans)
        fields = fieldnames(data.(selChanNames{j}));
        for k=1:length(fields)
            %             if j==2
            %                 junk = mean(data.(selChanNames{j}).(fields{k}))-meanData.(selChanNames{j});
            %             end
            %             junk(37)
            subplot(length(fields),length(selChans),(k-1)*length(selChans)+j);
            imagesc(Make2DPlotMat(squeeze((mean(data.(selChanNames{j}).(fields{k}))-meanData.(selChanNames{j}))./stdData.(selChanNames{j}))',chanMat,badChans,'linear'));
            title([selChanNames{j} ': ' fields{k}])
            set(gca,'clim',[-1 1])
             PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
            colorbar
        end
    end
end


figure(1)
colormap(LoadVar('CircularColorMap.mat'))
set(gcf,'DefaultAxesPosition',[0.05,0.15,0.92,0.75]);
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        subplot(length(fields),length(selChans),(k-1)*length(selChans)+j);
        imagesc(Make2DPlotMat(angle(squeeze(mean(data.(selChanNames{j}).(fields{k})))),chanMat,badChans,'linear'));
        title([selChanNames{j} ': ' fields{k}])
        set(gca,'clim',[-pi pi])
        %set(gca,'clim',[0.5 1])
        PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
        colorbar
    end
end


if normBool
    figure(2)
    colormap(LoadVar('CircularColorMap'))
    set(gcf,'DefaultAxesPosition',[0.05,0.15,0.92,0.75]);
    for j=1:length(selChans)
        fields = fieldnames(data.(selChanNames{j}));
        for k=1:length(fields)
            %             if j==2
            %                 junk = mean(data.(selChanNames{j}).(fields{k}))-meanData.(selChanNames{j});
            %             end
            %             junk(37)
            subplot(length(fields),length(selChans),(k-1)*length(selChans)+j);
            imagesc(Make2DPlotMat(angle(squeeze((mean(data.(selChanNames{j}).(fields{k}))-meanData.(selChanNames{j})))),chanMat,badChans,'linear'));
            title([selChanNames{j} ': ' fields{k}])
            set(gca,'clim',[-pi pi])
             PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
            colorbar
        end
    end
end




    nextFig = j+10;
    a = [];
    plotData = [];
    fields = fieldnames(assumTest.dw);
    a = MatStruct2StructMat(assumTest.dw);
    for k=1:length(fields)
        %a = assumTest.dw.(fields{k});
        %a(find(a==0)) = 1.1e-16;
        plotData(k,:) = a.(fields{k});
    end
    %log10Bool = 1;
    colorLimits = [];
    commonCLim = [];
    cCenter = [];
    invCscaleBool = 1;
    titlesBase = fields;
    titlesExt = [];
    resizeWinBool = 1;
    filename = 'junk';
    interpFunc = [];
    PlotHelper(nextFig,plotData,fileExt,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);

