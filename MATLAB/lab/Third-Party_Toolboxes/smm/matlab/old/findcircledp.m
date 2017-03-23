function findcircledp(filebase)

filename = [filebase '.whl'];
whldat = load(filename);

figure(1)
clf;
subplot(2,1,1);
% in order to view the maze in the correct orientation the values in whldat are transformed
plot(whldat(:,1),whldat(:,2),'.','color',[1 0 0],'markersize',7,'linestyle','none');
  set(gca,'xlim',[0 368],'ylim',[0 240]);
  zoom on
  
  
  fprintf('\ndesignation of trial beginning & end points\n------------------------------\n');
input('   In the figure window, select the right port/delay area.\n   Then click back in this window and hit ENTER...','s');
trig1x = xlim;
trig1y = ylim; 
% right port
rp = find(whldat(:,1)>=trig1x(1) & whldat(:,1)<=trig1x(2) & whldat(:,2)>=trig1y(1) & whldat(:,2)<=trig1y(2));

plot(whldat(:,1),whldat(:,2),'.','color',[1 0 0],'markersize',7,'linestyle','none');
  set(gca,'xlim',[0 368],'ylim',[0 240]);
  zoom on
input('   Select the bottom trigger zone left port/delay area.\n   Then click back in this window and hit ENTER...','s');
trig2x = xlim;
trig2y = ylim; 
% left port
lp = find(whldat(:,1)>=trig2x(1) & whldat(:,1)<=trig2x(2) & whldat(:,2)>=trig2y(1) & whldat(:,2)<=trig2y(2));

plot(whldat(:,2),368-whldat(:,1),'.','color',[1 0 0],'markersize',7,'linestyle','none');
  set(gca,'xlim',[0 240],'ylim',[0 368]);

% the delay period is when the animal is at the right port or the left port
dp = find((whldat(:,1)>=trig1x(1) & whldat(:,1)<=trig1x(2) & whldat(:,2)>=trig1y(1) & whldat(:,2)<=trig1y(2)) | ...
    (whldat(:,1)>=trig2x(1) & whldat(:,1)<=trig2x(2) & whldat(:,2)>=trig2y(1) & whldat(:,2)<=trig2y(2)));

  
subplot(2,1,2);
plot(whldat(dp,1),whldat(dp,2),'.','color',[1 0 0],'markersize',7,'linestyle','none');

dp = dp';

while 1,
  i = input('Save to disk (yes/no)? ', 's');
  if strcmp(i,'yes') | strcmp(i,'no'), break; end
end
if i(1) == 'y'
    load([filebase '_whl_indexes.mat']);
    fprintf('Saving %s\n', [filebase '_whl_indexes.mat']);
 
    fprintf('total trials n=%i\n', cr+ir+cl+il+crp+irp+ilp+crb+irb+clb+ilb);
    save([filebase '_whl_indexes.mat'],'correctright','incorrectright','correctleft','incorrectleft',...
        'pondercorrectright','ponderincorrectright','pondercorrectleft','ponderincorrectleft',...
        'badcorrectright','badincorrectright','badcorrectleft','badincorrectleft',... 
        'cr', 'ir', 'cl', 'il', 'crp', 'irp', 'clp', 'ilp', 'crb', 'irb', 'clb', 'ilb', 'rp', 'lp', 'dp');
end
