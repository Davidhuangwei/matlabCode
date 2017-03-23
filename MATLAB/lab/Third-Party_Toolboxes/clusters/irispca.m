function irispca();
% irispca: show first two principal components of iris data

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

load iris.txt;
b = iris(:,3:6);
showpca2(b');