function HeadPos = difspots2(GoodSpots, spots, NonSyncCnt,nFrames);
 % now make trajectory
  HeadPos = -1*ones(nFrames,4);
  [m,n] = size(GoodSpots);
  i = 1;
  j = 1;
  while (i<=nFrames & j<=m)
    if (i == 1+spots(GoodSpots(j),1))
      if (NonSyncCnt(1+spots(GoodSpots(j),1))==1 )
        HeadPos(i,1:2) = spots(GoodSpots(j),3:4);
        HeadPos(i,3:4) = spots(GoodSpots(j),3:4);
	j=j+1;
      else
        HeadPos(i,1:2) = mean(spots(GoodSpots(j:j+1),3:4));
        HeadPos(i,3:4) = mean(spots(GoodSpots(j:j+1),3:4));
	j=j+2;
      end
    end
    i=i+1;
  end
