function SortLinearMazeTrials(taskType, filebase)
% function SortLinearMazeTrials(taskType, filebase)
%
% sorts maze trials (with 2 delay areas) into different bevaioral conditions
% taskType is a text string describing the task (circle or z)
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

%taskType = 'circle';

xlimits = [0 368];
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
Tjunction = zeros(whlm,1); % not used
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

setnewtriggers = 1;
while (setnewtriggers)
    figure(1)
    clf;
    plot(whldat(:,1),whldat(:,2),'.','color',[0 0 1],'markersize',7,'linestyle','none');
    set(gca,'xlim',xlimits,'ylim',ylimits);
    zoom on;
    hold on;
 
    rWaterPort = zeros(whlm,1);
    moreboxes = 1;
    while (moreboxes)
        figure(1)
        zoom on;
        input('Select the bottom trigger zone (right port) to start a new trial.\n   Then click back in this window and hit ENTER...','s');
        rpx = xlim;
        rpy = ylim;
        if xlim==xlimits & ylim==ylimits,
            fprintf('*********\nThe whole maze area is not a reasonable selection\n*********\n');
        else
            hold on;
            plot([rpx(1) rpx(2) rpx(2) rpx(1) rpx(1)],[rpy(1) rpy(1) rpy(2) rpy(2) rpy(1)],'color',[1 0 0]);
            rWaterPort = rWaterPort | (whldat(:,1)>=rpx(1) & whldat(:,1)<=rpx(2) & whldat(:,2)>=rpy(1) & whldat(:,2)<=rpy(2));
            set(gca,'xlim',xlimits,'ylim',ylimits);
            while (1)
                i = input('Do the boxes cover the entire area? (y/n):', 's');
                if strcmp(i,'y') | strcmp(i,'n'), break; end
            end
            if ~isempty(i) & i(1)=='y',
                moreboxes = 0;        
            end
        end
    end
    set(gca,'xlim',xlimits,'ylim',ylimits);

    
    lWaterPort = zeros(whlm,1);
    moreboxes = 1;
    while (moreboxes)
        figure(1)
        zoom on;
        input('Select the top trigger zone (left port) to start a new trial.\n   Then click back in this window and hit ENTER...','s');
        lpx = xlim;
        lpy = ylim; 
        if xlim==xlimits & ylim==ylimits,
            fprintf('*********\nThe whole maze area is not a reasonable selection\n*********\n');
        else   
            hold on;
            plot([lpx(1) lpx(2) lpx(2) lpx(1) lpx(1)],[lpy(1) lpy(1) lpy(2) lpy(2) lpy(1)],'color',[1 0 0]);
            lWaterPort = lWaterPort | (whldat(:,1)>=lpx(1) & whldat(:,1)<=lpx(2) & whldat(:,2)>=lpy(1) & whldat(:,2)<=lpy(2));
            set(gca,'xlim',xlimits,'ylim',ylimits);
            while (1)
                i = input('Do the boxes cover the entire area? (y/n):', 's');
                if strcmp(i,'y') | strcmp(i,'n'), break; end
            end
            if ~isempty(i) & i(1)=='y',
                moreboxes = 0;        
            end
        end
    end
    set(gca,'xlim',xlimits,'ylim',ylimits);
    
    while (1)
        i = input('Are these trigger zones good? (yes/no):', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
    if i(1)=='y',
        setnewtriggers = 0;
    end
end
 

% the delay period is when the animal is at the right port or the left port
delayArea = rWaterPort | lWaterPort;

 %    plot(whldat(find(delayArea),1),whldat(find(delayArea),2),'.','color',[1 0 0],'markersize',7,'linestyle','none');

% find when the rat is in the trig zone
intrigzone = find(delayArea);

% find when the rat is not in the trig zone
notintrigzone = find(~delayArea & whldat(:,1)~=-1);
newtrialtrigger = notintrigzone(1);

donewithfile=0;
while ~donewithfile
    while (~isempty(intrigzone) & ~isempty(notintrigzone))
        
        reachedgoal = intrigzone(find(intrigzone>newtrialtrigger(1)));
        if isempty(reachedgoal),
            break;
        end
        
        exitedgoal = notintrigzone(find(notintrigzone>reachedgoal(1)));
        if isempty(exitedgoal),
            exitedgoal = reachedgoal(end); % so last trial isn't thrown out
        end
       
        endoftrial = intrigzone(find(intrigzone<exitedgoal(1)));
        if isempty(endoftrial),
            break;
        end
        
        previousgoal = intrigzone(find(intrigzone<newtrialtrigger(1)));
        if isempty(previousgoal),
            Houston_we_have_a_problem
        end

        if rWaterPort(previousgoal(end)), % if the end of the last trial was at the right water port
            beginning = 'right';
        end
        if lWaterPort(previousgoal(end)), % if the end of the last trial was at the left water port
            beginning = 'left ';
        end
        if rWaterPort(endoftrial(end)), % if endoftrial is at the right water port
            ending = 'right';
        end
        if lWaterPort(endoftrial(end)), % if endoftrial is at the left water port
            ending = 'left ';
        end 
        
        figure(1)
        clf
        hold on
        % in order to view the maze in the correct orientation the values in whldat are transformed
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(newtrialtrigger(1):endoftrial(end),2),xlimits(2)-whldat(newtrialtrigger(1):endoftrial(end),1),'.','color',[0 0 1],'markersize',7,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits);
        tryagain = 1;
        if beginning ~= ending,
            choice = 'correct  ';
        else
            choice = 'incorrect';
        end
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
        newtrialtrigger = exitedgoal(1);
    end
    clf
    hold on;
    if ~isempty(find((RightLeft | LeftRight) & ~delayArea & whldat(:,1)>0)),
        plot(ylimits(2)-whldat(find((RightLeft | LeftRight) & ~delayArea & whldat(:,1)>0),2),xlimits(2)-whldat(find((RightLeft | LeftRight) & ~delayArea & whldat(:,1)>0),1),'.','color',[0 0 1],'markersize',7,'linestyle','none');
        rangey=range(whldat(find((RightLeft | LeftRight) & ~delayArea & whldat(:,1)>0),2));
        rangex=range(whldat(find((RightLeft | LeftRight) & ~delayArea & whldat(:,1)>0),1));
        middlex=rangex/2+min(whldat(find((RightLeft | LeftRight) & ~delayArea & whldat(:,1)>0),1));
        xdivider=middlex-5;
        middley=rangey/2+min(whldat(find((RightLeft | LeftRight) & ~delayArea & whldat(:,1)>0),2));
        ydivider=middley;
        plot(ylimits,[xlimits(2)-xdivider xlimits(2)-xdivider],'color',[1 0 0])
        plot([ylimits(2)-ydivider ylimits(2)-ydivider],xlimits,'color',[1 0 0])
        set(gca,'xlim',ylimits,'ylim',xlimits);
        while 1,
            i = input('Do the lines divide the maze trajectory well? (yes/no):', 's');
            if strcmp(i,'yes') | strcmp(i,'no'), break; end
        end
        if i(1) == 'y'
            rGoalArm = (whldat(:,1)<=xdivider & whldat(:,2)<=ydivider & ~delayArea);
            lGoalArm = (whldat(:,1)<=xdivider & whldat(:,2)>ydivider & ~delayArea);
            rReturnArm = (whldat(:,1)>xdivider & whldat(:,2)<=ydivider & ~delayArea);
            lReturnArm = (whldat(:,1)>xdivider & whldat(:,2)>ydivider & ~delayArea);
        else
            fprintf('You need to write a better program!\n');
        end
    else
        fprintf('Maze cannot be divided due to lack of appropriate paths\n');
    end

    clf;
    
    if ~isempty(find(LeftRight)),
        subplot(3,4,1)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(LeftRight),2),xlimits(2)-whldat(find(LeftRight),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['left right good n=' num2str(LR)]);
    end
    if ~isempty(find(RightLeft)),
        subplot(3,4,2)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(RightLeft),2),xlimits(2)-whldat(find(RightLeft),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['right left good n=' num2str(RL)]);
    end
    if ~isempty(find(RightRight)),
        subplot(3,4,3)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(RightRight),2),xlimits(2)-whldat(find(RightRight),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['right right good n=' num2str(RR)]);
    end
    if ~isempty(find(LeftLeft)),
        subplot(3,4,4)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(LeftLeft),2),xlimits(2)-whldat(find(LeftLeft),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['left left good n=' num2str(LL)]);
    end
    if ~isempty(find(ponderLeftRight)),
        subplot(3,4,5)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(ponderLeftRight),2),xlimits(2)-whldat(find(ponderLeftRight),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['left right ponder n=' num2str(LRP)]);
    end
    if ~isempty(find(ponderRightLeft)),
        subplot(3,4,6)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(ponderRightLeft),2),xlimits(2)-whldat(find(ponderRightLeft),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['right left ponder n=' num2str(RLP)]);
    end
    if ~isempty(find(ponderRightRight)),
        subplot(3,4,7)
        hold on
          plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
      plot(ylimits(2)-whldat(find(ponderRightRight),2),xlimits(2)-whldat(find(ponderRightRight),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['right right ponder n=' num2str(RRP)]);
    end
    if ~isempty(find(ponderLeftLeft)),
        subplot(3,4,8)
        hold on
          plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
      plot(ylimits(2)-whldat(find(ponderLeftLeft),2),xlimits(2)-whldat(find(ponderLeftLeft),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['left left ponder n=' num2str(LLP)]);
    end
    if ~isempty(find(badLeftRight)),
        subplot(3,4,9)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(badLeftRight),2),xlimits(2)-whldat(find(badLeftRight),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['left right bad n=' num2str(LRB)]);
    end
    if ~isempty(find(badRightLeft)),
        subplot(3,4,10)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(badRightLeft),2),xlimits(2)-whldat(find(badRightLeft),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['right left bad n=' num2str(RLB)]);
    end
    if ~isempty(find(badRightRight)),
        subplot(3,4,11)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(badRightRight),2),xlimits(2)-whldat(find(badRightRight),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['right right bad n=' num2str(RRB)]);
    end
    if ~isempty(find(badLeftLeft)),
        subplot(3,4,12)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(badLeftLeft),2),xlimits(2)-whldat(find(badLeftLeft),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['left left bad n=' num2str(LLB)]);
    end
    
    figure(2)
    clf;    
    if ~isempty(find(lGoalArm)),
        subplot(4,3,1)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(lGoalArm),2),xlimits(2)-whldat(find(lGoalArm),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['lGoalArm']);
    end
    if ~isempty(find(Tjunction)),
        subplot(4,3,2)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(Tjunction),2),xlimits(2)-whldat(find(Tjunction),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Tjunction']);
    end
    if ~isempty(find(rGoalArm)),
        subplot(4,3,3)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(rGoalArm),2),xlimits(2)-whldat(find(rGoalArm),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['rGoalArm']);
    end
    if ~isempty(find(lWaterPort)),
        subplot(4,3,7)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(lWaterPort),2),xlimits(2)-whldat(find(lWaterPort),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['lWaterPort']);
    end
    if ~isempty(find(rWaterPort)),
        subplot(4,3,9)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(rWaterPort),2),xlimits(2)-whldat(find(rWaterPort),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['rWaterPort']);
    end
    if ~isempty(find(lReturnArm)),
        subplot(4,3,4)
        hold on
          plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
      plot(ylimits(2)-whldat(find(lReturnArm),2),xlimits(2)-whldat(find(lReturnArm),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['lReturnArm']);
    end
    if ~isempty(find(delayArea)),
        subplot(4,3,8)
        hold on
          plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
      plot(ylimits(2)-whldat(find(delayArea),2),xlimits(2)-whldat(find(delayArea),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['delayArea']);
    end
    if ~isempty(find(rReturnArm)),
        subplot(4,3,6)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(rReturnArm),2),xlimits(2)-whldat(find(rReturnArm),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['rReturnArm']);
    end
    if ~isempty(find(exploration)),
        subplot(4,3,11)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(exploration),2),xlimits(2)-whldat(find(exploration),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['exploration']);
    end
    figure(1)

    fprintf('total trials n=%i\n', LR+RR+RL+LL+LRP+RLP+RRP+LLP+LRB+RRB+RLB+LLB);
    while 1,
        i = input('Save to disk? (yes/no):', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
  
    if i(1) == 'y'
        matlabVersion = version;
        if str2num(matlabVersion(1)) > 6
            save([filebase '_whl_indexes.mat'],'-V6','exploration','LeftRight','RightRight','RightLeft','LeftLeft',...
                'ponderLeftRight','ponderRightRight','ponderRightLeft','ponderLeftLeft',...
                'badLeftRight','badRightRight','badRightLeft','badLeftLeft','delayArea','rWaterPort',...
                'lWaterPort','Tjunction','centerArm','rGoalArm','lGoalArm','rReturnArm','lReturnArm',...
                'XP','LR', 'RR', 'RL', 'LL', 'LRP', 'RRP', 'RLP', 'LLP', 'LRB', 'RRB', 'RLB', 'LLB','taskType');
            donewithfile = 1;
        else
            save([filebase '_whl_indexes.mat'],'exploration','LeftRight','RightRight','RightLeft','LeftLeft',...
                'ponderLeftRight','ponderRightRight','ponderRightLeft','ponderLeftLeft',...
                'badLeftRight','badRightRight','badRightLeft','badLeftLeft','delayArea','rWaterPort',...
                'lWaterPort','Tjunction','centerArm','rGoalArm','lGoalArm','rReturnArm','lReturnArm',...
                'XP','LR', 'RR', 'RL', 'LL', 'LRP', 'RRP', 'RLP', 'LLP', 'LRB', 'RRB', 'RLB', 'LLB','taskType');
            donewithfile = 1;
        end
    else
        while 1,
            i=input('\nDo you want to try again with the same trigger zones? (yes/no):', 's');
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
            
            clf;
            subplot(2,1,1);
            plot(whldat(:,2),368-whldat(:,1),'.','color',[1 0 0],'markersize',7,'linestyle','none');
            set(gca,'xlim',ylimits,'ylim',xlimits);
            subplot(2,1,2);
            
            newtrialtrigger = notintrigzone(1);
        else
            donewithfile = 1;
        end
    end
end


