function b = RadialBasis(Grid, Points, fn)
% b = RadialBasis(Grid, Points, fn)
% evaluates a set of radial basis functions based at Grid
% at the points Points.
% fn should be a function giving the basis as fn(r)
% The output b will be b(p,g) = basis function centered at g 
% evaluated at p.

nG = size(Grid,1);
nP = size(Points,1);

for i=1:nG
	Center = Grid(i*ones(nP,1),:);
	r = sqrt(sum((Center-Points).^2,2));
	b(:,i) = feval(fn, r);
end