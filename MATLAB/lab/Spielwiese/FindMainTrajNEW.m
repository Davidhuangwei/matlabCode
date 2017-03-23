function [strace ltrace] = FindMainTrajNEW(trials,whl,varargin)
[dd,overwrite] = DefaultArgs(varargin,{1.0,0});
%%
%% finds the average trace of mny traces
%%
%% input: whl file (nx2)
%%        beginning and end of trials in whl sampling (mx2)
%% (optional): dd is the distance of interpolated points
%%
%% output: ltrace = linearized position and angle
%%         strace = mean position, smoothed

%% get positions from whl data:
%pos = whl(find(WithinRanges(find(whl(:,1)),trials)),:);
pos = whl(find(WithinRanges([1:length(whl)]',trials)),:);

%%
figure
XBin = [min(pos(:,1)):(max(pos(:,1))-min(pos(:,1)))/100:max(pos(:,1))];
YBin = [min(pos(:,2)):(max(pos(:,2))-min(pos(:,2)))/100:max(pos(:,2))]; 
hh = hist2(pos,XBin,YBin);
for n=1:size(hh,1)
  shh(:,n) = smooth(hh(:,n),5,'lowess');
end
for n=1:size(hh,2)
  shh(n,:) = smooth(shh(n,:)',5,'lowess')';
end
  
xbin = XBin(1:end-1)+mean(diff(XBin))/2;
ybin = YBin(1:end-1)+mean(diff(YBin))/2;
imagesc(xbin,ybin,shh');
caxis(prctile(shh(:),[0 99]));

tt=1;
while tt
  %% good='left'; bad='right'; cut='mid';
  [px,py,button]=PointInput;
  switch button
   case 1  % left -- good
    trace(tt,:) = [px py];
    clf;
    imagesc(xbin,ybin,shh');
    caxis(prctile(shh(:),[0 99]));
    hold;
    plot(trace(1:tt,1),trace(1:tt,2),'ro-','markersize',10,'markeredgecolor','none','markerfacecolor',[1 0 0]);
    tt = tt+1;
   case 2  % right -- bad
    break
   case 3  % mid -- go back
    clf;
    tt = tt-1;
    imagesc(xbin,ybin,shh');
    caxis(prctile(shh(:),[0 99]));
    hold;
    plot(trace(1:tt-1,1),trace(1:tt-1,2),'ro-','markersize',10,'markeredgecolor','none','markerfacecolor',[1 0 0]);
  end
end

%keyboard;

if size(trace,1)>2

  %% number of points to interpolate (dd=1):
  d = sqrt(diff(trace(:,1)).^2 + diff(trace(:,2)).^2);
  num = round(d/(min(d)/2));
  %% 
  dx = sqrt(d.^2-diff(trace(:,2)).^2)./num;
  dy = sqrt(d.^2-diff(trace(:,1)).^2)./num;
  
  ftrace = [];
  for n=1:length(trace)-1
    
    if (trace(n+1,1)-trace(n,1))
      xx = [trace(n,1):(trace(n+1,1)-trace(n,1))/num(n):trace(n+1,1)]';
    else
      xx = ones(num(n)+1,1)*trace(n,1);
    end
    
    if (trace(n+1,2)-trace(n,2))
      yy = [trace(n,2):(trace(n+1,2)-trace(n,2))/num(n):trace(n+1,2)]';
    else
      yy = ones(num(n)+1,1)*trace(n,2);
    end
    
    ftrace = [ftrace; [xx yy]];
    clear xx yy;
  end
  
  %% smooth:
  strace(:,1) = smooth(ftrace(:,1),5,'lowess');
  strace(:,2) = smooth(ftrace(:,2),5,'lowess');
  strace(1:3,:) = ftrace(1:3,:);
  strace(end-3:end,:) = ftrace(end-3:end,:);
  
else
  
  %strace(:,1) = [min(trace(:,1)):abs(diff(trace(:,1)))/10:max(trace(:,1))]';
  %strace(:,2) = [min(trace(:,2)):abs(diff(trace(:,2)))/10:max(trace(:,2))]';
  strace(:,1) = [trace(1,1):diff(trace(:,1))/10:trace(end,1)]';
  strace(:,2) = [trace(1,2):diff(trace(:,2))/10:trace(end,2)]';
end
  
%% linear position: 
ltrace(1,1) = 0;
ltrace(2:length(strace),1) = cumsum(abs(diff(strace(:,1))+i*diff(strace(:,2))));

ltrace(1:end-1,2) = angle(diff(strace(:,1))+i*diff(strace(:,2)));
ltrace(end,2) = ltrace(end-1,2);


%keyboard;
%% correct direction:
TrialBeg = mean(whl(trials(:,1),:),1);
TrialEnd = mean(whl(trials(:,2),:),1);

if abs((strace(1,1)-TrialBeg(1))+i*(strace(1,2)-TrialBeg(2))) > abs((strace(1,1)-TrialEnd(1))+i*(strace(1,2)-TrialEnd(2))) 
  strace = flipud(strace);
  ltrace = flipud(ltrace);
end

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% interpolate 
%figure
%intrace(:,1) = [round(min(trace(:,1))):1:round(max(trace(:,1)))]';
%intrace(:,2) = interp1(trace(:,1),trace(:,2),intrace(:,1));
%plot(intrace(:,1),intrace(:,2));

%ltrace(:,3) = strace;

%sltrace = mySmooth(unwrap(ltrace(:,2)),3,3);
%sltrace(1:3,1) = ltrace(1:3,2);
%sltrace(end-3:end,1) = ltrace(end-3:end,2);
