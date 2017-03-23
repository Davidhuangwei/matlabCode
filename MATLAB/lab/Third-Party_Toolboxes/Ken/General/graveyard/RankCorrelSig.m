% function p = RankCorrelSig(S, n);
% returns the significance of a rank correlation S
% on n objects.
%
% S is sum (x-y)^2 - see RankCorrelation

function p = RankCorrelSig(S, n);

	% calculate exact p-value by generating permutations
	
	per = perms(1:n);
	
	diffs = per-repmat(1:n,size(per,1),1);
	Snull = sum(diffs.^2,2);
	
	p = Quantile(Snull, S);
