function MakeHippPowMovie2(fileBase,fileExt,nChannels,chanMat,badChan,lowCut,highCut,dbScale,zBool)
% function MakeHippPowMovie(fileBase,fileExt,nChannels,chanMat,badChan,lowCut,highCut,dbScale,zBool)

csd1FileExt = '.csd.1';
csd1NChannels = 84;
csd1ChanMat = MakeChanMat(6,14);
csd1BadChan = [14,13,12,11,10,9];
csd121FileExt = '.csd.121';
csd121NChannels = 72;
csd121ChanMat = MakeChanMat(6,12);
csd121BadChan = [12,11,10,9,8,7];

videoLimits = [368 240];

whlData = load([fileBase '.whl']);
dsPowName = [fileBase '_' num2str(lowCut) '-' num2str(highCut) 'Hz' fileExt '.100DBdspow'];
csd1DsPowName = [fileBase '_' num2str(lowCut) '-' num2str(highCut) 'Hz' csd1FileExt '.100DBdspow'];
csd121DsPowName = [fileBase '_' num2str(lowCut) '-' num2str(highCut) 'Hz' csd121FileExt '.100DBdspow'];
if dbScale
    powerData = (bload(dsPowName,[nChannels inf],0,'int16')')/100;
    csd1PowerData = (bload(csd1DsPowName,[csd1NChannels inf],0,'int16')')/100;
    csd121PowerData = (bload(csd121DsPowName,[csd121NChannels inf],0,'int16')')/100;
else
    powerData = 10.^((bload(dsPowName,[nChannels inf],0,'int16')')/1000);
    csd1PowerData = 10.^((bload(csd1DsPowName,[csd1NChannels inf],0,'int16')')/1000);
    csd121PowerData = 10.^((bload(csd121DsPowName,[csd121NChannels inf],0,'int16')')/1000);
end
mazeRegions = LoadMazeTrialTypes(fileBase, [1  1  1  1  1   1   1   1   1   1   1   1  0],[0  0  0  1  1  1   1   1   1]);
                                          % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP rp lp dp cp ca rca lca rra lra;
[speed, accel] = MazeSpeedAccel(whlData);

if ~exist([fileBase(1:6) 'AnatCurvScaled.mat'],'file')
    fprintf('No Anat Overlay File found: %s\n',[fileBase(1:6) 'AnatCurvScaled.mat']);
    plotAnatBool = 0;
else
    load([fileBase(1:6) 'AnatCurvScaled.mat']);
    plotAnatBool = 1;
end

whlSamp = 39.0625; % samples/sec

meanPowPerChan = mean(powerData(find(mazeRegions(:,1)~=-1),:),1);
stdPowPerChan = std(powerData(find(mazeRegions(:,1)~=-1),:),1);
stdPowPerChanMap = Make2DPlotMat(stdPowPerChan,chanMat);
badChanMask = ~isnan(Make2DPlotMat(ones(size(stdPowPerChan)),chanMat,badChan));
rawPowColorLimits = [min(meanPowPerChan-2.*stdPowPerChan) max(meanPowPerChan+3.*stdPowPerChan)];

csd1MeanPowPerChan = mean(csd1PowerData(find(mazeRegions(:,1)~=-1),:),1);
csd1StdPowPerChan = std(csd1PowerData(find(mazeRegions(:,1)~=-1),:),1);
csd1StdPowPerChanMap = Make2DPlotMat(csd1StdPowPerChan,csd1ChanMat);
csd1BadChanMask = ~isnan(Make2DPlotMat(ones(size(csd1StdPowPerChan)),csd1ChanMat,csd1BadChan));
rawCsd1ColorLimits = [min(csd1MeanPowPerChan-2.*csd1StdPowPerChan) max(csd1MeanPowPerChan+2.*csd1StdPowPerChan)];

csd121MeanPowPerChan = mean(csd121PowerData(find(mazeRegions(:,1)~=-1),:),1);
csd121StdPowPerChan = std(csd121PowerData(find(mazeRegions(:,1)~=-1),:),1);
csd121StdPowPerChanMap = Make2DPlotMat(csd121StdPowPerChan,csd121ChanMat);
csd121BadChanMask = ~isnan(Make2DPlotMat(ones(size(csd121StdPowPerChan)),csd121ChanMat,csd121BadChan));
rawCsd121ColorLimits = [35 60];
%rawCsd121ColorLimits = [min(csd121MeanPowPerChan-3.*csd121StdPowPerChan) max(csd121MeanPowPerChan+3.*csd121StdPowPerChan)];


if zBool
    colorLimits = [-3.01 3.01];
else
    if dbScale
        colorLimits = [-5 5];
    else
        colorLimits = [-.01 2.01];
    end
end

%load('ColorMapSean3.mat')
%ColorMapSean3(1,:) = [.75 .75 .75];
%colormap(ColorMapSean3);
figure(2)
clf
subplot(2,2,2)
ImageScMask(stdPowPerChanMap,badChanMask);
subplot(2,2,3)
ImageScMask(csd1StdPowPerChanMap,csd1BadChanMask);
subplot(2,2,4)
ImageScMask(csd121StdPowPerChanMap,csd121BadChanMask);
%colorbar;
fig1 = figure(1);
%set(fig1,'DoubleBuffer','on');


[whlm,n]=size(whlData);

% Plot positions
speedPlotPos =     [.07 .7 .04 .25];
accelPlotPos =     [.16 .7 .04 .25];
mazePlotPos =      [.23 .7 .31 .25];

rawPowerPlotPos =  [.05 .4 .25 .25];
rawCsd1PlotPos =   [.35 .4 .25 .25];
rawCsd121PlotPos = [.65 .4 .25 .25];

powerPlotPos =     [.05 .05 .25 .25];
csd1PlotPos =      [.35 .05 .25 .25];
csd121PlotPos =    [.65 .05 .25 .25];

j = 1;
movieBool = 0;
step=ceil(whlSamp/2);
while j<whlm

    figure(fig1)
    clf;
    subplot('position', speedPlotPos)
    if whlData(j,1) == -1
        plot(inf);
    else
        plot([0 1],[speed(j) speed(j)],'linewidth',7,'color',[1 0 0]);
    end
    title({'Speed'},'fontsize',8);
    set(gca,'fontsize',8,'xlim',[0 1],'xtick',[],'ylim',[0 max(speed)]);
    %set(h,'EraseMode','xor');

    subplot('position', accelPlotPos)
    if whlData(j,1) == -1
        plot(inf);
    else
        plot([0 1],[accel(j) accel(j)],'linewidth',7,'color',[1 0 0]);
    end
    title('Accel','fontsize',8);
    set(gca,'fontsize',8,'xlim',[0 1],'xtick',[],'ylim',[min(accel) max(accel)]);
    %set(h,'EraseMode','xor');

    if movieBool & 0
        figure(1)
    end
    subplot('position', mazePlotPos)
    hold off;
    plot(whlData(:,1),videoLimits(2)-whlData(:,2),'.','color',[0.5 0.5 0.5]);
    %set(h,'EraseMode','xor');
    hold on;
    plot(whlData(j,1),videoLimits(2)-whlData(j,2),'.r','markersize',20);
    set(gca,'xlim',[0 videoLimits(1)],'ylim',[0 videoLimits(2)]);
    set(gca,'xtick',[],'ytick',[])
    title({'Position'},'fontsize',8);

    %set(h,'EraseMode','xor');
    
    subplot('position', rawPowerPlotPos)
    hold off
    powMap = Make2DPlotMat(powerData(j,:),chanMat);
    ImageScMask(powMap,badChanMask,rawPowColorLimits);
    set(gca,'xtick',[],'ytick',[]);
    title({'Theta Power'},'fontsize',8);
    hold on
    if plotAnatBool
        for k=1:size(anatCurves,1)
            plot(anatCurves{k,1},anatCurves{k,2},'color',[0.5,0.5,0.5],'linewidth',2);
            %set(h,'EraseMode','xor');
        end
    end  
  
    
    subplot('position', rawCsd1PlotPos)
    hold off
    csd1PowMap = Make2DPlotMat(csd1PowerData(j,:),csd1ChanMat);
    ImageScMask(csd1PowMap,csd1BadChanMask,rawCsd1ColorLimits);
    set(gca,'xtick',[],'ytick',[]);
    title({'CSD1 Theta Power'},'fontsize',8);
    hold on
    if plotAnatBool
        for k=1:size(anatCurves,1)
            plot(anatCurves{k,1},-1+anatCurves{k,2},'color',[0.5,0.5,0.5],'linewidth',2);
            %set(h,'EraseMode','xor');
        end
    end    
    
    subplot('position', rawCsd121PlotPos)
    hold off
    csd121PowMap = Make2DPlotMat(csd121PowerData(j,:),csd121ChanMat);
    ImageScMask(csd121PowMap,csd121BadChanMask,rawCsd121ColorLimits);
    set(gca,'xtick',[],'ytick',[]);
    title({'CSD121 Theta Power'},'fontsize',8);
    hold on
    if plotAnatBool
        for k=1:size(anatCurves,1)
            plot(anatCurves{k,1},-2+anatCurves{k,2},'color',[0.5,0.5,0.5],'linewidth',2);
            %set(h,'EraseMode','xor');
        end
    end    
          
    subplot('position', powerPlotPos)
    hold off
    if zBool
        zPow = (powerData(j,:)-meanPowPerChan)./stdPowPerChan;
        zPowMap = Make2DPlotMat(zPow,chanMat);
        ImageScMask(zPowMap,badChanMask,colorLimits);
        %set(h,'EraseMode','xor');
    else
        if dbScale
            normPow = (powerData(j,:) - meanPowPerChan);
        else
            normPow = (powerData(j,:) ./ meanPowPerChan);
        end
        normPowMap = Make2DPlotMat(normPow,chanMat);
        ImageScMask(normPowMap,badChanMask,colorLimits);
        %set(h,'EraseMode','xor');
    end
    set(gca,'xtick',[],'ytick',[]);
    
    %set(gca,'clim',[colorLimits]);
    %colorbar;
    title({'Normalized', 'Theta Power'},'fontsize',8);
    if dbScale
        title({'Normalized', 'Theta Power (DB)'},'fontsize',8);
    end
    if zBool
        title({'Theta Power', '(Z-Score)'},'fontsize',8);
    end
    hold on
    if plotAnatBool
        for k=1:size(anatCurves,1)
            plot(anatCurves{k,1},anatCurves{k,2},'color',[0.5,0.5,0.5],'linewidth',2);
            %set(h,'EraseMode','xor');
        end
    end
    %drawnow
    
    subplot('position', csd1PlotPos)
    hold off
    if zBool
        csd1ZPow = (csd1PowerData(j,:)-csd1MeanPowPerChan)./csd1StdPowPerChan;
        csd1ZPowMap = Make2DPlotMat(csd1ZPow,csd1ChanMat);
        ImageScMask(csd1ZPowMap,csd1BadChanMask,colorLimits);
        %set(h,'EraseMode','xor');
    else
        if dbScale
            csd1NormPow = (csd1PowerData(j,:) - csd1MeanPowPerChan);
        else
            csd1NormPow = (csd1PowerData(j,:) ./ csd1MeanPowPerChan);
        end
        csd1NormPowMap = Make2DPlotMat(csd1NormPow,csd1ChanMat);
        ImageScMask(csd1NormPowMap,csd1BadChanMask,colorLimits);
        %set(h,'EraseMode','xor');
    end
    set(gca,'xtick',[],'ytick',[]);
    
    %set(gca,'clim',[colorLimits]);
    %colorbar;
    title({'CSD1 Normalized', 'Theta Power'},'fontsize',8);
    if dbScale
        title({'CSD1 Normalized', 'Theta Power (DB)'},'fontsize',8);
    end
    if zBool
        title({'CSD1 Theta Power', '(Z-Score)'},'fontsize',8);
    end
    hold on
    if plotAnatBool
        for k=1:size(anatCurves,1)
            plot(anatCurves{k,1},-1+anatCurves{k,2},'color',[0.5,0.5,0.5],'linewidth',2);
            %set(h,'EraseMode','xor');
        end
    end
    %drawnow
    xlabel([SaveTheUnderscores(fileBase)],'fontsize',8);
    
    subplot('position', csd121PlotPos)
    hold off
    if zBool
        csd121ZPow = (csd121PowerData(j,:)-csd121MeanPowPerChan)./csd121StdPowPerChan;
        csd121ZPowMap = Make2DPlotMat(csd121ZPow,csd121ChanMat);
        ImageScMask(csd121ZPowMap,csd121BadChanMask,colorLimits);
        %set(h,'EraseMode','xor');
    else
        if dbScale
            csd121NormPow = (csd121PowerData(j,:) - csd121MeanPowPerChan);
        else
            csd121NormPow = (csd121PowerData(j,:) ./ csd121MeanPowPerChan);
        end
        csd121NormPowMap = Make2DPlotMat(csd121NormPow,csd121ChanMat);
        ImageScMask(csd121NormPowMap,csd121BadChanMask,colorLimits);
        %set(h,'EraseMode','xor');
    end
    set(gca,'xtick',[],'ytick',[]);
    
    %set(gca,'clim',[colorLimits]);
    %colorbar;
    title({'CSD121 Normalized', 'Theta Power'},'fontsize',8);
    if dbScale
        title({'CSD121 Normalized', 'Theta Power (DB)'},'fontsize',8);
    end
    if zBool
        title({'CSD121 Theta Power', '(Z-Score)'},'fontsize',8);
    end
    hold on
    if plotAnatBool
        for k=1:size(anatCurves,1)
            plot(anatCurves{k,1},-2+anatCurves{k,2},'color',[0.5,0.5,0.5],'linewidth',2);
            %set(h,'EraseMode','xor');
        end
    end
    %drawnow
    xlabel(['Time: ' Sampl2TimeText(j,whlSamp,4)],'fontsize',8);

    if movieBool == 0
        i = input('how far to step (in seconds)?');

        if isempty(i)
            j = j+step;
        else
            if i == 'm'
                i = input('How long shall the movie be (in seconds)? [rest of file] ');
                if isempty(i)
                    movieLength = inf;
                else
                    movieLength = round(i*whlSamp);
                end
                step = ceil(.00001*whlSamp);
                movieBool = 1;
                start = j;
                fprintf('\nCapturing Movie... \nFrame:');
                movieNameExt = [];
                if dbScale
                    movieNameExt = [movieNameExt '_DB'];
                end
                if zBool
                    movieNameExt = [movieNameExt '_z-score'];
                end
                aviobj = avifile ( [fileBase fileExt '_ThetaPow' movieNameExt '.avi'], 'fps', round(whlSamp));
            else
                step = ceil(i*whlSamp);
                j = j+step;
            end
        end
    else
        frame = getframe ( fig1 );
        aviobj = addframe ( aviobj, frame );
        fprintf('%i,',j-start);
        if j == start+movieLength
            movieBool = 0;
            aviobj = close ( aviobj );
        else
            j = j+step;
        end
    end
end
if movieBool
    aviobj = close ( aviobj );
end



