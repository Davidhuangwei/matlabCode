function speeddata2d = mazespeed(whldata, smoothlen, binsize, numbinsmooth)
findex = find(whldata(:,1)>0);
[findex_m n] = size(findex);
for j=1:2
    for i=findex(1):findex_m
        if (whldata(i,j)<0),
            whldata(i,j) = whldata(i-1,j);
        end
    end
end
%if (isempty(smoothlen)),
    smoothlen = 21;
    %end
findex = find(whldata(:,1)~=-1);
filter = hanning(smoothlen);
whldata(findex,1) = Filter0(filter,whldata(findex,1));
whldata(findex,2) = Filter0(filter,whldata(findex,2));
findex = find(whldata(:,1)>0);
[findex_m n] = size(findex);
[whl_m n] = size(whldata);
speeddata = -1*ones(whl_m, 2);
speeddata(findex(ceil(smoothlen/2):findex_m-ceil(smoothlen/2)-1), 1) = diff(whldata(findex(ceil(smoothlen/2):findex_m-ceil(smoothlen/2)),1));
speeddata(findex(ceil(smoothlen/2):findex_m-ceil(smoothlen/2)-1), 2) = diff(whldata(findex(ceil(smoothlen/2):findex_m-ceil(smoothlen/2)),2));
speeddata2d = sqrt(speeddata(:,1).^2+speeddata(:,2).^2);
keyboard
return