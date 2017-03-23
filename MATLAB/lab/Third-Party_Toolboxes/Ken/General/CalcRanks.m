function rank = CalcRanks(x)
% Calculates ranks for a data set x.  x should be a vector.
% ties are given mean rank, as in Spearman's test.

if (min(size(x))>1)
    error('x should be a vector!');
end
x = x(:);

[xSort xInd] = sort(x);
xRank(xInd) = (1:n)';
% look for ties
d = [1,diff(xSort(:))',1];
dd = diff(d==0);
TieStart = find(dd==1);
TieEnd = find(dd==-1);

