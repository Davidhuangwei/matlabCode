function [spec_pt, rsspec_pt, ftest_pt, hf, f, lsd] = ...
			mxspec_pt(dN, tapers, nf, fk, sampling, freq) 
%MXSPEC_PT  Mixed point process spectrum using multitaper techniques 
%
%  [SPEC_PT, RSSPEC_PT, FTEST_PT, HF, F, LSD] = 
%		MXSPEC_PT(dN, TAPERS, NF, FK, SAMPLING)   
%  returns the multitaper spectral estimates of dN using prolates 
%  specified in TAPERS.   
%	SPEC_PT = Mixed spectrum
%	FSPEC_PT = Residual spectrum
%	FTEST_PT = F-test across frequencies
%
%  Note:  dN is in the counting representation.
%
%  Defaults:	TAPERS = [N, 5, 9]
%		NF = Next power of 2 > 2*N
%		FK = SAMPLING/2
%		SAMPLING = 1
%		FREQ = 
%

% Modification History: Written by Bijan Pesaran 02/04/00

ntr = size(dN,1);
n = size(dN,2);

errorchk = 0;

if nargin < 5 sampling = 1; end
if nargin < 2 tapers = [n, 5, 9]; end
if length(tapers) == 3
   tapers(1) = tapers(1).*sampling;
   tapers = dpsschk(tapers);
end
if length(tapers(:,1)) ~= n 
   error('dN and tapers must be the same length'); 
end
if nargin < 3 nf = max(256,2^(nextpow2(n+1)+2)); end
if nargin < 4 fk = nf./2; end
if nargin == 5 fk = floor(fk./sampling.*nf); end
if nargout > 3 errorchk = 1; end

ntapers = tapers.*sqrt(sampling);
K = length(ntapers(1,:));
n = length(ntapers(:,1));
f = [1:fk].*sampling./nf;

for k = 1:K H(k,:) = fft([ntapers(:,k)' zeros(1,nf-n)]); end

if ~errorchk
   spec_pt = zeros(1,nf);
	hf = 0;

	for it = 1:ntr
   	  for ik = 1:K
             spec_pt = spec_pt + abs(jk_pt).^2;
	     jk_pt = fft([dN(it,:).*ntapers(:,ik)' ... 
               zeros(1,nf-n)]) - mean(dN(it,:)).*H(ik,:);
  	     hf = hf + sum((dN(it,:).*ntapers(:,ik)').^2);
	     chat = chat + jk_pt .* H(k,1);
	    end
	end
	spec_pt = spec_pt(1:fk)./(K.*ntr);
	hf = hf./(K.*ntr);
	chat = chat./sum(H(:,1).^2,1)./ntr;
end


if errorchk  % compute delete one estimates :   
   	dNk = zeros(ntr*K,nf);
	hf = 0;
	

	for it = 1:ntr
   	for ik = 1:K
          dNk((it-1).*K+ik,:) = (fft([dN(it,:).*ntapers(:,ik)' ... 
               zeros(1,nf-n)]) - mean(dN(it,:)).*H(ik,:));
	  hf = hf + sum((dN(it,:).*ntapers(:,ik)').^2);
	end
	end
	  spec_pt = mean(abs(dNk(:,1:fk)).^2,1);
	  hf = hf./(K.*ntr);

	  lsp = zeros(ntr*K,fk); 
	  dNj = zeros(ntr*K-1,fk);
	for j = 1:ntr*K
	  indices = setdiff([1:ntr*K],[j]);
   	  dNj = dNk(indices,1:fk);
   	  SjdN = sum(abs(dNj).^2,1);
	  jlsp(j,:) = log(1./(ntr*K-1).*SjdN);
        end
   	lsp = mean(jlsp,1);
	lvar = (ntr*K-1)*std(jlsp,1).^2; 	
   	lsd = sqrt(lvar);
end
