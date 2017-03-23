function [no,xo,bin] = histcount(y,x)
% function [no,xo,bin] = histcount(y,x)
% use hist.
% no: numbers of elements in one bin.
% xo: edges (lower bound, (])
% bin: which bin each data belong to (you always have length(no)+1
% ids). becasue the smallest is: (-inf, edges(1)].
% YYC.

if nargin == 0
    error('Requires one or two input arguments.')
end
if nargin == 1
    x = 10;
end
if min(size(y))==1, y = y(:); end
if isstr(x) | isstr(y)
    error('Input arguments must be numeric.')
end

[m,n] = size(y);
if isempty(y),
    if length(x) == 1,
       x = 1:x;
    end
    nn = zeros(size(x)); % No elements to count
else
    if length(x) == 1
        miny = min(min(y));
        maxy = max(max(y));
    	  if miny == maxy,
    		  miny = miny - floor(x/2) - 0.5; 
    		  maxy = maxy + ceil(x/2) - 0.5;
     	  end
        binwidth = (maxy - miny) ./ x;
        xx = miny + binwidth*(0:x);
        xx(length(xx)) = maxy;
        x = xx(1:length(xx)-1) + binwidth/2;
    else
        xx = x(:)';
        miny = min(min(y));
        maxy = max(max(y));
        binwidth = [diff(xx) 0];
        xx = [xx(1)-binwidth(1)/2 xx+binwidth/2];
        xx(1) = min(xx(1),miny);
        xx(end) = max(xx(end),maxy);
    end
    nbin = length(xx);
    % Shift bins so the internal is ( ] instead of [ ).
    xx = full(real(xx)); y = full(real(y)); % For compatibility
    bins = xx + max(eps,eps*abs(xx));
    [nn,bin]= histc(y,[-inf bins],1);
    
    % Combine first bin with 2nd bin and last bin with next to last bin
    nn(2,:) = nn(2,:)+nn(1,:);
    nn(end-1,:) = nn(end-1,:)+nn(end,:);
    nn = nn(2:end-1,:);
end

if nargout == 0
    bar(x,nn,'hist');
else
  if min(size(y))==1, % Return row vectors if possible.
    no = nn';
    xo = x;
  else
    no = nn;
    xo = x';
  end
end
