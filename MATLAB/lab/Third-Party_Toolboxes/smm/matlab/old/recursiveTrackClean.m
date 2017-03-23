% This program determines if there are large jumps in the frame to frame location of the spots
% specifically, if the spot in frame B is more than twice as far from A than B is from C, and 
% |B-A| is above a threshold, B is probably junk and should be tossed.


function keepB = recursiveTrackClean(spots, GoodSpots, NonSyncCnt, m, A, B, C);
if (C+1<=m)
     if (NonSyncCnt(1+spots(GoodSpots(A),1))==1 ) % if there's one spot in frame A
       Ax = spots(GoodSpots(A),3);
       Ay = spots(GoodSpots(A),4);
       Aoffset = 0;
     else
       Ax = mean([spots(GoodSpots(A),3), spots(GoodSpots(A+1),3)]);
       Ay = mean([spots(GoodSpots(A),4), spots(GoodSpots(A+1),4)]);
       Aoffset = 1;
     end
     if (NonSyncCnt(1+spots(GoodSpots(B),1))==1 )
       Bx = spots(GoodSpots(B),3);
       By = spots(GoodSpots(B),4);
       Boffset = 0;
     else 
       Bx = mean([spots(GoodSpots(B),3), spots(GoodSpots(B+1),3)]);
       By = mean([spots(GoodSpots(B),4), spots(GoodSpots(B+1),4)]);
       Boffset = 1;
     end
     if (NonSyncCnt(1+spots(GoodSpots(C),1))==1 )
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
       keepB = 0;
    % if C is further from B than B is from A, keep B
     else if (((Ax-Bx)^2+(Ay-By)^2)^(1/2) < 20 | ((Cx-Bx)^2+(Cy-By)^2) > ((Ax-Bx)^2+(Ay-By)^2))
       keepB = 1;
       else 
 %        plot (Ax,Ay,'+','MarkerEdgeColor', 'k' );
 %        plot (Bx,By,'o','MarkerEdgeColor', 'k');
  %       plot (Cx,Cy,'*','MarkerEdgeColor', 'k' );
         keepB = recursiveTrackClean(spots, GoodSpots, NonSyncCnt, m, A, B, C+1+Coffset);
       end
     end
else
keepB = 0;
end

