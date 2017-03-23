%calculates direct product of a and b
% i.e. the matrix of size legnth(a) by length(b)
% each value is a produt of a(i)*b(j)
function out =DirectProd(a,b)

a=a(:); b=b(:)';
na = length(a); nb= length(b);
am = repmat(a,1,nb);
bm = repmat(b,na,1);

out = am .* bm;
clear am bm
