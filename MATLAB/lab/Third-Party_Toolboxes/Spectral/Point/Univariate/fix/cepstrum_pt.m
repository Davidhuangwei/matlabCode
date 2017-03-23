function [cep_pt, q, ac_pt, spec_pt, hf, lvar] = cepstrum_pt(dN, ctapers, ...
	fk, sampling, flag) 
% CEPSTRUM_PT estimates the cepstrum of a point process, dN
%
% CEP_PT = CEPSTRUM_PT(DN, TAPERS) calculates the cepstrum of dN
% and keeps NQ quefrencies.  NF defaults to SAMPLING./2
%
% [CEP_PT, Q, AC_PT, SPEC_PT, HF] = CEPSTRUM_PT(DN, TAPERS, FK, SAMPLING)
% returns the cepstrum, CEP_PT, and the quefrency axis in Q.  SAMPLING 
% defaults to 1.
%
% [CEP_PT, Q, AC_PT, SPEC_PT, HF, LVAR] = CEPSTRUM_PT(DN, TAPERS, ...
%		FK, SAMPLING, FLAG) 
% does the calculation pooling across trials and returns the error bars.  
%

% Modification History:  
%           Written by:  Bijan Pesaran,  August 2000, Caltech

sN = size(dN);
N = sN(2);
ntr = sN(1);
nf = max(256, 2.^(nextpow2(N)+1));
errorchk = 0;
flag = 0;

if nargin < 4 sampling = 1; end
tapers = [N, 1.5, 2]; 
tapers = dpsschk(tapers); 
if nargin < 3 fk = sampling./2; end
if nargout > 6 errorchk = 1; end

if ~errorchk
   [spec_pt, hf] = dmtspec_pt(dN, tapers, nf, fk, sampling);
   tmp = spec_pt./hf;
   tmp = detrend(log([tmp tmp(end:-1:2)]));
   cep_pt = real(ifft(tmp));     
end

q = [0:1./2./fk:length(cep_pt)./2./fk];
q = q(1:length(q)-1);

if errorchk
   error('Error bars not yet implemented');
   cep_pt = zeros(ntr, nf);
   for tr = 1:ntr 
      tmp = dN(tr,:);
      tmp = [tmp 0 reverse(tmp(2:end))];
      cep_pt(tr,:) = real(ifft(tmp)); 
   end
   cep_pt = cep_pt(:, 1:nq);
   for tr = 1:ntr
      indices = setdiff([1:ntr],[tr]);
      xj = cep_pt(indices,:);
      jlsp(tr,:) = log(1./(ntr-1).*sum(abs(cep_pt.^2),1));
   end
   lsp(tr,:) = mean(jlsp,1);
   lvar(tr,:) = (ntr-1)*std(jlsp,1).^2;
   lsd=sqrt(lvar);
end

