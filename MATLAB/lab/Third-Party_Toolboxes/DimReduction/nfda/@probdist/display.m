function display(a)
% DISPLAY Display a probability distribution object

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

disp(' ');
disp([inputname(1),' = '])
disp(' ');
disp('  E:');
disp(a.e);
disp('  Var:');
disp(a.var);
