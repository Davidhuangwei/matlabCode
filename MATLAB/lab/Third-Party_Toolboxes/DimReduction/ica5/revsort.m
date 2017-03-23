% revsort  - reverse sort columns (biggest 1st, ...)
%

function [out,i] = revsort(in)

if size(in,1) == 1
   in = in'; % make column vector
end

[out,i] = sort(in);
out = out(size(in,1):-1:1,:);
  i = i(size(in,1):-1:1,:);

