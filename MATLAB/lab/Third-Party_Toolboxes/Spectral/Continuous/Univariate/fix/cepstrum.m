function [Cep, q, AC, Spec, lvar] = cepstrum(X, ctapers, fk, sampling, flag)
% CEPSTRUM estimates the cepstrum of a continuous process, X
%
% CEP = CEPSTRUM(X, CTAPERS) calculates the cepstrum of X
% and smooths with CTAPERS = [CP, CK] degrees of freedom.  
%
% [CEP, Q] = CEPSTRUM(X, CTAPERS, FK, SAMPLING) returns the 
% cepstrum, CEP, and the quefrency axis in Q.  SAMPLING 
% defaults to 1.  FK defaults to 0.5*sampling. 
%
% [CEP, Q, LVAR] = CEPSTRUM(X, CTAPERS, FK, SAMPLING, FLAG) does the 
% calculation pooling across trials and returns the error bars.
%

% Modification History:  
%           Written by:  Bijan Pesaran,  July 2000, Bell Labs

%[Y,dims] = reduce(X);
Y = X;
sY = size(Y);
N = sY(2);
ntr = sY(1);
nf = max(256, 2.^(nextpow2(N)+1));
errorchk = 0;
flag = 0;

if nargin < 2 ctapers = [3,5]; end
if nargin < 4 sampling = 1; end
if nargin < 3 fk = 0.5.*sampling; end
if nargout > 4 errorchk = 1; end

cp = ctapers(1);
cK = ctapers(2);

nfk = 2*floor(fk./sampling.*nf)-1;
ctapers = dpsschk([nfk,cp,cK]);

if ~errorchk
   spec = dmtspec(Y, [N./sampling,1.5,2], nf, fk, sampling);
   cep = [];
   ac = []; 
   Spec = [];
   nfk = size(spec,2);
   for tr = 1:ntr
     tmp = detrend([log(spec(tr,1:end)),log(spec(tr,end:-1:2))]);
     LogSpec(tr,:) = tmp;
     tmp = detrend([(spec(tr,:)),(spec(tr,end:-1:2))]);
     Spec(tr,:) = tmp;
%     for k = 1:cK
%	ac(tr,k,:) = ifft(Spec(tr,:).*ctapers(:,k)');
%	cep(tr,k,:) = ifft(LogSpec(tr,:).*ctapers(:,k)');
%     end
     ac(tr,:) = real(ifft(Spec(tr,:)));
     cep(tr,:) = real(ifft(LogSpec(tr,:)));
   end
end

AC = ac;
Cep = cep;
q = [0:1./2./fk:length(Cep(1,:))./2./fk];
q = q(1:length(Cep(1,:)));

%if errorchk
%   cep = zeros(ntr, nf);
%   for tr = 1:ntr 
%      tmp = Y(tr,:);
%      tmp = [tmp 0 reverse(tmp(2:end))];
%      cep(tr,:) = real(ifft(tmp)); 
%   end
%   cep = cep(:, 1:nq);
%   for tr = 1:ntr
%      indices = setdiff([1:ntr],[tr]);
%      xj = cep(indices,:);
%      jlsp(tr,:) = log(1./(ntr-1).*sum(abs(cep.^2),1));
%   end
%   lsp(tr,:) = mean(jlsp,1);
%   lvar(tr,:) = (ntr-1)*std(jlsp,1).^2;
%	lsd=sqrt(lvar);
%end

