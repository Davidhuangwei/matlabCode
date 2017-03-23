%   MY_COMPASS      Simple compass plot.

% based on the MATLAB function specgraph\compass
% directional statistics package
% Dec-2001 ES

function hc = my_compass(x,y,s)

a = ((0:4) + 1./2) ./ 4;
sq = sqrt(2) .* exp(-sqrt(-1) .* 2 .* pi .* a);

xx = [0 1 .8 1 .8].';
yy = [0 0 .08 0 -.08].';
arrow = xx + yy.*sqrt(-1);

if nargin == 2
   if isstr(y)
      s = y;
      y = imag(x); x = real(x);
     else
      s = [];
   end
  elseif nargin == 1
   s = [];
   y = imag(x); x = real(x);
end

x = x(:);
y = y(:);
if length(x) ~= length(y)
   error('X and Y must be same length.');
end

z = (x + y.*sqrt(-1)).';
a = arrow * z;

next = lower(get(gca,'NextPlot'));
isholdon = ishold;
[th,r] = cart2pol(real(a),imag(a));
if isempty(s),
  h = my_polar(th,r);
  co = get(gca,'colororder');
  set(h,'color',co(1,:))
else
  h = my_polar(th,r,s);
end
if ~isholdon, set(gca,'NextPlot',next); end
if nargout > 0
   hc = h;
end
