function b = TensorBasis(Points, n)
% b = TensorBasis(Points, n)
% evaluates a tensor product cubic b-spline basis on the unit square
% at the points Points.
%
% n specifies the number of interior knots for each dimension
%
%The output b will be b(p,s) = basis function for spline s
% evaluated at p.

% construct knot vector
knots = [zeros(1,3) , 0:1/(n+1):1, ones(1,3)];

bx = bspline(Points(:,1), knots, 3);
by = bspline(Points(:,2), knots, 3);

[mx my] = meshgrid(1:n+4, 1:n+4);
b = bx(:,mx) .* by(:,my);

