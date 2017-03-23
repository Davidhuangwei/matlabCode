function chanmat = makecsdchanmat()
for i=1:6
    for j=1:14
        channels(j,i) = (i-1)*14+j;
    end
end
chanmat(:,:,1) = channels(1:7,:);
chanmat(:,:,2) = channels(8:14,:);
return