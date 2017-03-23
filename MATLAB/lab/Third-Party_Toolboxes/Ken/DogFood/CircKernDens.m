% [p cv] = CircKernDens(x, f, xi, interpflag);
%
% Circular density estimation by kernel smoothing.
%
% x is data set in radians.
%
% f is kernel function.  It takes 1 argument, and returns
% a number, which should have integral 1 over 0...2*pi.
% f will be passed matrix arguments in the range 0..2*pi.
% It should operate on each matrix element individually
% (so make sure you use x.^2, etc), and should have
% f(2*pi-x)=f(x) for a symmetrical smooth.
% e.g. f = inline('(1+cos(x))/2/pi', 'x')
% or  f = inline('exp(3*cos(x))/besseli(0,3)/2/pi', 'x');
%
% xi is range to compute the smoothed density histogram over.
% p is only calculated in length(xi)>0
%
% returns a probability density function p over xi
% and optionally a cross-validation measure cv which gives
% the cross-validated (log2) likelihood ratio per point 
% of the estimated distribution, against a uniform.  If 
% cv<0, your fit is worse than useless. If interp is set to
% 1 (default), you save time and memory by interpolating p(x) from xi.
% otherwise computing cv and p are independent, but this is
% QUADRATIC in length(x).

function [p, cv] = CircKernDens(x, f, xi, interpflag);

if nargin<4
    interp=1;
end

% make matrix of distances between each data point
% and each evaluation point.

% first make x a column vector and xi a row vector
sz = size(xi);
x = x(:); xi = xi(:)';
nx = length(x); nxi = length(xi);

% only compute p if xi is non-empty
if nxi>0
	% now make distance matrix
	d = mod(repmat(x,1,nxi)-repmat(xi,nx,1), 2*pi);
	
	% weight matrix
	w = f(d);
	
	% now make probs
	p = mean(w);
	% reshape p to original size of xi
	p = reshape(p, sz);
else
    p = [];
end

if nargout>=2
	% make cross-val measure
	f0 = f(0); % for later use

	% compute p at each x.
    if interpflag
        px = interp1(xi, p, x);
    else
    	px = CircKernDens(x, f, x); % recursion - how cool is that!
    end
    
	cv = mean(log2((px*nx - f0)/(nx-1))) - log2(1/2/pi);
end

