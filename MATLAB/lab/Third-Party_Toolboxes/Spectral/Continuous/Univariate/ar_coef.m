function AR = ar_coef(spec,p)
%AR_COEF  Estimate the coefficients of an AR(p) process.
%
%  AR = AR_COEF(SPEC,P) estimates the P coefficients of an AR(P) process
%  using the Levinson-Durbin recursion procedure given a spectrum SPEC
%  that covers the Nyquist interval for positive and negative frequencies. 
%

%  Author:  Bijan Pesaran Bell Labs, July 1999
%

nf=length(spec);
tmp=ifft(spec);
cf=real(tmp(2:p+1));
cf0=tmp(1);

phi(1,1)=cf(1)/cf0;
P(1)=cf0-phi(1,1).*cf(1);

% Levinson-Durbin, PP.402 Percival and Walden
% Note the array indices for P, phi begin with 1

for k=2:p 
	phi(k,k)=(cf(k)-sum(phi(1:k-1,k-1).*cf(k-1:-1:1)'))./P(k-1);
	for j=1:k-1 phi(j,k)=phi(j,k-1)-phi(k,k).*phi(k-j,k-1); end
	P(k)=cf0-sum(phi(1:k,k).*cf(1:k)');
end

AR=squeeze(phi(:,p));
