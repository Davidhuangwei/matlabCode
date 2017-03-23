% function MakeHippPowMovieGood10(fileBase,fileExt,depVarTitle,lowCut,highCut,varargin)
% [dbScale,zBool,compression,quality,movieNameExt]  = DefaultArgs(varargin,{1,1,'Indeo3',100,[]});
function MakeHippCohMovieGood10(fileBase,fileExt,depVarTitle,win,ave,ref,lowCut,highCut,varargin)
[compression,quality,movieNameExt]  = DefaultArgs(varargin,{'Indeo3',100,[]});
%IV50
%videoLimits = [368 240];
xPlotPad = 10;
yPlotPad = 15;


nChannels = load(['ChanInfo/NChan' fileExt '.txt']);
chanMat = LoadVar(['ChanInfo/ChanMat' fileExt '.mat']);
badChan = load(['ChanInfo/BadChan' fileExt '.txt']);
offset = load(['ChanInfo/Offset' fileExt '.txt']);
if ~exist(['ChanInfo/' 'AnatCurves.mat'],'file')
    fprintf('No Anat Overlay File found: %s\n',['ChanInfo/' 'AnatCurves.mat']);
    plotAnatBool = 0;
else
    anatCurvesFile = [pwd '/ChanInfo/' 'AnatCurves.mat'];
    plotAnatBool = 1;
end

figSize = [640 340];
whlSamp = 39.0625; % samples/sec

yPlotBorder = [.07 .81];
yPlotBuff = (yPlotBorder(2)-yPlotBorder(2)*(size(chanMat,1)/(size(chanMat,1)+offset(1)*2)))/2;
mazePlotPos = [.02 yPlotBorder(1) .42 yPlotBorder(2)];
powerPlotPos = [.46 yPlotBorder(1)+yPlotBuff .49 yPlotBorder(2)-yPlotBuff*2];

[refChanY refChanX] = find(chanMat==ref);

cwd = pwd;
cd(fileBase)
whlData = load([fileBase '.whl']);
plotWhlData = ReflectCart(RotateCart(whlData(:,1:2),pi/2,[0 0]),pi/2,[0 0]);
plotWhlData(whlData(:,1)<0,1:2) = NaN;
% whlData(whlData(:,1)~=-1,1:2) = [whlDataRotRef(whlData(:,1)~=-1,1)+videoLimits(2),...
%          whlDataRotRef(whlData(:,1)~=-1,2)+videoLimits(1)];
videoXLim = [min(plotWhlData(:,1)) max(plotWhlData(:,1))];
videoYLim = [min(plotWhlData(:,2)) max(plotWhlData(:,2))];
% whlData2 = whlDataRotRef;
% videoLimits2 = ReflectCart(RotateCart(videoLimits(:,1:2),pi/2,[0 0]),pi/2,[0 0]);
% set(gca,'xlim',[0 videoLimits2(1)]);
% set(gca,'ylim',[0 videoLimits2(2)]);

% test = ReflectCart(RotateCart(videoLimits(:,1:2),pi/2,[0 0]),pi/2,[0 0]);

dsPowName = [fileBase '_' num2str(lowCut) '-' num2str(highCut) ...
    'Hz_Win' num2str(win) '_Ave' num2str(ave) fileExt '_ref' num2str(ref) '.10000coh'];
powerData = ATanCoh(bload(dsPowName,[nChannels inf],0,'int16')'/10000);

mazeRegions = LoadMazeTrialTypes(fileBase, [1  1  1  1  1   1   1   1   1   1   1   1  0],[0  0  0  1  1  1   1   1   1]);
                                          % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP rp lp dp cp ca rca lca rra lra;
[speed, accel] = MazeSpeedAccel(whlData);
cd(cwd)

meanPowPerChan = mean(powerData(find(mazeRegions(:,1)~=-1),:),1);
%stdPowPerChan = std(powerData(find(mazeRegions(:,1)~=-1),:),1);
meanPowPerChanMap = Make2DPlotMat(meanPowPerChan,chanMat,badChan,'linear');
badChanMask = [];% ~isnan(Make2DPlotMat(ones(size(stdPowPerChan)),chanMat,badChan));
%badChanMask = ~isnan(Make2DPlotMat(ones(size(stdPowPerChan)),chanMat,badChan));

% if zBool
    colorLimits = [-.07 .07];
% else
%     if dbScale
%         colorLimits = [-4 4];
%     else
%         colorLimits = [-.01 2.01];
%     end
% end

%load('ColorMapSean3.mat')
%ColorMapSean3(1,:) = [.75 .75 .75];
%colormap(ColorMapSean3);
figure(2)
clf
imagesc(UnATanCoh(meanPowPerChanMap));
%ImageScMask(stdPowPerChanMap,badChanMask);
%imagesc(meanPowPerChanMap)
set(gca,'clim',[0.5 1])
colorbar;
fig1 = figure(1);
clf
set(gcf,'units','pixels')
currPos = get(gcf,'position');
set(gcf, 'Position', [currPos(1:2) figSize]);
set(gcf, 'PaperPosition', [currPos(1:2) figSize]);
%set(fig1,'DoubleBuffer','on');


[whlm,n]=size(whlData);

% Plot positions
%speedPlotPos = [.07 .12 .04 .69];
%accelPlotPos = [.16 .12 .04 .69];
%mazePlotPos = [.23 .12 .31 .69];
%powerPlotPos = [.57 .12 .39 .69];

rateFactor = 0.25;
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
%     subplot('position', speedPlotPos)
%     if whlData(j,1) == -1
%         plot(inf);
%     else
%         plot([0 1],[speed(j) speed(j)],'linewidth',7,'color',[1 0 0]);
%     end
%     title({'Speed'},'fontsize',8);
%     ylabel('cm/sec')
%     set(gca,'fontsize',8,'xlim',[0 1],'xtick',[],'ylim',[0 max(speed)]);
%     %set(h,'EraseMode','xor');
% 
%     subplot('position', accelPlotPos)
%     if whlData(j,1) == -1
%         plot(inf);
%     else
%         plot([0 1],[accel(j) accel(j)],'linewidth',7,'color',[1 0 0]);
%     end
%     title('Accel','fontsize',8);
%     set(gca,'fontsize',8,'xlim',[0 1],'xtick',[],'ylim',[min(accel) max(accel)]);
%     %set(h,'EraseMode','xor');
% 
    if movieBool & 0
        figure(1)
    end
    subplot('position', mazePlotPos)
    hold off;
    plot(plotWhlData(:,1),plotWhlData(:,2),'.','color',[0.5 0.5 0.5]);

    %plot(whlData(:,1),videoLimits(2)-whlData(:,2),'.','color',[0.5 0.5 0.5]);
    %set(h,'EraseMode','xor');
    hold on;
    plot(plotWhlData(j,1),plotWhlData(j,2),'.r','markersize',60);
    %plot(whlData(j,1),videoLimits(2)-whlData(j,2),'.r','markersize',60);
    set(gca,'xlim',videoXLim+[-xPlotPad xPlotPad]);set(gca,'Ylim',videoYLim+[-yPlotPad yPlotPad])
    %set(gca,'xlim',[xLimAdj videoLimits(1)-xLimAdj],'ylim',[0 videoLimits(2)]);
    set(gca,'xtick',[],'ytick',[])
    title({'Position'},'fontsize',8);
    if rateFactor == 1
        xlabel(['Time: ' num2str(timeMin) ':' secPlaceHolder num2str(timeSec,2) '.' cSecPlaceHolder num2str(timeCsec,2)],'fontsize',8);
    else
        xlabel(['Time: ' num2str(timeMin) ':' secPlaceHolder num2str(timeSec,2) '.' cSecPlaceHolder num2str(timeCsec,2),...
            '  (playback rate ' num2str(rateFactor) 'x)'], 'fontsize',8);
    end
    %set(h,'EraseMode','xor');
    
    subplot('position', powerPlotPos)
    hold off
    colormap(LoadVar('ColorMapSean6'));
%     if zBool
%         zPow = (powerData(j,:)-meanPowPerChan)./stdPowPerChan;
%         zPowMap = Make2DPlotMat(zPow,chanMat,badChan,'linear');
%         badChanMask = [];%~isnan(Make2DPlotMat(ones(size(zPow)),chanMat,badChan));
%        % badChanMask = ~isnan(Make2DPlotMat(ones(size(zPow)),chanMat,badChan));
%         %ImageScMask(zPowMap,badChanMask,colorLimits);
%         imagesc(zPowMap);
%         set(gca,'clim',colorLimits);
%         colorbar
%         %set(h,'EraseMode','xor');
%     else
%         if dbScale
            normPow = UnAtanCoh(powerData(j,:)) - UnAtanCoh(meanPowPerChan);
%         else
%             normPow = (powerData(j,:) ./ meanPowPerChan);
%         end
        normPowMap = Make2DPlotMat(normPow,chanMat,badChan,'linear');
        badChanMask = [];%~isnan(Make2DPlotMat(ones(size(normPow)),chanMat,badChan));
        %badChanMask = ~isnan(Make2DPlotMat(ones(size(normPow)),chanMat,badChan));
        imagesc(normPowMap);
        set(gca,'clim',colorLimits);
        colorH = colorbar;
        set(colorH,'ytick',[colorLimits(1) 0 colorLimits(2)])
        %set(h,'EraseMode','xor');
%     end
    set(gca,'xtick',[],'ytick',[]);
    
    %set(gca,'clim',[colorLimits]);
    %colorbar;
    title({'Normalized', [depVarTitle ' Coherence']},'fontsize',8);
%     if dbScale
%         title({'Normalized', [depVarTitle ' Power (DB)']},'fontsize',8);
%     end
%     if zBool
%         title({[depVarTitle ' Power'], '(Z-Score)'},'fontsize',8);
%     end
    hold on
    if plotAnatBool
        PlotAnatCurves(anatCurvesFile,size(chanMat)+offset*2,0.5-offset,[],3)
       %for k=1:size(anatCurves,1)
        %   plot(anatCurves{k,1}.*(size(chanMat,2)+0.5),anatCurves{k,2}.*(size(chanMat,1)+0.5),'color',[0.5,0.5,0.5],'linewidth',2);
            %set(h,'EraseMode','xor');
        %end
    end
       hold on
        plot(refChanX,refChanY,'.','markersize',45,'color','w')
        plot(refChanX,refChanY,'o','markersize',14,'color','k')
     %drawnow

    if movieBool == 0
        i = input('how far to step (in seconds)?');

        if isempty(i)
            j = j+step;
        else
            if i == 'm'
                i = input('How long shall the movie be (in seconds)? [rest of file] ');
                rateFactor = input('Enter sampling rate factor? [1] ');
                if isempty(rateFactor)
                    rateFactor = 1;
                end
                if isempty(i)
                    movieLength = inf;
                else
                    movieLength = round(i*whlSamp);
                end
                step = ceil(.00001*whlSamp);
                movieBool = 1;
                start = j;
                fprintf('\nCapturing Movie... \nFrame:');
%                 if dbScale
%                     movieNameExt = [movieNameExt '_DB'];
%                 end
%                 if zBool
%                     movieNameExt = [movieNameExt '_z-score'];
%                 end
                %%% mpgwrite %%%
%                 winSize = get(fig1,'Position');
%                 winSize(1:2) = [0 0];
%                 movieMat=moviein(movieLength,fig1,winSize);

                aviobj = avifile( [fileBase fileExt '_' depVarTitle 'Coh_' ...
                    'Win' num2str(win) '_Ave' num2str(ave)...
                    '_' compression '_' num2str(quality) '_' movieNameExt '.avi'],...
                    'fps', round(whlSamp*rateFactor),'compression',compression,'quality',quality);
            else
                step = ceil(i*whlSamp);
                j = j+step;
            end
        end
    else
        %frame = getframe( fig1 );
        %movieMat(j) = frame;
        aviobj = addframe( aviobj, fig1 );
        fprintf('%i,',j-start);
        if j == start+movieLength
            movieBool = 0;
                %%% mpgwrite %%%
%             addpath /u12/smm/matlab/mpgwrite/
%             mpgOptions = [1, 2, 2, 1, 0, 1, 1, 1];
%             mpgwrite(movieMat, jet, [fileBase fileExt '_' depVarTitle 'Pow_' movieNameExt '.mpg'], mpgOptions);
%            
            aviobj = close ( aviobj );
        else
            j = j+step;
        end
    end
end
if movieBool
    aviobj = close ( aviobj );
end


