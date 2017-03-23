function [tfdsp_df,tfdsp_dt,tfsp]=tfdcxy(X, tapers, dn, nf, fk, ...
					sampling, flag)
%TFDSP Time and Frequency spectral derivatives
%
%  [TFDSP_DF,TFDSP_DT,TFSP]=TFDSP(X, TAPERS) computes the time and
%  frequency derivative spectral estimates.  
%
%  [TFDSP_DF, TFDSP_DT, TFSP, F] = TFDSP(X, TAPERS, DN, NF, FK, ...
%                                        SAMPLING, FLAG) 
%

%  Author:  Bijan Pesaran 07/20/98
%               -Modified to include trial-averaging.  05/12/00
%

[Y,dims]=reduce(X);
sY=size(Y);
nt=sY(2);
nch=sY(1);

if nargin < 4; nf = 2^nextpow2(N); end
if nargin < 5 fk=nf./2; end
if nargin < 6 sampling=1; end
if nargin > 5 fk=floor(fk./sampling.*nf); 
               tapers(1)=tapers(1).*sampling;
end
if nargin < 7 flag = 0; end
if nargout > 4 errorchk=1; end

tapers=dpsschk(tapers);
K=length(tapers(1,:));
N=length(tapers(:,1));

dn=dn.*sampling;
if nargin == 2; dn=N./5; end

nwin=floor((nt-N)./dn);

f=[1:fk]*sampling./nf;

if flag == 1
  error('Channel averaging not yet implemented')
end

if flag == 0
  tfdsp_df = zeros(nch, nwin, fk);
  tfdsp_dt = zeros(nch, nwin, fk);
  tfsp = zeros(nch, nwin, fk);
  tmp2 = zeros(1, nf);
for ii = 1:nwin
  V = zeros(K,nf)+complex(0,1)*zeros(K,nf);
  for ch=1:nch
  tmp1 = detrend(Y(ch,(ii-1)*dn+1:(ii-1)*dn+N));
    for j = 1:K 
      tmp2(1:N) = tmp1'.*tapers(:,j);
      V(j,:) = fft(tmp2); 
    end
  tfsp(ch, ii, :) = mean(abs(V(:,1:fk)).^2,1);
  dsp = mean(V(1:K-1,1:fk).*conj(V(2:K,1:fk)),1);
  tfdsp_df(ch, ii, :) = 2.*imag(dsp);
  tfdsp_dt(ch, ii, :) = 2.*real(dsp);
  end
end
end

%tfdsp_dt = restore(tfdsp_dt, dims);
%tfdsp_df = restore(tfdsp_df, dims);
%tfsp = restore(tfsp, dims);




