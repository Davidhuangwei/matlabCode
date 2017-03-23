function [proj, f]=sp_proj(X, tapers, sampling, fk, pad)
%SP_PROJ  Spectral projection using the multitaper techniques
%
% [PROJ, F] = SP_PROJ(X, TAPERS, SAMPLING, FK, PAD) 

% Modification History: Written by Bijan Pesaran 3 July, 2000


ntr = size(X, 1);
nt = size(X, 2);

errorchk=0;


if nargin < 3 sampling = 1; end
nt = nt./sampling;
if nargin < 2 tapers = [nt,3,5]; end
if length(tapers) == 2
   n = tapers(1);
   w = tapers(2);
   p = n*w;
   k = floor(2*p-1);
   tapers = [n,p,k];
   disp(['Using ' num2str(k) ' tapers.']);
end
if length(tapers) == 3 
   tapers(1) = tapers(1).*sampling; 
   tapers = dpsschk(tapers);
end
if nargin < 4 fk = [0,sampling./2]; end
if length(fk) == 1
    fk = [0,fk];
end
if nargin < 5 pad = 2; end


N = length(tapers(:,1));
nt = nt.*sampling;
if N ~= nt error('Error:  Length of time series and tapers must be equal'); end

K = length(tapers(1,:));
nf = max(256,pad*2.^(nextpow2(N+1)));

df = sampling./nf;
f = [0:df:sampling-df];
nfk = [min(find(f > fk(1)))-1,min(find(f > fk(2))-1)];
f = f(nfk(1):nfk(2));

wtmp = zeros(1, nf);
proj = zeros(ntr, K, nf);

for tr = 1:ntr,
  x = detrend(X(tr, :))';
  tmp = fft(tapers(:,1:K).*x(:,ones(1,K)),nf)';  
     %proj(tr, ik, :) = e(mod(ik,2)+1).*tmp.*ph;
  proj(tr, :, :) = tmp;%.*repmat(ph,9,1);
end

proj = proj(:, :, nfk(1):nfk(2));
