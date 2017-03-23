function c = horzcat(a, b)
% HORZCAT concatenate two probdist_alpha objects horizontally
%
% Arrays of probdist_alphas are made by composing such arrays of respective
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
  c = probdist_alpha([get(a, 'E') get(b, 'E')], ...
		     [get(a, 'Var') get(b, 'Var')], ...
		     [a.malpha b.malpha], [a.valpha b.valpha], ...
		     [a.msign b.msign], [a.vsign b.vsign]);
end
