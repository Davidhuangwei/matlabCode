function val = get(a,prop_name)
% GET get the value of given property

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
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
 case 'Malpha'
  val = a.malpha;
 case 'Valpha'
  val = a.valpha;
 case 'Msign'
  val = a.msign;
 case 'Vsign'
  val = a.vsign;
 otherwise
  error('Bad property.')
end

