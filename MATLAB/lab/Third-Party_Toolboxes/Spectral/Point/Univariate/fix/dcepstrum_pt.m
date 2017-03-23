function [Dcep_pt, q, Spec_pt] = dcepstrum_pt(dN, tapers, ctapers, ...
			fk, sampling, flag) 
% DCEPSTRUM_PT calculates the derivative cepstrum of a spectral estimate
%
% DCEP_PT = DCEPSTRUM_PT(dN, CTAPERS) calculates the derivative cepstrum of X
% and smooths with CTAPERS = [CP, CK], CK degrees of freedom.
%
% [DCEP_PT, CEP_PT, Q] = DCEPSTRUM_PT(dN, CTAPERS, FK, SAMPLING) returns the 
% derivative cepstrum, DCEP_PT, the cepstrum, CEP_PT, and the quefrency 
% axis for DCEP/CEP in Q.  SAMPLING defaults to 1.
%
% [DCEP_PT, CEP_PT, Q, LVAR] = DCEPSTRUM_PT(dN, CTAPERS, FK, SAMPLING, FLAG)
% does the calculation pooling across trials and returns the error bars.
%

% Modification History:  
%           Written by:  Bijan Pesaran,  July 2000, Bell Labs

%[Y,dims] = reduce(X);
Y = dN;
sY = size(Y);
N = sY(2);
ntr = sY(1);
nf = max(256, 2.^(nextpow2(N)+1));
errorchk = 0;
flag = 0;

if nargin < 5 sampling = 1; end
if nargin < 2 tapers = [N, 5, 9]; end
if length(tapers) == 3
   tapers(1) = tapers(1).*sampling; 
   tapers = dpsschk(tapers); 
end
if nargin < 3 ctapers = [5,9]; end
if nargin < 4 fk = 0.5*sampling; end
if nargout > 6 errorchk = 1; end

if ~errorchk
   [df, dt, sp] = dspec_pt(Y, tapers, nf, fk, sampling);
   dlnt = dt./sp;     
   tmp = detrend([dlnt(1,1:end),dlnt(1,end:-1:2)]);
   Dcep_pt = real(ifft(tmp));
   Spec_pt = sp;
%   Dlnf = detrend([dlnf,dlnf(end:-1:2)]);
%   Nf = length(Dlnf);
%   ctapers = dpsschk([Nf,10,19]);
%   K = size(ctapers,2);  
%   for k = 1:2:K
%     dcep((k+1)/2,:) = ifft(Dlnf.*ctapers(:,k)');
%   end
%   Dcep = mean(real(dcep));   
end

q = [0:1./2./fk:length(Dcep_pt(1,:))./2./fk];
q = q(1:length(Dcep_pt(1,:)));


if errorchk
   error('This code is not complete');
   dcep = zeros(ntr, nf);
   for tr = 1:ntr 
      tmp = Y(tr,:);
      tmp = [tmp 0 reverse(tmp(2:end))];
      dcep(tr,:) = real(ifft(tmp)); 
   end
   dcep = dcep(:, 1:nq);
   for tr = 1:ntr
      indices = setdiff([1:ntr],[tr]);
      xj = qcep(indices,:);
      jlsp(tr,:) = log(1./(ntr-1).*sum(abs(dcep.^2),1));
   end
   lsp(tr,:) = mean(jlsp,1);
   lvar(tr,:) = (ntr-1)*std(jlsp,1).^2;
	lsd=sqrt(lvar);
end

