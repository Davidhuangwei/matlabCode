function [dcp_dsvn, newac] = computevard(dcp_dsv, dcp_dsvn, ac, mv)
% COMPUTEVARD is used by by ndfa_iter.  This function is the feedback version
% of COMPUTEVAR.

%
% Matlab implementation of this function is very slow due to a loop.
% Use mex function compiled from computevard.c instead.

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

errtxt = sprintf('COMPUTEVARD.M: Compile with mex computevard.c\nYou can remove this message, but Matlab version is very slow due to a loop.');

error(errtxt)  % You can remove this, but the result is slow.

newac=zeros(size(ac));
d=size(newac,2);
for i=1:size(mv,1)
  newac(i,2:end)=reshape(mv(i,i,:), [1 d-1]);
end
for i=d:-1:2
  newac(:,i) = newac(:,i) .* dcp_dsvn(:,i) ./ (dcp_dsvn(:,i) + dcp_dsv(:,i));
  dcp_dsvn(:,i) = dcp_dsvn(:,i) + dcp_dsv(:,i);
  dcp_dsv(:,i-1) = dcp_dsv(:,i-1) + newac(:,i).^2 .* dcp_dsv(:,i);
end
dcp_dsvn(:,1) = dcp_dsvn(:,1) + dcp_dsv(:,1);
