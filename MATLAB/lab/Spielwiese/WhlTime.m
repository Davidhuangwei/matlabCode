function WhlTime(FileBase,whl,spike,varargin)
[file,overwrite] = DefaultArgs(varargin,{[],0});

figure
for n=unique(spike.ind)'
  good = find(spike.ind==n & spike.good);
  
  if length(good)>2000
    good2 = good([1:10:end]);
  else
    good2 = good;
  end
  
  [ccg, t] = CCG(spike.t(good),1,20,50,20000);
  
  clf
  subplot(211)
  plot(spike.t(good2)/20000,spike.ph(good2)*180/pi,'.')
  hold on
  plot(spike.t(good2)/20000,spike.ph(good2)*180/pi+360,'.')
  plot(spike.t(good2)/20000,spike.ph(good2)*180/pi+720,'.')
  plot([1:length(whl.whl(:,3))]/whl.rate,200*(whl.whl(:,3)/max(whl.whl(:,3))-1))
  
  subplot(223)
  plot(whl.plot(1:100:end,1),whl.plot(1:100:end,2),'o', ...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[0.9 0.9 0.9]);
  hold on
  scatter(spike.pos(good2,1),spike.pos(good2,2),30,(spike.ph(good2))*180/pi);
  
  subplot(224)
  bar(t,ccg);
  xlim([min(t) max(t)]);
  
  waitforbuttonpress;
  whatbutton = get(gcf,'SelectionType');
  switch whatbutton
   case 'normal'  % left -- PC 
    type = 1;
   case 'alt'     % right -- bad
    type = 0;
   case 'extend'  % mid -- go back 
    type = 2;
   case 'open'    % double click -- go back 
    a=5;
  end
end

return;

%indx = find(whl.ctr(:,1)>0);
whlspeed = diff(whl.whl(:,3));
whlspeed(end+1) = whlspeed(end);
indx = whlspeed~=0;

whll(:,1) = indx;
whll(:,2:3) = whl.whl(indx,1:2);
whll(:,4) = whl.whl(indx,3);


for n=1:1000
  clf;
  trial = [(n-1)*100+1:n*100];
  
  subplot(3,1,[1:2])
  plot(whll(trial,2),whll(trial,3),'.-');
  hold on 
  plot(whll(trial(1),2),whll(trial(1),3),'go') ;
  plot(whll(trial(end),2),whll(trial(end),3),'ro');
  xlim([min(whll(:,2)) max(whll(:,2))])
  ylim([min(whll(:,3)) max(whll(:,3))])
  
  subplot(313)
  plot(whll(trial,1),whll(trial,4),'.');
  waitforbuttonpress;
end
  
