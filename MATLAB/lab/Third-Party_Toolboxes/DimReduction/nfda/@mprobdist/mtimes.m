function c = mtimes(a, b)
% MTIMES matrix multiply mprobdists by probdists and numbers
%
%    The product is calculated as normal matrix product assuming
%    all probability distributions involved to be uncorreleted,
%    i.e. for call C = A * B, where A is a probdist and B a mprobdist
%      E[C] = E[A] * E[B]
%      Var[C] = E[A]^2 * Var[B] + Var[A] * E[B]^2 + Var[A] * Var[B];
%      Multivar[C] = E[A] * Multivar[B]
%      Extravar[C] = E[A]^2 * Extravar[B] + Var[A] * (E[B]^2 + Var[B])
%      
%    Both multiplicands must not be mprobdists.
%    This is because operation multivar*multivar is meaningless.

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if (isa(a, 'double'))
  if (~isa(b, 'mprobdist'))
    b = mprobdist(b);
  end
  [size1 size2 size3] = size(b.multivar);

  % Multiply the multivar vectors
  mv1 = reshape(b.multivar, [size1 size2*size3]);
  mv = reshape(a * mv1, [size(a,1) size2 size3]);

  c = mprobdist(a*get(b.probdist, 'E'), a.^2*get(b.probdist, 'Var'), ...
		mv, a.^2*b.extravar);
elseif (isa(a, 'probdist'))
  if (~isa(b, 'mprobdist'))
    b = mprobdist(b);
  end
  cpd = a * b.probdist;
  e = get(b.probdist, 'E');
  % Multiply the source weight vectors
  [size1 size2 size3] = size(b.multivar);

  mv1 = reshape(b.multivar, [size1 size2*size3]);
  mv = reshape(a.e * mv1, [size(a,1) size2 size3]);

  c = mprobdist(get(cpd, 'E'), get(cpd, 'Var'), mv, ...
		a.e.^2*b.extravar + a.var*(e.^2+get(b, 'Var')) );
% missing: a.var * b.multivar
else
  % mprobdist * mprobdist multiplication not supported
  error ('Unsupported parameter types in multiplication')
end
