% [m r] = CircConf(x, alpha, nBoot)
%
% computes circular mean and confidence intervals of circular data.
% by either bootstrap or analytic method (see NI Fisher, Analysis
% of circular data, p.88
%
% uses bootstrap method if 3rd argument is present and non-zero.
% if 3rd argument is omitted, will use bootstrap is number of data
% points <25.

function [m, r] = CircConf(x, alpha, nBoot)

n = length(x);

if nargin<2
	alpha = 0.05;
end

% find mean and k
[m R] = circmean(x);
k = BesselRatInv(R);

% small sample modification to k (see p.88)
if n<=15
    if k<2
        k = max(k-2/(n*k), 0);
    else
        k = (n-1)^3*k/(n^3+n);
    end
end

% determine whether we should do a bootstrap
if nargin<3
    if k<.4 | (k<1 & n<25) | (k<1.5 & n<15) | (k<2 & n<10)
        nBoot = 200;
    else
        nBoot = 0;
    end
end

if nBoot==0
    sigma = (n*R*k).^-.5;
    err = asin(norminv(1-alpha/2)*sigma);
    r = m + [-err err];
else
	m = circmean(x);
	b = bootstrp(nBoot,'circmean', x);
	
	% unwrap data around mean value
	Unwrapped = mod(b-m+pi, 2*pi)+m-pi;
	
	r(1) = prctile(Unwrapped, 100*(alpha/2));
	r(2) = prctile(Unwrapped, 100-100*(alpha/2));
end

return
% OLD VERSION - FROM p.75. THIS IS MORE COMPLEX BUT DOESN'T USE
% A VON MISES ASSUMPTION (WHICH WE CAN LIVE WITH)

if nargin<2
	alpha = 0.05;
end

if nargin<3
    if length(x)<25
        nBoot = 200;
    else
        nBoot = 0;
    end
end

if nBoot==0
    [m r] = circmean(x);
    [m2 r2] = circmean(x*2);
    delta = (1-r2)/(2*r^2);
    sigma = sqrt(delta/length(x));
    sinarg = norminv(1-alpha/2)*sigma;
    if sinarg<1
        err = asin(norminv(1-alpha/2)*sigma);
    else
        err = pi;
    end
    r = m + [-err err];
else
	m = circmean(x);
	b = bootstrp(nBoot,'circmean', x);
	
	% unwrap data around mean value
	Unwrapped = mod(b-m+pi, 2*pi)+m-pi;
	
	r(1) = prctile(Unwrapped, 100*(alpha/2));
	r(2) = prctile(Unwrapped, 100-100*(alpha/2));
end