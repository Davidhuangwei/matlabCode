% v = RandomSample(m, n)
%
% produces a vector of m integers in the range 1:n
% without replacement.

function v = RandomSample(m, n)

rp = randperm(n);

v = rp(1:m);
