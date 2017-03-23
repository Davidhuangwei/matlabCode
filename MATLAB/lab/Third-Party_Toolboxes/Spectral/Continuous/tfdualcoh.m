function [coh,f,Sy1,Sy2,lvar]=tfdualcoh(X1,X2,tapers,dn,nf,fk,sampling,flag)
%  TFDUALCOH calculates the coherence between X1 and X2 on a moving window.
%
%  COH = TFDUALCOH(X1, X2, TAPERS, DN, NF, FK, SAMPLING) calculates the 
%  dual-frequency coherence of X1 and X2 on a moving window using prolates 
%  specified in TAPERS.  NF defaults to the next power of 2 greater than N.  
%  FK defaults to NF/2 and SAMPLING defaults to 1.  DN defaults to N/10.
%
%  [COH, F] = TFDUALCOH(X1,X2,TAPERS, DN, NF, FK, SAMPLING)  returns the
%  frequency axis for COH in F.
%
%  [COH, F, LVAR] = TFDUALCOH(X1,X2,TAPERS, DN, NF, FK, SAMPLING)  returns the
%  error bars for COH in LVAR.  [Not implemented]

%  Written by:  Bijan Pesaran Caltech 1998
%

[Y1,dims1]=reduce(X1);
sY1=size(Y1);
n1=sY1(2);
nch1=sY1(1);

[Y2,dims2]=reduce(X2);
sY2=size(Y2);
n2=sY2(2);
nch2=sY2(1);
errorchk=0;

if n1 ~= n2 or nch1 ~= nch2 error('Input arrays not compatible'); end
if dims1 ~= dims2 error('Input arrays not compatible'); end
if nargin < 7 sampling=1; end
n=tapers(1).*sampling;
if nargin < 4 dn=floor(tapers(1)/10); end;
if nargin < 5 nf=max(256,2^nextpow2(n)); end
if nargin < 6 fk=nf./2; end
if nargin > 6 fk=floor(fk./sampling.*nf); end
if nargin < 8 flag = 0; end
if nargout > 2 errorchk=1; end

dn=dn.*sampling;
nch=nch1;
dims=dims1;
nwin=floor((n1-n)./dn);

if flag == 0 coh=zeros(nwin,nch,fk,fk)+i*zeros(nwin,nch,fk,fk); 
             Sy1=zeros(nwin,nch,fk);
             Sy2=zeros(nwin,nch,fk);  end
if flag > 0  coh=zeros(nwin,fk,fk)+i*zeros(nwin,fk,fk); 
             Sy1=zeros(nwin,fk);
             Sy2=zeros(nwin,fk);  end
for win=1:nwin
   tmp1=X1(:,dn*win:dn*win+n-1);
   tmp2=X2(:,dn*win:dn*win+n-1);
   [tmp_coh,f,tS1,tS2]=dualcoh(tmp1,tmp2,tapers,nf,fk.*sampling./nf,sampling,flag);
  if flag == 0 
        coh(win,:,:,:)=tmp_coh; 
        Sy1(win,:,:)=tS1;
        Sy2(win,:,:)=tS2;
   end
   if flag > 0 
       coh(win,:,:)=tmp_coh; 
       Sy1(win,:)=tS1;
       Sy2(win,:)=tS2;
   end
end














