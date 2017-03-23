% FBVPrint(f)
% f is a 1d array of dimension 2^n, which is interpreted as a function
% of a binary vector.  This function prints its values, ordered by
% number of variables set to 1.

function FBVPrint(f)

f = f(:);
n = log2(length(f));

if n~=round(n)
	error('dimension of input variable must be a power of 2');
end


% sort indices in order of number of  bits
ind = 0:(2^n - 1);
nbits = sum(dec2bin(ind, n)-'0', 2);

[dummy order] = sort(nbits);

for i=order(:)'
	fprintf('%s: %f\n', dec2bin(i-1, n), f(i));
end