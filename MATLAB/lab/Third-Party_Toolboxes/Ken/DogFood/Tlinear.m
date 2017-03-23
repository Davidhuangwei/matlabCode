% function [rho, p] = Tlinear(th1, th2, nRands)
%
% tests for circular-circular association using the T-linear method
% (Fisher p.151)
%
% p: p-value - will be near 1 for positive correlations, 0 for negative ones. rho - corr coef.

function [rho, p] = Tlinear(th1, th2, nRands)

if nargin<3
    nRands = 500;
end

n = length(th1);
if length(th2)~=n
	error('th1 and th2 should have the same length');
end

th1 = th1(:);
th2 = th2(:);

c1 = cos(th1);
s1 = sin(th1);
c2 = cos(th2);
s2 = sin(th2);

A = sum(c1.*c2);
B = sum(s1.*s2);
C = sum(c1.*s2);
D = sum(s1.*c2);

E = sum(cos(2*th1));
F = sum(sin(2*th1));
G = sum(cos(2*th2));
H = sum(sin(2*th2));

rho = 4*(A*B-C*D)/sqrt((n^2-E^2-F^2)*(n^2-G^2-H^2));


if nargin>=2
    % compute p-vals by randomization
    T0 = A*B-C*D;
    for i=1:nRands
%         th2r = th2(randperm(n));
        perm = randperm(n);
		c2r = c2(perm);
		s2r = s2(perm);
		
		Ar = sum(c1.*c2r);
		Br = sum(s1.*s2r);
		Cr = sum(c1.*s2r);
		Dr = sum(s1.*c2r);
        T(i) = Ar*Br-Cr*Dr;
    end
    
    p = Quantile(T, T0);
end