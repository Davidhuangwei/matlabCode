function nx = NormMatrix( x)
% normalizes to N(0,1) matrix for each columnt separately
nCol = size(x,2);
nTime = size(x,1);

Mean = repmat(mean(x,1), nTime, 1);
Std = repmat(std(x,0,1), nTime, 1);
nx = (x- Mean) ./ Std;
