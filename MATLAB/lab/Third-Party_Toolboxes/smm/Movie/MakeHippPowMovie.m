function MakeHippPowMovie(fileBase,fileExt,nChannels,chanMat,badChan,lowCut,highCut,dbScale,zBool)
% function MakeHippPowMovie(fileBase,fileExt,nChannels,chanMat,badChan,lowCut,highCut,dbScale,zBool)

whlData = load([fileBase '.whl']);
dsPowName = [fileBase '_' num2str(lowCut) '-' num2str(highCut) 'Hz' fileExt '.100DBdspow'];
if dbScale
    powerData = (bload(dsPowName,[nChannels inf],0,'int16')')/100;
else
    powerData = 10.^((bload(dsPowName,[nChannels inf],0,'int16')')/1000);
end
mazeRegions = LoadMazeTrialTypes(fileBase, [1  1  1  1  1   1   1   1   1   1   1   1  0],[0  0  0  1  1  1   1   1   1]);
                                          % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP rp lp dp cp ca rca lca rra lra;
[speed, accel] = mazespeedaccel(whlData);

load('ColorMapSean3.mat')
ColorMapSean3(1,:) = [.75 .75 .75];
colormap(ColorMapSean3);
noWhiteColorMap = ColorMapSean3(2:end,:);

whlSamp = 39.0625; % samples/sec

meanPowPerChan = mean(powerData(find(mazeRegions(:,1)~=-1),:),1);
stdPowPerChan = std(powerData(find(mazeRegions(:,1)~=-1),:),1);
stdPowPerChanMap = Make2DPlotMat(stdPowPerChan,chanMat,badChan);

imagesc(stdPowPerChanMap);
colorbar;

if zBool
    colorLimits = [-3.01 3.01];
else
    if dbScale
        colorLimits = [-15 5];
    else
        colorLimits = [-.01 2.01];
    end
end

load('ColorMapSean3.mat')
ColorMapSean3(1,:) = [.75 .75 .75];
noWhiteColorMap = ColorMapSean3(2:end,:);
colormap(ColorMapSean3);
figure(2)
imagesc(stdPowPerChanMap);
colorbar;
figure(1)

clf;
speedColorRange = [0 90];
accelColorRange = [-7 7];
subplot('position', [.05 .05 .04 .8])
pcolor(repmat([speedColorRange(1):speedColorRange(2)],2,1)')
shading interp
title('Speed','fontsize',8);
[ytlm n] = size(get(gca,'yticklabel'));
set(gca,'fontsize',8,'xtick',[],'ytick',[round(speedColorRange(1):(speedColorRange(2)-speedColorRange(1))/(ytlm):speedColorRange(2))],'yticklabel',[round(speedColorRange(1):(speedColorRange(2)-speedColorRange(1))/(ytlm):speedColorRange(2))]);

subplot('position', [.14 .05 .04 .8])
pcolor(repmat([accelColorRange(1):accelColorRange(2)],2,1)');
[ytlm n] = size(get(gca,'yticklabel'));
set(gca,'fontsize',8,'xtick',[],'ytick', [round(1:(abs(accelColorRange(1))+accelColorRange(2))/ytlm:1+abs(accelColorRange(1))+accelColorRange(2))] ,'yticklabel',[round(accelColorRange(1):(abs(accelColorRange(1))+accelColorRange(2))/ytlm:accelColorRange(2))]);
%set(gca,'xtick',[],'ytick', [0 mean([accelColorRange(1) accelColorRange(2)] accelColorRange(2)) ,'yticklabel',[round(accelColorRange(1):(accelColorRange(2)-accelColorRange(1))/(ytlm-1):accelColorRange(2))]);
shading interp
title('Accel','fontsize',8);

[whlm,n]=size(whlData);

j = 1;
movieBool = 0;
step=ceil(whlSamp/2);
while j<whlm

    if movieBool
        figure(1)
    end
    subplot('position', [.20 .05 .31 .8])
    hold off;
    plot(whlData(:,1),whlData(:,2),'.','color',[0.5 0.5 0.5]);
    hold on;
    speedColor = round(speed(j)/90*length(noWhiteColorMap)); % 90 cm/s is top speedColor
    speedColor = max(1,speedColor);
    speedColor = min(length(noWhiteColorMap),speedColor);
    plot(whlData(j,1),whlData(j,2),'.','color',noWhiteColorMap(speedColor,:),'markersize',45);
    colorCenter = ceil(length(noWhiteColorMap)/2);
    accelColor = round(colorCenter + accel(j)/7*length(noWhiteColorMap)/2); % +-7cm/s^2 is top accelColor;
    accelColor = min(length(noWhiteColorMap),accelColor);
    accelColor = max(1,accelColor);
    plot(whlData(j,1),whlData(j,2),'.','color',noWhiteColorMap(accelColor,:),'markersize',25);
    set(gca,'xlim',[0 368],'ylim',[0 240]);
    set(gca,'xtick',[],'ytick',[]);
    title('position','fontsize',8);
      
    subplot('position', [.58 .05 .38 .8])
    hold off
    if 0
        zPow = (powerData(j,:)-meanPowPerChan)./stdPowPerChan;
        zPowMap = Make2DPlotMat(zPow,chanMat,badChan);
        imagesc(zPowMap);
    else
        if dbScale
            normPow = (powerData(j,:) - meanPowPerChan);
        else
            normPow = (powerData(j,:) ./ meanPowPerChan);
        end
        normPowMap = Make2DPlotMat(normPow,chanMat,badChan);
        imagesc(normPowMap);
    end
    set(gca,'xtick',[]);
    set(gca,'clim',[colorLimits]);
    colorbar;
    title('Theta Power','fontsize',8);
    hold on
    
    lw = 2; % line width
    lc = [0.5 0.5 0.5]; % line color
    ca1x1 = [0.5:0.25:2.0,2.5:0.5:6.5];
    ca1x2 = ca1x1;
    ca1y1 = [9.25,7.5,6,4.75,3.9,3,2.5,1.9,1.5,1.4,1.5,1.75,2.25,3,4.1,5.4];
    ca1y2 = ca1y1+[1.6:-(1.6-0.65)/6:0.65,0.6,0.6,0.6:(0.75-0.6)/6:0.75];
    plot(ca1x1,ca1y1,'color',lc,'linewidth',lw)
    plot(ca1x2,ca1y2,'color',lc,'linewidth',lw)
    
    fissureX = [1.25:0.25:3.5,4:0.5:5.5,5.63];
    fissureY = [15,14.1,13.2,12.3,10.5,9,8.3,7.8,7.3,7,7.1,7.5,8.1,8.8,9];
    plot(fissureX,fissureY,'color',lc,'linewidth',lw)
    
    ca3x1 = [4:0.5:6.5];
    ca3x2 = [4,3.85,3.75,3.7,3.75,ca3x1];
    ca3y1 = [13.1,13.3,13.8,14.5,14.9,15.2];
    ca3y2 = [13.1,13.25,13.5,13.8,14,ca3y1+1.1];
    plot(ca3x1,ca3y1,'color',lc,'linewidth',lw)
    plot(ca3x2,ca3y2,'color',lc,'linewidth',lw)   
    
    dggX = [1.5:0.5:3.5,3.75,4:0.5:5.5,5.8,5.8,5.7,5.5:-0.5:4,3.75,3.5,2.75,3.5,4,4.5,5];
    dggY = [17,16.4,14.9,12.7,10.7,10.4,10.5,10.8,11.3,11.9,12.3,12.6,12.8,12.7,12.3,11.8,11.5,11.7,12.4,15.7,15.8,16.1,16.3,16.7];
    plot(dggX,dggY,'color',lc,'linewidth',lw)

    if movieBool == 0
        i = input('how far to step (in seconds)?');

        if isempty(i)
            j = j+step;
        else
            if i == 'm'
                i = input('How long shall the movie be (in seconds)? [rest of file]');
                if isempty(i)
                    movieLength = inf;
                else
                    movieLength = round(i*whlSamp);
                end
                step = ceil(.00001*whlSamp);
                movieBool = 1;
                start = j;
                fprintf('\nCapturing Movie... \nFrame:');
                aviobj = avifile ( [fileBase '.avi'], 'fps', round(whlSamp));
            else
                step = ceil(i*whlSamp);
                j = j+step;
            end
        end
    else
        frame = getframe ( gcf );
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



