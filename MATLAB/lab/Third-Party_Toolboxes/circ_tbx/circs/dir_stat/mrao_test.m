%   MRAO_TEST       Modified Rao's test of uniformity for directional data.
%
%       call:   [H0 P_VALUE] = MRAO_TEST(THETA, F, ALPHA)
%       does:   Test the null hypothesis (HO):
%                                               f(theta) = theta/(2*pi)
%               against the alternative (H1):
%                                               f(theta) != theta/(2*pi),
%       output: the p value; 1 if H0 is accepted, 0 if rejected.
%
%       See also RAO_TEST.

% directional statistics package
% Dec-2001 ES

function [H0, p_value] = mrao_test(theta, f, alpha);

% check input size
[s1 s2] = size(theta);
if s1~=1 & s2~=1
    error('input should be a vector')
end
[s3 s4] = size(f);
if s3~=1 & s4~=1
    error('input should be a vector')
end  
% make them row vectors
if s1>s2
    theta = theta';
end
if s3>s4
    f=f';
end
% make sure they are of the same length
if size(theta)~=size(f)
   error('vectors should be of the same length')
end

% check requested alpha
if alpha<=0 | alpha>=1
    error('alpha should be between 0 and 1')
end
% cannot estimate, likely to be non-uniform
if length(theta)<4
    H0 = 0;
    p_value = 1;
    return
end

% measure, sort and permute the input vector
n = length(theta);
theta = sort(theta);
ptheta = [theta(n) theta(1:(n-1))];

% find the arc lengths (incl. correction for circularity)
dtheta = theta - ptheta;
dtheta(1) = dtheta(1) + 2*pi;

% modifications for modulation
n = f / min(f);
lambda = 2*pi/sum(n);

% the statistic - half the sum of the weighed deviations
UM = 1/2*sum(abs(dtheta-lambda.*n));
p_value = rao_table(UM*180/pi,sum(n));
sum(n)
% compare
if p_value>alpha
    H0 = 1;
    tbuf = sprintf('H0 accepted (rao p value = %g)', p_value);
else
    H0 = 0;
    tbuf = sprintf('H0 rejected (rao p value = %g)', p_value);
end
