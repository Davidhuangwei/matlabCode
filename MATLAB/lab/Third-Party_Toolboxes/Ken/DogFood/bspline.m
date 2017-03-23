function b = bspline(x, knots, order)
% b = bspline(x, knots, order)
% constructs a set of bsplines of specified order (default 3) at
% the values x with specified knots.  Returns b(x,s) as the s'th
% spline evaluated at x.
%
% NB if you want to span the full spline space, the end points need
% to be (order+1) multiples.

x = x(:);
nx = length(x);
knots = knots(:);
nk = length(knots);
ns = nk-order-1;

% do it by recursion!!

if order==0
	[dummy bin] = histc(x, knots);
    bin(x==knots(end)) = min(find(knots==knots(end)))-1;  % if x is maxval, replace with last bin
	Good = find(bin>0 & bin<nk);
	b = sparse(Good, bin(Good), 1, nx, nk-1);
else
	% get lower level b-spline by recursion
	bl = bspline(x, knots, order-1);
	

	xx = repmat(x, [1 ns]);
	kk = repmat(knots', [nx 1]);
	Term1 = (xx - kk(:,1:ns)).*bl(:,1:ns)./(kk(:,1+order:ns+order) - kk(:,1:ns) + eps);
	Term2 = (kk(:,2+order:nk)-xx).*bl(:,2:ns+1)./(kk(:,2+order:nk) - kk(:,2:ns+1) + eps);
	
	b = Term1 + Term2;
end
