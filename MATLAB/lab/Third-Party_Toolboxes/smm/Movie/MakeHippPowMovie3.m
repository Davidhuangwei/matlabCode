function MakeHippPowMovie2(fileBase,fileExt,nChannels,chanMat,badChan,lowCut,highCut,dbScale,zBool)
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
stdPowPerChanMap = Make2DPlotMat(stdPowPerChan,chanMat,badChan);

if zBool
    colorLimits = [-3.01 3.01];
else
    if dbScale
        colorLimits = [-15 5];
    else
        colorLimits = [-.01 2.01];
    end
end

%load('ColorMapSean3.mat')
%ColorMapSean3(1,:) = [.75 .75 .75];
%colormap(ColorMapSean3);
figure(2)
ImageScMask(stdPowPerChanMap);
%colorbar;
fig1 = figure(1);
%set(fig1,'DoubleBuffer','on');


if 0
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
end

[whlm,n]=size(whlData);

j = 1;
movieBool = 0;
step=ceil(whlSamp/2);
while j<whlm
    
    subplot('position', [.07 .05 .04 .8])
    if whlData(j,1) == -1
        plot(inf);
    else

        plot([0 1],[speed(j) speed(j)],'linewidth',7,'color',[1 0 0]);
    end
    title('Speed','fontsize',8);
    set(gca,'fontsize',8,'xlim',[0 1],'xtick',[],'ylim',[0 max(speed)]);
    %set(h,'EraseMode','xor');

    subplot('position', [.16 .05 .04 .8])
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
    subplot('position', [.23 .05 .31 .8])
    hold off;
    plot(whlData(:,1),whlData(:,2),'.','color',[0.5 0.5 0.5]);
    %set(h,'EraseMode','xor');
    hold on;
    plot(whlData(j,1),whlData(j,2),'.r','markersize',20);
    set(gca,'xlim',[0 368],'ylim',[0 240]);
    set(gca,'xtick',[],'ytick',[]);
    title('position','fontsize',8);
    %set(h,'EraseMode','xor');
      
    subplot('position', [.57 .05 .39 .8])
    hold off
    if 0
        zPow = (powerData(j,:)-meanPowPerChan)./stdPowPerChan;
        zPowMap = Make2DPlotMat(zPow,chanMat,badChan);
        ImageScMask(zPowMap);
        %set(h,'EraseMode','xor');
    else
        if dbScale
            normPow = (powerData(j,:) - meanPowPerChan);
        else
            normPow = (powerData(j,:) ./ meanPowPerChan);
        end
        normPowMap = Make2DPlotMat(normPow,chanMat,badChan);
        ImageScMask(normPowMap);
        %set(h,'EraseMode','xor');
    end
    set(gca,'xtick',[],'ytick',[]);
    set(gca,'clim',[colorLimits]);
    colorbar;
    title('Normalized Theta Power','fontsize',8);
    hold on
    if plotAnatBool
        for k=1:size(anatCurves,1)
            plot(anatCurves{k,1},anatCurves{k,2},'color',[0.5,0.5,0.5],'linewidth',2);
            %set(h,'EraseMode','xor');
        end
    end
    %drawnow

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
                aviobj = avifile ( [fileBase 'ThetaPow.avi'], 'fps', round(whlSamp));
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



