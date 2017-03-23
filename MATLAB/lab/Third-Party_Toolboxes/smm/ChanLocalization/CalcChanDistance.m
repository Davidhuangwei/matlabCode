% function distance = CalcChanDistance(chans,chanMat,xChanSpacing,yChanSpacing)
function distance = CalcChanDistance(chans,chanMat,xChanSpacing,yChanSpacing)

for j=1:length(chans)
    for k=1:length(chans)
        [m1 n1] = find(chans(j)==chanMat);
        [m2 n2] = find(chans(k)==chanMat);
        distance(j,k) = sqrt((yChanSpacing*(m2-m1))^2 + (xChanSpacing*(n2-n1))^2);
    end
end
        