function [returnarmPowMat, centerarmPowMat, choicepointPowMat, choicearmPowMat] = CalcRegionPowDist(taskType,filebasemat,fileext,nchannels,badchan,lowband,highband,plotbool,trialtypesbool)

if ~exist('trialtypesbool','var')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp
end
if ~exist('mazelocationsbool','var')
    mazelocationsbool = [0  0  0  1  1  1   1   1   1];
                       %rp lp dp cp ca rca lca rra lra
end
% [1 0 1 0 0 0 0 0 0 0 0 0 0]
% [0 0 0 1 1 1 1 1 1]

if ~exist('dbscale','var')
    dbscale = 0;
end
if ~exist('plotbool','var')
    plotbool = 0;
end


[numfiles n] = size(filebasemat);
ntrials=0;

returnarmPowMat = [];
centerarmPowMat = [];
choicepointPowMat = [];
choicearmPowMat = [];

for i=1:numfiles
    
    dspowname = [filebasemat(i,:) '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBdspow'];
    powerdat = 10.^((bload(dspowname,[nchannels inf],0,'int16')')/1000);
    [dspm n] = size(powerdat);
    
    allMazeRegions = loadmazetrialtypes(filebasemat(i,:),trialtypesbool,[0 0 0 1 1 1 1 1 1]);
    [whlm n] = size(allMazeRegions);
    if whlm~=dspm
        FILES_NOT_SAME_SIZE
    end
    
    atports = loadmazetrialtypes(filebasemat(i,:),trialtypesbool,[1 1 0 0 0 0 0 0 0]);
    
    choicepoint = loadmazetrialtypes(filebasemat(i,:),trialtypesbool,[0 0 0 1 0 0 0 0 0]);
    centerarm   = loadmazetrialtypes(filebasemat(i,:),trialtypesbool,[0 0 0 0 1 0 0 0 0]);
    choicearm   = loadmazetrialtypes(filebasemat(i,:),trialtypesbool,[0 0 0 0 0 1 1 0 0]);
    returnarm   = loadmazetrialtypes(filebasemat(i,:),trialtypesbool,[0 0 0 0 0 0 0 1 1]);
    
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
        trialchoicearm = trialbegin(1)-1+find(choicearm(trialbegin(1):(trialend(1)-1),1)~=-1);
        
        trialbegin = trialend(1)-1+find(allMazeRegions(trialend(1):end,1)~=-1);

        if plotbool
            figure(3)
            clf
            hold on
            plot(returnarm(trialreturnarm,1),returnarm(trialreturnarm,2),'.','color',[0 0 1],'markersize',7);
            plot(centerarm(trialcenterarm,1),centerarm(trialcenterarm,2),'.','color',[1 0 0],'markersize',7);
            plot(choicepoint(trialchoicepoint,1),choicepoint(trialchoicepoint,2),'.','color',[0 0 0],'markersize',7);
            plot(choicearm(trialchoicearm,1),choicearm(trialchoicearm,2),'.','color',[0 1 1],'markersize',7);
            set(gca,'xlim',[0 368],'ylim',[0 240]);    
        end
        returnarmPowMat = [returnarmPowMat; mean(powerdat(trialreturnarm,:),1)];
        centerarmPowMat = [centerarmPowMat; mean(powerdat(trialcenterarm,:),1)];
        choicepointPowMat = [choicepointPowMat; mean(powerdat(trialchoicepoint,:),1)];
        choicearmPowMat = [choicearmPowMat; mean(powerdat(trialchoicearm,:),1)];
        ntrials = ntrials + 1;
        if plotbool
            fprintf('n=%d : ',ntrials);
            input('next?');
        end

        
    end
end
fprintf('total n=%d : ',ntrials);

if dbscale
    returnarmPowMat = 10*log10(returnarmPowMat);
    centerarmPowMat = 10*log10(centerarmPowMat);
    choicepointPowMat = 10*log10(choicepointPowMat);
    choicearmPowMat = 10*log10(choicearmPowMat);
end
return
