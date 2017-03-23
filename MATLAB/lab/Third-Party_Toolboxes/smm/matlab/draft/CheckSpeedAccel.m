function CheckSpeedAccel(fileBase)
% function MakeHippPowMovie(fileBase,fileExt,nChannels,chanMat,badChan,lowCut,highCut,dbScale,zBool)

timeWindow = 1;
tracesBool = 1;
traceWinHeight = [-5000 5000];

whlSamp = 39.065;
pixelsPerCM = 20.58/11;

videoLimits = [368 240];

whlData = load([fileBase '.whl']);
mazeRegions = LoadMazeTrialTypes(fileBase, [1  1  1  1  1   1   1   1   1   1   1   1  0],[0  0  0  1  1  1   1   1   1]);
                                          % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP rp lp dp cp ca rca lca rra lra;
[speed, accel] = MazeSpeedAccel(whlData);


whlSamp = 39.0625; % samples/sec
eegSamp = 1250;

fig1 = figure(1);
%set(fig1,'DoubleBuffer','on');


[whlm,n]=size(whlData);


j = 2;
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
    subplot(3,2,1)
    if whlData(j,1) == -1
        plot(inf);
    else
        plot([0 1],[speed(j) speed(j)],'linewidth',7,'color',[1 0 0]);
    end
    title({'MazeSpeed'},'fontsize',8);
    set(gca,'fontsize',8,'xlim',[0 1],'xtick',[],'ylim',[0 max(speed)]);
    %set(h,'EraseMode','xor');

    subplot(3,2,2)
    if whlData(j,1) == -1
        plot(inf);
    else
        plot([0 1],[accel(j) accel(j)],'linewidth',7,'color',[1 0 0]);
    end
    title('MazeAccel','fontsize',8);
    set(gca,'fontsize',8,'xlim',[0 1],'xtick',[],'ylim',[min(accel) max(accel)]);
    %set(h,'EraseMode','xor');

    subplot(3,2,3)
    if whlData(j,1) == -1
        plot(inf);
    else
        speedCalc = sqrt((whlData(j+1,1)-whlData(j,1))^2 + (whlData(j+1,2)-whlData(j,2))^2)*whlSamp/pixelsPerCM;
        %fprintf('%i %i\n%i %i\n',whlData(j+1,1),whlData(j,1),whlData(j+1,2),whlData(j,2));
        plot([0 1],[speedCalc speedCalc],'linewidth',7,'color',[1 0 0]);
    end
    title({'CalcSpeed'},'fontsize',8);
    set(gca,'fontsize',8,'xlim',[0 1],'xtick',[],'ylim',[0 max(speed)]);
    %set(h,'EraseMode','xor');

    subplot(3,2,4)
    if whlData(j,1) == -1
        plot(inf);
    else
        previousSpeed = sqrt((whlData(j,1)-whlData(j-1,1))^2 + (whlData(j,2)-whlData(j-1,2))^2)*whlSamp/pixelsPerCM;
        accelCalc =  (speedCalc-previousSpeed)*whlSamp;
        plot([0 1],[accelCalc accelCalc],'linewidth',7,'color',[1 0 0]);
        fprintf('%i %i\n',speedCalc,previousSpeed);
    end
    title('CalcAccel','fontsize',8);
    set(gca,'fontsize',8,'xlim',[0 1],'xtick',[],'ylim',[min(accel) max(accel)]);
    %set(h,'EraseMode','xor');

    
    if movieBool & 0
        figure(1)
    end
    subplot(3,2,5:6)
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



