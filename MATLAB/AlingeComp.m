function [ny, idy]=AlingeComp(x,y,ka)
% function [ny, idy]=AlingeComp(x,y,ka)
% alinge components according to the distance of spatial profile.
c=CompDist(x,y,ka);
[~,cy]=max(c,[],1);
[~,idy]=sort(cy);
ny=y(:,idy);
