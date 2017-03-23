function [a, c] = jadiag(c, a, maxiter, epsi)
% syntaxe       [a, c] = jadiag(c, a, maxiter, epsi)
%
% Performs approximate joint diagonalization of several positive matrices.
% The matrices to be diagonalised are given in concatenated form by a
% m x n matrix c, n being a multiple of m. They are transformed to nearly
% diagonal and the transformation is also applied to a. Thus a yields the
% diagonalising matrix if it is initialised by the identity matrix (the
% default), otherwise it is the product of the diagonalsing matrix with
% its initialized value.
% The stoping criterion is that the square norm (with respect to a
% certain metric) of the relative "gradient" is less than epsi or the
% number of step attains maxstep. The above squared norm also equals
% approximatively the decrease of the criterion at this step.
% a defaults to the identity matrix, maxiter to 19 and epsi defaults.
% to m*(m-1)*1e-6 (a and maxiter are set to their defaults if empty).
%
% Copyright Pham Dinh-Tuan (Laboraroire Jean Kuntzman
%			    Dinh-Tuan.Pham@imag.fr) 15/02/2008

global debug       % set debug=1 to print intermediate results

[m, n] = size(c);
nmat = fix(n/m);
if (n > nmat*m)
  error('argument must be the concatenation of square matrices')
end

if nargin < 2 || isempty(a); a = eye(m); end
if nargin < 3 || isempty(maxiter); maxiter = 15; end
if nargin < 4; epsi = m*(m-1)*1e-5; end

for it = 1:maxiter
  decr = 0;
  for i = 2:m
    for j=1:i-1
      c1 = c(i,i:m:n);
      c2 = c(j,j:m:n);
      g12 = mean(c(i,j:m:n)./c1);		% this is g_{ij}
      g21 = mean(c(i,j:m:n)./c2);		% conjugate of g_{ji}
      omega21 = mean(c1./c2);
      omega12 = mean(c2./c1);
      omega = sqrt(omega12*omega21);
      tmp = sqrt(omega21/omega12);
      tmp1 = (tmp*g12 + g21)/(omega + 1);
      tmp2 = (tmp*g12 - g21)/max(omega - 1, eps);	% in case omega = 1
      h12 = tmp1 + tmp2;				% this is twice h_{ij}
      h21 = conj((tmp1 - tmp2)/tmp);			% this is twice h_{ji}
      decr = decr + nmat*(g12*conj(h12) + g21*h21)/2;

      tmp = 1 + 0.5i*imag(h12*h21);	% = 1 + (h12*h21 - conj(h12*h21))/4
      tmp = tmp + sqrt(tmp^2 - h12*h21);
      T = [1 -h12/tmp; -h21/tmp 1];
      c([i j],:) = T*c([i j],:);			% new i, j rows of c
      c(:,[i:m:n,j:m:n]) = reshape(reshape(c(:,[i:m:n,j:m:n]),m*nmat,2)*T', ...
				   m,nmat*2);		% new i,j columns of c
      a([i j],:) = T*a([i j],:);
    end
  end
  if debug
    fprintf('iteration %d, gradient norm %.6g\n', it, sqrt(decr/(m*(m+1))));
  end
  if decr < epsi; break; end		% convergence achieved
end
