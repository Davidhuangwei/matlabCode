function sortmazetrials(filebase)

filename = [filebase '.whl'];
whldat = load(filename);

correctright = [];
incorrectright = [];
correctleft = [];
incorrectleft = [];
pondercorrectright = [];
ponderincorrectright = [];
pondercorrectleft = [];
ponderincorrectleft = [];
badcorrectright = [];
badincorrectright = [];
badcorrectleft = [];
badincorrectleft = [];

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

figure(1)
clf;
subplot(2,1,1);
% in order to view the maze in the correct orientation the values in whldat are transformed
plot(whldat(:,1),whldat(:,2),'.','color',[1 0 0],'markersize',7,'linestyle','none');
  set(gca,'xlim',[0 368],'ylim',[0 240]);
  zoom on
  
fprintf('\ndesignation of trial beginning & end points\n------------------------------\n');
input('   In the figure window, select a trigger zone to start a new trial.\n   Then click back in this window and hit ENTER...','s');
trig1x = xlim;
trig1y = ylim; 

plot(whldat(:,1),whldat(:,2),'.','color',[1 0 0],'markersize',7,'linestyle','none');
  set(gca,'xlim',[0 368],'ylim',[0 240]);
  zoom on
input('   Select the other trigger zone to start a new trial.\n   Then click back in this window and hit ENTER...','s');
trig2x = xlim;
trig2y = ylim; 

plot(whldat(:,2),368-whldat(:,1),'.','color',[1 0 0],'markersize',7,'linestyle','none');
  set(gca,'xlim',[0 240],'ylim',[0 368]);

subplot(2,1,2);
[whldat_m n] = size(whldat);

%find when the rat first enters the trig zone
trigzoneentries = find((whldat(:,1)>=trig1x(1) & whldat(:,1)<=trig1x(2) & whldat(:,2)>=trig1y(1) & whldat(:,2)<=trig1y(2))...
    | (whldat(:,1)>=trig2x(1) & whldat(:,1)<=trig2x(2) & whldat(:,2)>=trig2y(1) & whldat(:,2)<=trig2y(2)));
intrigzone = trigzoneentries(1);

while (1)
    % find when the rat leaves the trig zone
    notintrigzone = find(~((whldat(:,1)>=trig1x(1) & whldat(:,1)<=trig1x(2) & whldat(:,2)>=trig1y(1) & whldat(:,2)<=trig1y(2))...
    | (whldat(:,1)>=trig2x(1) & whldat(:,1)<=trig2x(2) & whldat(:,2)>=trig2y(1) & whldat(:,2)<=trig2y(2))));
    if isempty(notintrigzone),
        break;
    end
    newtrialtrigger = notintrigzone(find(notintrigzone>=intrigzone));
    
    % trigger end of trial when rat reenters the trig zone
    trigzoneentries = find((whldat(:,1)>=trig1x(1) & whldat(:,1)<=trig1x(2) & whldat(:,2)>=trig1y(1) & whldat(:,2)<=trig1y(2))...
        | (whldat(:,1)>=trig2x(1) & whldat(:,1)<=trig2x(2) & whldat(:,2)>=trig2y(1) & whldat(:,2)<=trig2y(2)));
    if (isempty(trigzoneentries) | isempty(newtrialtrigger)),
        break;
    end
    endoftrial = trigzoneentries(find(trigzoneentries>=newtrialtrigger(1)));
    
    if isempty(endoftrial),
        break;
    end
    plot(whldat(newtrialtrigger(1):endoftrial(1),2),368-whldat(newtrialtrigger(1):endoftrial(1),1),'.','color',[1 0 0],'markersize',7,'linestyle','none');
    set(gca,'xlim',[0 240],'ylim',[0 368]);
    tryagain = 1;
    while (tryagain == 1)
        keyin = input('trial classification - [partial trial=x]/[correct=c,incorrect=i,][right=r,left=l][ponder=p,bad=b] :', 's');
        switch (keyin)
        case 'x'
            tryagain = 0;
        case 'cr'
            correctright = [correctright newtrialtrigger(1):endoftrial(1)];
            tryagain = 0;
            
        case 'ir'
            incorrectright = [incorrectright newtrialtrigger(1):endoftrial(1)];
            tryagain = 0;
        case 'cl'
            correctleft = [correctleft newtrialtrigger(1):endoftrial(1)];
            tryagain = 0;
        case 'il'
            incorrectleft = [incorrectleft newtrialtrigger(1):endoftrial(1)];
            tryagain = 0;
        case 'crp'
            pondercorrectright = [pondercorrectright newtrialtrigger(1):endoftrial(1)];
            tryagain = 0;
        case 'irp'
            ponderincorrectright = [ponderincorrectright newtrialtrigger(1):endoftrial(1)];
            tryagain = 0;
        case 'clp'
            pondercorrectleft = [pondercorrectleft newtrialtrigger(1):endoftrial(1)];
            tryagain = 0;
        case 'ilp'
            ponderincorrectleft = [ponderincorrectleft newtrialtrigger(1):endoftrial(1)];
            tryagain = 0;
        case 'crb'
            badcorrectright = [badcorrectright newtrialtrigger(1):endoftrial(1)];
            tryagain = 0;
        case 'irb'
            badincorrectright = [badincorrectright newtrialtrigger(1):endoftrial(1)];
            tryagain = 0;
        case 'clb'
            badcorrectleft = [badcorrectleft newtrialtrigger(1):endoftrial(1)];
            tryagain = 0;
        case 'ilb'
            badincorrectleft = [badincorrectleft newtrialtrigger(1):endoftrial(1)];
            tryagain = 0;
        otherwise
            fprintf('unrecognized input -- try again------------------------------\n');
        end
    end
    if length(endoftrial) < 2,
        break;
    end
    intrigzone = endoftrial(2);
end 
clf;
if ~isempty(correctright),
    subplot(3,4,1)
    plot(whldat(correctright,2),368-whldat(correctright,1),'.','color',[1 0 0],'markersize',4,'linestyle','none');
    set(gca,'xlim',[0 240],'ylim',[0 368]);
    title(['correct right']);
end
if ~isempty(correctleft),
    subplot(3,4,2)
    plot(whldat(correctleft,2),368-whldat(correctleft,1),'.','color',[1 0 0],'markersize',4,'linestyle','none');
    set(gca,'xlim',[0 240],'ylim',[0 368]);
    title('correct left');
end
if ~isempty(incorrectright),
    subplot(3,4,3)
    plot(whldat(incorrectright,2),368-whldat(incorrectright,1),'.','color',[1 0 0],'markersize',4,'linestyle','none');
    set(gca,'xlim',[0 240],'ylim',[0 368]);
    title('incorrect right');
end
if ~isempty(incorrectleft),
    subplot(3,4,4)
    plot(whldat(incorrectleft,2),368-whldat(incorrectleft,1),'.','color',[1 0 0],'markersize',4,'linestyle','none');
    set(gca,'xlim',[0 240],'ylim',[0 368]);
    title('incorrect left');
end
if ~isempty(pondercorrectright),
    subplot(3,4,5)
    plot(whldat(pondercorrectright,2),368-whldat(pondercorrectright,1),'.','color',[1 0 0],'markersize',4,'linestyle','none');
    set(gca,'xlim',[0 240],'ylim',[0 368]);
    title('ponder correct right');
end
if ~isempty(pondercorrectleft),
    subplot(3,4,6)
    plot(whldat(pondercorrectleft,2),368-whldat(pondercorrectleft,1),'.','color',[1 0 0],'markersize',4,'linestyle','none');
    set(gca,'xlim',[0 240],'ylim',[0 368]);
    title('ponder correct left');
end
if ~isempty(ponderincorrectright),
    subplot(3,4,7)
    plot(whldat(ponderincorrectright,2),368-whldat(ponderincorrectright,1),'.','color',[1 0 0],'markersize',4,'linestyle','none');
    set(gca,'xlim',[0 240],'ylim',[0 368]);
    title('ponder incorrect right');
end
if ~isempty(ponderincorrectleft),
    subplot(3,4,8)
    plot(whldat(ponderincorrectleft,2),368-whldat(ponderincorrectleft,1),'.','color',[1 0 0],'markersize',4,'linestyle','none');
    set(gca,'xlim',[0 240],'ylim',[0 368]);
    title('ponder incorrect left');
end
if ~isempty(badcorrectright),
    subplot(3,4,9)
    plot(whldat(badcorrectright,2),368-whldat(badcorrectright,1),'.','color',[1 0 0],'markersize',4,'linestyle','none');
    set(gca,'xlim',[0 240],'ylim',[0 368]);
    title('bad correct right');
end
if ~isempty(badcorrectleft),
    subplot(3,4,10)
    plot(whldat(badcorrectleft,2),368-whldat(badcorrectleft,1),'.','color',[1 0 0],'markersize',4,'linestyle','none');
    set(gca,'xlim',[0 240],'ylim',[0 368]);
    title('bad correct left');
end
if ~isempty(badincorrectright),
    subplot(3,4,11)
    plot(whldat(badincorrectright,2),368-whldat(badincorrectright,1),'.','color',[1 0 0],'markersize',4,'linestyle','none');
    set(gca,'xlim',[0 240],'ylim',[0 368]);
    title('bad incorrect right');
end
if ~isempty(badincorrectleft),
    subplot(3,4,12)
    plot(whldat(badincorrectleft,2),368-whldat(badincorrectleft,1),'.','color',[1 0 0],'markersize',4,'linestyle','none');
    set(gca,'xlim',[0 240],'ylim',[0 368]);
    title('bad incorrect left');
end

while 1,
  i = input('\n\nSave to disk (yes/no)? ', 's');
  if strcmp(i,'yes') | strcmp(i,'no'), break; end
end
if i(1) == 'y'
    fprintf('Saving %s\n', [filebase '_whl_indexes.mat']);
    save([filebase '_whl_indexes.mat'],'correctright','incorrectright','correctleft','incorrectleft',...
        'pondercorrectright','ponderincorrectright','pondercorrectleft','ponderincorrectleft',...
        'badcorrectright','badincorrectright','badcorrectleft','badincorrectleft');
end
