function GoodSpots2 = difspots3(GoodSpots, Spots, NonSyncCnt);
 [m,n]=size(GoodSpots);
 GoodSpots2 = zeros(m,1);
os1 = 0; %offset1
os2 = 0; %offset2
i=1;
while(i<=m-4) % drop the last 4 points for simplicity
     if (NonSyncCnt(1+spots(GoodSpots(i),1))==1 )
       x1 = spots(GoodSpots(i),3);
       y1 = spots(GoodSpots(i),4);
       os1 = 0;
     else
       x1 = mean(spots(GoodSpots(i),3), spots(GoodSpots(i+1),3));
       y1 = mean(spots(GoodSpots(i),4), spots(GoodSpots(i+1),4));
       os1 = 1;
     end
     if (NonSyncCnt(1+spots(GoodSpots(i+os1+1),1))==1 )
       x2 = spots(GoodSpots(i+os1+1),3);
       y2 = spots(GoodSpots(i+os1+1),4);
       os2 = 0;
     else 
       x2 = mean(spots(GoodSpots(i+os1+1),3), spots(GoodSpots(i+os1+2),3));
       y2 = mean(spots(GoodSpots(i+os1+1),4), spots(GoodSpots(i+os1+2),4));
       os2 = 1;
     end
     if (NonSyncCnt(1+spots(GoodSpots(i+os1+os2+2),1))==1 )
       x3 = spots(GoodSpots(i+os1+os2+2),3);
       y3 = spots(GoodSpots(i+os1+os2+2),4);
     else 
       x3 = mean(spots(GoodSpots(i+os1+os2+2),3), spots(GoodSpots(i+os1+os2+3),3));
       y3 = mean(spots(GoodSpots(i+os1+os2+2),4), spots(GoodSpots(i+os1+os2+3),4));
     end
     if (((x1-x2)^2+(y1-y2)^2)^(1/2) > ((x1-x3)^2+(y1-y3)^2)^(1/2))
       plot([x1,y1],[x2,y2],'r');
     end
     i=i+1+os1;
end
       