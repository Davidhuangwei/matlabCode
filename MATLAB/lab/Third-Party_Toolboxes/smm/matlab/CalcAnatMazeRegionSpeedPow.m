function [returnArmPowMat, centerArmPowMat, TjunctionPowMat, goalArmPowMat] = CalcAnatMazeRegionSpeedPow(taskType,fileBaseMat,fileNameFormat,fileExt,nchannels,lowCut,highCut,onePointBool,saveBool,plotbool,trialtypesbool)
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


[numfiles n] = size(fileBaseMat);
ntrials=0;


speedPow = struct('centerArm',struct('speed',[],'power',[]),'returnArm',struct('speed',[],'power',[]), ...
    'Tjunction',struct('speed',[],'power',[]),'goalArm',struct('speed',[],'power',[]));


for i=1:numfiles
    
    dspowname = [fileBaseMat(i,:) '_' num2str(lowCut) '-' num2str(highCut) 'Hz' fileExt '.100DBdspow'];
    fprintf('Loading: %s\n',dspowname);
    powerdat = 10.^((bload(dspowname,[nchannels inf],0,'int16')')/1000);
    [dspm n] = size(powerdat);
    
    allMazeRegions = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 1 1 1 1 1 1]);
    [speed accel] = MazeSpeedAccel(allMazeRegions);
    [whlm n] = size(allMazeRegions);
    if whlm~=dspm
        FILES_NOT_SAME_SIZE
    end
    
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
            if onePointBool
                if 0
                    returnArmMidX = min(returnarm(trialreturnarm,1)) + (max(returnarm(trialreturnarm,1)) - min(returnarm(trialreturnarm,1)))/2;
                    returnArmMidIndex = find(abs(returnarm(trialreturnarm,1) - returnArmMidX) == min(abs(returnarm(trialreturnarm,1) - returnArmMidX)));
                    returnArmMidPoint = returnArmMidIndex(1);

                    centerArmMidX = min(centerarm(trialcenterarm,1)) + (max(centerarm(trialcenterarm,1)) - min(centerarm(trialcenterarm,1)))*1/2;
                    centerArmMidIndex = find(abs(centerarm(trialcenterarm,1) - centerArmMidX) == min(abs(centerarm(trialcenterarm,1) - centerArmMidX)));
                    centerArmMidPoint = centerArmMidIndex(1);
                else
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
            end
        else
            fprintf('\nSkipping trial because of bad indexing!\n')
            keyboard
        end
        ntrials = ntrials + 1;
        if plotbool
            fprintf('n=%d : ',ntrials);
            j = 0;
            while ~strcmp(j,'s') & ~strcmp(j,'d')
                j = input('Save (s) or delete (d)? ','s');
                if strcmp(j,'s')
                    if onePointBool
                        speed = [returnArmPowMat; powerdat(trialreturnarm(returnArmMidPoint(1)),:)];
                        centerArmPowMat = [centerArmPowMat; powerdat(trialcenterarm(centerArmMidPoint(1)),:)];
                        TjunctionPowMat = [TjunctionPowMat; powerdat(trialchoicepoint(choicePointMidPoint(1)),:)];
                        goalArmPowMat = [goalArmPowMat; powerdat(trialgoalarm(choiceArmMidPoint(1)),:)];
                    else
                        returnArmPowMat = [returnArmPowMat; mean(powerdat(trialreturnarm,:),1)];
                        centerArmPowMat = [centerArmPowMat; mean(powerdat(trialcenterarm,:),1)];
                        TjunctionPowMat = [TjunctionPowMat; mean(powerdat(trialchoicepoint,:),1)];
                        goalArmPowMat = [goalArmPowMat; mean(powerdat(trialgoalarm,:),1)];
                    end
                end
            end
        else
            if onePointBool
                returnArmPowMat = [returnArmPowMat; powerdat(trialreturnarm(returnArmMidPoint(1)),:)];
                centerArmPowMat = [centerArmPowMat; powerdat(trialcenterarm(centerArmMidPoint(1)),:)];
                TjunctionPowMat = [TjunctionPowMat; powerdat(trialchoicepoint(choicePointMidPoint(1)),:)];
                goalArmPowMat = [goalArmPowMat; powerdat(trialgoalarm(choiceArmMidPoint(1)),:)];
            else
                returnArmPowMat = [returnArmPowMat; mean(powerdat(trialreturnarm,:),1)];
                centerArmPowMat = [centerArmPowMat; mean(powerdat(trialcenterarm,:),1)];
                TjunctionPowMat = [TjunctionPowMat; mean(powerdat(trialchoicepoint,:),1)];
                goalArmPowMat = [goalArmPowMat; mean(powerdat(trialgoalarm,:),1)];
            end
        end
    end
end


fprintf('total n=%d : ',ntrials);
if saveBool
    
    if fileNameFormat == 1,
        if onePointBool
            outname = [taskType '_' fileBaseMat(1,1:8)  ...
                '-' fileBaseMat(end,1:8) ...
                fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_point_AnatMazeRegionPow.mat'];
        else
            outname = [taskType '_' fileBaseMat(1,1:8)  ...
                '-' fileBaseMat(end,1:8) ...
                fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_mean_AnatMazeRegionPow.mat'];
        end
    end
    
    if fileNameFormat == 2,
        if onePointBool
        outname = [taskType '_' fileBaseMat(1,[1:10]) '-' fileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_point_AnatMazeRegionPow.mat'];
        else
                    outname = [taskType '_' fileBaseMat(1,[1:10]) '-' fileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_mean_AnatMazeRegionPow.mat'];
        end

     end
    if fileNameFormat == 0,
        if onePointBool
        outname = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_point_AnatMazeRegionPow.mat'];
        else
                    outname = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_mean_AnatMazeRegionPow.mat'];
        end
    end
    fprintf('Saving %s\n', outname);
    matlabVersion = version;
    if str2num(matlabVersion(1)) > 6
        save(outname,'-V6','returnArmPowMat','centerArmPowMat','TjunctionPowMat','goalArmPowMat');
    else
        save(outname,'returnArmPowMat','centerArmPowMat','TjunctionPowMat','goalArmPowMat');
    end
end

return
