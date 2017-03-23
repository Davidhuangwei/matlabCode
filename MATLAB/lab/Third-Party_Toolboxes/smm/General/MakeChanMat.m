function chanMat = MakeChanMat(x,y,z)
% function chanMat = MakeChanMat(x,y,z)  
% makes a matrix of dimesions x,y,z where values increase from 1 down y then z then x.
% e.g.
% chanMat = MakeChanMat(4,3,2) creates the following matrix:
% chanMat(:,:,1) = 1  7  13 19
%                  2  8  14 20
%                  3  9  15 21
% chanMat(:,:,2) = 4  10 16 22
%                  5  11 17 23
%                  6  12 18 24

if ~exist('x') | isempty(x)
    x = 1;
end
if ~exist('y') | isempty(y)
    y = 1;
end
if ~exist('z') | isempty(z)
    z = 1;
end

for i=1:x
    for j=1:y*z
        channels(j,i) = (i-1)*y*z+j;
    end
end
for k=1:z
    chanMat(:,:,k) = channels((k-1)*y+1:(k*y),:);
end
return