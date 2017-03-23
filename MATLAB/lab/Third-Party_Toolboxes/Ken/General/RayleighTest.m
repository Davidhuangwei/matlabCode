% [p, th0, r] = RayleighTest(th)
%
% Tests a set of angles for directional preference.
%
% p returns p-value, th0 mean angle, and r is radial distance
%
% see Fisher, statistical analysis of circular data, p.70.

function [p, th0, r] = RayleighTest(th)

if length(th)==0
    p=NaN;
    th0 = NaN;
    r = NaN;
    return;
end

x = exp(i*th);
m = mean(x);

th0 = angle(m);
r = abs(m);
n = length(th);

z = n*r*r;

p = exp(-z)*(...
	1 + (2*z-z*z)/(4*n) - (24*z - 132*z*z + 76*z^3 - 9*z^4)/(288*n*n) ...
	);