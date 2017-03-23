function MakeHippPowMovie4(fileBase,fileExt,nChannels,chanMat,badChan,lowCut,highCut,dbScale,zBool)
% function MakeHippPowMovie(fileBase,fileExt,nChannels,chanMat,badChan,lowCut,highCut,dbScale,zBool)

videoLimits = [368 240];

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

if ~exist([fileBase(1:6) '_AnatCurves.mat'],'file')
    fprintf('No Anat Overlay File found: %s\n',[fileBase(1:6) '_AnatCurves.mat']);
    plotAnatBool = 0;
else
    load([fileBase(1:6) '_AnatCurves.mat']);
    plotAnatBool = 1;
end

whlSamp = 39.0625; % samples/sec

meanPowPerChan = mean(powerData(find(mazeRegions(:,1)~=-1),:),1);
stdPowPerChan = std(powerData(find(mazeRegions(:,1)~=-1),:),1);
stdPowPerChanMap = Make2DPlotMat(stdPowPerChan,chanMat);
badChanMask = ~isnan(Make2DPlotMat(ones(size(stdPowPerChan)),chanMat,badChan));

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
ImageScMask(stdPowPerChanMap,badChanMask);
%colorbar;
fig1 = figure(1);
%set(fig1,'DoubleBuffer','on');


[whlm,n]=size(whlData);

% Plot positions
speedPlotPos = [.07 .12 .04 .69];
accelPlotPos = [.16 .12 .04 .69];
mazePlotPos = [.23 .12 .31 .69];
powerPlotPos = [.57 .12 .39 .69];

j = 1;
movieBool = 0;
step=ceil(whlSamp/2);
while j<whlm

    timeMin = floor(j/whlSamp/60);
    timeSec = floor(j/whlSamp-timeMin*60);
    timeCsec = floor(100*(j/whlSamp-timeSec-timeMin*60));
    if timeSec >= 10
        secPlaceHolder = '';
    else
        secPlaceHolder = '0';
    end
    if timeCsec >= 10
        cSecPlaceHolder = '';
    else
        cSecPlaceHolder = '0';
    end


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
    xlabel(['Time: ' num2str(timeMin) ':' secPlaceHolder num2str(timeSec,2) '.' cSecPlaceHolder num2str(timeCsec,2)],'fontsize',8);

    %set(h,'EraseMode','xor');
      
    subplot('position', powerPlotPos)
    hold off
    if zBool
        zPow = (powerData(j,:)-meanPowPerChan)./stdPowPerChan;
        zPowMap = Make2DPlotMat(zPow,chanMat);
        badChanMask = ~isnan(Make2DPlotMat(ones(size(zPow)),chanMat,badChan));
        ImageScMask(zPowMap,badChanMask,colorLimits);
        %set(h,'EraseMode','xor');
    else
        if dbScale
            normPow = (powerData(j,:) - meanPowPerChan);
        else
            normPow = (powerData(j,:) ./ meanPowPerChan);
        end
        normPowMap = Make2DPlotMat(normPow,chanMat);
        badChanMask = ~isnan(Make2DPlotMat(ones(size(normPow)),chanMat,badChan));
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
        PlotAnatCurves([fileBase(1:6) '_AnatCurves.mat'],[size(chanMat,1)+.5 size(chanMat,2)+.5],[0 0],[0.5,0.5,0.5],2)
       %for k=1:size(anatCurves,1)
        %   plot(anatCurves{k,1}.*(size(chanMat,2)+0.5),anatCurves{k,2}.*(size(chanMat,1)+0.5),'color',[0.5,0.5,0.5],'linewidth',2);
            %set(h,'EraseMode','xor');
        %end
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



