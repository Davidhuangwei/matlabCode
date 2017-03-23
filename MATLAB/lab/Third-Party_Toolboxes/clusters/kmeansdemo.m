% KMEANSDEMO: demonstrate k-means clustering

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

echo on;

[i,ic] = loadiris;
c = kmeans1(i,3);
showclusters(i,c);
view(350,30);

iris_within  = wscatter(i,ic)
iris_between = bscatter(i,ic)

within  = wscatter(i,c)
between = bscatter(i,c)

[numbers,means,variances] = clusterstats(i,c)

[total_error,error_per_cluster,nr_misclassified,nr_in_cluster,best_in_cluster] = ...
   misclass(c,ic)

echo off;