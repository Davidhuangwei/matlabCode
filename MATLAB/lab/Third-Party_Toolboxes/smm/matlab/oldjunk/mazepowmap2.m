function [mazepow,mazesmooth] = mazepowmap(powdat, whldat, binsize, numbinsmooth, plotbool )

xlim = 368;
ylim = 240;

if (size(powdat) ~= size(whldat))
    i = input('two matrices are not the same size. average to to size of whldat?[y/n]','s');
    if i == 'y',
        powdat = avedownsize(powdat, whldat);
    else
        return
    end
end

mazepow = zeros(ceil(xlim/binsize), ceil(ylim/binsize));
[mpm mpn] = size(mazepow);
minpow = min(powdat);

minusones = find(whldat(:,1)==-1);
% whldat(minusones) = NaN;
whldat = binsize*ceil(whldat/binsize);

mazepow = Accumulate(whldat(~minusones,1:2), powdat(~minusones));
sumpos = Accumulate(whldat(~minusones,1:2));
mazepow(find(sumpos)==0)= NaN;
mazepow = mazepow./sumpos;
% calculating average power-position map
for x=1:mpm
    for y=1:mpn
        bin = find(whldat(:,1)>(x*binsize-binsize) & whldat(:,1)<=x*binsize & whldat(:,2)>(y*binsize-binsize) & whldat(:,2)<=y*binsize);
        if (isempty(bin)),
            mazepow(x,y) = NaN;
        else
            mazepow(x,y) = mean(powdat(bin));            
        end   
    end
end

%now smooth
mazesmooth = mazepow;
tempmat = zeros(numbinsmooth, numbinsmooth);   
for x=numbinsmooth:mpm
    for y=numbinsmooth:mpn
        if ~isnan(mazepow(x,y)),
          tempmat = mazepow((x-(numbinsmooth-1)):x, (y-(numbinsmooth-1)):y);
          mazesmooth(x,y) = mean(tempmat(find(~isnan(tempmat))));
      end
    end
end
if (plotbool),
    figure(1)
    imagesc(mazepow)
    colorbar
    figure(2)
    imagesc(mazesmooth)
    colorbar
end
return