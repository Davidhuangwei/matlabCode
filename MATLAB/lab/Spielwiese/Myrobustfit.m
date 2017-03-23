function [b stats] = Myrobustfit(X,Y,func,varargin)
%
% like robustfit
%
% the problem with robust fit is, that it fails if the slope is
% larger than 45 degrees... 
% Myrobustfit doe the fit for (X,Y) and (Y,X) and gives the values
% with the better p-value
[func,const,origin] = DefaultArgs(varargin,{'bisquare',1,[0 0]});

%% sort according to distance from origin 


[b1 stats1] = robustfit(X,Y,func,const);

if stats1.p<=stats2.p
  b = b1;
  stats = stats1;
else
  b = [0;0];
  b(1) = -b2(1)/b2(2);
  b(2) = 1/b2(2);
  stats = stats2;
end  

return;


