function sortaltermazetrials(filebase)
% function sortcirclemazetrials(filebase)
% sorts circle maze trials into different bevaioral conditions
%
% outputs are saved to a file named to match a corresponding .whl file
% the left column of outputs below contain indexes of the corresponding .whl file
% that indicate the type of trial performed. the right column of outputs 
% designates how many trials of the corresponding type were performed.
% exploration               xp
% correctright              cr
% incorrectright            ir
% correctleft               cl
% incorrectleft             il
% pondercorrectright        crp
% ponderincorrectright      irp
% pondercorrectleft         clp
% ponderincorrectleft       ilp
% badcorrectright           crb
% badincorrectright         irb
% badcorrectleft            clb
% badincorrectleft          ilb
%
% the following outputs contain indexes corresponding to when the animal
% was in different parts of the maze/task
% delayarea
% Rwaterport
% Lwaterport
% choicepoint
% centerarm
% Rchoicearm
% Lchoicearm
% Rreturnarm
% Lreturnarm

xlimits  =[0 368];
ylimits = [0 240];

filename = [filebase '.whl'];
whldat = load(filename);
[whlm n] = size(whldat);

exploration = zeros(whlm,1);
correctright = zeros(whlm,1);
incorrectright = zeros(whlm,1);
correctleft = zeros(whlm,1);
incorrectleft = zeros(whlm,1);
pondercorrectright = zeros(whlm,1);
ponderincorrectright = zeros(whlm,1);
pondercorrectleft = zeros(whlm,1);
ponderincorrectleft = zeros(whlm,1);
badcorrectright = zeros(whlm,1);
badincorrectright = zeros(whlm,1);
badcorrectleft = zeros(whlm,1);
badincorrectleft = zeros(whlm,1);
delayarea = zeros(whlm,1);
Rwaterport = zeros(whlm,1);
Lwaterport = zeros(whlm,1);
choicepoint = zeros(whlm,1);
centerarm = zeros(whlm,1);
Rchoicearm = zeros(whlm,1);
Lchoicearm = zeros(whlm,1);
Rreturnarm = zeros(whlm,1);
Lreturnarm = zeros(whlm,1);

xp = 0;
cr = 0;
ir = 0;
cl = 0;
il = 0;
crp = 0;
irp = 0;
clp = 0;
ilp = 0;
crb = 0;
irb = 0;
clb = 0;
ilb = 0;

setnewtriggers = 1;
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
    Rwaterport = (whldat(:,1)>=rwpx(1) & whldat(:,1)<=rwpx(2) & whldat(:,2)>=rwpy(1) & whldat(:,2)<=rwpy(2));
    plot([rwpx(1) rwpx(2) rwpx(2) rwpx(1) rwpx(1)],[rwpy(1) rwpy(1) rwpy(2) rwpy(2) rwpy(1)],'color',[1 0 0]);
    set(gca,'xlim',xlimits,'ylim',ylimits);
    
    figure(1)
    zoom on
    input('Select the top trigger zone (left port) to start a new trial.\n   Then click back in this window and hit ENTER...','s');
    lwpx = xlim;
    lwpy = ylim; 
    Lwaterport = (whldat(:,1)>=lwpx(1) & whldat(:,1)<=lwpx(2) & whldat(:,2)>=lwpy(1) & whldat(:,2)<=lwpy(2));
    plot([lwpx(1) lwpx(2) lwpx(2) lwpx(1) lwpx(1)],[lwpy(1) lwpy(1) lwpy(2) lwpy(2) lwpy(1)],'color',[1 0 0]);
    set(gca,'xlim',xlimits,'ylim',ylimits);   
    
    delayarea = zeros(whlm,1);
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
            delayarea = delayarea | (whldat(:,1)>=dax(1) & whldat(:,1)<=dax(2) & whldat(:,2)>=day(1) & whldat(:,2)<=day(2));
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
    
    
    figure(1)
    zoom on
    input('Select the choice point.\n   Then click back in this window and hit ENTER...','s');
    cpx = xlim;
    cpy = ylim; 
    choicepoint = (whldat(:,1)>=cpx(1) & whldat(:,1)<=cpx(2) & whldat(:,2)>=cpy(1) & whldat(:,2)<=cpy(2));
    plot([cpx(1) cpx(2) cpx(2) cpx(1) cpx(1)],[cpy(1) cpy(1) cpy(2) cpy(2) cpy(1)],'color',[1 0 0]);
    set(gca,'xlim',xlimits,'ylim',ylimits);

    while (1)
        i = input('Are these trigger zones good? (yes/no):', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
    if i(1)=='y',
        setnewtriggers = 0;
    end
end
 
% find when the rat is in the trig zone
intrigzone = find(Rwaterport | Lwaterport);
trigzoneentry = intrigzone(1);

% find when the rat is not in the trig zone
notintrigzone = find(~Rwaterport & ~Lwaterport & whldat(:,1)~=-1);

donewithfile=0;
while ~donewithfile
    while (~isempty(intrigzone) & ~isempty(notintrigzone))
        newtrialtrigger = notintrigzone(find(notintrigzone>trigzoneentry));
        
        if isempty(newtrialtrigger),
            break;
        end
        endoftrial = intrigzone(find(intrigzone>newtrialtrigger(1)));
        
        if isempty(endoftrial),
            break;
        end
        
        if Rwaterport(trigzoneentry), % if the end of the last trial was at the right water port
            beginning = 'right';
        end
        if Lwaterport(trigzoneentry), % if the end of the last trial was at the left water port
            beginning = 'left ';
        end
        if Rwaterport(endoftrial(1)), % if endoftrial is at the right water port
            ending = 'right';
        end
        if Lwaterport(endoftrial(1)), % if endoftrial is at the left water port
            ending = 'left ';
        end
        
        
        daentry = newtrialtrigger(1)-1+find(delayarea(newtrialtrigger(1):endoftrial(1))); % find the delay period for this trial
        if isempty(daentry)
            fprintf('\n *** no delay period ***\n');
        else
            if beginning == 'right', % if the end of the last trial was at the right water port
                Rreturnarm(newtrialtrigger(1):daentry(1)-1)=1;
            end
            if beginning == 'left ', % if the end of the last trial was at the left water port
                Lreturnarm(newtrialtrigger(1):daentry(1)-1)=1;
            end
            cpentry = daentry(end)-1+find(choicepoint(daentry(end):endoftrial(1))); % find the choicepoint for this trial
            if isempty(cpentry)
                fprintf('\n *** no choice point ***\n');
            else
                centerarm((daentry(end)+1):(cpentry(1)-1))=1;
                if ending == 'right', % if endoftrial is at the right water port
                    Rchoicearm((cpentry(end)+1):(endoftrial(1)-1))=1;
                end
                if ending == 'left ', % if endoftrial is at the left water port
                    Lchoicearm((cpentry(end)+1):(endoftrial(1)-1))=1;
                end
            end
        end
        figure(1)
        clf
        hold on
        % in order to view the maze in the correct orientation the values in whldat are transformed
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(newtrialtrigger(1):(endoftrial(1)-1),2),xlimits(2)-whldat(newtrialtrigger(1):(endoftrial(1)-1),1),'.','color',[0 0 1],'markersize',7,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits);
        tryagain = 1;
        if beginning ~= ending,
            choice = 'correct  ';
        else
            choice = 'incorrect';
        end
        while (tryagain == 1)
            fprintf('%s %s\n', choice, ending);
            keyin = input('classify trial - [exploration=x,good=g,ponder=p,bad=b] :', 's');
            switch (keyin)
            case 'x'
                exploration(newtrialtrigger(1):(endoftrial(1)-1))=1;
                tryagain = 0;
                xp=xp+1;            
            case 'g'
                if choice == 'correct  ',
                    if ending == 'right',
                        correctright(newtrialtrigger(1):(endoftrial(1)-1))=1;
                        tryagain = 0;
                        cr=cr+1;     
                    else
                        correctleft(newtrialtrigger(1):(endoftrial(1)-1))=1;
                        tryagain = 0;
                        cl=cl+1;
                    end
                else
                    if ending == 'right',
                        incorrectright(newtrialtrigger(1):(endoftrial(1)-1))=1;
                        tryagain = 0;
                        ir=ir+1;     
                    else
                        incorrectleft(newtrialtrigger(1):(endoftrial(1)-1))=1;
                        tryagain = 0;
                        il=il+1;
                    end
                end
            case 'p'
                if choice == 'correct  ',
                    if ending == 'right',
                        pondercorrectright(newtrialtrigger(1):(endoftrial(1)-1))=1;
                        tryagain = 0;
                        crp=crp+1;
                    else
                        pondercorrectleft(newtrialtrigger(1):(endoftrial(1)-1))=1;
                        tryagain = 0;
                        clp=clp+1;
                    end
                else
                    if ending == 'right',
                        ponderincorrectright(newtrialtrigger(1):(endoftrial(1)-1))=1;
                        tryagain = 0;
                        irp=irp+1;
                    else
                        ponderincorrectleft(newtrialtrigger(1):(endoftrial(1)-1))=1;
                        tryagain = 0;
                        ilp=ilp+1;
                    end
                end
            case 'b'
                if choice == 'correct  ',
                    if ending == 'right',
                        badcorrectright(newtrialtrigger(1):(endoftrial(1)-1))=1;
                        tryagain = 0;
                        crb=crb+1;
                    else
                        badcorrectleft(newtrialtrigger(1):(endoftrial(1)-1))=1;
                        tryagain = 0;
                        clb=clb+1;
                    end
                else
                    if ending == 'right',
                        badincorrectright(newtrialtrigger(1):(endoftrial(1)-1))=1;
                        tryagain = 0;
                        irb=irb+1;
                    else
                        badincorrectleft(newtrialtrigger(1):(endoftrial(1)-1))=1;
                        tryagain = 0;
                        ilb=ilb+1;
                    end
                end
            otherwise
                fprintf('unrecognized input -- try again------------------------------\n');
            end
        end
        trigzoneentry = endoftrial(1);
    end 
    clf;
    
    if ~isempty(find(correctright)),
        subplot(3,4,1)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(correctright),2),xlimits(2)-whldat(find(correctright),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['correct right good n=' num2str(cr)]);
    end
    if ~isempty(find(correctleft)),
        subplot(3,4,2)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(correctleft),2),xlimits(2)-whldat(find(correctleft),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['correct left good n=' num2str(cl)]);
    end
    if ~isempty(find(incorrectright)),
        subplot(3,4,3)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(incorrectright),2),xlimits(2)-whldat(find(incorrectright),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['incorrect right good n=' num2str(ir)]);
    end
    if ~isempty(find(incorrectleft)),
        subplot(3,4,4)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(incorrectleft),2),xlimits(2)-whldat(find(incorrectleft),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['incorrect left good n=' num2str(il)]);
    end
    if ~isempty(find(pondercorrectright)),
        subplot(3,4,5)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(pondercorrectright),2),xlimits(2)-whldat(find(pondercorrectright),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['correct right ponder n=' num2str(crp)]);
    end
    if ~isempty(find(pondercorrectleft)),
        subplot(3,4,6)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(pondercorrectleft),2),xlimits(2)-whldat(find(pondercorrectleft),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['correct left ponder n=' num2str(clp)]);
    end
    if ~isempty(find(ponderincorrectright)),
        subplot(3,4,7)
        hold on
          plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
      plot(ylimits(2)-whldat(find(ponderincorrectright),2),xlimits(2)-whldat(find(ponderincorrectright),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['incorrect right ponder n=' num2str(irp)]);
    end
    if ~isempty(find(ponderincorrectleft)),
        subplot(3,4,8)
        hold on
          plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
      plot(ylimits(2)-whldat(find(ponderincorrectleft),2),xlimits(2)-whldat(find(ponderincorrectleft),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['incorrect left ponder n=' num2str(ilp)]);
    end
    if ~isempty(find(badcorrectright)),
        subplot(3,4,9)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(badcorrectright),2),xlimits(2)-whldat(find(badcorrectright),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['correct right bad n=' num2str(crb)]);
    end
    if ~isempty(find(badcorrectleft)),
        subplot(3,4,10)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(badcorrectleft),2),xlimits(2)-whldat(find(badcorrectleft),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['correct left bad n=' num2str(clb)]);
    end
    if ~isempty(find(badincorrectright)),
        subplot(3,4,11)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(badincorrectright),2),xlimits(2)-whldat(find(badincorrectright),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['incorrect right bad n=' num2str(irb)]);
    end
    if ~isempty(find(badincorrectleft)),
        subplot(3,4,12)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(badincorrectleft),2),xlimits(2)-whldat(find(badincorrectleft),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['incorrect left bad n=' num2str(ilb)]);
    end
    
    figure(2)
    clf;    
    if ~isempty(find(Lchoicearm)),
        subplot(4,3,1)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(Lchoicearm),2),xlimits(2)-whldat(find(Lchoicearm),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Lchoicearm']);
    end
    if ~isempty(find(choicepoint)),
        subplot(4,3,2)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(choicepoint),2),xlimits(2)-whldat(find(choicepoint),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['choicepoint']);
    end
    if ~isempty(find(Rchoicearm)),
        subplot(4,3,3)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(Rchoicearm),2),xlimits(2)-whldat(find(Rchoicearm),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Rchoicearm']);
    end
    if ~isempty(find(Lwaterport)),
        subplot(4,3,4)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(Lwaterport),2),xlimits(2)-whldat(find(Lwaterport),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Lwaterport']);
    end
    if ~isempty(find(centerarm)),
        subplot(4,3,5)
        hold on
        plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
        plot(ylimits(2)-whldat(find(centerarm),2),xlimits(2)-whldat(find(centerarm),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['centerarm']);
    end
    if ~isempty(find(Rwaterport)),
        subplot(4,3,6)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(Rwaterport),2),xlimits(2)-whldat(find(Rwaterport),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Rwaterport']);
    end
    if ~isempty(find(Lreturnarm)),
        subplot(4,3,7)
        hold on
          plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
      plot(ylimits(2)-whldat(find(Lreturnarm),2),xlimits(2)-whldat(find(Lreturnarm),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Lreturnarm']);
    end
    if ~isempty(find(delayarea)),
        subplot(4,3,8)
        hold on
          plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
      plot(ylimits(2)-whldat(find(delayarea),2),xlimits(2)-whldat(find(delayarea),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['delayarea']);
    end
    if ~isempty(find(Rreturnarm)),
        subplot(4,3,9)
        hold on
         plot(ylimits(2)-whldat(:,2),xlimits(2)-whldat(:,1),'.','color',[1 1 0],'markersize',7,'linestyle','none');
       plot(ylimits(2)-whldat(find(Rreturnarm),2),xlimits(2)-whldat(find(Rreturnarm),1),'.','color',[0 0 1],'markersize',4,'linestyle','none');
        set(gca,'xlim',ylimits,'ylim',xlimits, 'xtick', [], 'ytick', []);
        title(['Rreturnarm']);
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

        fprintf('total trials n=%i\n', cr+ir+cl+il+crp+clp+irp+ilp+crb+irb+clb+ilb);
    while 1,
        i = input('Save to disk? (yes/no):', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
    if i(1) == 'y'
        fprintf('Saving %s\n', [filebase '_whl_indexes.mat']);

        
        save([filebase '_whl_indexes.mat'],'exploration','correctright','incorrectright','correctleft','incorrectleft',...
            'pondercorrectright','ponderincorrectright','pondercorrectleft','ponderincorrectleft',...
            'badcorrectright','badincorrectright','badcorrectleft','badincorrectleft','delayarea','Rwaterport',...
            'Lwaterport','choicepoint','centerarm','Rchoicearm','Lchoicearm','Rreturnarm','Lreturnarm',...
            'xp','cr', 'ir', 'cl', 'il', 'crp', 'irp', 'clp', 'ilp', 'crb', 'irb', 'clb', 'ilb');
        donewithfile = 1;
    else
        while 1,
            i=input('\nDo you want to try again with the same trigger zones? (yes/no):', 's');
            if strcmp(i,'yes') | strcmp(i,'no'), break; end
        end
        if i(1) == 'y'
            
            exploration = zeros(whlm,1);
            correctright = zeros(whlm,1);
            incorrectright = zeros(whlm,1);
            correctleft = zeros(whlm,1);
            incorrectleft = zeros(whlm,1);
            pondercorrectright = zeros(whlm,1);
            ponderincorrectright = zeros(whlm,1);
            pondercorrectleft = zeros(whlm,1);
            ponderincorrectleft = zeros(whlm,1);
            badcorrectright = zeros(whlm,1);
            badincorrectright = zeros(whlm,1);
            badcorrectleft = zeros(whlm,1);
            badincorrectleft = zeros(whlm,1);
            centerarm = zeros(whlm,1);
            Rchoicearm = zeros(whlm,1);
            Lchoicearm = zeros(whlm,1);
            Rreturnarm = zeros(whlm,1);
            Lreturnarm = zeros(whlm,1);

         
            xp = 0;
            cr = 0;
            ir = 0;
            cl = 0;
            il = 0;
            crp = 0;
            irp = 0;
            clp = 0;
            ilp = 0;
            crb = 0;
            irb = 0;
            clb = 0;
            ilb = 0;
                      
            trigzoneentry = intrigzone(1);
        else
            donewithfile = 1;
        end
    end
end
        
