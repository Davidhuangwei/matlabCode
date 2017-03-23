function MakeMazeEventFile(fileBaseMat,trialtypesbool,mazelocationsbool,whlSamp)
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

if ~exist('whlSamp', 'var') | isempty(whlSamp),
    whlSamp = 39.065; %default
end
if ~exist('plotbool','var')
    plotbool = 1;
end
if ~exist('saveBool','var')
    saveBool = 0;
end
if ~exist('onePointBool','var')
    onePointBool = 0;
end

[numfiles n] = size(fileBaseMat);
ntrials=0;

for i=1:numfiles
    
    eventFileName = [fileBaseMat(i,:) '.maz.evt'];
    eventFileID = fopen(eventFileName,'w')
    if eventFileID == -1;
         ERROR_OPEN_EVT_FILE_FAILED
    end
    
    allMazeRegions = loadmazetrialtypes(fileBaseMat(i,:),trialtypesbool,[1 1 1 1 1 1 1 1 1]);
    [whlm n] = size(allMazeRegions);
    
    RLports     = loadmazetrialtypes(fileBaseMat(i,:),trialtypesbool,[1 1 0 0 0 0 0 0 0]);
    delayport   = loadmazetrialtypes(fileBaseMat(i,:),trialtypesbool,[0 0 1 0 0 0 0 0 0]);
    choicepoint = loadmazetrialtypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 1 0 0 0 0 0]);
    centerarm   = loadmazetrialtypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 1 0 0 0 0]);
    choicearm   = loadmazetrialtypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 1 1 0 0]);
    returnarm   = loadmazetrialtypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 0 0 1 1]);
    xp = loadmazetrialtypes(fileBaseMat(i,:),[0 0 0 0 0 0 0 0 0 0 0 0 1]);
    
    %plot(allMazeRegions(:,1),allMazeRegions(:,2))
    trialbegin = find(returnarm(:,1)~=-1);
    while ~isempty(trialbegin),
        trialbegin(1)
        atport = trialbegin(1)-1 + find(RLports((trialbegin(1)):end,1)~=-1);
        trialend = atport(1)-1 + find(returnarm(atport((1)):end,1)~=-1);
        if isempty(trialend) | trialend(1) <= trialbegin(1),
            breaking = 1
            keyboard
            break;
        end
        trialreturnarm = trialbegin(1)-1+find(returnarm(trialbegin(1):(trialend(1)-1),1)~=-1);
        trialdelayport = trialbegin(1)-1+find(delayport(trialbegin(1):(trialend(1)-1),1)~=-1);
        trialcenterarm = trialbegin(1)-1+find(centerarm(trialbegin(1):(trialend(1)-1),1)~=-1);
        trialchoicepoint = trialbegin(1)-1+find(choicepoint(trialbegin(1):(trialend(1)-1),1)~=-1);
        trialchoicearm = trialbegin(1)-1+find(choicearm(trialbegin(1):(trialend(1)-1),1)~=-1);
        trialRLports = trialbegin(1)-1+find(RLports(trialbegin(1):(trialend(1)-1),1)~=-1);
        trialxp = trialbegin(1)-1+find(xp(trialbegin(1):(trialend(1)-1),1)~=-1);

        trialbegin = trialend(1);
        
        if plotbool
            figure(3)
            clf
            hold on
            if ~isempty(trialreturnarm)
                plot(returnarm(trialreturnarm,1),returnarm(trialreturnarm,2),'.','color',[0 0 1],'markersize',7);
                plot(allMazeRegions(trialreturnarm(1),1),allMazeRegions(trialreturnarm(1),2),'.','color',[1 1 0],'markersize',30);
                fprintf(eventFileID,'%f ReturnArm\n',trialreturnarm(1)*1000/whlSamp);
            end
            if ~isempty(trialdelayport)
                plot(delayport(trialdelayport,1),delayport(trialdelayport,2),'.','color',[0.5 0.5 0.5],'markersize',7);
                plot(allMazeRegions(trialdelayport(1),1),allMazeRegions(trialdelayport(1),2),'.','color',[1 1 0],'markersize',30);
                fprintf(eventFileID,'%f DelayArea\n',trialdelayport(1)*1000/whlSamp);
            end
            if ~isempty(trialdelayport)
                plot(centerarm(trialcenterarm,1),centerarm(trialcenterarm,2),'.','color',[1 0 0],'markersize',7);
                plot(allMazeRegions(trialcenterarm(1),1),allMazeRegions(trialcenterarm(1),2),'.','color',[1 1 0],'markersize',30);
                fprintf(eventFileID,'%f CenterArm\n',trialcenterarm(1)*1000/whlSamp);
            end
            if ~isempty(trialchoicepoint)
                plot(choicepoint(trialchoicepoint,1),choicepoint(trialchoicepoint,2),'.','color',[0 0 0],'markersize',7);
                plot(allMazeRegions(trialchoicepoint(1),1),allMazeRegions(trialchoicepoint(1),2),'.','color',[1 1 0],'markersize',30);
                fprintf(eventFileID,'%f ChoicePoint\n',trialchoicepoint(1)*1000/whlSamp);
            end
            if ~isempty(trialchoicearm)
                plot(choicearm(trialchoicearm,1),choicearm(trialchoicearm,2),'.','color',[0 1 1],'markersize',7);
                plot(allMazeRegions(trialchoicearm(1),1),allMazeRegions(trialchoicearm(1),2),'.','color',[1 1 0],'markersize',30);
                fprintf(eventFileID,'%f RewardArm\n',trialchoicearm(1)*1000/whlSamp);
            end
            if ~isempty(trialRLports)
                plot(RLports(trialRLports,1),RLports(trialRLports,2),'.','color',[1 0 1],'markersize',7);
                plot(allMazeRegions(trialRLports(1),1),allMazeRegions(trialRLports(1),2),'.','color',[1 1 0],'markersize',30);
                fprintf(eventFileID,'%f RewardPort\n',trialRLports(1)*1000/whlSamp);
            end
            if ~isempty(trialxp)
                plot(xp(trialxp,1),xp(trialxp,2),'.','color',[0 1 0],'markersize',7);
                plot(xp(trialxp(1),1),xp(trialxp(1),2),'.','color',[1 1 0],'markersize',30);
                fprintf(eventFileID,'%f Exploration\n',trialxp(1)*1000/whlSamp);
            end
            set(gca,'xlim',[0 368],'ylim',[0 240]);
 
        end
            if 0
                plot(returnarm(trialreturnarm(returnArmMidPoint),1),returnarm(trialreturnarm(returnArmMidPoint),2),'.','color',[0 1 0],'markersize',20);
                plot(choicepoint(trialchoicepoint(choicePointMidPoint),1),choicepoint(trialchoicepoint(choicePointMidPoint),2),'.','color',[0 1 0],'markersize',20);
                plot(centerarm(trialcenterarm(centerArmMidPoint),1),centerarm(trialcenterarm(centerArmMidPoint),2),'.','color',[0 1 0],'markersize',20);
                plot(choicearm(trialchoicearm(choiceArmMidPoint),1),choicearm(trialchoicearm(choiceArmMidPoint),2),'.','color',[0 1 0],'markersize',20);
                
                %plot(returnarm(round(mean(trialreturnarm)),1),returnarm(round(mean(trialreturnarm)),2),'.','color',[0 1 0],'markersize',7);
                %plot(centerarm(round(mean(trialcenterarm)),1),centerarm(round(mean(trialcenterarm)),2),'.','color',[0 1 0],'markersize',7);
                %plot(choicepoint(round(mean(trialchoicepoint)),1),choicepoint(round(mean(trialchoicepoint)),2),'.','color',[0 1 0],'markersize',7);
                %plot(choicearm(round(mean(trialchoicearm)),1),choicearm(round(mean(trialchoicearm)),2),'.','color',[0 1 0],'markersize',7);
            end
        ntrials = ntrials + 1;
        if plotbool
            fprintf('n=%d : ',ntrials);
            input('next?');
        end

        
    end
    fclose(eventFileID);
end
