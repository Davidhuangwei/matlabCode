function [dqcep, dsp_dfdt, qcep, cep, q] = ...
   				dqcepstrum(X, tapers, nq, sampling, flag)
% DQCEPSTRUM calculates the time-derivative of the qcepstrum.
%
% DQCEP = DQCEPSTRUM(X, TAPERS) calculates the time-derivative of the
% dqcepstrum keeping NQ quefrencies.  NQ defaults to 100.
%
% [DQCEP, QCEP, CEP, Q] = DQCEPSTRUM(X, TAPERS, NQ, SAMPLING) returns the 
% cepstrum, CEP, and the quefrency axis for QCEP/CEP in Q.  SAMPLING 
% defaults to 1.
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
if nargin < 2 tapers = [N, 10, 19]; end
if length(tapers) == 3
   tapers(1) = tapers(1).*sampling; 
   tapers = dpsschk(tapers); 
end
if nargin < 3 nq = 100; end
if nargout > 3 errorchk = 1; end

K = size(tapers, 2);
nf = 2* N;  dq = 1./(nf.* sampling);
q = [1:nq-1];

if ~errorchk
   [dsp_df2, dsp_dt2, dsp_dfdt, sp] = ...
      d2spec(Y, tapers, nf, sampling, sampling);
   %dlns_df = C(1).*df./sp;
   %qcep = -1./2./pi.*ifft(dlns_df);     
   dqcep = ifft(dsp_dfdt./sp);
   if max(real(dqcep)) > 1e-3 
      error('Real part of qcepstrum not negligible'); 
   end
   dqcep = -imag(dqcep(1:nq));
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

