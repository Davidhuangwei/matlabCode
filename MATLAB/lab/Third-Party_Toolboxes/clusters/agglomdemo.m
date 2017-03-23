% AGGLOMDEMO : demonstrate agglomerative clustering

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

[iris,irisc] = loadiris;
i = iris(:,1:30);
c = agglom(i,5,'dmean');
showclusters(i,c);