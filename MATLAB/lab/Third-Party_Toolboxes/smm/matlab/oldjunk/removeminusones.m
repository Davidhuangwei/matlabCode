function whldata = removeminusones(whldata)
findex = find(whldata(:,1)~=-1);
[findex_m n] = size(findex);
for j=1:2
    for i=findex(1):findex_m
        if (whldata(i,j)==-1),
            whldata(i,j) = whldata(i-1,j);
        end
    end
end
return