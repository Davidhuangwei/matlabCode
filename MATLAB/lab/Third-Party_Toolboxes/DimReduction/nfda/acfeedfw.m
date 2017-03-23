function x = acfeedfw(s, net)
% ACFEEDFW  Do feedforward with acprobdist_alpha sources
%
%    Usage:
%      x = acfeedfw(s, net)
%      where sources should be acprobdist_alpha
%      returns a cell array with intermediate results

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if (~isa(s, 'acprobdist_alpha'))
  error('Use acfeedfw only with sources of type acprobdist_alpha')
end

if (size(s, 1) ~= size(net.b2, 1))
  error('Network input and output dimensions need to be equal')
end

filler = ones(1, size(s, 2)-1);

x = cell(1,5);
x{1} = makeprop(s(:,1:end-1));
x{2} = net.w1*x{1} + net.b1 * filler;
x{3} = feval(net.nonlin, x{2});
x{4} = net.w2*x{3} + net.b2 * filler + x{1};
mv = x{4}.multivar;
x{5} = mv;

for i=1:size(mv,1)
  mv(i,i,:)=mv(i,i,:)-reshape(s.ac(i,2:end), [1 1 size(mv,3)]);
end
x{4}.multivar = mv;
x{4} = updatevar(x{4}, s.var(:,1:end-1));

