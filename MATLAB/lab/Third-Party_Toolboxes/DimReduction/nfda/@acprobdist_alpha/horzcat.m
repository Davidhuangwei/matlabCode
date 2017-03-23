function c = horzcat(a, b)
% HORZCAT concatenate two acprobdist_alpha objects horizontally
%
% Arrays of acprobdist_alphas are made by composing such arrays of respective
% subcomponents.

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if (nargin == 1)
  c = a;
else
  c = acprobdist_alpha([a.probdist_alpha b.probdist_alpha], [a.ac b.ac], ...
                       [a.nvar b.nvar]);
end
