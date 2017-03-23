function [returnArmPowMat, centerArmPowMat, TjunctionPowMat, goalArmPowMat] = CalcAnatMazeRegionPowCircle(taskType,fileBaseMat,fileNameFormat,fileExt,nchannels,lowCut,highCut,onePointBool,saveBool,plotbool,trialtypesbool)

if ~exist('trialtypesbool','var')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
end
if ~exist('mazelocationsbool','var')
    mazelocationsbool = [0  0  0  1  1  1   1   1   1];
                       %rp lp dp tj ca rga lga rra lra
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

quad1PowMat = [];
quad2PowMat = [];
quad3PowMat = [];
quad4PowMat = [];

for i=1:numfiles
    
    dspowname = [fileBaseMat(i,:) '_' num2str(lowCut) '-' num2str(highCut) 'Hz' fileExt '.100DBdspow'];
    powerdat = 10.^((bload(dspowname,[nchannels inf],0,'int16')')/1000);
    [dspm n] = size(powerdat);
    
    allMazeRegions = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 1 1 1 1]);
    leftRightTrials = LoadMazeTrialTypes(fileBaseMat(i,:),([1 0 0 0 1 0 0 0 1 0 0 0 0]&trialtypesbool),[0 0 0 0 0 1 1 1 1]);
    rightLeftTrials = LoadMazeTrialTypes(fileBaseMat(i,:),([0 0 1 0 0 0 1 0 0 0 1 0 0]&trialtypesbool),[0 0 0 0 0 1 1 1 1]);
  
    [whlm n] = size(allMazeRegions);
    if whlm~=dspm
        FILES_NOT_SAME_SIZE
    end

    atports = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[1 1 1 0 0 0 0 0 0]);

    rReturnArm = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 0 0 1 0]);
    lReturnArm   = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 0 0 0 1]);
    rGoalArm   = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 1 0 0 0]);
    lGoalArm   = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 0 1 0 0]);

    %plot(allMazeRegions(:,1),allMazeRegions(:,2))
    trialbegin = find(allMazeRegions(:,1)~=-1);
    while ~isempty(trialbegin),
        trialend = trialbegin(1) + find(atports((trialbegin(1)+1):end,1)~=-1);
        if isempty(trialend),
            breaking = 1
            break;
        end

        trialrReturnArm = trialbegin(1)-1+find(rReturnArm(trialbegin(1):(trialend(1)-1),1)~=-1);
        triallReturnArm = trialbegin(1)-1+find(lReturnArm(trialbegin(1):(trialend(1)-1),1)~=-1);
        trialrGoalArm = trialbegin(1)-1+find(rGoalArm(trialbegin(1):(trialend(1)-1),1)~=-1);
        triallGoalArm = trialbegin(1)-1+find(lGoalArm(trialbegin(1):(trialend(1)-1),1)~=-1);

        if plotbool
            figure(3)
            clf
            hold on
            plot(allMazeRegions(find(allMazeRegions(:,1)~=-1),1),allMazeRegions(find(allMazeRegions(:,1)~=-1),2),'.','color',[1 1 0]);

            plot(rReturnArm(trialrReturnArm,1),rReturnArm(trialrReturnArm,2),'.','color',[0 0 1],'markersize',7);
            plot(lReturnArm(triallReturnArm,1),lReturnArm(triallReturnArm,2),'.','color',[1 0 0],'markersize',7);
            plot(rGoalArm(trialrGoalArm,1),rGoalArm(trialrGoalArm,2),'.','color',[0 0 0],'markersize',7);
            plot(lGoalArm(triallGoalArm,1),lGoalArm(triallGoalArm,2),'.','color',[0 1 1],'markersize',7);
            set(gca,'xlim',[0 368],'ylim',[0 240]);
        end
        if onePointBool

            rReturnArmMidPointDist = (rReturnArm(trialrReturnArm,1) - mean([max(rReturnArm(trialrReturnArm,1)) min(rReturnArm(trialrReturnArm,1))])).^2 + ...
                (rReturnArm(trialrReturnArm,2) - mean([max(rReturnArm(trialrReturnArm,2)) min(rReturnArm(trialrReturnArm,2))])).^2;
            rReturnArmMidPoint = find(rReturnArmMidPointDist == min(rReturnArmMidPointDist));
            if leftRightTrials(trialbegin(1))~=-1
                quad4PowMat = [quad4PowMat; powerdat(trialrReturnArm(rReturnArmMidPoint),:)];
            else
                quad1PowMat = [quad1PowMat; powerdat(trialrReturnArm(rReturnArmMidPoint),:)];
            end

            lReturnArmMidPointDist = (lReturnArm(triallReturnArm,1) - mean([max(lReturnArm(triallReturnArm,1)) min(lReturnArm(triallReturnArm,1))])).^2 + ...
                (lReturnArm(triallReturnArm,2) - mean([max(lReturnArm(triallReturnArm,2)) min(lReturnArm(triallReturnArm,2))])).^2;
            lReturnArmMidPoint = find(lReturnArmMidPointDist == min(lReturnArmMidPointDist));
            if leftRightTrials(trialbegin(1))~=-1
                quad1PowMat = [quad1PowMat; powerdat(triallReturnArm(lReturnArmMidPoint),:)];
            else
                quad4PowMat = [quad4PowMat; powerdat(triallReturnArm(lReturnArmMidPoint),:)];
            end

            rGoalArmMidPointDist = (rGoalArm(trialrGoalArm,1) - mean([max(rGoalArm(trialrGoalArm,1)) min(rGoalArm(trialrGoalArm,1))])).^2 + ...
                (rGoalArm(trialrGoalArm,2) - mean([max(rGoalArm(trialrGoalArm,2)) min(rGoalArm(trialrGoalArm,2))])).^2;
            rGoalArmMidPoint = find(rGoalArmMidPointDist == min(rGoalArmMidPointDist));
            if leftRightTrials(trialbegin(1))~=-1
                quad3PowMat = [quad3PowMat; powerdat(trialrGoalArm(rGoalArmMidPoint),:)];
            else
                quad2PowMat = [quad2PowMat; powerdat(trialrGoalArm(rGoalArmMidPoint),:)];
            end

            lGoalArmMidPointDist = (lGoalArm(triallGoalArm,1) - mean([max(lGoalArm(triallGoalArm,1)) min(lGoalArm(triallGoalArm,1))])).^2 + ...
                (lGoalArm(triallGoalArm,2) - mean([max(lGoalArm(triallGoalArm,2)) min(lGoalArm(triallGoalArm,2))])).^2;
            lGoalArmMidPoint = find(lGoalArmMidPointDist == min(lGoalArmMidPointDist));
            if leftRightTrials(trialbegin(1))~=-1
                quad2PowMat = [quad2PowMat; powerdat(triallGoalArm(lGoalArmMidPoint),:)];
            else
                quad3PowMat = [quad3PowMat; powerdat(triallGoalArm(lGoalArmMidPoint),:)];
            end

            if plotbool
                if leftRightTrials(trialbegin(1))~=-1
                    plot(rReturnArm(trialrReturnArm(rReturnArmMidPoint),1),rReturnArm(trialrReturnArm(rReturnArmMidPoint),2),'.','color',[0 1 0],'markersize',20);
                    plot(lReturnArm(triallReturnArm(lReturnArmMidPoint),1),lReturnArm(triallReturnArm(lReturnArmMidPoint),2),'.','color',[0 1 0],'markersize',20);
                    plot(rGoalArm(trialrGoalArm(rGoalArmMidPoint),1),rGoalArm(trialrGoalArm(rGoalArmMidPoint),2),'.','color',[0 1 0],'markersize',20);
                    plot(lGoalArm(triallGoalArm(lGoalArmMidPoint),1),lGoalArm(triallGoalArm(lGoalArmMidPoint),2),'.','color',[0 1 0],'markersize',20);
                else
                    plot(rReturnArm(trialrReturnArm(rReturnArmMidPoint),1),rReturnArm(trialrReturnArm(rReturnArmMidPoint),2),'*','color',[0 1 0],'markersize',20);
                    plot(lReturnArm(triallReturnArm(lReturnArmMidPoint),1),lReturnArm(triallReturnArm(lReturnArmMidPoint),2),'*','color',[0 1 0],'markersize',20);
                    plot(rGoalArm(trialrGoalArm(rGoalArmMidPoint),1),rGoalArm(trialrGoalArm(rGoalArmMidPoint),2),'*','color',[0 1 0],'markersize',20);
                    plot(lGoalArm(triallGoalArm(lGoalArmMidPoint),1),lGoalArm(triallGoalArm(lGoalArmMidPoint),2),'*','color',[0 1 0],'markersize',20);                    
                end
                %plot(rReturnArm(round(mean(trialrReturnArm)),1),rReturnArm(round(mean(trialrReturnArm)),2),'.','color',[0 1 0],'markersize',7);
                %plot(lReturnArm(round(mean(triallReturnArm)),1),lReturnArm(round(mean(triallReturnArm)),2),'.','color',[0 1 0],'markersize',7);
                %plot(choicepoint(round(mean(trialrGoalArm)),1),rGoalArm(round(mean(trialrGoalArm)),2),'.','color',[0 1 0],'markersize',7);
                %plot(lGoalArm(round(mean(triallGoalArm)),1),lGoalArm(round(mean(triallGoalArm)),2),'.','color',[0 1 0],'markersize',7);
            end
        else
            if leftRightTrials(trialbegin(1))~=-1
                quad4PowMat = [quad4PowMat; mean(powerdat(trialrReturnArm,:),1)];
                quad1PowMat = [quad1PowMat; mean(powerdat(triallReturnArm,:),1)];
                quad3PowMat = [quad3PowMat; mean(powerdat(trialrGoalArm,:),1)];
                quad2PowMat = [quad2PowMat; mean(powerdat(triallGoalArm,:),1)];
            else
                quad1PowMat = [quad4PowMat; mean(powerdat(trialrReturnArm,:),1)];
                quad4PowMat = [quad1PowMat; mean(powerdat(triallReturnArm,:),1)];
                quad2PowMat = [quad3PowMat; mean(powerdat(trialrGoalArm,:),1)];
                quad3PowMat = [quad2PowMat; mean(powerdat(triallGoalArm,:),1)];
            end
        end
        ntrials = ntrials + 1;
        if plotbool
            fprintf('n=%d : ',ntrials);
            input('next?');
        end
        trialbegin = trialend(1)-1+find(allMazeRegions(trialend(1):end,1)~=-1);


    end
end
returnArmPowMat = quad1PowMat;
centerArmPowMat = quad2PowMat;
TjunctionPowMat = quad3PowMat;
goalArmPowMat = quad4PowMat;

fprintf('total n=%d : ',ntrials);
if saveBool
    if fileNameFormat == 1,
        ERROR_fileNameFormat_NOT_READY
        outname = [tasktype '_' fileBaseMat(1,1) fileBaseMat(1,2:4) fileBaseMat(1,5) fileBaseMat(1,6:8) ...
            '-' fileBaseMat(end,1) fileBaseMat(end,2:4) fileBaseMat(end,5) fileBaseMat(end,6:8)...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_pos_pow_sum.mat'];
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
