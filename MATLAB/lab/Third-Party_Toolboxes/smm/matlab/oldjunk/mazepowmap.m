function mazepowmap(powdat, whldat, binsize, numbinsmooth )

xlim = 368;
ylim = 240;

if (size(powdat) ~= size(whldat))
    whldat
    return
end

mazepow = zeros(ceil(xlim/binsize), ceil(ylim/binsize));
[mpm mpn] = size(mazepow);
minpow = min(powdat);

% calculating average power-position map
for x=1:mpm
    for y=1:mpn
        if (isempty(find(whldat(:,1)>(x*binsize-binsize) & whldat(:,1)<=x*binsize & whldat(:,2)>(y*binsize-binsize) & whldat(:,2)<=y*binsize))),
            mazepow(x,y) = NaN;
        else
            mazepow(x,y) = mean(powdat(find(whldat(:,1)>(x*binsize-binsize) & whldat(:,1)<=x*binsize & whldat(:,2)>(y*binsize-binsize) & whldat(:,2)<=y*binsize)));            
        end   
    end
end
keyboard
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
figure(1)
imagesc(mazepow)
colorbar
figure(2)
imagesc(mazesmooth)
colorbar