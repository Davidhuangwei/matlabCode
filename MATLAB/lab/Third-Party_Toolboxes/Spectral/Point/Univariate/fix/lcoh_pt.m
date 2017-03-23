function [lc_pt, sp_pt, hf, f, lvar_pt]= lcoh_pt(dN, tapers, nf, fk, sampling)
% LCOH_PT estimates the Loeve coherency for a point process
%
% LC_PT = LCOH_PT(dN, TAPERS, NF, FK, SAMPLING) calculates 
% the Loeve coherency between two frequencies f1 and f2.  TAPERS defaults to
% [N, 10, 19].  NF defaults to the next power of 2 greater than N.  FK defaults
% to NF./2 and SAMPLING defaults to 1.
%
% [LC_PT, SP_PT, F, HF] = LCOH_PT(dN, TAPERS, NF, FK, SAMPLING) returns the
% frequency axis for LC in F and the high frequency limit in HF.
%
% [LC_PT, SP_PT, F, LVAR_PT] = LCOH_PT(dN, TAPERS, NF, FK, SAMPLING)  
% returns the error bars for LC_PT in LVAR_PT.
%
% [LC_PT, SP_PT, F, LVAR_PT] = LCOH_PT(dN, TAPERS, NF, FK, SAMPLING, FLAG)
% allows the specification for the calculation of the Loeve coherency.  
% If flag is 0 the calculation is done row by row with one coherency per row.  
% If flag is 1 the calculation is done pooling across rows giving one
% coherence over all.  If flag is 11 then the calcuation is done as for
% FLAG = 1 but the error bars cannot be calculated to save memory.

% Written by:  Bijan Pesaran Caltech 2000
%

%[Y, dims] = reduce(dN);
sdN = size(dN);
n = sdN(2);
ntr = sdN(1);
errorchk = 0;

if nargin < 5 sampling = 1; end
if nargin < 2 tapers = [n, 10, 19]; end
if length(tapers) == 3
   tapers(1) = tapers(1).*sampling;
   tapers = dpsschk(tapers);
end
if nargin < 3 nf = max(256,2^(nextpow2(n+1)+1)); end
if nargin < 4 fk = nf./2; end
if nargin > 3 fk = floor(fk./sampling.*nf); end
if nargin < 5 flag = 0; end
if nargout > 4 errorchk = 1; end

ntapers = tapers.*sqrt(sampling);
K = length(ntapers(1, :));
N = length(ntapers(:,1));

f = [1:fk]*sampling./nf;
tmpts = zeros(1, nf);

for k = 1:K H(k,:) = fft([ntapers(:,k)' zeros(1,nf-n)]); end

if errorchk
if flag == 0
	hf = 0;
	lc = zeros(ntr, fk, fk);
	for tr = 1:ntr
  		tmp = dN(tr, :);
  		yk = zeros(K, nf);
		for ik = 1:K 
  			yk(ik, :) = fft([dN(tr,:).*ntapers(:,ik)' ...  
               			zeros(1,nf-n)]) - mean(dN(tr,:)).*H(ik,:); 
			hf = hf + sum((dN(trpl,:).*ntapers(:,ik)').^2);
		end
  		yk = yk(:, 1:fk);
  		sp_pt(tr, :) = mean(abs(yk).^2);
  		lc_pt(tr, :, :) = 1./K.*(yk.'*conj(yk))./...
			sqrt(sp_pt(tr,:)'*sp_pt(tr, :));               
	 	lsp_pt = zeros(K, fk, fk);
		for j = 1:K
       		  indices = setdiff([1:K], [j]);
        	  yj = yk(indices, 1:fk);
        	  spj_pt = mean(abs(yj).^2);
         	  lsp_pt(j,:,:) = ...
			1./(K-1).*(yj.'*conj(yj))./sqrt(spj_pt'*spj_pt);  
		end   		
		lvar_pt(tr, :, :) = (K-1)*std(lsp_pt).^2;
	end
end

if flag
	yk = zeros(K.*ntr, fk);
	lc = zeros(fk, fk);
	for tr = 1:ntr
  		tmp = detrend(Y(tr, :));
		for ik = 1:K 
  			tmpts(1:N) = tmp'.*tapers(:, ik);
  			f1 = fft(tmpts);
  			yk(ik+K.*tr, :) = f1(1:fk); 
		end
  		lsp = zeros(ntr.*K, fk, fk);
		for j = 1:K
       	indices = setdiff([1:K],[j]);
     		yj = yk(indices+K*tr, 1:fk);
        	spj = mean(abs(yj).^2, 1);
         lsp(j+K.*tr, :, :) = 1./(K-1).*(yj.'*conj(yj))./sqrt(spj'*spj);
		end
  		lvar = (K-1)*std(lsp).^2;
	end
	sp = mean(abs(yk).^2, 1);
	lc = 1./(K.*ntr).*(yk.'*conj(yk))./sqrt(sp'*sp);
end
end

if ~errorchk
	hf = 0;
	sp_pt = zeros(1, fk);
	yk = zeros(1, fk);
	lc_pt = zeros(fk, fk);
	for tr = 1:ntr
		for ik = 1:K 
			yk = fft([dN(tr,:).*ntapers(:,ik)' ...  
               			zeros(1,nf-n)]) - mean(dN(tr,:)).*H(ik,:); 
			hf = hf + sum((dN(tr,:).*ntapers(:,ik)').^2);
  			yk = yk(1:fk);
  			sp_pt = sp_pt + abs(yk).^2./(K.*ntr);
  			lc_pt = lc_pt + yk.'*conj(yk)./(K.*ntr);
		end
	end
	lc_pt = lc_pt./sqrt(sp_pt'*sp_pt);
	hf = hf./(K*ntr);
end


