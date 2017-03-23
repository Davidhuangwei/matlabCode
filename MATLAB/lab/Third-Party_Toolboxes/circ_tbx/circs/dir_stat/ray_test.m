%   RAY_TEST        Rayleigh's LR test of uniformity for directional data.
%
%       call:   [H0 P_VALUE] = RAY_TEST(THETA,F,ALPHA)
%               RAY_TEST(...,'graph') also plots the results.
%       does:   Test the null hypothesis (HO):
%                                               f(theta) = 1/(2*pi)
%               against the alternative (H1):
%                                               f(theta) = g(theta),
%               where g corresponds to von Mises' pdf.
%               Based on the Pearson approximation for the nR^2 statistic
%       output: the p value; 1 if H0 is accepted, 0 if rejected.
%
%       See also RAY_CDF, DIR_CSR.

% directional statistics package
% Dec-2001 ES

function [H0, p_value] = ray_test(theta,f,alpha,varargin);

nargs = nargin;
if nargs < 2 | isempty( f ), f = ones( size( theta ) ); end
if nargs < 3 | isempty( alpha ), alpha = 0.05; end

% check input size
if length(theta)<5
    H0 = 0;
    p_value = 1;    %   cannot estimate, likely to be non-uniform
    return
end

% calculate the statistic R
[C S R] = dir_csr(theta,f);

% and the p value (~chi2 w/ 2 dof)
% p_value = 1 - chi2cdf(2*sum(f)*R^2,2); 
% based on chi2cdf - valid for large n only

% and the p_value
p_value = ray_cdf(R,sum(f));

% compare
if p_value>alpha
    H0 = 1;
    tbuf = sprintf('Rayleigh p value = %0.2g', p_value);
else
    H0 = 0;
    tbuf = sprintf('Rayleigh p value = %0.2g', p_value);
end

% visual if so desired
nin = nargin - 3;
if (nin>0 & isstr(varargin{nin}))
    graph = varargin{nin};
    nin = nin - 1;
    if (nin>0 & isstr(varargin{nin}))
        temp_buf = sprintf('; %s',varargin{nin});
        tbuf = strcat(tbuf, temp_buf);
    end
    nin = nin - 1;
    if nin > 0
        dir_mean(theta,f,tbuf,varargin{nin},'subplots');
    else
        dir_mean(theta,f,tbuf,graph);
    end
end