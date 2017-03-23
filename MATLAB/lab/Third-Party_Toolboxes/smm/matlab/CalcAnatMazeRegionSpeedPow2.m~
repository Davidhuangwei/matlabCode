function CalcAnatMazeRegionSpeedPow2(taskType,fileBaseMat,fileNameFormat,fileExt,nchannels,freqRange,winLength,NW,peakPowBool,saveBool,plotbool,trialtypesbool)
% function [returnArmPowMat, centerArmPowMat, TjunctionPowMat, goalArmPowMat] = CalcAnatMazeRegionPow(taskType,fileBaseMat,fileNameFormat,fileExt,nchannels,lowCut,highCut,onePointBool,saveBool,plotbool,trialtypesbool)

if ~exist('trialtypesbool','var')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp
end
if ~exist('mazelocationsbool','var')
    mazelocationsbool = [0  0  0  1  1  1   1   1   1];
                       %rp lp dp cp ca rca lca rra lra
end
% [1 0 1 0 0 0 0 0 0 0 0 0 0]
% [0 0 0 1 1 1 1 1 1]

if ~exist('plotbool','var')
    plotbool = 0;
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
hanFilter = hanFilter./mean(hanFilter);


[numfiles n] = size(fileBaseMat);
ntrials=0;


speedPowStruct = struct('returnArm',struct('speed',[],'power',[]),'centerArm',struct('speed',[],'power',[]), ...
    'Tjunction',struct('speed',[],'power',[]),'goalArm',struct('speed',[],'power',[]));


for i=1:numfiles
    
    eegName = [fileBaseMat(i,:) '.eeg'];
    
    allMazeRegions = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 1 1 1 1 1 1]);
    [speed accel] = MazeSpeedAccel(allMazeRegions);
    [whlm n] = size(allMazeRegions);
    
    
    atports = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[1 1 0 0 0 0 0 0 0]);
    
    choicepoint = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 1 0 0 0 0 0]);
    centerarm   = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 1 0 0 0 0]);
    goalarm   = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 1 1 0 0]);
    returnarm   = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 0 0 1 1]);
    
    %plot(allMazeRegions(:,1),allMazeRegions(:,2))
    trialbegin = find(allMazeRegions(:,1)~=-1);
    while ~isempty(trialbegin),
        trialend = trialbegin(1) + find(atports((trialbegin(1)+1):end,1)~=-1);
        if isempty(trialend),
            breaking = 1
            break;
        end

        trialreturnarm = trialbegin(1)-1+find(returnarm(trialbegin(1):(trialend(1)-1),1)~=-1);
        trialcenterarm = trialbegin(1)-1+find(centerarm(trialbegin(1):(trialend(1)-1),1)~=-1);
        trialchoicepoint = trialbegin(1)-1+find(choicepoint(trialbegin(1):(trialend(1)-1),1)~=-1);
        trialgoalarm = trialbegin(1)-1+find(goalarm(trialbegin(1):(trialend(1)-1),1)~=-1);

        trialbegin = trialend(1)-1+find(allMazeRegions(trialend(1):end,1)~=-1);

        if ~isempty(trialreturnarm) & ~isempty(trialcenterarm) & ~isempty(trialchoicepoint) & ~isempty(trialgoalarm)
            if plotbool
                figure(3)
                clf
                hold on
                plot(returnarm(trialreturnarm,1),returnarm(trialreturnarm,2),'.','color',[0 0 1],'markersize',7);
                plot(centerarm(trialcenterarm,1),centerarm(trialcenterarm,2),'.','color',[1 0 0],'markersize',7);
                plot(choicepoint(trialchoicepoint,1),choicepoint(trialchoicepoint,2),'.','color',[0 0 0],'markersize',7);
                plot(goalarm(trialgoalarm,1),goalarm(trialgoalarm,2),'.','color',[0 1 1],'markersize',7);
                set(gca,'xlim',[0 368],'ylim',[0 240]);
            end
            if 1
                returnArmMidPointDist = (returnarm(trialreturnarm,1) - mean([max(returnarm(trialreturnarm,1)) min(returnarm(trialreturnarm,1))])).^2 + ...
                    (returnarm(trialreturnarm,2) - mean([max(returnarm(trialreturnarm,2)) min(returnarm(trialreturnarm,2))])).^2;
                returnArmMidPoint = find(returnArmMidPointDist == min(returnArmMidPointDist));
                centerArmMidX = min(centerarm(trialcenterarm,1)) + (max(centerarm(trialcenterarm,1)) - min(centerarm(trialcenterarm,1)))*1/2;
                centerArmMidIndex = find(abs(centerarm(trialcenterarm,1) - centerArmMidX) == min(abs(centerarm(trialcenterarm,1) - centerArmMidX)));
                centerArmMidPoint = centerArmMidIndex(1);
            end
            if 0
                returnArmMidX = min(returnarm(trialreturnarm,1)) + (max(returnarm(trialreturnarm,1)) - min(returnarm(trialreturnarm,1)))/2;
                returnArmMidIndex = find(abs(returnarm(trialreturnarm,1) - returnArmMidX) == min(abs(returnarm(trialreturnarm,1) - returnArmMidX)));
                returnArmMidPoint = returnArmMidIndex(1);

                centerArmMidX = min(centerarm(trialcenterarm,1)) + (max(centerarm(trialcenterarm,1)) - min(centerarm(trialcenterarm,1)))*2/3;
                centerArmMidIndex = find(abs(centerarm(trialcenterarm,1) - centerArmMidX) == min(abs(centerarm(trialcenterarm,1) - centerArmMidX)));
                centerArmMidPoint = centerArmMidIndex(1);
            end
            if 0
                returnArmMidPointDist = (returnarm(trialreturnarm,1) - mean([max(returnarm(trialreturnarm,1)) min(returnarm(trialreturnarm,1))])).^2 + ...
                    (returnarm(trialreturnarm,2) - mean([max(returnarm(trialreturnarm,2)) min(returnarm(trialreturnarm,2))])).^2;
                returnArmMidPoint = find(returnArmMidPointDist == min(returnArmMidPointDist));

                centerArmMidPointDist = (centerarm(trialcenterarm,1) - mean([max(centerarm(trialcenterarm,1)) min(centerarm(trialcenterarm,1))])).^2 + ...
                    (centerarm(trialcenterarm,2) - mean([max(centerarm(trialcenterarm,2)) min(centerarm(trialcenterarm,2))])).^2;
                centerArmMidPoint = find(centerArmMidPointDist == min(centerArmMidPointDist));

            end
            choicePointMidPointDist = (choicepoint(trialchoicepoint,1) - mean([max(choicepoint(trialchoicepoint,1)) min(choicepoint(trialchoicepoint,1))])).^2 + ...
                (choicepoint(trialchoicepoint,2) - mean([max(choicepoint(trialchoicepoint,2)) min(choicepoint(trialchoicepoint,2))])).^2;
            choicePointMidPoint = find(choicePointMidPointDist == min(choicePointMidPointDist));

            choiceArmMidPointDist = (goalarm(trialgoalarm,1) - mean([max(goalarm(trialgoalarm,1)) min(goalarm(trialgoalarm,1))])).^2 + ...
                (goalarm(trialgoalarm,2) - mean([max(goalarm(trialgoalarm,2)) min(goalarm(trialgoalarm,2))])).^2;
            choiceArmMidPoint = find(choiceArmMidPointDist == min(choiceArmMidPointDist));

            if plotbool
                plot(returnarm(trialreturnarm(returnArmMidPoint(1)),1),returnarm(trialreturnarm(returnArmMidPoint(1)),2),'.','color',[0 1 0],'markersize',20);
                plot(choicepoint(trialchoicepoint(choicePointMidPoint(1)),1),choicepoint(trialchoicepoint(choicePointMidPoint(1)),2),'.','color',[0 1 0],'markersize',20);
                plot(centerarm(trialcenterarm(centerArmMidPoint(1)),1),centerarm(trialcenterarm(centerArmMidPoint(1)),2),'.','color',[0 1 0],'markersize',20);
                plot(goalarm(trialgoalarm(choiceArmMidPoint(1)),1),goalarm(trialgoalarm(choiceArmMidPoint(1)),2),'.','color',[0 1 0],'markersize',20);

                %plot(returnarm(round(mean(trialreturnarm)),1),returnarm(round(mean(trialreturnarm)),2),'.','color',[0 1 0],'markersize',7);
                %plot(centerarm(round(mean(trialcenterarm)),1),centerarm(round(mean(trialcenterarm)),2),'.','color',[0 1 0],'markersize',7);
                %plot(choicepoint(round(mean(trialchoicepoint)),1),choicepoint(round(mean(trialchoicepoint)),2),'.','color',[0 1 0],'markersize',7);
                %plot(goalarm(round(mean(trialgoalarm)),1),goalarm(round(mean(trialgoalarm)),2),'.','color',[0 1 0],'markersize',7);
            end
        else
            fprintf('\nSkipping trial because of bad indexing!\n')
            keyboard
        end
        ntrials = ntrials + 1;
        
        j = 's';
        if ~plotbool
            fprintf('n=%d : ',ntrials);
            j = 0;
            while ~strcmp(j,'s') & ~strcmp(j,'d')
                j = input('Save (s) or delete (d)? ','s');
            end
        end
        if strcmp(j,'s')
            midPoints = [trialreturnarm(returnArmMidPoint(1)); trialcenterarm(centerArmMidPoint(1)); ...
                trialchoicepoint(choicePointMidPoint(1)); trialgoalarm(choiceArmMidPoint(1))];
            
            mazeRegionNames = fieldnames(speedPowStruct);
            nPoints = size(getfield(speedPowStruct,mazeRegionNames{1},'speed'),1);
            
            if plotbool
                figure(2)
                clf
            end
           
            if size(midPoints,1) == size(mazeRegionNames,1)
                for k=1:size(mazeRegionNames,1)
                    eegPos = round(midPoints(k)/whlSamp*eegSamp-winLength/2);
                    [yo, fo] = mtpsd_sm(bload(eegName,[nchannels winLength],eegPos*nchannels*bps,'int16'),winLength*2,eegSamp,winLength,0,NW);
                    if peakPowBool
                        power = 10.*log10(max(yo(find(fo>=freqRange(1) & fo<=freqRange(2)),:)));
                    else
                        %keyboard
                        power = 10.*log10(sum(yo(find(fo>=freqRange(1) & fo<=freqRange(2)),:)));
                    end
                    speedPowStruct = setfield(speedPowStruct,mazeRegionNames{k},'power',{nPoints + 1,1:nchannels}, power);
                    speedSeg = hanFilter.*speed(round(midPoints(k)-whlWinLength/2+1):round(midPoints(k)-whlWinLength/2)+size(hanFilter,1));
                    indexes = find(speedSeg >= 0);
                    if isempty(indexes)
                      
                        fprintf('error_speed_cant_be_reliably_measured');
                        keyboard
                    else
                        speedPowStruct = setfield(speedPowStruct,mazeRegionNames{k},'speed',{nPoints + 1,1}, mean(speedSeg(indexes)));
                        %returnArmSpeed = mean(speedSeg(indexes));
                        %whlSpeedSeg(indexes)
                    end
                    if plotbool
                        subplot(1,4,k)
                        hold on
                        plot(fo(find(fo<=100)),10.*log10(yo(find(fo<=100),plotChan)))
                        plot(fo(find(fo<=100)),10.*log10(max(yo(find(fo>=freqRange(1) & fo<=freqRange(2)),plotChan))),'r');
                        set(gca,'ylim',[40 80]);
                        title([mazeRegionNames{k} ' - speed: ' num2str(getfield(speedPowStruct,mazeRegionNames{k},'speed',{nPoints + 1,1}))]);
                    end
                    
                end
            else
                We_got_problems
            end
        end
    end
end
keyboard
figure(1)
clf
chans = [33;37;39;42;59;62];
for i=1:length(chans)
    subplot(length(chans),1,i)
    plotChan = chans(i);
    hold on
    colors = [0 0 1;1 0 0;0 1 0;0.5 0.5 0.5];
    allRegionsPow = [];
    allRegionsSpeed = [];
    for k=1:size(mazeRegionNames,1)
        nPoints = size(getfield(speedPowStruct,mazeRegionNames{k},'speed'),1);
        plot(getfield(speedPowStruct,mazeRegionNames{k},'speed',{1:nPoints,1}),getfield(speedPowStruct,mazeRegionNames{k},'power',{1:nPoints,plotChan}),'.','color',colors(k,:));
        %         [p s] = polyfit(getfield(speedPowStruct,mazeRegionNames{k},'speed',{1:nPoints,1}),getfield(speedPowStruct,mazeRegionNames{k},'power',{1:nPoints,plotChan}),1);
        %    endPoints = [min(getfield(speedPowStruct,mazeRegionNames{k},'speed')) max(getfield(speedPowStruct,mazeRegionNames{k},'speed'))];
        %         plot(endPoints,p(1).*endPoints+p(2),'k')
        set(gca,'xlim',[35 130]);
        %set(gca,'ylim',[68,84],'xlim',[35 130]);

        title(['channel: ' num2str(plotChan)]);
        allRegionsPow = [allRegionsPow; getfield(speedPowStruct,mazeRegionNames{k},'power',{1:nPoints,plotChan})];
        allRegionsSpeed = [allRegionsSpeed; getfield(speedPowStruct,mazeRegionNames{k},'speed',{1:nPoints,1})];
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

return
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
