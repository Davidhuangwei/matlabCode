%   WHEELER         Wheeler's 2-sample test for directional data.
%
%       call:   [H0 P_VALUE] = WHEELER(THETA1,THETA2,ALPHA)
%               WHEELER(...,'compass') also plots,
%               WHEELER(...,'rose') makes a rose diagram.
%
%       does:   Test the null hypothesis (HO):
%                                               f(theta1) = f(theta2)
%               against the alternative (H1):
%                                               f(theta1) ~= f(theta2),
%               Observations are linearly rankled and then replaced
%               by uniformly distributed scores.
%
%       output: the p value (-1 if cannot compare)
%               H0: 1 if accepted, 0 if rejected.

% directional statistics package
% Dec-2001 ES

function [H0, p_value] = wheeler(a,b,alpha,varargin);

%% need to untie matches ! ! !

% check input size
[s1 s2] = size(a);
[s3 s4] = size(b);
if ( ( s1~=1 ) & ( s2~=1 ) ) | ( ( s3~=1 ) & ( s4 ~= 1 ) )
    error('inputs should be vectorial')
end
% make them row vectors
if s1>s2
    a = a';
end
if s3>s4
    b = b';
end 
% check requested alpha
if (alpha<=0) | (alpha>=1)
    error('alpha should be between 0 and 1')
end

a = sort(a);
b = sort(b);
na = length(a);
nb = length(b);

% cannot estimate, likely to be non-uniform
if na<4 | nb<4
    H0 = 0;
    p_value = -1;
    return
end

% arrange the signed data points
comb = sortrows([a b; ones(1, na) 2*ones(1,nb)]');
beta = find(comb(:,2)==1)*2*pi/(na+nb);

% compute the test statistic R
xa = cos(beta);
ya = sin(beta);
C = sum(xa);
S = sum(ya);
R = 2*(na+nb-1)*(C^2+S^2)/(na*nb);

% it is distributed as chi2, so
p_value = 1 - chi2cdf(R, 2);

% compare
if p_value>alpha
    H0 = 1;
else
    H0 = 0;
end

% give a visual, if so desired
nin = nargin - 3;
if (nin>0 & isstr(varargin{nin}))
    graph = varargin{nin};
    nin = nin - 1;
    beta_b = find(comb(:,2)==2)*2*pi/(na+nb);
    xb = cos(beta_b);
    yb = sin(beta_b);
    tbuf = sprintf('Wheeler uniform score test; p value = %g\nn1 = %g, n2 = %g',p_value, na, nb);
    switch graph
    case 'compass'
       figure, compass(xa,ya), hold on, compass (xb,yb,'r'), hold off;
       title(tbuf)
    case 'rose'
       n = na + nb;
       figure, my_rose(beta,n,'-');
       hold on, my_rose(beta_b,n,'.');
       hold off;
       title(tbuf)
    end
 end
 

% a better approximation - f distribution
% n = na + nb
% fR = R / (n - 1 - R)
% v1 = 1 + ( (n*(n+1)-6*na*nb) / (n*(na-1)*(nb-1)) ) 
% v2 = (n-3)/round(v1)
% fcdf(fR,round(v2),round(v1))

% R2 = (C^2+S^2)
% R2 = R*n1*(n-n1)/2/(n-1)