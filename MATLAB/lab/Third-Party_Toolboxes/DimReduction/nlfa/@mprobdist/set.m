function a = set(a, prop_name, val)
% SET set the value of given property
%
% Mprobdist internal, should not be used.

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

switch prop_name
 case 'E'
  a.probdist = set(a.probdist, 'E', val);
 case 'Var'
  a.probdist = set(a.probdist, 'Var', val);
 case 'Mvar'
  a.multivar = val;
 case 'Evar'
  a.extravar = val;
 otherwise
  error('Bad property.')
end

