function [interpChans distWeights] = FunkyInterp2D(oldChans,badchan,interpWeightOrder)
% function [interpChans distWeights] = FunkyInterp2D(oldChans,badchan,interpWeightOrder)

yDist = 100;
xDist = 300;
slopeFactor = 100;
oldChans = oldChans';
interpChans = NaN*size(oldChans);
distWeights = zeros(size(oldChans));
nShanks = size(oldChans,1);
nSites = size(oldChans,2);
for x=1:nShanks
    for y=1:nSites
        chan = (x-1)*nSites+y;
        if ~isempty(find(chan==badchan))
            nearChans = [];
            nearDists = [];
            for i=-1:1:1
                for j=-ceil(xDist/yDist):1:ceil(xDist/yDist)
                    if (x+i > 0) & (y+j > 0) & (x+i <= nShanks) & (y+j <= nSites)
                        chan2 = (x+i-1)*nSites+y+j;
                        if isempty(find(chan2==badchan))
                            %fprintf('%i,%i:',x+i,y+j)
                            nearChans = cat(1,nearChans,oldChans(x+i,y+j));
                            nearDists = cat(1,nearDists,sqrt((i*xDist)^2 + (j*yDist)^2));
                        end
                    end
                end
            end
            if ~isempty(nearChans)
                interpChans(x,y) = nearChans'*(1./nearDists.^interpWeightOrder)/sum(1./nearDists.^interpWeightOrder);
                distWeights(x,y) = sum(nearDists)./2^(length(nearDists)-1);
            end
        else
            interpChans(x,y) = oldChans(x,y);
        end
    end
end
interpChans = interpChans';
return
  
        
        