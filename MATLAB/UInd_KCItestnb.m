function Sta = UInd_KCItestnb(x, y, width)
% function [p_val] = UInd_test(x, y)
% To test if x and y are unconditionally independent with bootstrap (which is 
%       the same as in HSIC test) or with the finite-sample Gamma approximation.
% INPUT:
%   X and Y: data matrices of size number_of_samples * dimensionality. 
%   width (optional): the kernel width for x and y.
% Output:
%   p_val: the p value obtained by bootstrapping (if the sample size is 
%       smaller than 1000) or by Gamma approximation (if the sample size is 
%       large).
% Copyright (c) 2010-2011  Kun Zhang, Jonas Peters.
% All rights reserved.  See the file COPYING for license terms.
%
% For details of the method, see K. Zhang, J. Peters, D. Janzing, and B. Schoelkopf, 
%       "A kernel-based conditional independence test and application in causal discovery,"
%       In UAI 2011,
%         and 
%       A. Gretton, K. Fukumizu, C.-H. Teo, L. Song, B. Schoelkopf and A. Smola, "A kernel 
%       Statistical test of independence." In NIPS 21, 2007.

T = length(y); % the sample size

% % Controlling parameters
% if T>1000
%     Approximate = 1;
%     Bootstrap = 0;
% else
%     Bootstrap = 1;
%     Approximate = 0;
% end
Method_kernel_width = 1; % 1: empirical value; 2: median

% Num_eig = floor(T/4); % how many eigenvalues are to be calculated?
if T>1000
    Num_eig = floor(T/2);
else
    Num_eig = T;
end
% normalize the data
x = x - repmat(mean(x), T, 1);
x = x * diag(1./std(x));
y = y - repmat(mean(y), T, 1);
y = y * diag(1./std(y));
Sta = [];
% use empirical kernel width instead of the median
if ~exist('width', 'var')||isempty(width)||width==0
    if T < 200
        width = 0.8;
    elseif T < 1200
        width = 0.5;
    else
        width = 0.3;
    end
end
if Method_kernel_width == 1
    theta = 1/(width^2); % I use this parameter to construct kernel matices. Watch out!! width = sqrt(2) sigma  AND theta= 1/(2*sigma^2)
else
    theta = 0;
end
%    width = sqrt(2)*medbw(x, 1000); %use median heuristic for the band width.
%theta = 1/(width^2); % I use this parameter to construct kernel matices. Watch out!! width = sqrt(2) sigma  AND theta= 1/(2*sigma^2)

H =  eye(T) - ones(T,T)/T; % for centering of the data in feature space
% Kx = kernel([x], [x], [theta/size(x,2),1]); Kx = H * Kx * H; %%%%Problem
% Ky = kernel([y], [y], [theta/size(y,2),1]); Ky = H * Ky * H;  %%%%Problem
Kx = kernel([x], [x], [theta * size(x,2),1]); Kx = H * Kx * H; %%%%Problem
Ky = kernel([y], [y], [theta * size(y,2),1]); Ky = H * Ky * H;  %%%%Problem

Sta = trace(Kx * Ky);