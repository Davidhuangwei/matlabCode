function MazeTrackClean(spots, GoodSpots, NonSyncCnt )
figure(20); hold on
[m,n]=size(GoodSpots)
NewGoodSpots = zeros(m,1);
SpotsTooClose = 1;
plot(spots(GoodSpots,3),spots(GoodSpots,4),'.');

% first the part of the program eliminates frames in which there are two spots and they are too far apart to be real
% it plots in red a line connecting the spots from the to be rejected frames.

i=1;
while(i<=m)
  if (NonSyncCnt(1+spots(GoodSpots(i),1))==1 )
     NewGoodSpots(i) = 1;
     i=i+1;
  else
     if ((((spots(GoodSpots(i),3) - spots(GoodSpots(i+1),3))^2 + (spots(GoodSpots(i),4) - spots(GoodSpots(i+1),4))^2)^(1/2)) < 20 )
       NewGoodSpots(i) = 1;
       NewGoodSpots(i+1) = 1;
     else
       plot([spots(GoodSpots(i),3), spots(GoodSpots(i+1),3)],[ spots(GoodSpots(i),4), spots(GoodSpots(i+1),4)],'r');
     end
     i = i+2;
  end
end

GoodSpots = GoodSpots(find(NewGoodSpots == 1));
[m,n]=size(GoodSpots)


% This part of the program determines if there are large jumps in the frame to frame location of the 
% spots specifically, if the spot in frame B is more than twice as far from A than B is from C, and 
% |B-A| is above a threshold, B is probably junk and should be tossed. The program uses resursion to 
% determine if large jumps occur for successive frames but then return.

NewGoodSpots = zeros(m,1);
NewGoodSpots(1) = 1; % the first frame is assumed to be good

A=1;
B = A+1+(NonSyncCnt(1+spots(GoodSpots(A),1))-1); % B is either 1 or two lines after A depending on how many spots are in frame A
C = B+1+(NonSyncCnt(1+spots(GoodSpots(B),1))-1); % C is either 1 or two lines after B depending on how many spots are in frame A
oldC = C;

while (C+1<=m)    
     if (NonSyncCnt(1+spots(GoodSpots(A),1))==1 ) % if there's one spot in frame A
       Ax = spots(GoodSpots(A),3);
       Ay = spots(GoodSpots(A),4);
     else
       Ax = mean([spots(GoodSpots(A),3), spots(GoodSpots(A+1),3)]);
       Ay = mean([spots(GoodSpots(A),4), spots(GoodSpots(A+1),4)]);
     end
     if (NonSyncCnt(1+spots(GoodSpots(B),1))==1 ) % if there's one spot in frame B
       Bx = spots(GoodSpots(B),3);
       By = spots(GoodSpots(B),4);
       Boffset = 0;
     else 
       Bx = mean([spots(GoodSpots(B),3), spots(GoodSpots(B+1),3)]);
       By = mean([spots(GoodSpots(B),4), spots(GoodSpots(B+1),4)]);
       Boffset = 1;
     end
     if (NonSyncCnt(1+spots(GoodSpots(C),1))==1 ) % if there's one spot in frame C
       Cx = spots(GoodSpots(C),3);
       Cy = spots(GoodSpots(C),4);
       Coffset = 0;
     else 
       Cx = mean([spots(GoodSpots(C),3), spots(GoodSpots(C+1),3)]);
       Cy = mean([spots(GoodSpots(C),4), spots(GoodSpots(C+1),4)]);
       Coffset = 1;
     end

       % if the spot in frame B is more than twice as far from A than B is from C, and |B-A| is above a threshold, B is probably junk
     if (((Ax-Bx)^2+(Ay-By)^2)^(1/2) > 15 & ((Ax-Cx)^2+(Ay-Cy)^2)^(1/2) < (((Ax-Bx)^2+(Ay-By)^2)^(1/2))/2 )    
       plot([Ax, Bx], [ Ay, By],'g');
       % A stays the same
       B = oldC;
       C = oldC+1+(NonSyncCnt(1+spots(GoodSpots(oldC),1))-1); % next frame after the old C frame
       oldC = C; % set new oldC

       % if C is further from B than B is from A (i.e. animal is moving away from point A) or if jitter is small, keep B
     else if (((Ax-Bx)^2+(Ay-By)^2)^(1/2) < 20 | ((Cx-Bx)^2+(Cy-By)^2) > ((Ax-Bx)^2+(Ay-By)^2))
       NewGoodSpots(B) = 1;
       if (NonSyncCnt(1+spots(GoodSpots(B),1))==2 ) % write both spots in frame B if there are two
         NewGoodSpots(B+1) = 1;
       end
       A = B;
       B = oldC;
       C = oldC+1+(NonSyncCnt(1+spots(GoodSpots(oldC),1))-1); % next frame after the old C frame
       oldC = C; % set new oldC

       else 
         % get the next spot too if neither of the above are true yet
         C = C+1+Coffset;
       end
     end
end

GoodSpots = GoodSpots(find(NewGoodSpots == 1));
[m,n]=size(GoodSpots)

