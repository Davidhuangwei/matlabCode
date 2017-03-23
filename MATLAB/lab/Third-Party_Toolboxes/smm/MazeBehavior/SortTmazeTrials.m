function SortTmazeTrials(taskType,filebase)
% function SortTmazeTrials(taskType, filebase)
%
% sorts T maze trials into different bevaioral conditions
% taskType is a text string describing the task (alter or force)
%
% outputs are saved to a file named to match a corresponding .whl file
% the left column of outputs below contain indexes of the corresponding .whl file
% that indicate the type of trial performed. the right column of outputs 
% designates how many trials of the corresponding type were performed.
% exploration            XP
% LeftRight              LR
% RightRight             RR
% RightLeft              RL
% LeftLeft               LL
% ponderLeftRight        LRP
% ponderRightRight       RRP
% ponderRightLeft        RLP
% ponderLeftLeft         LLP
% badLeftRight           LRB
% badRightRight          RRB
% badRightLeft           RLB
% badLeftLeft            LLB
%
% the following outputs contain indexes corresponding to when the animal
% was in different parts of the maze/task
% delayArea
% rWaterPort
% lWaterPort
% Tjunction
% centerArm
% rGoalArm
% lGoalArm
% rReturnArm
% lReturnArm

xlimits  =[0 368];
ylimits = [0 240];

filename = [filebase '.whl'];
whldat = load(filename);
[whlm n] = size(whldat);

exploration = zeros(whlm,1);
LeftRight = zeros(whlm,1);
RightRight = zeros(whlm,1);
RightLeft = zeros(whlm,1);
LeftLeft = zeros(whlm,1);
ponderLeftRight = zeros(whlm,1);
ponderRightRight = zeros(whlm,1);
ponderRightLeft = zeros(whlm,1);
ponderLeftLeft = zeros(whlm,1);
badLeftRight = zeros(whlm,1);
badRightRight = zeros(whlm,1);
badRightLeft = zeros(whlm,1);
badLeftLeft = zeros(whlm,1);
delayArea = zeros(whlm,1);
rWaterPort = zeros(whlm,1);
lWaterPort = zeros(whlm,1);
Tjunction = zeros(whlm,1);
centerArm = zeros(whlm,1);
rGoalArm = zeros(whlm,1);
lGoalArm = zeros(whlm,1);
rReturnArm = zeros(whlm,1);
lReturnArm = zeros(whlm,1);

XP = 0;
LR = 0;
RR = 0;
RL = 0;
LL = 0;
LRP = 0;
RRP = 0;
RLP = 0;
LLP = 0;
LRB = 0;
RRB = 0;
RLB = 0;
LLB = 0;


while (1)
    i = input('Would you like to load the trigger zones from file? (y/n): ', 's');
    if strcmp(i,'y') | strcmp(i,'n'), break; end    
end
if i(1)=='y',
    while (1)
        i = input(['from what file? [' filebase '_whl_indexes.mat]: '], 's');
        if strcmp(i,''), 
            whlIndexes = load([filebase '_whl_indexes.mat']); 
            break;
        else
            if exist(i,'file')
                whlIndexes = load(i);
                break;
            else
                fprintf('FILE NOT FOUND\n');
            end
        end
    end     
    triggerZones = getfield(whlIndexes,'triggerZones');
    trigFieldNames = fieldnames(triggerZones);
    
    figure(1)
    clf
    hold on
    plot(whldat(:,1),whldat(:,2),'.','color',[0 0 1],'markersize',7,'linestyle','none');
    for j=1:size(trigFieldNames,1)
        for k=1:size(getfield(triggerZones,trigFieldNames{j}),1)
            xZone = getfield(triggerZones,trigFieldNames{j},{k,[1,3]});
            yZone = getfield(triggerZones,trigFieldNames{j},{k,[2,4]});
            eval([trigFieldNames{j} '=' trigFieldNames{j} ...
                ' | (whldat(:,1)>=xZone(1) & whldat(:,1)<=xZone(2) & whldat(:,2)>=yZone(1) & whldat(:,2)<=yZone(2));']);
            plot([xZone(1) xZone(2) xZone(2) xZone(1) xZone(1)],[yZone(1) yZone(1) yZone(2) yZone(2) yZone(1)],'color',[1 0 0]);
        end
    end
    set(gca,'xlim',xlimits,'ylim',ylimits);
    zoom on;
    while (1)
        i = input('Are these trigger zones good? (yes/no): ', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
    if i(1)=='y',
        setnewtriggers = 0;
    else
        setnewtriggers = 1;
        triggerZones = [];
    end
else
    setnewtriggers = 1;
    triggerZones = [];
end


while (setnewtriggers)
    figure(1)
    clf;
    plot(whldat(:,1),whldat(:,2),'.','color',[0 0 1],'markersize',7,'linestyle','none');
    set(gca,'xlim',xlimits,'ylim',ylimits);
    zoom on;
    hold on;
    
    figure(1)
    fprintf('\ndesignation of trial beginning & end points\n------------------------------\n');
    input('Select the bottom trigger zone (right port) to start a new trial.\n   Then click back in this window and hit ENTER...','s');
    rwpx = xlim;
    rwpy = ylim; 
    rWaterPort = (whldat(:,1)>=rwpx(1) & whldat(:,1)<=rwpx(2) & whldat(:,2)>=rwpy(1) & whldat(:,2)<=rwpy(2));
    plot([rwpx(1) rwpx(2) rwpx(2) rwpx(1) rwpx(1)],[rwpy(1) rwpy(1) rwpy(2) rwpy(2) rwpy(1)],'color',[1 0 0]);
    set(gca,'xlim',xlimits,'ylim',ylimits);
    triggerZones = setfield(triggerZones,'rWaterPort',{1,1:4},[rwpx(1) rwpy(1) rwpx(2) rwpy(2)]);
    
    figure(1)
    zoom on
    input('Select the top trigger zone (left port) to start a new trial.\n   Then click back in this window and hit ENTER...','s');
    lwpx = xlim;
    lwpy = ylim; 
    lWaterPort = (whldat(:,1)>=lwpx(1) & whldat(:,1)<=lwpx(2) & whldat(:,2)>=lwpy(1) & whldat(:,2)<=lwpy(2));
    plot([lwpx(1) lwpx(2) lwpx(2) lwpx(1) lwpx(1)],[lwpy(1) lwpy(1) lwpy(2) lwpy(2) lwpy(1)],'color',[1 0 0]);
    set(gca,'xlim',xlimits,'ylim',ylimits);   
    triggerZones = setfield(triggerZones,'lWaterPort',{1,1:4},[lwpx(1) lwpy(1) lwpx(2) lwpy(2)]);

    delayArea = zeros(whlm,1);
    moreboxes = 1;
    while (moreboxes)
        figure(1)
        zoom on;
        input('Select part of the delay area.\n   Then click back in this window and hit ENTER...','s');
        dax = xlim;
        day = ylim;
        if xlim==xlimits & ylim==ylimits,
            fprintf('*********\nThe whole maze area is not a reasonable selection\n*********\n');
        else   
            hold on;
            plot([dax(1) dax(2) dax(2) dax(1) dax(1)],[day(1) day(1) day(2) day(2) day(1)],'color',[1 0 0]);
            delayArea = delayArea | (whldat(:,1)>=dax(1) & whldat(:,1)<=dax(2) & whldat(:,2)>=day(1) & whldat(:,2)<=day(2));
            set(gca,'xlim',xlimits,'ylim',ylimits);
            if isfield(triggerZones,'delayArea')
                nBoxes = size(getfield(triggerZones,'delayArea'),1) + 1;
            else
                nBoxes = 1;
            end
            triggerZones = setfield(triggerZones,'delayArea',{nBoxes,1:4}, ...
                [dax(1) day(1) dax(2) day(2)]);

            while (1)
                i = input('Do the boxes cover the entire area? (y/n): ', 's');
                if strcmp(i,'y') | strcmp(i,'n'), break; end
            end
            if ~isempty(i) & i(1)=='y',
                moreboxes = 0;        
            end
        end
    end
    set(gca,'xlim',xlimits,'ylim',ylimits);
    
    while (1)
        i = input('Would you like to load the T-Junction (choice point) coordinates from a file? (y/n): ','s');
        if strcmp(i,'y') | strcmp(i,'n'), break; end
    end
    if i(1)=='y'
        while (1)
            i = input(['from what file? [' filebase '_whl_indexes.mat]: '], 's');
            if strcmp(i,''),
                whlIndexes = load([filebase '_whl_indexes.mat']);
                break;
            else
                if exist(i,'file')
                    whlIndexes = load(i);
                    break;
                else
                    fprintf('FILE NOT FOUND\n');
                end
            end
        end
        cpx = getfield(whlIndexes,'triggerZones','Tjunction',{[1,3]});
        cpy = getfield(whlIndexes,'triggerZones','Tjunction',{[2,4]});
    else
        figure(1)
        zoom on
        input('Select the choice point.\n   Then click back in this window and hit ENTER...','s');
        cpx = xlim;
        cpy = ylim;
    end
    Tjunction = (whldat(:,1)>=cpx(1) & whldat(:,1)<=cpx(2) & whldat(:,2)>=cpy(1) & whldat(:,2)<=cpy(2));
    plot([cpx(1) cpx(2) cpx(2) cpx(1) cpx(1)],[cpy(1) cpy(1) cpy(2) cpy(2) cpy(1)],'color',[1 0 0]);
    set(gca,'xlim',xlimits,'ylim',ylimits);
    triggerZones = setfield(triggerZones,'Tjunction',{1,1:4},[cpx(1) cpy(1) cpx(2) cpy(2)]);


    while (1)
        i = input('Are these trigger zones good? (yes/no): ', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
    if i(1)=='y',
        setnewtriggers = 0;
    end
end
 
% find when the rat is in the trig zone
intrigzone = find(rWaterPort | lWaterPort);
trigzoneentry = intrigzone(1);

% find when the rat is not in the trig zone
notintrigzone = find(~rWaterPort & ~lWaterPort & whldat(:,1)~=-1);

donewithfile=0;
while ~donewithfile
    while (~isempty(intrigzone) & ~isempty(notintrigzone))
        newtrialtrigger = notintrigzone(find(notintrigzone>trigzoneentry));
        if isempty(newtrialtrigger),
            break;
        end
        
        reachedgoal = intrigzone(find(intrigzone>newtrialtrigger(1)));
        if isempty(reachedgoal),
            break;
        end
      
        exitedgoal = notintrigzone(find(notintrigzone>reachedgoal(1)));
        if isempty(exitedgoal),
            break;
        end
        
        endoftrial = intrigzone(find(intrigzone<exitedgoal(1)));
        if isempty(endoftrial),
            break;
        end
        
        if rWaterPort(trigzoneentry), % if the end of the last trial was at the right water port
            beginning = 'right';
        end
        if lWaterPort(trigzoneentry), % if the end of the last trial was at the left water port
            beginning = 'left ';
        end
        if rWaterPort(endoftrial(end)), % if endoftrial is at the right water port
            ending = 'right';
        end
        if lWaterPort(endoftrial(end)), % if endoftrial is at the left water port
            ending = 'left ';
        end
        
        
        daentry = newtrialtrigger(1)-1+find(delayArea(newtrialtrigger(1):endoftrial(end))); % find the delay period for this trial
        if isempty(daentry)
            fprintf('\n *** no delay period ***\n');
        else
            delayArea(daentry(1):daentry(end)) = 1; % This deals with trials with reentry into the delay area after leaving
            if beginning == 'right', % if the end of the last trial was at the right water port
                rReturnArm(newtrialtrigger(1):daentry(1)-1)=1;
            end
            if beginning == 'left ', % if the end of the last trial was at the left water port
                lReturnArm(newtrialtrigger(1):daentry(1)-1)=1;
            end
            cpentry = daentry(end)-1+find(Tjunction(daentry(end):endoftrial(end))); % find the Tjunction for this trial
            if isempty(cpentry)
                fprintf('\n *** no choice point ***\n');
            else
                Tjunction(cpentry(1):cpentry(end)) = 1; % This deals with trials with spatially extensive "pondering" by assigning all points as Tjunction until a final goal arm is chosen 
                centerArm((daentry(end)+1):(cpentry(1)-1))=1;
                if ending == 'right', % if endoftrial is at the right water port
                    rGoalArm((cpentry(end)+1):(reachedgoal(1)-1))=1;
                end
                if ending == 'left ', % if endoftrial is at the left water port
                    lGoalArm((cpentry(end)+1):(reachedgoal(1)-1))=1;
                end
            end
        end
        figure(1)
        clf
        hold on
        % in order to view the maze in the correct orientation the values in whldat are transformed
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(newtrialtrigger(1):endoftrial(end),2),xlimits(2)-whldat(newtrialtrigger(1):endoftrial(end),1),'.','color',[0.5 0.5 0.5],'markersize',7,'linestyle','none');

        
        plot(ylimits(2)-whldat(newtrialtrigger(1)-1+find(rReturnArm(newtrialtrigger(1):endoftrial(end))),2),xlimits(2)-whldat(newtrialtrigger(1)-1+find(rReturnArm(newtrialtrigger(1):endoftrial(end))),1),'.','color',[0 0 1],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(newtrialtrigger(1)-1+find(lReturnArm(newtrialtrigger(1):endoftrial(end))),2),xlimits(2)-whldat(newtrialtrigger(1)-1+find(lReturnArm(newtrialtrigger(1):endoftrial(end))),1),'.','color',[0 0 1],'markersize',7,'linestyle','none');

        plot(ylimits(2)-whldat(newtrialtrigger(1)-1+find(delayArea(newtrialtrigger(1):endoftrial(end))),2),xlimits(2)-whldat(newtrialtrigger(1)-1+find(delayArea(newtrialtrigger(1):endoftrial(end))),1),'.','color',[0 1 1],'markersize',7,'linestyle','none');
        
        plot(ylimits(2)-whldat(newtrialtrigger(1)-1+find(centerArm(newtrialtrigger(1):endoftrial(end))),2),xlimits(2)-whldat(newtrialtrigger(1)-1+find(centerArm(newtrialtrigger(1):endoftrial(end))),1),'.','color',[1 0 0],'markersize',7,'linestyle','none');

        plot(ylimits(2)-whldat(newtrialtrigger(1)-1+find(Tjunction(newtrialtrigger(1):endoftrial(end))),2),xlimits(2)-whldat(newtrialtrigger(1)-1+find(Tjunction(newtrialtrigger(1):endoftrial(end))),1),'.','color',[0 1 0],'markersize',7,'linestyle','none');

        plot(ylimits(2)-whldat(newtrialtrigger(1)-1+find(rGoalArm(newtrialtrigger(1):endoftrial(end))),2),xlimits(2)-whldat(newtrialtrigger(1)-1+find(rGoalArm(newtrialtrigger(1):endoftrial(end))),1),'.','color',[0 0 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(newtrialtrigger(1)-1+find(lGoalArm(newtrialtrigger(1):endoftrial(end))),2),xlimits(2)-whldat(newtrialtrigger(1)-1+find(lGoalArm(newtrialtrigger(1):endoftrial(end))),1),'.','color',[0 0 0],'markersize',7,'linestyle','none');

        plot(ylimits(2)-whldat(newtrialtrigger(1)-1+find(rWaterPort(newtrialtrigger(1):endoftrial(end))),2),xlimits(2)-whldat(newtrialtrigger(1)-1+find(rWaterPort(newtrialtrigger(1):endoftrial(end))),1),'.','color',[1 0 1],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(newtrialtrigger(1)-1+find(lWaterPort(newtrialtrigger(1):endoftrial(end))),2),xlimits(2)-whldat(newtrialtrigger(1)-1+find(lWaterPort(newtrialtrigger(1):endoftrial(end))),1),'.','color',[1 0 1],'markersize',7,'linestyle','none');
        
        set(gca,'xlim',ylimits,'ylim',xlimits);
        zoom on;
        
        figure(2)
        clf
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(newtrialtrigger(1):endoftrial(end),2),xlimits(2)-whldat(newtrialtrigger(1):endoftrial(end),1),'.','color',[0.5 0.5 0.5],'markersize',7,'linestyle','none');
       
        plot(ylimits(2)-whldat(newtrialtrigger(1)-1+find(centerArm(newtrialtrigger(1):endoftrial(end))),2),xlimits(2)-whldat(newtrialtrigger(1)-1+find(centerArm(newtrialtrigger(1):endoftrial(end))),1),'.','color',[1 0 0],'markersize',7,'linestyle','none');

        plot(ylimits(2)-whldat(newtrialtrigger(1)-1+find(Tjunction(newtrialtrigger(1):endoftrial(end))),2),xlimits(2)-whldat(newtrialtrigger(1)-1+find(Tjunction(newtrialtrigger(1):endoftrial(end))),1),'.','color',[0 1 0],'markersize',7,'linestyle','none');

        plot(ylimits(2)-whldat(newtrialtrigger(1)-1+find(rGoalArm(newtrialtrigger(1):endoftrial(end))),2),xlimits(2)-whldat(newtrialtrigger(1)-1+find(rGoalArm(newtrialtrigger(1):endoftrial(end))),1),'.','color',[0 0 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(newtrialtrigger(1)-1+find(lGoalArm(newtrialtrigger(1):endoftrial(end))),2),xlimits(2)-whldat(newtrialtrigger(1)-1+find(lGoalArm(newtrialtrigger(1):endoftrial(end))),1),'.','color',[0 0 0],'markersize',7,'linestyle','none');
        
        set(gca,'xlim',ylimits(2)-getfield(triggerZones,'Tjunction',{[4,2]})+[-10 10],'ylim',xlimits(2)-getfield(triggerZones,'Tjunction',{[3 1]})+[-10 10]);
        zoom on;
        
        tryagain = 1;
        while (tryagain == 1)
            fprintf('%s %s\n', beginning, ending);
            keyin = input('classify trial - [exploration=x,good=g,ponder=p,bad=b] :', 's');
            switch (keyin)
            case 'x'
                exploration(newtrialtrigger(1):endoftrial(end))=1;
                tryagain = 0;
                XP=XP+1;            
            case 'g'
                if beginning == 'right',
                    if ending == 'right',
                        RightRight(newtrialtrigger(1):endoftrial(end))=1;
                        tryagain = 0;
                        RR=RR+1;
                    else
                        RightLeft(newtrialtrigger(1):endoftrial(end))=1;
                        tryagain = 0;
                        RL=RL+1;
                    end
                else
                    if ending == 'right',
                        LeftRight(newtrialtrigger(1):endoftrial(end))=1;
                        tryagain = 0;
                        LR=LR+1;
                    else
                        LeftLeft(newtrialtrigger(1):endoftrial(end))=1;
                        tryagain = 0;
                        LL=LL+1;
                    end
                end
            case 'p'
                if beginning == 'right',
                    if ending == 'right',
                        ponderRightRight(newtrialtrigger(1):endoftrial(end))=1;
                        tryagain = 0;
                        RRP=RRP+1;
                    else
                        ponderRightLeft(newtrialtrigger(1):endoftrial(end))=1;
                        tryagain = 0;
                        RLP=RLP+1;
                    end
                else
                    if ending == 'right',
                        ponderLeftRight(newtrialtrigger(1):endoftrial(end))=1;
                        tryagain = 0;
                        LRP=LRP+1;
                    else
                        ponderLeftLeft(newtrialtrigger(1):endoftrial(end))=1;
                        tryagain = 0;
                        LLP=LLP+1;
                    end
                end
            case 'b'
                if beginning == 'right',
                    if ending == 'right',
                        badRightRight(newtrialtrigger(1):endoftrial(end))=1;
                        tryagain = 0;
                        RRB=RRB+1;

                    else
                        badRightLeft(newtrialtrigger(1):endoftrial(end))=1;
                        tryagain = 0;
                        RLB=RLB+1;
                    end
                else
                    if ending == 'right',
                        badLeftRight(newtrialtrigger(1):endoftrial(end))=1;
                        tryagain = 0;
                        LRB=LRB+1;

                    else
                        badLeftLeft(newtrialtrigger(1):endoftrial(end))=1;
                        tryagain = 0;
                        LLB=LLB+1;
                    end
                end
            otherwise
                fprintf('unrecognized input -- try again------------------------------\n');
            end
        end
        trigzoneentry = endoftrial(end);
    end 
    
    figure(1)
    clf;
    
    if ~isempty(find(LeftRight)),
        subplot(4,4,1)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(LeftRight),2),xlimits(2)-whldat(find(LeftRight),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Left Right good n=' num2str(LR)]);
    end
    if ~isempty(find(RightLeft)),
        subplot(4,4,2)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(RightLeft),2),xlimits(2)-whldat(find(RightLeft),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Right Left good n=' num2str(RL)]);
    end
    if ~isempty(find(RightRight)),
        subplot(4,4,3)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(RightRight),2),xlimits(2)-whldat(find(RightRight),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Right Right good n=' num2str(RR)]);
    end
    if ~isempty(find(LeftLeft)),
        subplot(4,4,4)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(LeftLeft),2),xlimits(2)-whldat(find(LeftLeft),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Left Left good n=' num2str(LL)]);
    end
    if ~isempty(find(ponderLeftRight)),
        subplot(4,4,5)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(ponderLeftRight),2),xlimits(2)-whldat(find(ponderLeftRight),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Left Right ponder n=' num2str(LRP)]);
    end
    if ~isempty(find(ponderRightLeft)),
        subplot(4,4,6)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(ponderRightLeft),2),xlimits(2)-whldat(find(ponderRightLeft),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Right Left ponder n=' num2str(RLP)]);
    end
    if ~isempty(find(ponderRightRight)),
        subplot(4,4,7)
        hold on
          plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
      plot(ylimits(2)-whldat(find(ponderRightRight),2),xlimits(2)-whldat(find(ponderRightRight),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Right Right ponder n=' num2str(RRP)]);
    end
    if ~isempty(find(ponderLeftLeft)),
        subplot(4,4,8)
        hold on
          plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
      plot(ylimits(2)-whldat(find(ponderLeftLeft),2),xlimits(2)-whldat(find(ponderLeftLeft),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Left Left ponder n=' num2str(LLP)]);
    end
    if ~isempty(find(badLeftRight)),
        subplot(4,4,9)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(badLeftRight),2),xlimits(2)-whldat(find(badLeftRight),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Left Right bad n=' num2str(LRB)]);
    end
    if ~isempty(find(badRightLeft)),
        subplot(4,4,10)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(badRightLeft),2),xlimits(2)-whldat(find(badRightLeft),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Right Left bad n=' num2str(RLB)]);
    end
    if ~isempty(find(badRightRight)),
        subplot(4,4,11)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(badRightRight),2),xlimits(2)-whldat(find(badRightRight),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Right Right bad n=' num2str(RRB)]);
    end
    if ~isempty(find(badLeftLeft)),
        subplot(4,4,12)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(badLeftLeft),2),xlimits(2)-whldat(find(badLeftLeft),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Left Left bad n=' num2str(LLB)]);
    end
    if ~isempty(find(exploration)),
        subplot(4,4,13)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(exploration),2),xlimits(2)-whldat(find(exploration),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['exploration']);
    end

    
    figure(2)
    clf;    
    if ~isempty(find(lGoalArm)),
        subplot(3,3,1)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(lGoalArm),2),xlimits(2)-whldat(find(lGoalArm),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['lGoalArm']);
    end
    if ~isempty(find(Tjunction)),
        subplot(3,3,2)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(Tjunction),2),xlimits(2)-whldat(find(Tjunction),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Tjunction']);
    end
    if ~isempty(find(rGoalArm)),
        subplot(3,3,3)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(rGoalArm),2),xlimits(2)-whldat(find(rGoalArm),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['rGoalArm']);
    end
    if ~isempty(find(lWaterPort)),
        subplot(3,3,4)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(lWaterPort),2),xlimits(2)-whldat(find(lWaterPort),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['lWaterPort']);
    end
    if ~isempty(find(centerArm)),
        subplot(3,3,5)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(centerArm),2),xlimits(2)-whldat(find(centerArm),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['centerArm']);
    end
    if ~isempty(find(rWaterPort)),
        subplot(3,3,6)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(rWaterPort),2),xlimits(2)-whldat(find(rWaterPort),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['rWaterPort']);
    end
    if ~isempty(find(lReturnArm)),
        subplot(3,3,7)
        hold on
          plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
      plot(ylimits(2)-whldat(find(lReturnArm),2),xlimits(2)-whldat(find(lReturnArm),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['lReturnArm']);
    end
    if ~isempty(find(delayArea)),
        subplot(3,3,8)
        hold on
          plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
      plot(ylimits(2)-whldat(find(delayArea),2),xlimits(2)-whldat(find(delayArea),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['delayArea']);
    end
    if ~isempty(find(rReturnArm)),
        subplot(3,3,9)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(rReturnArm),2),xlimits(2)-whldat(find(rReturnArm),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['rReturnArm']);
    end
    figure(1)

        fprintf('total trials n=%i\n', LR+RR+RL+LL+LRP+RLP+RRP+LLP+LRB+RRB+RLB+LLB);
    while 1,
        i = input('Save to disk? (yes/no):', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
    if i(1) == 'y'
        fprintf('Saving %s\n', [filebase '_whl_indexes.mat']);

        matlabVersion = version;
        if str2num(matlabVersion(1)) > 6
            save([filebase '_whl_indexes.mat'],'-V6','exploration','LeftRight','RightRight','RightLeft','LeftLeft',...
                'ponderLeftRight','ponderRightRight','ponderRightLeft','ponderLeftLeft',...
                'badLeftRight','badRightRight','badRightLeft','badLeftLeft','delayArea','rWaterPort',...
                'lWaterPort','Tjunction','centerArm','rGoalArm','lGoalArm','rReturnArm','lReturnArm',...
                'XP','LR', 'RR', 'RL', 'LL', 'LRP', 'RRP', 'RLP', 'LLP', 'LRB', 'RRB', 'RLB', 'LLB','taskType','triggerZones');
            donewithfile = 1;
        else
            save([filebase '_whl_indexes.mat'],'exploration','LeftRight','RightRight','RightLeft','LeftLeft',...
                'ponderLeftRight','ponderRightRight','ponderRightLeft','ponderLeftLeft',...
                'badLeftRight','badRightRight','badRightLeft','badLeftLeft','delayArea','rWaterPort',...
                'lWaterPort','Tjunction','centerArm','rGoalArm','lGoalArm','rReturnArm','lReturnArm',...
                'XP','LR', 'RR', 'RL', 'LL', 'LRP', 'RRP', 'RLP', 'LLP', 'LRB', 'RRB', 'RLB', 'LLB','taskType','triggerZones');
            donewithfile = 1;
        end
        
        if 0
            while 1,
                i = input('Would you like to save TjunctionCoordinates.mat to disk? (yes/no): ', 's');
                if strcmp(i,'yes') | strcmp(i,'no'), break; end
            end
            if i(1) == 'y'
                TjunctionXlim = cpx;
                TjunctionYlim = cpy;
                if str2num(matlabVersion(1)) > 6
                    save('TjunctionCoordinates.mat','-V6','TjunctionXlim','TjunctionYlim');
                else
                    save('TjunctionCoordinates.mat','TjunctionXlim','TjunctionYlim');
                end
            end
        end
    else
        while 1,
            i=input('\nDo you want to try again with the same trigger zones? (yes/no): ', 's');
            if strcmp(i,'yes') | strcmp(i,'no'), break; end
        end
        if i(1) == 'y'
            
            exploration = zeros(whlm,1);
            LeftRight = zeros(whlm,1);
            RightRight = zeros(whlm,1);
            RightLeft = zeros(whlm,1);
            LeftLeft = zeros(whlm,1);
            ponderLeftRight = zeros(whlm,1);
            ponderRightRight = zeros(whlm,1);
            ponderRightLeft = zeros(whlm,1);
            ponderLeftLeft = zeros(whlm,1);
            badLeftRight = zeros(whlm,1);
            badRightRight = zeros(whlm,1);
            badRightLeft = zeros(whlm,1);
            badLeftLeft = zeros(whlm,1);
            centerArm = zeros(whlm,1);
            rGoalArm = zeros(whlm,1);
            lGoalArm = zeros(whlm,1);
            rReturnArm = zeros(whlm,1);
            lReturnArm = zeros(whlm,1);

         
            XP = 0;
            LR = 0;
            RR = 0;
            RL = 0;
            LL = 0;
            LRP = 0;
            RRP = 0;
            RLP = 0;
            LLP = 0;
            LRB = 0;
            RRB = 0;
            RLB = 0;
            LLB = 0;
                      
            trigzoneentry = intrigzone(1);
        else
            donewithfile = 1;
        end
    end
end
        
