function [r] = ComputeSignal(g,y)

%
% [r] = ComputeSignal(g,y)
%
% This function compute the output of the SISO filter g
% when driven by the observations y.
%
% Author : Pierre JALLON
% Date of creation : 04/23/2005
% Date of last modification : 04/23/20005
%

Lmax = size(g,1);
N = size(y,1);         

r = 0;
for (n=1:N)
	r = r + filter(g(:,n),1,y(n,:));
end
   
