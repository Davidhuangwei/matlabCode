function [tfdsxy_df,tfdsxy_dt,tfsxy,tfsxx,tfsyy,f]=tfdsxy(X1, X2, ...
			  tapers, dn, nf, fk, sampling, flag)
%TFDSXY Time and Frequency cross-spectral derivatives
%
%  [TFDSXY_DF,TFDSXY_DT,TFSXY]=TFDSXY(X1, X2, TAPERS) computes the time and
%  frequency derivative cross-spectral estimates.  
%
%  [TFDSXY_DF, TFDSXY_DT, TFSXY, F] = TFDSXY(X1, X2, TAPERS, DN, NF, FK, ...
%                                SAMPLING, FLAG) returns the frequency axis.
%

%  Author:  Bijan Pesaran 06/01/00
%

[Y1,dims1]=reduce(X1);
sY1=size(Y1);
nt1=sY1(2);
nch1=sY1(1);

[Y2,dims2]=reduce(X2);
sY2=size(Y2);
nt2=sY2(2);
nch2=sY2(1);

if nt1 ~= nt2 or nch1 ~= nch2 error('Input arrays not compatible'); end
if dims1 ~= dims2 error('Input arrays not compatible'); end

if nargin < 7 sampling=1; end
tapers(1)=tapers(1).*sampling;
if nargin < 4 dn=floor(tapers(1)/10); end;

if nargin < 5; nf = 2^nextpow2(N); end
if nargin < 6 fk=sampling./2; end
if nargin < 8 flag = 0; end
if nargout > 6 errorchk=1; end

nt=nt1;
nch=nch1;
dims=dims1;

tapers=dpsschk(tapers);
K=length(tapers(1,:));
n=length(tapers(:,1));
dn=dn.*sampling;
nwin=floor((nt-n)./dn);
nfk=floor(fk.*nf./sampling);

f=[1:nfk]*sampling./nf;

if flag == 1
  error('Channel averaging not yet implemented')
end

if flag == 0
  tfdsxy_df = zeros(nch, nwin, nfk);
  tfdsxy_dt = zeros(nch, nwin, nfk);
  tfsxy = zeros(nch, nwin, nfk);
  tfsxx = zeros(nch, nwin, nfk);
  tfsyy = zeros(nch, nwin, nfk);
  tmp21 = zeros(1, nf); tmp11 = zeros(1, nf);
for ii = 1:nwin
  V1 = zeros(K,nf)+complex(0,1)*zeros(K,nf);
  V2 = zeros(K,nf)+complex(0,1)*zeros(K,nf);
  for ch=1:nch
    tmp1 = detrend(Y1(ch,(ii-1)*dn+1:(ii-1)*dn+n));
    tmp2 = detrend(Y2(ch,(ii-1)*dn+1:(ii-1)*dn+n));
    for j = 1:K 
      tmp11(1:n) = tmp1'.*tapers(:,j);
      V1(j,:) = fft(tmp11); 
      tmp21(1:n) = tmp2'.*tapers(:,j);
      V2(j,:) = fft(tmp21); 
    end
    tfsxy(ch, ii, :) = mean(V1(:,1:nfk).*conj(V2(:,1:nfk)),1);
    tfsxx(ch, ii, :) = mean(V1(:,1:nfk).*conj(V1(:,1:nfk)),1);
    tfsyy(ch, ii, :) = mean(V2(:,1:nfk).*conj(V2(:,1:nfk)),1);
    dsxy_dt = mean(V1(1:K-1,1:nfk).*conj(V2(2:K,1:nfk)),1) + ...
	      mean(V1(2:K,1:nfk).*conj(V2(1:K-1,1:nfk)),1);
    dsxy_df = mean(complex(0,1).*V1(1:K-1,1:nfk).*conj(V2(2:K,1:nfk)),1) - ...
	      mean(complex(0,1).*V1(2:K,1:nfk).*conj(V2(1:K-1,1:nfk)),1);
    tfdsxy_dt(ch, ii, :) = dsxy_dt;
    tfdsxy_df(ch, ii, :) = dsxy_df;
  end
end
end

%tfdsp_dt = restore(tfdsp_dt, dims);
%tfdsp_df = restore(tfdsp_df, dims);
%tfsp = restore(tfsp, dims);




