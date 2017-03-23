function s = sum_structs(s1, s2)
% SUM_STRUCTS  Add all the fields of two structures together
%

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

f = fieldnames(s1);
c1 = struct2cell(s1);
c2 = struct2cell(s2);
if size(c1) ~= size(c2)
  error('sum_structs: Structures must be of same type')
end

c = cell(size(c1));

for k=1:length(c1),
  c{k} = c1{k} + c2{k};
end

s = cell2struct(c, f, 1);
