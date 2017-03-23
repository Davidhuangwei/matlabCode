function val = get(a,prop_name)
% GET get the value of given property

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

switch prop_name
 case 'E'
  val = get(a.probdist, 'E');
 case 'Var'
  val = get(a.probdist, 'Var');
 case 'Mvar'
  val = a.multivar;
 case 'Evar'
  val = a.extravar;
 otherwise
  error('Bad property.')
end

