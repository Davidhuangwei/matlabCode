function [iris,irisc] = loadiris();
% LOADIRIS : loads the cluster IRIS benchmark data
% [iris,irisc] = loadiris()
%	iris  - a 4*150 matrix containing the 150 samples
%	irisc - a 1*150 category vector containing the category of each sample

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

load iris.txt;
irisc = iris(:,1)';
iris = iris(:,3:6)';