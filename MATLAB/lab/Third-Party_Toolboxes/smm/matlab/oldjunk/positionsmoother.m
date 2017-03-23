function whldata = positionsmoother(whldata, smoothlen)
findex = find(whldata(:,1)~=-1);
[findex_m n] = size(findex);
for j=1:2
    for i=findex(1):findex_m
        if (whldata(i,j)==-1),
            whldata(i,j) = whldata(i-1,j);
        end
    end
end
if (~exist(smoothlen)),
    smoothlen = 21;
end
findex = find(whldata(:,1)~=-1);
filter = hanning(smoothlen);
whldata(findex,1) = Filter0(filter,whldata(findex,1));
whldata(findex,2) = Filter0(filter,whldata(findex,2));
return