function cleantracking2(spots, GoodSpots, NonSyncCnt )
figure(10); hold on
[m,n]=size(GoodSpots)
NewGoodSpots = zeros(m,1);
SpotsTooClose = 1;
plot(spots(GoodSpots,3),spots(GoodSpots,4),'.');

% first the program eliminates frames in which there are two spots and they are too far apart or two close
% together to real

i=1;
while(i<=m)
  if (NonSyncCnt(1+spots(GoodSpots(i),1))==1 )
     NewGoodSpots(i) = 1;
     i=i+1;
  else
     if ((((spots(GoodSpots(i),3) - spots(GoodSpots(i+1),3))^2 + (spots(GoodSpots(i),4) - spots(GoodSpots(i+1),4))^2)^(1/2)) < 20 & (((spots(GoodSpots(i),3) - spots(GoodSpots(i+1),3))^2 + (spots(GoodSpots(i),4) - spots(GoodSpots(i+1),4))^2)^(1/2)) > 4)
       NewGoodSpots(i) = 1;
       NewGoodSpots(i+1) = 1;
     else
       plot([spots(GoodSpots(i),3), spots(GoodSpots(i+1),3)],[ spots(GoodSpots(i),4), spots(GoodSpots(i+1),4)],'r');
     end
     i = i+2;
  end
end

% next the program determines if there are large jumps in the frame to frame location of the spots
% specifically, if the spot if frame A (mean location of spots if there are 2) is further from the
% spot in frame A+1 than it is from the spot in frame A+2 (and (A-(A+1))^2 is above some minimal threshold)
% the spot in frame A+1 is likely to be junk and fram A+1 should be tossed.

GoodSpots = GoodSpots(find(NewGoodSpots == 1));
[m,n]=size(GoodSpots)
NewGoodSpots = zeros(m,1);
counter = 0;
os1 = 0; %offset1
os2 = 0; %offset2
i=1;
NewGoodSpots(i) = 1; % the first frame is assumed to be good
while(i<=m-5) % drop the last 4 points for simplicity
     if (NonSyncCnt(1+spots(GoodSpots(i),1))==1 ) % if there's one spot in the first frame
       x1 = spots(GoodSpots(i),3);
       y1 = spots(GoodSpots(i),4);
       os1 = 0;
     else
       x1 = mean([spots(GoodSpots(i),3), spots(GoodSpots(i+1),3)]);
       y1 = mean([spots(GoodSpots(i),4), spots(GoodSpots(i+1),4)]);
       os1 = 1;
     end
     if (NonSyncCnt(1+spots(GoodSpots(i+os1+1),1))==1 )
       x2 = spots(GoodSpots(i+os1+1),3);
       y2 = spots(GoodSpots(i+os1+1),4);
       os2 = 0;
     else 
       x2 = mean([spots(GoodSpots(i+os1+1),3), spots(GoodSpots(i+os1+2),3)]);
       y2 = mean([spots(GoodSpots(i+os1+1),4), spots(GoodSpots(i+os1+2),4)]);
       os2 = 1;
     end
     if (NonSyncCnt(1+spots(GoodSpots(i+os1+os2+2),1))==1 )
       x3 = spots(GoodSpots(i+os1+os2+2),3);
       y3 = spots(GoodSpots(i+os1+os2+2),4);
     else 
       x3 = mean([spots(GoodSpots(i+os1+os2+2),3), spots(GoodSpots(i+os1+os2+3),3)]);
       y3 = mean([spots(GoodSpots(i+os1+os2+2),4), spots(GoodSpots(i+os1+os2+3),4)]);
     end
       % if point a is further from a+1 than a+2, a-(a+1) is above a threshold, a+1 is probably junk
     if (((x1-x2)^2+(y1-y2)^2)^(1/2) > 13 & ((x1-x2)^2+(y1-y2)^2)^(1/2) > ((x1-x3)^2+(y1-y3)^2)^(1/2))
       plot([x1, x2], [ y1, y2],'g');
       i = i+1+os2;
       counter = counter +1;
     end
      % if (os2 == 0) 
     i=i+1+os1;
end
       
