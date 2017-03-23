function HeadPos = clean2spots(nFrames,GoodSpots,spots,NonSyncCnt)


      plot(spots(find(spots(:,1)==wierd(1) | spots(:,1)==wierd(2) | spots(:,1)==wierd(3) | spots(:,1)==wierd(4) | spots(:,1)==wierd(5)),3),spots(find(spots(:,1)==wierd(1) | spots(:,1)==wierd(2) | spots(:,1)==wierd(3) | spots(:,1)==wierd(4) | spots(:,1)==wierd(5))+1,3), spots(find(spots(:,1)==wierd(1) | spots(:,1)==wierd(2) | spots(:,1)==wierd(3) | spots(:,1)==wierd(4) | spots(:,1)==wierd(5)),4),spots(find(spots(:,1)==wierd(1) | spots(:,1)==wierd(2) | spots(:,1)==wierd(3) | spots(:,1)==wierd(4) | spots(:,1)==wierd(5))+1,4),'.','MarkerEdgeColor','r')

     [m,n] = size(wierd);
     indexes=zeros(m,1);
for i=1:m indexes=find(ismember(spots(:,1),wierd)); end

wierd = find(HeadPos(:,3)>=140 & HeadPos(:,3)<=150 & HeadPos(:,4)>=49 & HeadPos(:,4)<=56);

plot(spots(indexes,3),spots(indexes,4),'.','MarkerEdgeColor','r')

hp = difspots2(GoodSpots, spots,NonSyncCnt,nFrames);

 plot(a(find(a(:,1)~=-1),1),a(find(a(:,2)~=-1),2) ,'.')

