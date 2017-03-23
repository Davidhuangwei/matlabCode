function csdMat = Csd2D(interpChans,distWeights,csdWeightOrder)
yDist = 100;
xDist = 300;

nShanks = size(interpChans,1);
nSites = size(interpChans,2);
csdMat = zeros(nShanks,nSites-2);

csdDirs = [0,-1; -1,-1; -1,0; -1,1];

for x=1:nShanks
    for y=2:nSites-1
        csdEsts = [];
        csdDists = [];
        for a=1:4
            i=csdDirs(a,1);
            j=csdDirs(a,2);
            if (x+i>0) & (x+i<=nShanks) & (y+j>0) & (y+j<=nSites) & (x-i>0) & (x-i<=nShanks) & (y-j>0) & (y-j<=nSites)
                %fprintf('%i,%i;%i,%i:',x,i,y,j)
                csdEsts = cat(1,csdEsts,(interpChans(x+i,y+j)-interpChans(x,y))/sqrt((i*xDist)^2+(j*yDist)^2) - ...
                    (interpChans(x,y)-interpChans(x-i,y-j))/sqrt((i*xDist)^2+(j*yDist)^2));
                csdDists = cat(1,csdDists,2*sqrt((i*xDist)^2+(j*yDist)^2) + distWeights(x-i,y-j) + distWeights(x+i,y+j));
            end
        end
        csdMat(x,y-1) = csdEsts'*(1./csdDists.^csdWeightOrder)/sum(1./csdDists.^csdWeightOrder);
    end
end
      
return