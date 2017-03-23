function b = dftfilt(n,W,c,k,q)
% n: number of input samples
% W: maximum angular freq. relative to n
% c: cycles
% k: oversampling
%
% 0 < W <= .5
% q: [0;1] 0->fft, 1->c cycles

f = 2*pi/n;						% Angular increment.
w = j * c * [0:f:2*pi-f/2]';	% Column.
x = 1:1/k:W*n/c;				% Row.
b = exp(-w*x);					% Exponentiation of outer product.

for i = 1:size(b,2),
	m  = round(q*n*(i-1)/(i+k-1));	% Number of elements to discard.
	mu = round(m/2);				% Number of upper elemnts.
	ml = m-round(m/2);				% Number of lower elemnts.
	b(:,i) = b(:,i) .* [zeros(mu,1) ; hanning(n-m) ; zeros(ml,1)];
%	b(:,i) = b(:,i) .* [zeros(mu,1) ; ones(n-m,1) ; zeros(ml,1)];
end
