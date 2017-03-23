function [proj, hf, f]=spproj_pt(dN, tapers, nf, fk, sampling)
%SPPROJ_DN  Spectral projection using the multitaper techniques
%
% [PROJ, F] = SP_PROJ_DN(dN, TAPERS, NF, FK) calculates the multitaper
% spectral projection of X using prolates specified in TAPERS.
%
% Note:  dN is a trial-time series array.

% Modification History: Written by Bijan Pesaran 3 July, 2000


ntr = size(dN, 1);
N = size(dN, 2);

errorchk=0;

if nargin < 5 sampling = 1; end
if nargin < 2 tapers = [N, 3, 5];  end 
if length(tapers) == 3 tapers(1) = tapers(1).*sampling; end
tapers = dpsschk(tapers);
if nargin < 3 nf = max(256,2^(nextpow2(N+1)+1)); end
if nargin < 4 fk = nf./2; end
if nargin > 4 fk = floor(nf.*fk./sampling);  end
if nargout > 3 errorchk = 1; end

%e = [sqrt(-1),1]; % e = e(2:-1:1);
%ph = exp(i*2*pi*[1:nf]./nf.*(N-1)/2);

K = size(tapers, 2);
N = size(tapers, 1);
ntapers = tapers.*sqrt(sampling);

wtmp = zeros(1, nf);
f = [1:fk].*sampling./nf;


for k = 1:K H(k,:) = fft([ntapers(:,k)' zeros(1,nf-N)]); end

proj = zeros(ntr, K, nf);
hf = 0;

for tr = 1:ntr,
  x = dN(tr,:)';
  rate = mean(x);
  for ik = 1:K
  %  tmp = fft([(ntapers(:,1:K).*x(:,ones(1,K)))' zeros(K,nf-N)]);
  tmp = fft([(ntapers(:,ik).*x)' zeros(1,nf-N)]);
  proj(tr, ik, :) = tmp - rate.*H(ik,:);
  hf = hf + sum((x.*ntapers(:,ik)).^2);
  end
end

proj = proj(:, :, 1:fk);
hf = hf./K./ntr;
