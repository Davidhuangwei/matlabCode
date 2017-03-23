function [qcep, cep, q, lvar] = qcepstrum(X, tapers, nq, sampling, flag)
% QCEPSTRUM calculates the qcepstrum of a spectral estimate
%
% QCEP = QCEPSTRUM(X, TAPERS) calculates the cepstrum of SPEC
% and keeps NQ quefrencies.  NQ defaults to 10.
%
% [QCEP, CEP, Q] = QCEPSTRUM(X, TAPERS, NQ, SAMPLING) returns the 
% cepstrum, CEP, and the quefrency axis for QCEP/CEP in Q.  SAMPLING 
% defaults to 1.
%
% [QCEP, CEP, Q, LVAR] = QCEPSTRUM(X, TAPERS, NQ, SAMPLING, FLAG) does the 
% calculation pooling across trials and returns the error bars.
%

% Modification History:  
%           Written by:  Bijan Pesaran,  July 2000, Bell Labs

[Y,dims] = reduce(X);
sY = size(Y);
N = sY(2);
ntr = sY(1);
errorchk = 0;
flag = 0;

if nargin < 4 sampling = 1; end
if nargin < 2 tapers = [N, 20, 39]; end
if length(tapers) == 3
   tapers(1) = tapers(1).*sampling; 
   tapers = dpsschk(tapers); 
end
if nargin < 3 nq = 10; end
if nargout > 3 errorchk = 1; end

nf = 2*N;
dq = 1./(nf.*sampling);
q = [1:nq-1];

if ~errorchk
   [df, dt, sp, C] = dspec(Y, tapers, nf, sampling, sampling);
   dlns_df = C(1).*df./sp;
   qcep = -1./2./pi.*ifft(dlns_df);     
   if max(real(qcep)) > 1e-3 
      error('Real part of qcepstrum not negligible'); 
   end
   qcep = -imag(qcep(1:nq));
   cep(2:nq) = qcep(2:nq)./q;
end

if errorchk
   qcep = zeros(ntr, nf);
   for tr = 1:ntr 
      tmp = Y(tr,:);
      tmp = [tmp 0 reverse(tmp(2:end))];
      qcep(tr,:) = real(ifft(tmp)); 
   end
   qcep = qcep(:, 1:nq);
   for tr = 1:ntr
      indices = setdiff([1:ntr],[tr]);
      xj = qcep(indices,:);
      jlsp(tr,:) = log(1./(ntr-1).*sum(abs(qcep.^2),1));
   end
   lsp(tr,:) = mean(jlsp,1);
   lvar(tr,:) = (ntr-1)*std(jlsp,1).^2;
	lsd=sqrt(lvar);
end

