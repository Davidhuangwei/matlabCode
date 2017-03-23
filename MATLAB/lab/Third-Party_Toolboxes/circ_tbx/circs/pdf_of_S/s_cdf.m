%   S_CDF           Computes p value for a sample from a unit circle.
%
%       See COMP_CIRC_VAR, DIR_MEAN.

% directional statistics package
% Dec-2001 ES

function p = s_cdf(theta);

reps = 10000;
n = length(theta);
x = rand(reps,n)*2*pi;
temp = comp_circ_var(x);
[yy,xx,rs,emsg] = cdfcalc(temp);

[mean, S, s] = dir_mean(theta,ones(length(theta),1));
index = min(find(xx>S));
p = yy(index);

figure, plot(xx,yy(1:end-1))
hold on, plot(xx(index),yy(index),'r.')
tbuf = sprintf('n=%g, p=%0.3g, S=%0.3g, reps=%g',n,p,S,reps);
title(tbuf), xlabel('S'), ylabel('F(S)')
disp('finished')