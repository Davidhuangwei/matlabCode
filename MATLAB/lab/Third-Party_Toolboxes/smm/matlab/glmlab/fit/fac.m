function X=fac(x,aszero)
%FAC Takes vector x (levels of quantitative variable) to give indicator matrix
%USE: X=fac(x, aszero)
%   where  x  is the vector of levels of the variable;
%          aszero  is the variable to set as zero (default: the first).
%If aszero is 0, all columns are returned.
%By default, column one is omitted (ie aszero=1).

%Copyright 1996, 1997 Peter Dunn
%Last revision: 01/05/1997

%Defaults
if nargin==1, 
   aszero=1; 
end;

if (size(x,1)~=1) & (size(x,2)~=1), 
   X=x; 				%Probably already fac-ed
   return; 
end;

x=floor(x(:));				%Round data

cfmat=ones(size(x))*(min(x):max(x));    %Matrix for comparison

datmat=x * ones(1,max(x)-min(x)+1);	%Data matrix

cols = (datmat==cfmat);			%Pick out columns
X=cols;

if aszero~=0,				%Set reference column
    X(:,aszero)=[];
end;

if length(X)==0,			%Error recovery
   X=x;
end;
