%   MY_CDFPLOT      Display an empirical cumulative distribution function.

% based on the MATLAB function stats\cdfplot
% directional statistics package
% Dec-2001 ES

function [handleCDF,stats] = my_cdfplot(x,string)

% Get sample cdf, display error message if any
[yy,xx,n,emsg] = cdfcalc(x);
error(emsg);

% Create vectors for plotting
k = length(xx);
n = reshape(repmat(1:k, 2, 1), 2*k, 1);
xCDF    = [-Inf; xx(n); Inf];
yCDF    = [0; 0; yy(1+n)];

% Now plot the sample (empirical) CDF staircase.
hCDF = plot(xCDF , yCDF, string);
if (nargout>0), handleCDF=hCDF; end

% Compute summary statistics if requested.
if nargout > 1
   stats.min    =  min(x);
   stats.max    =  max(x);
   stats.mean   =  mean(x);
   stats.median =  median(x);
   stats.std    =  std(x);
end