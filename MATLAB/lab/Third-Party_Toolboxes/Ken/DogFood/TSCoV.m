% TSCoV(y, n, f)
%
% TSCoV stands for Time Series Coefficient of Variation
% 
% Inputs: y(f, t, ch) is a time frequency analysis of the TS 
% in question - for example produced by mtcsg.
% 		  n is the number of tapers (should be 2*NW-1, e.g. 5)
%         f is an optional vector of frequency bins produced by mtcsg
%
% How it works: If the time series is a stationary Gaussian,
% the time frequency analysis is a chi^2 distribution with 2*n
% although this goes wrong near the start and end of the frequency
% range.  The coefficient of variation (s.d./mean) for
% a chi^2 is sqrt(2/DF).  
%
% This function does a plot of the coefficient of variation in
% each frequency bin, overlaid with the constant number expected
% for the chi^2.

function TSCoV(y, n, f, Color)

if (nargin<3) f = ((0:size(y,1)-1) / (size(y,1) - 1)); end

% calculate coefficient of variation
CoV = squeeze(std(y,0,2) ./ mean(y,2));

% plot it with a dotted line for expected value
plot(f,CoV);
h = ishold;
hold on
plot([f(1) f(end)], [1 1] * sqrt(1/n), '--');

if (h==0) hold off; end;