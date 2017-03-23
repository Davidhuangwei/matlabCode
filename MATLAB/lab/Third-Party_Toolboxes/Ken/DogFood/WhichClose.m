% WhichClose(Fet, Clu)
%
% computes mean feature vector for each cell and starts an xgvis on it

function WhichClose(Fet, Clu)
nClu = max(Clu);

for c = 1:nClu
	center(c,:) = mean(Fet(find(Clu==c), :));
end

xgvis(center);
