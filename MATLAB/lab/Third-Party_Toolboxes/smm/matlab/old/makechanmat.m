function chanmat = makechanmat()
for i=1:6
    for j=1:16
        channels(j,i) = (i-1)*16+j;
    end
end
chanmat(:,:,1) = channels(1:8,:);
chanmat(:,:,2) = channels(9:16,:);
return