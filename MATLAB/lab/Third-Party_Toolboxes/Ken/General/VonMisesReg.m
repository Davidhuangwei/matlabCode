% [mu, b, k, berr] = VonMisesReg(th, x, v0)
%
% fits a model of the form th ~ VonMises(mu + 2*atan(b'*x), k)
%
% berr returns the large-sample covariance matrix estimate for b
%
% See Fisher, Statistical analysis of circular data, sec 6.4.2
%
% v0 is starting estimate[mu beta]

function [mu, b, k, berr] = VonMisesReg(th, x, v0)

if min(size(th))>1
	error('th must be a vector')
end
th = th(:);

if size(x,1)~=length(th)
	error('x should be a nxd matrix with n the number of points');
end
if size(x,2)==1
	warning('did you forget the constant term?');
end
[n, d] = size(x);

if n<d+1
    warning('not enough data points');
    mu = circmean(th);
    b = NaN*ones(1,d);
    k = NaN;
    berr = NaN*ones(d);
    return
end

g = inline('2*atan(x)');
dg = inline('2./(1+x.*x)');

% initialize variables
if nargin<3
    mu = circmean(th);
    v0 = [mu zeros(1,d)];
end

if 1
% use netlab optimization routines
opt([1 2 3 9 10 11 14 18]) = [0 1e-4 1e-3 0 100 100 100 0];
[v options errlog pointlog] = scg(@VonMisesReg_f, v0, opt, @VonMisesReg_df, th, x);

% estimate k
mu = v(1);
b = v(2:end);
[mu2, R] = circmean(th-g(x*b'));
k = BesselRatInv(R);

% now make covariance est for b
gv = dg(x*b');
G2 = sparse(1:n, 1:n, gv.*gv);
xG2xI = inv(x'*G2*x);
gtx = gv'*x;
berr = (xG2xI + xG2xI*gtx'*gtx*xG2xI/(n-gtx*xG2xI*gtx'))/k/R;



%keyboard
return
end

while 1
%    xb = x*b';
%    gxb = g(x*b');

    u = sin(th-mu-g(x*b));
%    G = sparse(1:n, 1:n, dg(x*b));
    G2 = sparse(1:n, 1:n, dg(x*b).^2);

    y = u./dg(x*b)/(besseli(1,k)/besseli(0,k));
    db = (x'*G2*x)\(x'*G2*y);
    x'*G2*x
    det(x'*G2*x)
    
    ridge = .1;
    b = b+db -b*ridge;
    
    [mu, R] = circmean(th-g(x*b));
    k = BesselRatInv(R);

    fprintf('mu %f k %f b ', mu, k);
    fprintf('%f ', b);
    fprintf('\n');
    
    xr = -10:.1:10;
    hold off; plot(x(:,1), mod(th,2*pi), '.', 'markersize', 1);
    hold on; plot(xr, mod(mu+g([xr', ones(size(xr))']*b),2*pi), 'r');
    
    pause
end

return

% to test
x = rand(1000,1)*20 - 10;
th = 2*atan(2*x + 1)+randn(1000,1);
VonMisesReg(th, [x, ones(1000,1)]);
