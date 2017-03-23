function ggouttr=FindTrialsNoEvt(FileBase,whlctr,varargin)
[CutPoints] = DefaultArgs(varargin,{3});
%% find trials based on rat's location in maze 

whlplot = whlctr(find(whlctr(:,2)>0),:);
  
plot(whlplot(:,1),whlplot(:,2),'o','markersize',5,'markeredgecolor','none','markerfacecolor',[0.9 0.9 0.9]);

switch CutPoints
 case 1 
  title('1st click for boundery, 2nd click for area (both in x)');
  [boundx boundy] =  ginput(2);
  if boundx(2)<boundx(1)
    infield = zeros(length(whlctr),1);
    infield(whlctr(:,1)<=boundx(1)) = 1;
  else
    infield = zeros(length(whlctr),1);
    infield(whlctr(:,1)>=boundx(1)) = 1;
  end
 case 2
  title('mark left and right boundery (both in x)');
  [boundx boundy] =  ginput(2);
  intv = sort(boundx);
  infield = ~WithinRanges(whlctr(:,1),intv');
 case 3
  title('mark EXCLUDED area');
  [infield ply] = myClusterPoints(whlctr,0); 
 case 4
  title('mark square around cut ');
  [infield ply] = myClusterPoints(whlctr,0); 
 case 5
  title('open field ');
  return;
 case 6
  title('mark INCLUDED area');
  [infield ply] = myClusterPoints(whlctr,0);
  infield = ~infield;
end

%% get the intervals
%% find the beginning
outtr = ~infield & whlctr(:,1)>0;
douttrp = 1.0*find(~(~diff(outtr)));


xbouttr(:,1) = douttrp;
a = length(find(ismember(find(~infield),[xbouttr(1):xbouttr(2)])))<=1;
b = length(find(ismember(find(~infield),[xbouttr(end-1):xbouttr(end)])))<=1
if a & ~b
  bouttr = xbouttr(2:end,1);
elseif ~a & b
  bouttr = xbouttr(1:end-1,1);
elseif a & b
  bouttr = xbouttr(2:end-1,1);
else
  bouttr = xbouttr;
end

gouttr = reshape(bouttr,2,length(bouttr)/2)';
  
if CutPoints == 4
  gouttr(2:end,1) = gouttr(1:end-1,2)+1; 
  gouttr(1,1) = min(find(whlctr(:,1)>0));
  %gouttr(1:end-1,2) = gouttr(2:end,1)-1; 
  %gouttr(end,2) = whlctr(end,2);
end

clf
dgouttr = gouttr(:,2)-gouttr(:,1);
hist(dgouttr,100);
title('mark upper and lower boundery of good trial lengths');
[itix itiy] = ginput(2);
ggouttr = gouttr(dgouttr>min(itix) & dgouttr<max(itix),:);

close all;

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %% check for missing time stamps:
  if ~min(abs(diff(nevt(:,2))))
    fprintf('WARNING: time stamps are missing\n');
  end
  
  evtt = round(nevt(:,1)/Rate);
  evtt(evt(:,1)==0)=1;
  
  %% identify trials
  ntrials = sortrows([evtt(:,:); evtt(2:end-1,:)-1],1);
  xtrials = reshape(ntrials,2,length(ntrials)/2)';
  xtdir = sign(diff(nevt(:,2)));
  
  trials = xtrials(xtdir~=0,:);
  tdir = xtdir(xtdir~=0,:);
    
  figure;
  hist((trials(:,2)-trials(:,1))/WhlRate,100);
  title('determine threshold for duration of trial');
  [thx thy] = ginput(1);
  close;
  
  good = find((trials(:,2)-trials(:,1))/WhlRate<thx);
  gtrials = trials(good,:);
  gtdir = tdir(good);
  
  figure;
  hist((gtrials(:,2)-gtrials(:,1))/WhlRate,100);
  title('determine threshold for duration of trial');
  [thx thy] = ginput(1);
  close;
    
  ggood = find((gtrials(:,2)-gtrials(:,1))/WhlRate<thx);
  
  trial.itv = gtrials(ggood,:);
  trial.dir = gtdir(ggood);
  
  %% mark stimmulation
  trial.stim = round(evt(find(evt(:,2)==tevt.st),1)/Rate);
  
  save([FileBase '.trials'],'trial');
  
%else
  load([FileBase '.trials'],'-MAT');
%end
  
return;
