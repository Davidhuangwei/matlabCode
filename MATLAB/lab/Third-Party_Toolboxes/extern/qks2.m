function P = qks2(M, tol)
%QKS2   Kolmogorov-Smirnov probability.
%       QKS2(x) computes the function that enters into the calculation
%       of the significance level in a Kolmogorov-Smirnov test.
%                      +oo
%                     .-- [    k-1         2  2  ]
%          Q  (x) = 2  >  [ (-1)   exp(-2.x .k ) ]
%           KS        '-- [                      ]
%                      k=1
%       QKS2(M) calculates QKS2(x) for each x in M.
%       QKS2(M, TOL) uses TOL as the precision required for the convergence.
%       The default value is MATLAB's eps (1e-8).
%
%       See also: KSTEST, QKS.
if (nargin < 1 | nargin > 2)
   error('QKS: requires one or two arguments.') ;
end

if (nargin == 1)
   tol = eps ;
else
   if (tol <= 0)
      error('QKS: precision must be strictly positive.') ;
   end
end

[nl, nc] = size(M) ;
if ((nl * nc) <= 0)
   error('QKS: first argument is empty or has wrong dimensions.') ;
end

n   = nl * nc ;
X   = reshape(abs(M), n, 1) ;
P   = ones(n, 1) ;
% Everything smaller than 0.2 is put to 0 (|error| < 1e-12).
iii = find(X < 0.2) ;
if (~isempty(iii))
% Maximum number of terms to calculate.
% Fast choice : absolute value of the term is <tol
%   m = ceil(sqrt(-log(tol)/2)/min(X(iii)))  ;
% Conservative choice: variation between two successive |term| is < tol
   m   = ceil(-(log(tol)/2/min(X(iii)) + 1)/2) ;
   J = 1:m ;
   U = exp( -2 * X(iii).^2 * J.^2) ;
   jjj = find(rem(J,2)) ;
   U(:, jjj) = -U(:, jjj) ;
   P(iii) = -2 * sum(U')' ;
end

P = reshape(P, nl, nc) ;
