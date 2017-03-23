function GoodSpotsDif = difspots(GoodSpots, Spots);
     [m,n]=size(GoodSpots);
     GoodSpotsDif = zeros(m,1);
     for i=1:m
         GoodSpotsDif(i) = ((Spots(GoodSpots(i),3)-Spots(GoodSpots(max(i-1,1)),3))^2 + (Spots(GoodSpots(i),4)-Spots(GoodSpots(max(i-1,1)),4))^2)^(1/2);
     end
     size(GoodSpotsDif)
