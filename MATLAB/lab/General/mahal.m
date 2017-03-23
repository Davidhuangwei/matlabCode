function d = mahal(Y,X);
% MAHAL Mahalanobis distance.
%   MAHAL(Y,X) gives the Mahalanobis distance of each point in
%   Y from the sample in X. 
%   
%   The number of columns of Y must equal the number
%   of columns in X, but the number of rows may differ.
%   The number of rows must exceed the number of columns
%   in X.

%   B.A. Jones 2-04-95
%   Copyright 1993-2000 The MathWorks, Inc. 
%   $Revision: 2.8 $  $Date: 2000/05/26 18:53:01 $

[rx,cx] = size(X);
[ry,cy] = size(Y);

if cx ~= cy
   error('Requires the inputs to have the same number of columns.');
end

if rx < cx
   error('The number of rows of X must exceed the number of columns.');
end

m = mean(X);
M = m(ones(ry,1),:);
C = X - m(ones(rx,1),:);
[Q,R] = qr(C,0);

ri = R'\(Y-M)';
d = sum(ri.*ri)'*(rx-1);

