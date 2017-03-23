function [Xspec, f] = xspec(X1, X2, tapers, nf, fk, sampling, flag)
% XSPEC calculates the cross-spectrum using the multitaper method
%
% XSPEC = XSPEC(X1, X2, TAPERS, NF, FK, SAMPLING) calculates 
% the xspec of X1 and X2 using prolates specified in TAPERS.  
% TAPERS defaults to [N, 3, 5] where N is the length of the data.
% NF defaults to the next power of 2 greater than N.  FK defaults
% to NF./2 and SAMPLING defaults to 1.
%
% [XSPEC, F] = XSPEC(X1, X2, TAPERS, NF, FK, SAMPLING)  returns the
% frequency axis for XSPEC in F.
%
% If FLAG = 0 the rows of X1 and X2 are different channels and Xspec
%  is a matrix.
% If FLAG = 1 the rows of X1 and X2 are different trials and Xspec is
%  averaged across trials and is a vector.
%

% Written by:  Bijan Pesaran Bell Labs 1999
%

%[Y1, dims1] = reduce(X1);
Y1 = X1;
sY1 = size(Y1);
n1 = sY1(2);
nch1 = sY1(1);

%[Y2, dims2] = reduce(X2);
Y2 = X2;
sY2 = size(Y2);
n2 = sY2(2);
nch2 = sY2(1);

if n1 ~= n2 error('X1 and X2 must have the same dimensions'); end
N = n1;
if nargin < 3 tapers = [N 3 5]; end
if nargin < 4 nf = max(256,2^(nextpow2(N)+1)); end
if nargin < 5 fk = nf./2; end
if nargin < 6 sampling = 1; end
if length(tapers) == 3; tapers(1) = tapers(1).*sampling; end
if nargin > 5 fk = floor(fk./sampling.*nf); end
if nargin < 7 flag = 0; end

tapers = dpsschk(tapers);
K = length(tapers(1,:));
N = length(tapers(:,1));

f = [1:fk]*sampling./nf;

if flag == 0
Xspec = zeros(nch1,nch2,fk);
y1k = zeros(K,nf);
y2k = zeros(K,nf);

for ch1 = 1:nch1
   tmp1 = detrend(Y1(ch1,:))';
   for ch2 = 1:ch1
      tmp2 = detrend(Y2(ch2,:))';
      y1k = fft(tapers(:,1:K).*tmp1(:,ones(1,K)),nf)';
      y2k = fft(tapers(:,1:K).*tmp2(:,ones(1,K)),nf)';
      Xspec(ch1,ch2,:) = mean(y1k(:,1:fk).*conj(y2k(:,1:fk)),1);
      Xspec(ch2,ch1,:) = conj(Xspec(ch1,ch2,:));
   end
end

end

if flag == 1
nch = nch1;
Xspec = zeros(1,fk) + complex(0,1)*zeros(1,fk);
y1k = zeros(K,nf);
y2k = zeros(K,nf);

for ch = 1:nch
   tmp1 = detrend(Y1(ch,:))';
   tmp2 = detrend(Y2(ch,:))';
   y1k = fft(tapers(:,1:K).*tmp1(:,ones(1,K)),nf)';
   y2k = fft(tapers(:,1:K).*tmp2(:,ones(1,K)),nf)';
   Xspec = Xspec + mean(y1k(:,1:fk).*conj(y2k(:,1:fk)),1);
end

end
