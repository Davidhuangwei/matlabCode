function [proj, f, lvar] = specproj(X, tapers, nf, fk, sampling)
%  SPECPROJ calculates multitaper spectral projections
%
%  PROJ = SPECPROJ(X, TAPERS, NF) calculates the multitaper projections
%  of X using prolates.
%
%  [PROJ, F] = SPECPROJ(X, TAPERS, NF, FK, SAMPLING) returns the frequency 
%  axis for PROJ.
% 
%	Defaults:	TAPERS = [N, 3, 5]
%					NF = Nextpower of 2 > N
%					FK = SAMPLING/2
%					SAMPLING = 1
%

% Modification History:  
%           Written by:  Bijan Pesaran, 08/97
%           Modified:    Added error bars BP 08/27/98

[Y, dims] = reduce(X);
sY = size(Y);
N = sY(2);
ntr = sY(1);

if nargin < 5 sampling = 1; end
if nargin < 2 
   tapers = [N, 3, 5]; 
   tapers(1) = tapers(1).*sampling;
end
if nargin < 3 nf = max(256,2^(nextpow2(N+1)+1)); end
if nargin < 4 fk = nf./2; end
if nargin == 5 fk = floor(fk./sampling.*nf); end

tapers = dpsschk(tapers);
K = length(tapers(1,:));
proj = zeros(ntr, K, fk);
wtmp = zeros(1, nf);

for tr = 1:ntr
	tmp = detrend(Y(tr,:));
	for ik = 1:K
   	wtmp(1:N) = tmp'.*tapers(:,ik);
   	xk(ik,:) = fft(wtmp);
	end
   proj(tr,:,:) = xk(:,1:fk);
end

proj = squeeze(proj);