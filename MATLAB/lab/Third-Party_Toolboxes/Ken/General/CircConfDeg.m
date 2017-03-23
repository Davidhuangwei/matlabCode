% [m r] = CircConfDeg(x, alpha, nBoot)
%
% computes circular mean and confidence intervals of circular data
% with bootstrap method.
%
% See also CircConf

function [m, r] = CircConfDeg(x, alpha, nBoot)

x=x*pi/180;

if nargin<2
	alpha = 0.05;
end

if nargin<3
    nBoot = 400;
end

m = circmean(x);
b = bootstrp(nBoot,'circmean', x);

% unwrap data around mean value
Unwrapped = mod(b-m+pi, 2*pi)+m-pi;

r(1) = prctile(Unwrapped, 100*(alpha/2));
r(2) = prctile(Unwrapped, 100-100*(alpha/2));

m = m*180/pi;
r = r*180/pi;