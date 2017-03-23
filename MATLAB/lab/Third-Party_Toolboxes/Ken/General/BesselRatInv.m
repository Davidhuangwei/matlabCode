% k = BesselRatInv(r)
% calculates the k for which r=besseli(1,k)/besseli(0,k);
% uses the algorithm in Fisher - Statistical Analysis of Circular data
% on page 51.

function y = BesselRatInv(x)

g0 = find(x>=0 & x<.53);
g1 = find(x>=.53 & x<.85);
g2 = find(x>=.85 & x<=1);

y = NaN*ones(size(x));

y(g0) = 2*x(g0) + x(g0).^3 + 5*x(g0).^5/6;
y(g1) = -0.4 + 1.39*x(g1) + 0.43./(1-x(g1));
y(g2) = 1./(x(g2).^3 - 4*x(g2).^2 + 3*x(g2));