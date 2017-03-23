function CalcAnatMazeRegionSpeedPow5(taskType,fileBaseMat,fileNameFormat,fileExt,nchannels,winLength,thetaFreqRange,thetaNW,gammaFreqRange,gammaNW,saveBool,plotbool,trialtypesbool)
% function  CalcAnatMazeRegionPow(taskType,fileBaseMat,fileNameFormat,fileExt,nchannels,lowCut,highCut,onePointBool,saveBool,plotbool,trialtypesbool)

if ~exist('trialtypesbool','var')  | isempty(trialtypesbool)
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp
end

% [1 0 1 0 0 0 0 0 0 0 0 0 0]
% [0 0 0 1 1 1 1 1 1]

if ~exist('plotbool','var')
    plotbool = 1;
end
if ~exist('saveBool','var')
    saveBool = 0;
end
if ~exist('onePointBool','var')
    onePointBool = 0;
end
plotChan = 35;
bps = 2; % bytes per sample
eegSamp = 1250;
whlSamp = 39.065;
whlWinLength = winLength/eegSamp*whlSamp;
hanFilter = hanning(floor(whlWinLength));


plotFig = 0;

measurements = struct('speed',[],'accel',[],'thetaPowPeak',[],'thetaPowIntg',[],'gammaPowPeak',[],'gammaPowIntg',[],'thetaNWYo',[],'gammaNWYo',[]);

trialNum = 0;

trialMidRegionsStruct = CalcFileMidPoints(taskType,fileBaseMat,plotFig,trialtypesbool);
mazeMeasStruct = [];

numfiles = size(fileBaseMat,1);
for file=1:numfiles
    eegName = [fileBaseMat(file,:) '.eeg'];
    whlDat = load([fileBaseMat(file,:) '.whl']);
    [speed accel] = MazeSpeedAccel(whlDat);
    
    if isempty(getfield(trialMidRegionsStruct,fileBaseMat(file,:)));
        fprintf('File %s has no specified trials...\n',fileBaseMat(file,:));
    else
        mazeRegionNames = fieldnames(getfield(trialMidRegionsStruct,fileBaseMat(file,:)));

        for trial=1:length(getfield(trialMidRegionsStruct,fileBaseMat(file,:),mazeRegionNames{1})) % assumes same number of trials in each maze region

            trialNum = trialNum + 1;
            for k=1:size(mazeRegionNames,1) % get all the (spatial) mid-points for this trial
                trialMidPoints(k) = getfield(trialMidRegionsStruct,fileBaseMat(file,:),mazeRegionNames{k},{trial});
            end

            plotColors = [0 0 1;1 0 0;0 0 0;0 1 1];
            figure(1);
            clf
            hold on;
            for k=1:size(mazeRegionNames,1)
                plot(whlDat(round(trialMidPoints(k)-whlWinLength/2+1):round(trialMidPoints(k)+whlWinLength/2),1),...
                    whlDat(round(trialMidPoints(k)-whlWinLength/2+1):round(trialMidPoints(k)+whlWinLength/2),2),'o','color',plotColors(k,:),'markersize',5);
                plot(whlDat(trialMidPoints(k),1),whlDat(trialMidPoints(k),2),'.','color',[0 1 0],'markersize',20);
            end

            if plotbool
                figure(2)
                clf
            end

            %if size(trialMidPoints,1) == size(mazeRegionNames,1)
            for k=1:size(mazeRegionNames,1)
                for m=interval(1):timeStep:interval(2)
                    whlTime = trialMidPoints(k) + m*whlSamp;
                    %%%%%% speed & accel %%%%%%%
                    speedSeg = speed(round(whlTime-whlWinLength/2+1):round(whlTime-whlWinLength/2)+size(hanFilter,1));
                    accelSeg = accel(round(whlTime-whlWinLength/2+1):round(whlTime-whlWinLength/2)+size(hanFilter,1));

                    indexes = speedSeg >= 0;
                    normHanFilter = hanFilter./mean(hanFilter(indexes)); % normalize the hanning filter
                    
                    if isempty(find(indexes>0))

                        fprintf('error_speed_cant_be_reliably_measured');
                        keyboard
                    else
                        speedSeg = normHanFilter.*speedSeg;
                        accelSeg = normHanFilter.*accelSeg;
                        
                        mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'trialMidPoints',{trialNum},trialMidPoints(k));
                        mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'speeds',['n' num2str(abs(m))],{trialNum},mean(speedSeg(indexes)));
                        mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'accels',['n' num2str(abs(m))],{trialNum},mean(accelSeg(indexes)));

                        %speedPowStruct = setfield(speedPowStruct,mazeRegionNames{k},'speed',{nPoints + 1,1}, mean(speedSeg(indexes)));
                        %returnArmSpeed = mean(speedSeg(indexes));
                        %whlSpeedSeg(indexes)
                    end
                end

                eegPos = round(trialMidPoints(k)/whlSamp*eegSamp-winLength/2);
                %%%% for theta %%%%
                [yo, fo] = mtpsd_sm(bload(eegName,[nchannels winLength],eegPos*nchannels*bps,'int16'),winLength*2,eegSamp,winLength,0,thetaNW);
                mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'thetaNWYo',{trialNum,1:length(fo),1:nchannels},yo);
                powPeak = 10.*log10(max(yo(find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),:)));
                powIntg = 10.*log10(sum(yo(find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),:)));
                mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'thetaPowPeak',{trialNum,1:nchannels},powPeak);
                mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'thetaPowIntg',{trialNum,1:nchannels},powIntg);
                %mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'power',{nPoints + 1,1:nchannels}, power);
                if plotbool
                    subplot(2,4,k)
                    hold on
                    plot([0 100],[powPeak(plotChan) powPeak(plotChan)],'--r');
                    plot([0 100],[powIntg(plotChan) powIntg(plotChan)]-7,'--g');
                    plot(fo(find(fo<=100)),10.*log10(yo(find(fo<=100),plotChan)))
                    plot([thetaFreqRange(1) thetaFreqRange(1)],[40 80],':k')
                    plot([thetaFreqRange(2) thetaFreqRange(2)],[40 80],':k')
                    set(gca,'ylim',[40 80]);
                    title(mazeRegionNames{k});
                    if k==1
                        ylabel('theta');
                    end
                end

                %%%%% for gamma %%%%%%
                [yo, fo] = mtpsd_sm(bload(eegName,[nchannels winLength],eegPos*nchannels*bps,'int16'),winLength*2,eegSamp,winLength,0,gammaNW);
                mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'gammaNWYo',{trialNum,1:length(fo),1:nchannels},yo);
                powPeak = 10.*log10(max(yo(find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),:)));
                powIntg = 10.*log10(sum(yo(find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),:)));
                mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'gammaPowPeak',{trialNum,1:nchannels},powPeak);
                mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'gammaPowIntg',{trialNum,1:nchannels},powIntg);
                if plotbool
                    subplot(2,4,k+4)
                    hold on
                    plot([0 100],[powPeak(plotChan) powPeak(plotChan)],'--r');
                    plot([0 100],[powIntg(plotChan) powIntg(plotChan)]-12,'--g');
                    plot(fo(find(fo<=100)),10.*log10(yo(find(fo<=100),plotChan)))
                    plot([gammaFreqRange(1) gammaFreqRange(1)],[40 80],':k')
                    plot([gammaFreqRange(2) gammaFreqRange(2)],[40 80],':k')
                    %plot([0 100],[power(plotChan) power(plotChan)],'r');
                    %plot(fo(find(fo<=100)),10.*log10(max(yo(find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),plotChan))),'g');
                    set(gca,'ylim',[40 80]);
                    if k==1
                        legend('peak','intg')
                        ylabel('gamma');
                    end
                    xlabel(['speed: ' num2str(getfield(mazeMeasStruct,mazeRegionNames{k},'speed',{trialNum}),3)...
                        ', accel: ' num2str(getfield(mazeMeasStruct,mazeRegionNames{k},'accel',{trialNum}),3)]);
                end
                %end
            end

        end
    end
end
keyboard

%addpath /u12/smm/matlab/draft
%PlotSpeedPow
if saveBool

    if fileNameFormat == 1,
        outname1 = [taskType '_' fileBaseMat(1,1:8) '-' fileBaseMat(end,1:8) ];
    end
    if fileNameFormat == 2,
        outname1 = [taskType '_' fileBaseMat(1,[1:10]) '-' fileBaseMat(end,[8:10]) ];
    end
    if fileNameFormat == 0,
        outname1 = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19])];
    end
    outname2 = [fileExt '_Win' num2str(winLength) '_thetaF' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) ...
        'NW' num2str(thetaNW) '_gammaF' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'NW' num2str(gammaNW) ...
        '_MazeRegionsSpeedPow.mat'];
    outname = [outname1 outname2];
    fprintf('Saving %s\n', outname);
    matlabVersion = version;
    if str2num(matlabVersion(1)) > 6
        save(outname,'-v6','winLength','thetaFreqRange','thetaNW','gammaFreqRange','gammaNW','fo','mazeMeasStruct');

    else
        save(outname,'winLength','thetaFreqRange','thetaNW','gammaFreqRange','gammaNW','fo','mazeMeasStruct');
    end
end

%save('alter-test3_sm9603m211s254-m244s290.eeg_Win626_thetaNW2_gammaNW4_MazeMeasStruct.mat',...
 %   'winLength','thetaFreqRange','thetaNW','gammaFreqRange','gammaNW','fo','mazeMeasStruct');
return



figure(4)
clf
chans = [33;37;39;42;59;62];
for i=1:length(chans)
    subplot(length(chans),1,i)
    plotChan = chans(i);
    hold on
    colors = [0 0 1;1 0 0;0 1 0;0.5 0.5 0.5];
    allRegionsPow = [];
    allRegionsSpeed = [];
    nPoints = length(mazeMeasStruct);
    for k=1:size(mazeRegionNames,1)
        for ii=1:nPoints
            plot(getfield(mazeMeasStruct(ii),mazeRegionNames{k},'speed'),getfield(mazeMeasStruct(ii),mazeRegionNames{k},'thetaPowPeak',{plotChan}),'.','color',colors(k,:));
            %         [p s] = polyfit(getfield(speedPowStruct,mazeRegionNames{k},'speed',{1:nPoints,1}),getfield(speedPowStruct,mazeRegionNames{k},'power',{1:nPoints,plotChan}),1);
            %    endPoints = [min(getfield(speedPowStruct,mazeRegionNames{k},'speed')) max(getfield(speedPowStruct,mazeRegionNames{k},'speed'))];
            %         plot(endPoints,p(1).*endPoints+p(2),'k')
            set(gca,'xlim',[35 130]);
            %set(gca,'ylim',[68,84],'xlim',[35 130]);

            title(['channel: ' num2str(plotChan)]);
            allRegionsPow = [allRegionsPow; getfield(mazeMeasStruct(ii),mazeRegionNames{k},'thetaPowPeak',{plotChan})];
            allRegionsSpeed = [allRegionsSpeed; getfield(mazeMeasStruct(ii),mazeRegionNames{k},'speed')];
        end
    end
    %[p s] = polyfit(allRegionsSpeed,allRegionsPow,1);
    %plot([35 130],p(1).*[35 130]+p(2),'k','linewidth',2)
    [b,bint,r,rint,stats] = regress(allRegionsPow, [ones(size(allRegionsSpeed)) allRegionsSpeed], 0.01);
    plot([35 130],b(2).*[35 130]+b(1),'k','linewidth',2);
    fprintf('\nchan:%i, r2=%1.4f %1.20f',plotChan,stats(1),stats(3));
end

keyboard
fprintf('total n=%d : ',ntrials);
if saveBool
    
    if fileNameFormat == 1,
            outname = [taskType '_' fileBaseMat(1,1:8)  ...
                '-' fileBaseMat(end,1:8) ...
                fileExt '_' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz_Win' num2str(winLength) '_NW' num2str(NW) '_MazeRegionsSpeedPow.mat'];
    end
    if fileNameFormat == 2,
        outname = [taskType '_' fileBaseMat(1,[1:10]) '-' fileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz_Win' num2str(winLength) '_NW' num2str(NW) '_MazeRegionsSpeedPow.mat'];
 
     end
    if fileNameFormat == 0,
        outname = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19]) ...
            fileExt '_' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz_Win' num2str(winLength) '_NW' num2str(NW) '_MazeRegionsSpeedPow.mat'];
     end
    fprintf('Saving %s\n', outname);
    matlabVersion = version;
    if str2num(matlabVersion(1)) > 6
        save(outname,'-V6','speedPowStruct');
    else
        save(outname,'speedPowStruct');
    end
end


plotChan = 41;
speed = [];
power = [];
group = [];
mazeRegionNames = fieldnames(speedPowStruct);
nPoints = size(speedPowStruct.returnArm.speed,1);
for k=1:2
speed = [speed; getfield(speedPowStruct,mazeRegionNames{k},'speed',{1:nPoints,1})];
power = [power; getfield(speedPowStruct,mazeRegionNames{k},'power',{1:nPoints,plotChan})];
group = [group; k*ones(size(getfield(speedPowStruct,mazeRegionNames{k},'speed',{1:nPoints,1})))];
end
aoctool(speed,power,group,0.05,'Speed','Log10(Power)');
