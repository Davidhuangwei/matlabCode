% B = RegularizedInverse(A, cond);
%
% computes a regularized inverse based on singular value
% decomposition, where only those singular values whos
% ratio to the top one is at least cond are kept.

function B = RegularizedInverse(A, c);

[u s v] = svd(A,0);

d = diag(s);
TooSmall = (dd./max(d) < c);

dInv = (1-TooSmall)./(d+TooSmall);

B = v*diag(dInv)*u';