% [p cv] = KernDens(x, f, xi, interpflag);
%
% Density estimation by kernel smoothing.
%
% x is data set
%
% f is kernel function.  It takes 2 arguments. f(x,y) is value of
% kernel centered on x evaluated at y. f should have integral 1 
% over the domain of y.f will be passed matrix arguments, and should operate on 
% each matrix element individually (so make sure you use x.^2, etc)
%
% e.g. f = inline('exp(-(x-y).^2/(2*h^2))/sqrt(2*pi)/h', 'x', 'y');
% f = inline('max(h-abs(x-y), 0)./h^2', 'x', 'y'); 
% for Gaussian and triangular kernels. NB h must be a literal number .
% { with endpoints e0 and e1, replace denom h^2 with 
% h^2 - max(h-abs(x-e0),0).^2/2 - max(h-abs(x-e1),0).^2/2, and don't 
% forget to multiply numerator by (y>e0).*(y<e1)
%
% xi is range to compute the smoothed density histogram over.
% p is only calculated in length(xi)>0
%
% returns a probability density function p over xi
% and optionally a cross-validation measure cv which gives
% the cross-validated (log2) likelihood ratio per point 
% of the estimated distribution. You might want to compare
% this against a "zero knowledge" distribution like a uniform,
% but that's up to you.

function [p, cv] = KernDens(x, f, xi, interpflag);

if nargin<4
    interpflag=1;
end

% make matrix of distances between each data point
% and each evaluation point.

% first make x a column vector and xi a row vector
sz = size(xi);
x = x(:); xi = xi(:)';
nx = length(x); nxi = length(xi);

% only compute p if xi is non-empty
if nxi>0
	% now make weight matrix
	w = f(repmat(x,1,nxi), repmat(xi,nx,1));
		
	% now make probs
	p = mean(w);
	% reshape p to original size of xi
	p = reshape(p, sz);
else
    p = [];
end

if nargout>=2
	% make cross-val measure
	f0 = f(x,x); % for later use

	% compute p at each x.
    if interpflag
        px = interp1(xi, p, x);
    else
    	px = KernDens(x, f, x); % recursion - how cool is that!
    end
    
	cv = mean(log2((px*nx - f0)/(nx-1)));
end

