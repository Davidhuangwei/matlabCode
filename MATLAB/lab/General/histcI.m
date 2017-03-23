% [n, bin] = histcI(x, edges, dim)
%
% This is like histc (MATLAB builtin function) but with the
% difference that there is one less output bin - the annoying
% one that contained anything equal to edges(end) is gone -
% insteac anything equal to the edges(end) is included in the
% previous bin

function [n, bin] = histcI(varargin)

[n, bin] = histc(varargin{:});
if size(n,1)==1 
    n = n';
end
len = size(n,1);
n(len-1,:) = n(len-1,:)+n(len,:);
n = n(1:len-1,:);

bin(find(bin==len)) = len-1;
