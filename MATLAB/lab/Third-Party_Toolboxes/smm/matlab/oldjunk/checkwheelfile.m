
  goodWhlpos=find(Whl(:,1)~=-1);
  Whl = Whl(goodWhlpos,:);
  fprintf('\nThe Whl file data\n----------------------\n');
  while ~strcmp(input('   Hit ENTER to show the next 100 samples, or type ''done''+ENTER to proceed...','s'),'done'),
    k = k+1;
		if k*100 > length(Whl), break; end
    cla;
    set(gca,'xlim',[0 368],'ylim',[0 240]);
    plot(Whl((k-1)*100+1:k*100,1),Whl((k-1)*100+1:k*100,2),'.','color',[1 0 0],'markersize',10,'linestyle','none');
    plot(Whl((k-1)*100+1:k*100,3),Whl((k-1)*100+1:k*100,4),'.','color',[0 1 0],'markersize',10,'linestyle','none');
    for j=(k-1)*100+1:k*100, line([Whl(j,1) Whl(j,3)],[Whl(j,2) Whl(j,4)],'color',[0 0 0]); end
    set(gca,'xlim',[0 368],'ylim',[0 240]);
  end

  
  	cleanHeadPos = HeadPos(HeadPos(:,1)~=-1&HeadPos(:,2)~=-1&HeadPos(:,3)~=-1&HeadPos(:,4)~=-1,:);
  fprintf('\nTrajectory of the rat\n----------------------\n');
  while ~strcmp(input('   Hit ENTER to show the next 100 samples, or type ''done''+ENTER to proceed...','s'),'done'),
    k = k+1;
		if k*100 > length(cleanHeadPos), break; end
    cla;
    set(gca,'xlim',[0 368],'ylim',[0 240]);
    plot(cleanHeadPos((k-1)*100+1:k*100,1),cleanHeadPos((k-1)*100+1:k*100,2),'.','color',[1 0 0],'markersize',10,'linestyle','none');
    plot(cleanHeadPos((k-1)*100+1:k*100,3),cleanHeadPos((k-1)*100+1:k*100,4),'.','color',[0 1 0],'markersize',10,'linestyle','none');
    for j=(k-1)*100+1:k*100, line([cleanHeadPos(j,1) cleanHeadPos(j,3)],[cleanHeadPos(j,2) cleanHeadPos(j,4)],'color',[0 0 0]); end
    set(gca,'xlim',[0 368],'ylim',[0 240]);
  end

