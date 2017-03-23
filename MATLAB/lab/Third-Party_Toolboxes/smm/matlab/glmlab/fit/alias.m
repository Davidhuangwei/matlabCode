function label=alias(X)
%ALIAS Finds aliased columns of matrix X
%USE: labels=alias(X)
%   where  labels  is a vector of the linearly independent columns
%          X  is the original data matrix.
%X(:,label) is the matrix with aliased variables removed
%For use within  glmlab

%Copyright 1996, 1997 Peter Dunn
%Last revision: 08/12/1997

toler=paramtrs;                         %Obtain tolerance parameter
mfilename

X

%Obtain the first column--it must be included.
XX=X(:,1);
label=[1];
i=1;

for j=1:size(X,2);                      %Cycle through remaining columns

   i=i+1;
   XX=[XX X(:,j)];                      %Append next column

   if det(XX'*XX)<toler,                %if determinant less than tolerance...
      XX=[ XX(:,1:size(XX,2)-1) ];      %...discard this column
   else
      label=[label j];                  %...else include as another col
   end;

end;
