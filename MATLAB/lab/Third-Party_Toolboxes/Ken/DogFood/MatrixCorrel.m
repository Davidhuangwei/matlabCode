% sees if two similarity matrices are more similar than the null hypothesis
% of shuffling one of them by permuting the columns and rows.

function p = MatrixCorrel(M1,M2, nRand)

if nargin<3
	nRand = 3e2;
end

n = size(M1,1);

Good = find(isfinite(M1) & isfinite(M2));

b = regress(M1(Good),[M2(Good) ones(length(Good),1)]);


for i=1:nRand
	perm = randperm(n);
	M2p = M2(perm,perm);
	Good = find(isfinite(M1) & isfinite(M2p));
	bp = regress(M1(Good), [M2p(Good) ones(length(Good),1)]);
	b0(i) = bp(1);
end

p = Quantile(b0,b(1));