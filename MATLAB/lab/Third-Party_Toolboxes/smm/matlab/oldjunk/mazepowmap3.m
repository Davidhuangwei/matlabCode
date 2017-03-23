function [mazepow,mazesmooth] = mazepowmap3(powdat, whldat, binsize, numbinsmooth, plotbool )

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

%mazepow = zeros(ceil(xlim/binsize), ceil(ylim/binsize));
%[mpm mpn] = size(mazepow);
%minpow = min(powdat);

notminusones = find(whldat(:,1)~=-1);
whldat = ceil(whldat./binsize);

sumpow = Accumulate(whldat(notminusones,1:2), powdat(notminusones));
sumpos = Accumulate(whldat(notminusones,1:2), 1);
zerosum = find(sumpos==0);
sumpos(zerosum)= NaN;
mazepow = sumpow./sumpos;

%now smooth
[mpm mpn] = size(mazepow);
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