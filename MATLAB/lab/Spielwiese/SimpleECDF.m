function [Fout,x,ind,Flo,Fup,D] = SimpleECDF(y,varargin)
%ECDF Empirical (Kaplan-Meier) cumulative distribution function.
%   [F,X, ind] = myecdf(Y) calculates the Kaplan-Meier estimate of the
%   cumulative distribution function (cdf), also known as the empirical
%   cdf.  Y is a vector of data values.  F is a vector of values of the
%   empirical cdf evaluated at X. ind returns the index within the original
%   Y vector to which x corresponds now.
%
%
% see ecdf
if (nargin > 0) && isscalar(y) && ishandle(y) && isequal(get(y,'type'),'axes')
    axarg = {y};
    if nargin>1
       y = varargin{1};
       varargin(1) = [];
    else
       y = [];  % error to be dealt with below
    end
else
    axarg = {};
end 

% Require a data vector
if ~isvector(y)
    error('stats:ecdf:VectorRequired','Input Y must be a vector.');
end
x = y(:);

okargs = {'censoring' 'frequency' 'alpha' 'function' 'bounds'};
defaults = {[]        []          0.05    'cdf'      'off'};

% Check arguments

cens = zeros(size(x));

freq = ones(size(x));

% % Remove NaNs, so they will be treated as missing
% [ignore1,ignore2,x,cens,freq] = statremovenan(x,cens,freq);


% Remove missing observations indicated by NaN's.
t = ~isnan(x) & ~isnan(freq) & ~isnan(cens) & freq>0;
x = x(t);
n = length(x);
if n == 0
    error('stats:ecdf:NotEnoughData',...
          'Input sample has no valid data (all missing values).');
end
cens = cens(t);
freq = freq(t);

% Sort observation data in ascending order.
[x,ind] = sort(x);
cens = cens(ind);
freq = freq(ind);
if isa(x,'single')
   freq = single(freq);
end

% Compute cumulative sum of frequencies
totcumfreq = cumsum(freq);
obscumfreq = cumsum(freq .* ~cens);

totalcount = totcumfreq(end);

% Get number of deaths and number at risk at each unique X
D = [obscumfreq(1); diff(obscumfreq)];
N = totalcount - [0; totcumfreq(1:end-1)];

% No change in function except at a death, so remove other points
t = (D>0);
x = x(t);
D = D(t);
N = N(t);

% Use the product-limit (Kaplan-Meier) estimate of the survivor
% function, transform to the CDF.
S = cumprod(1 - D./N);

Func = 1 - S;
F0 = 0;       % starting value of this function (at x=-Inf)

% Include a starting value; required for accurate staircase plot
%x = [min(y); x];
%F = [F0; Func];
F = Func;

if nargout>3 || (nargout==0 && isequal(bounds,'on'))
    % Get standard error of requested function
    if cdf_sf % 'cdf' or 'survivor'
        se = repmat(NaN,size(D));
        if N(end)==D(end)
            t = 1:length(N)-1;
        else
            t = 1:length(N);
        end
        se(t) = S(t) .* sqrt(cumsum(D(t) ./ (N(t) .* (N(t)-D(t)))));
    else % 'cumhazard'
        se = sqrt(cumsum(D ./ (N .* N)));
    end

    % Get confidence limits
    zalpha = -Snorminv(alpha/2);
    halfwidth = zalpha*se;
    Flo = max(0, Func-halfwidth);
    Flo(isnan(halfwidth)) = NaN; % max drops NaNs, put them back
    if cdf_sf % 'cdf' or 'survivor'
        Fup = min(1, Func+halfwidth);
        Fup(isnan(halfwidth)) = NaN; % max drops NaNs
    else % 'cumhazard'
        Fup = Func+halfwidth; % no restriction on upper limit
    end
    Flo = [NaN; Flo];
    Fup = [NaN; Fup];
end

%% Plot if no return values are requested
%if nargout==0
%    if isequal(bounds,'on')
%        h = stairs(axarg{:},x,[F Flo Fup]);
%        set(h(2:3), 'Color',get(h(1),'Color'), 'LineStyle',':');
%    else
%        stairs(axarg{:},x,F);
%    end
%else
Fout = F;
%end
