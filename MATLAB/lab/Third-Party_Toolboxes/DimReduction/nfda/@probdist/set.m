function a = set(a,prop_name,val)
% SET set the value of given property

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

switch prop_name
 case 'E'
  a.e = val;
 case 'Var'
  a.var = val;
 otherwise
  error('Bad property.')
end

