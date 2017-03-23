function [B, c]=SSpecJAJD(x,Fs,wn,kn,fr,Winstep,ncomp,isnorm,smpt)
% [B, Spec] = SSpecJAJD(x,kn,wn,Fs,fr(or center of frequency bins),Winstep,is_fm,ncomp)
% first, get instantaneouse spectral matrix
% Input:
% x: lfp in size tx*nch
% kn: timewindow for computing spectrum. when it is a scaler, we use Parzen
%   window.
% wn: timewindow for computing frequency, when length<4 , we use dpss
%   to comput taper,  wn = [WinLength,NW,nTapers]. NW: default 3, nTapers:
%   default 2*NW -1. for frequency method, default: Parzen window. You can
%   choose hamming window as you like,modify at line 51-52. 
% Fs: sampling frequency of x. default: 1250 Hz.
% fr: center of frequency bins. when it is a scaler, numbers of frequency
%   bins. default: 35:10:200;
% Winstep(tx/nt): Window step length of successive windows (default is
%   WinLength/2)
% is_fm:    0: using time domain method.
%           1: using frequency domain method. default.
%           Notice that this two methods are nearly equivalent. Frequnecy
%           method have advantage of have positive semi-definite spectral
%           matrix. 
%
% Output:
% B: unmixing matrix (sepatating matrix). S=B*X.
% Spec: spectrum in size of: [nch,nch,nfr,nt]
%
% refernece: Pham 2002, Exploiting source non stationary and coloration in
% blind source separation.
% any bug: YY 

if isempty(x);B=[];c=[];return;end
if isempty(Fs)||nargin<2;Fs=1250;warning('Sampling frequency is set to 1250 Hz.');end
if isempty(wn)||nargin<3;wn=[ceil(Fs/min(fr)*2), 3, 5];end
if isempty(kn)||nargin<4; kn=wn(1);end
if isempty(fr)||nargin<5; fr=35:10:200;warning('Computing gamma band.');end
if isempty(Winstep)||nargin<6;Winstep=floor(wn(1)/2);end
if isempty(isnorm)||nargin<8;isnorm=false;end
if isempty(smpt)||nargin<9;smpt=[];end

% if isempty(is_fm);is_fm=true;end %
is_fm=true;% now using the 
% Parameters:
[tx, nch]=size(x);
if isempty(ncomp)||nargin<7;ncomp=nch;end
% fcmp=false;
% if length(ncomp)<2
%     if ncomp>1
%         temp_c=1:ncomp;
%     else
%         fcmp=true;%
%     end
% else
%     temp_c=ncomp;
% end
if tx<nch
    warning('Dimention wrong, switched.')
    x=x';
    [tx, nch]=size(x);
end
fr=fr/Fs*2*pi;% home made fourier.
nfr=length(fr);
if length(kn)<2
    try
    H=sigwin.parzenwin(kn);
    ku=generate(H);
    catch
        ku=parzenwin(kn);
    end
else
    ku=kn;
end
kn=length(ku);
if length(wn)<4
    if is_fm
%         H=sigwin.parzenwin(wn(1));
%         wn=generate(H);
        wn=hann(wn(1));
        wn=wn/sum(wn);
        lwn=length(wn);
    else
        [wn V]=dpss(wn(1),wn(2),wn(3),'calc');
        [lwn,nwn]=size(wn);
    end
else
    [lwn,nwn]=size(wn);
end
if isnorm
    stdx=std(x,1);
x=bsxfun(@rdivide,x,stdx);
end
if is_fm
    %%  using the frequency domain method:
    %
    xlt=exp(bsxfun(@times,repmat([1:tx]',nch,1),-1i*fr)).*repmat(x(:),1,nfr);
    clear x
    xlt=reshape(xlt,[tx,nch*nfr]);
    ku=ku_regenerator(ku,.001,1,kn);% computed as discribed in the paper.
    for k=1:(nch*nfr)
        xlt(:,k)=conv(xlt(:,k),ku(:),'same');
    end
%     xlt=a;
%     clear a
    xlt=reshape(xlt,tx,nch,nfr);
    if isempty(smpt)
        gt=lwn:Winstep:(tx-lwn);
    else
        gt=smpt((smpt<=(tx-lwn))&(smpt>=lwn));
    end
    nt=length(gt);
    Spec=zeros(nch,nch,nfr,nt);
    for k=1:nt
        for n=1:nfr
            t=gt(k)+[0:(lwn-1)]-floor(lwn/2);
            Spec_tmp=bsxfun(@times,wn(end:(-1):1),sq(xlt(t,:,n)))'*sq(xlt(t,:,n));
            Spec(:,:,n,k)=real(Spec_tmp+Spec_tmp')/2;
        end
    end
    clear xlt
    Spec=reshape(Spec,nch,nch,nfr*nt);
    %% using the time domain method (not used)
    % Using multitaper to get the window w(s) fullfilling sum(w^2)=1
    % use dpss to get tapers.
    % the matrix of R would be very large. So you don't use long time chunk...
    % And it would be better to use short ones to check the stationarity.
else
    %% using the time domain method (not used)
    gt=max(lwn,kn):Winstep:tx;
    kul=bsxfun(@times,ku(:),exp(1i*bsxfun(@times,1:kn,fr(:))'));
    nt=length(gt);
    for kk=1:nwn
        Rx=complex(nch,nch,nt,kn);
        for k=1:kn
            wnkn=wn(1:(end-kn),kk).*wn((kn+1):end,kk);
            wnkn=wnkn(end:(-1):1);
            for n=1:nch
                for m=1:nch
                    xnt=x(:,n);
                    xmt=x(:,m);
                    Rx(n,m,:,k)=(xnt(bsxfun(@plus,gt(:),1:(lwn-kn))).*xmt(bsxfun(@plus,gt(:),1:(lwn-kn))))*wnkn(:);
                end
            end
        end
        clear xnt xmt
        if kk==1
            Spec=zeros(nch*nch*nt,nfr);
        end
        Rx=reshape(Rx,nch*nch*nt,kn);
        tmp=Rx*kul
        Spec=Spec+real(tmp+tmp')/2;
    end
    Spec=permute(reshape(real(Spec),nch,nch,nt,nfr),[1,2,4,3]);
    Spec=reshape(Spec,nch,nch,nfr*nt);
    
end
if 1
    takematrix=repmat(eye(nch),nt,1);
for k=1:nfr
    Spec(:,:,k:nfr:end)=Spec(:,:,k:nfr:end)/mean(sum(reshape(Spec(:,:,k:nfr:end),nch*nt,nch).*takematrix,2));
end
end
N=nch*nt*nfr;
Spec=reshape(Spec,nch,N);
if ncomp<1
    [uu,s,~]=svd(cov(Spec'));
    s=diag(s);
    k_uu=(s>s(1)*10^-5);
    s=s'*triu(ones(nch));
    s=s/s(end);
    ncomp=find(s>ncomp,1,'first');
    ncomp=max(ncomp,2);
    tSpec=uu(:,k_uu)'*Spec;
end
%%
if 0
m=ncomp-1;%max(ncomp-1,5);
mm=sum(k_uu)-4;%nch-4;
[~,~,~,stats]=factoran(tSpec',m);
bic=-2*stats.loglike+m*log(N);
obic=bic+10^-4;
while (bic<obic)&&(m<mm)
    m=m+1;
    obic=bic;
    [~,~,~,stats]=factoran(tSpec',m);
    bic=-2*stats.loglike+m*log(N);
end
m=m-1;%-1;
% [lambda,~,~,~,~]=factoran(Spec',m);
[u,v,~]=svd(cov(tSpec'));%lambda
u=uu(:,k_uu)*u(:,1:m);
% [u,v,~]=svd(Spec*Spec');
% Spec=reshape(Spec,nch,nch,[]);
% for k=1:size(Spec,3);Spec(:,:,k)=u'*Spec(:,:,k)*u;end
% % I did not whiten it... do i need to whiten? 
% if fcmp
%     m=size(v,2);
% temp_c=1:find(diag(v)'*triu(ones(m))/trace(v)>ncomp,1,'first');
% end
% Spec=reshape(Spec(temp_c,temp_c,:),ncomp,[]);
temp_c=zeros(m,m,nt*nfr);
ncomp=m;
else 
    m=ncomp;
    [u,v,~]=svd(cov(Spec'));%lambda
u=u(:,1:m);
temp_c=zeros(m,m,nt*nfr);
end
Spec=reshape(Spec,nch,nch,[]);
%%
for k=1:size(Spec,3);temp_c(:,:,k)=u'*Spec(:,:,k)*u;end
Spec=reshape(temp_c,ncomp,[]);
clear temp_c
%% bss using pham's 2001 method of joint diagonalization.
% B=PhamAJD(Spec);
[nB,c]=jadiag(Spec);% assume the mixing matrix is the same in all bands. 
% [nB,c] = bgwedge(Spec,50,10);
% [ B ,c ] =  joint_diag(reshape(Spec,nch,nch*nt*nfr),10^-6); % very bad...
B=nB*u';
if isnorm
   B=bsxfun(@times,B,stdx); 
end
% B=nB*pinv(lambda);
c=reshape(c,m,m,nfr,nt);% not use this now...
% Joint approximate diagonalization using cardoso's code.
end
%%
function kui=ku_regenerator(ku,okui,jku,lku)
% generate subfunction to compute ku in frequency method.
% see last sentence in page 3 of Pham's 2002 paper. 
% NB: not longer than 500... 
if jku<lku
    nku=ku(lku-jku)*sum(ku(1:jku).^2)/sum(okui);
    kui=ku_regenerator(ku,[nku, okui],jku+1,lku);
else
    kui=okui;
end
end