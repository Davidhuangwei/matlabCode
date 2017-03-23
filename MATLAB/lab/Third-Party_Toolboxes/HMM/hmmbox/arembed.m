function [x,y] = arembed(Z,p,m);

%  function [x,y] = arembed(Z,p,m);
%  Create embedded data for use in, for example, an AR model
%  Z      univariate time series 
%  p      order of model
%  m      embedding method; 0-ieads; 1-toeplitz (default 0)
%  x      embedded 'inputs'
%  y      targets

if nargin < 2, error('arembed needs at least two arguments'); end
if nargin < 3 | isempty(m), m=0; end

Z=Z(:)';
n=length(Z);

if m==0
  x=embed(Z,p,1);
  x=x(1:n-p,p:-1:1);   % Reverse columns of x and remove last row
  y=Z(p+1:1:n)';
  return
end

t=toeplitz(Z);
xt=t(1:n-p+1,n-p+1:n);
x=xt(2:size(xt,1),:);
x=x(:,p:-1:1);   % Reverse columns of x
y=Z(p+1:1:n)';

% Reverse rows of x to get correct time ordering
x=x(n-p:-1:1,:);   

