% [p g] = GrubbsTest(x)
%
% Performs Grubbs' test for outliers in univariate normal data
% see e.g. http://www.itl.nist.gov/div898/handbook/eda/section3/eda35h.htm
%
% tail is used as in ttest - 0 for two-tailed (default) -1 for left, +1 
% for right
%
% it is also approximate (as evidenced by it can be >1!) but is accurate for
% small p.

function [p, g] = GrubbsTest(x, tail)

if nargin<2
    tail=0;
end

mu = mean(x);
sig = std(x);
n = length(x);

if tail==0
    g = max(abs(x-mu))/sig;
elseif tail<0
    g = min(x-mu)/sig;
elseif tail>0
    g = max(x-mu)/sig;
end
    
%t2 = tinv(.05/(2*n),n-2)^2;

%crit = (n-1)/sqrt(n) * sqrt(t2/(n-2+t2));
%p = (g>crit);

%return

t2 = (n-2)/((sqrt(n)*g/(n-1)).^-2 - 1);

p = (1-tcdf(sqrt(t2),n-2))*n ...
    * (1+(tail==0)); % double p for two-tailed test.
