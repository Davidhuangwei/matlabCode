% [x c] = EmpiricalCdf(data);
%
% computes the cdf of a set of input data. 
% this is a very simple function that basically only involves a sort

function [x, c] = EmpiricalCdf(data);

nData = length(data);

[x order] = sort(data);

c = (1:nData)'/nData;
