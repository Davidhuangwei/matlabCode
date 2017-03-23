%   DIR_CSR         Compute the C S and R statistics for directional data.
%
%       call:   [C, S, R] = DIR_CSR(THETA,F)
%       does:   computes the statistics.

% directional statistics package
% Nov-2001 ES

function [C, S, R] = dir_csr(theta,f);

% data format check
if length(theta)~=length(f)
    error('input vectors must be of the same size');
end
if ~any(f)
    error('all values are zero');
end
if size(theta)~=size(f)
    f=f';
end

n = sum(f);
x = f.*cos(theta);
y = f.*sin(theta);

C = sum(x)/n;
S = sum(y)/n;   
R = (C^2 + S^2)^0.5;