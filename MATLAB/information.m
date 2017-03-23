function [estimate,nbias,sigma,descriptor]=information(x,y,descriptor,approach,base)
%INFORMATION   Estimates the mutual information of two stationary signals with
%              independent pairs of samples using various approaches.
%   [ESTIMATE,NBIAS,SIGMA,DESCRIPTOR] = INFORMATION(X,Y) or
%   [ESTIMATE,NBIAS,SIGMA,DESCRIPTOR] = INFORMATION(X,Y,DESCRIPTOR) or
%   [ESTIMATE,NBIAS,SIGMA,DESCRIPTOR] = INFORMATION(X,Y,DESCRIPTOR,APPROACH) or
%   [ESTIMATE,NBIAS,SIGMA,DESCRIPTOR] = INFORMATION(X,Y,DESCRIPTOR,APPROACH,BASE)
%
%   ESTIMATE     : The mutual information estimate
%   NBIAS        : The N-bias of the estimate
%   SIGMA        : The standard error of the estimate
%   DESCRIPTOR   : The descriptor of the histogram, see also HISTOGRAM2
%
%   X,Y          : The time series to be analyzed, both row vectors
%   DESCRIPTOR   : Where DESCRIPTOR=[LOWERBOUNDX,UPPERBOUNDX,NCELLX;
%                                    LOWERBOUNDY,UPPERBOUNDY,NCELLY]
%     LOWERBOUND?: Lowerbound of the histogram in ? direction
%     UPPERBOUND?: Upperbound of the histogram in ? direction
%     NCELL?     : The number of cells of the histogram  in ? direction 
%   APPROACH     : The method used, one of the following ones :
%     'unbiased' : The unbiased estimate (default)
%     'mmse'     : The minimum mean square error estimate
%     'biased'   : The biased estimate
%   BASE         : The base of the logarithm; default e
%
%   See also: http://www.cs.rug.nl/~rudy/matlab/

%   R. Moddemeijer 
%   Copyright (c) by R. Moddemeijer
%   $Revision: 1.1 $  $Date: 2001/02/05 08:59:36 $

x = MakeUniformDistr(x)';
y = MakeUniformDistr(y)';
x=x(:)';
y=y(:)';
if nargin <1
   disp('Usage: [ESTIMATE,NBIAS,SIGMA,DESCRIPTOR] = INFORMATION(X,Y)')
   disp('       [ESTIMATE,NBIAS,SIGMA,DESCRIPTOR] = INFORMATION(X,Y,DESCRIPTOR)')
   disp('       [ESTIMATE,NBIAS,SIGMA,DESCRIPTOR] = INFORMATION(X,Y,DESCRIPTOR,APPROACH)')
   disp('       [ESTIMATE,NBIAS,SIGMA,DESCRIPTOR] = INFORMATION(X,Y,DESCRIPTOR,APPROACH,BASE)')
   disp('Where: DESCRIPTOR = [LOWERBOUNDX,UPPERBOUNDX,NCELLX;')
   disp('                     LOWERBOUNDY,UPPERBOUNDY,NCELLY]')
   return
end

% Some initial tests on the input arguments

[NRowX,NColX]=size(x);

if NRowX~=1
  error('Invalid dimension of X');
end;

[NRowY,NColY]=size(y);

if NRowY~=1
  error('Invalid dimension of Y');
end;

if NColX~=NColY
  error('Unequal length of X and Y');
end;

if nargin>5
  error('Too many arguments');
end;

if nargin==2
  [h,descriptor]=histogram2(x,y);
end;

if nargin>=3
  [h,descriptor]=histogram2(x,y,descriptor);
end;

if nargin<4
  approach='unbiased';
end;

if nargin<5
  base=exp(1);
end;

lowerboundx=descriptor(1,1);
upperboundx=descriptor(1,2);
ncellx=descriptor(1,3);
lowerboundy=descriptor(2,1);
upperboundy=descriptor(2,2);
ncelly=descriptor(2,3);

estimate=0;
sigma=0;
count=0;

% determine row and column sums

hy=sum(h);
hx=sum(h');

for nx=1:ncellx
  for ny=1:ncelly
    if h(nx,ny)~=0 
      logf=log(h(nx,ny)/hx(nx)/hy(ny));
    else
      logf=0;
    end;
    count=count+h(nx,ny);
    estimate=estimate+h(nx,ny)*logf;
    sigma=sigma+h(nx,ny)*logf^2;
  end;
end;

% biased estimate

estimate=estimate/count;
sigma   =sqrt( (sigma/count-estimate^2)/(count-1) );
estimate=estimate+log(count);
nbias   =(ncellx-1)*(ncelly-1)/(2*count);

% conversion to unbiased estimate

if approach(1)=='u'
  estimate=estimate-nbias;
  nbias=0;
end;

% conversion to minimum mse estimate

if approach(1)=='m'
  estimate=estimate-nbias;
  nbias=0;
  lambda=estimate^2/(estimate^2+sigma^2);
  nbias   =(1-lambda)*estimate;
  estimate=lambda*estimate;
  sigma   =lambda*sigma;
end;

% base transformation

estimate=estimate/log(base);
nbias   =nbias   /log(base);
sigma   =sigma   /log(base);
end
function out = MakeUniformDistr(in,varargin)
%function out = MakeUniformDistr(in,a,b)
%does the ecdf transformatiton of the in
%so thatt  = (b-a)2*pi*ecdf(in)+awhos
% if in is uniform distributed then out=in
[a,b] = DefaultArgs(varargin,{min(in), max(in)});
[f,x,ind] = myecdf(in);

[dummy indr] = sort(ind);

out = (b-a)*f(indr)+a;

end
function [Fout,x,ind,Flo,Fup,D] = myecdf(y,varargin)
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
%{
dont know howthis affect anything, it only makes the cdf notredundant
but for our purposes we need all points
t = (diff(x) == 0);
if any(t)
    x(t) = [];
    totcumfreq(t) = [];
    obscumfreq(t) = [];
end
%} 
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
x = [min(y); x];
F = [F0; Func];

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

% Plot if no return values are requested
if nargout==0
    if isequal(bounds,'on')
        h = stairs(axarg{:},x,[F Flo Fup]);
        set(h(2:3), 'Color',get(h(1),'Color'), 'LineStyle',':');
    else
        stairs(axarg{:},x,F);
    end
else
    Fout = F;
end
end