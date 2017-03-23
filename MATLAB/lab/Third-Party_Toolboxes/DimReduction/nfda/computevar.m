function var = computevar(nvar, ac)
% COMPUTEVAR is used by by updatevar
% 
% Matlab implementation of this function is very slow due to a loop.
% Use mex function compiled from computevar.c instead.

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

errtxt = sprintf('COMPUTEVAR.M: Compile with mex computevar.c\nYou can remove this message, but Matlab version is very slow due to a loop.');

error(errtxt)  % You can remove this, but the result is slow.

var = nvar;
d=size(nvar,2);
for i=2:d
  var(:,i) = var(:,i) + ac(:,i).^2 .* var(:,i-1);
end
