function [interpChans distWeights] = FunkyInterp(oldChans,dimensions)
yDist = 100;
xDist = 300;
slopeFactor = 100;
interpChans = NaN*size(oldChans);
distWeights = zeros*size(oldChans);
nShanks = dimensions(1);
nSites = dimensions(2);
interpWeightOrder = 1;
for x=1:nShanks
    for y=1:nSites
        chan = (x-1)*nSites+y;
        if ~isempty(find(chan==badchan))
            nearChans = [];
            nearDists = [];
            for i=-1:1:1
                for j=-1:1:1
                    if (x+i > 0) & (y+j > 0)
                        chan2 = (x+i-1)*nSites+y+j;
                        if isempty(find(chan2==badchan))
                            nearChans = cat(1,nearChans,oldChans(x+i,y+j);
                            nearDists = cat(1,nearDists,sqrt((i*xDist)^2 + (j*yDist)^2));
                        end
                    end
                end
            end
            interpChans(x,y) = nearChans*(1./nearDists.^interpWeightOrder)'/sum(1./nearDists.^interpWeightOrder);
            distWeights(x,y) = sum(nearDists)./2^(length(nearDists)-1);
        else
            interpChans(x,y) = oldChans(x,y);
        end
    end
end
return

csdWeightOrder = 3;
csdMat = zeros(nShanks,nSites-2)
for x=1:nShanks
    for y=2:nSites-1
        for i=[0 -1 -1 -1]
            csdEsts = [];
            csdDists = [];
            for j=[-1 -1 0 1]
                csdEsts = cat(1,csdEsts,(interpChans(x,y)-interpChans(x+i,y+j))/sqrt((i*xDist)^2+(j*yDist)^2) - ...
                    (interpChans(x,y)-interpChans(x-i,y-j))/sqrt((i*xDist)^2+(j*yDist)^2));
                csdDists = cat(1,csdDists,2*sqrt((i*xDist)^2+(j*yDist)^2) + distWeights(x-i,y-j) + distWeights(x+i,y+j));
            end
        end
        csdMat(x,y-1) = csdEsts*(1./csdDists.^csdWeightOrder)'/sum(1./csdDists.^csdWeightOrder);
    end
end
        
        
        