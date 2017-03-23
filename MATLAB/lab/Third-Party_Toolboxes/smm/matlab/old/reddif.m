function reddif(GoodSpots, spots, GSD,thresh)
figure(3); hold on
[m,n]=size(GSD);
linemat = zeros(2,2);
lastDist = 0;
for i=1:m
  if (GSD(i)>=thresh),
  if ((((spots(GoodSpots(i),3)-spots(GoodSpots(max(i-1,1)),3))^2 + (spots(GoodSpots(i),4)-spots(GoodSpots(max(i-1,1)),4))^2)^(1/2)) > (((spots(GoodSpots(min(m,i+1)),3)-spots(GoodSpots(max(i-1,1)),3))^2 + (spots(GoodSpots(min(m,i+1)),4)-spots(GoodSpots(max(i-1,1)),4))^2)^(1/2)));
  %  if (lastDist >=thresh),
      linemat(1,1) = spots(GoodSpots(max(1,i-1)),3);
      linemat(1,2) = spots(GoodSpots(max(1,i-1)),4);
      linemat(2,1) = spots(GoodSpots(i),3);
      linemat(2,2) = spots(GoodSpots(i),4);
      plot(linemat(:,1),linemat(:,2),'MarkerFaceColor', 'r');
      %line(spots(GoodSpots(max(1,i-1),3)), spots(GoodSpots(max(1,i-1),4)) );
      %  line(spots(GoodSpots(i),3), spots(GoodSpots(i),4) );
    end

  else
   % plot(spots(GoodSpots(i),3), spots(GoodSpots(i),4),'markersize',1,'MarkerEdgeColor','r');
  end    
%  lastDist = GSD(i);
end
