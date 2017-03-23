function [Spec fr]= mtSpec(x,kn,wn,Fs,fr,Winstep)
% Spec = mtSpec(x,kn,wn,Fs,fr(or center of frequency bins),Winstep,is_fm,ncomp)
% Using multitaper to get instantaneouse spectrum.
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
% Spec: spectrum in size of: [nch,nch,nfr,nt]
%
% refernece: Pham 2002, Exploiting source non stationary and coloration in
% blind source separation.
% any bug: YY 
if isempty(x);B=[]; Spec=[];return;end
if isempty(Fs);Fs=1250;warning('Sampling frequency is set to 1250 Hz.');end
if isempty(fr); fr=35:10:200;warning('Computing gamma band.');end
if isempty(wn);wn=[ceil(Fs/min(fr)*2), 3, 5];end
if isempty(kn); kn=wn(1);end
if isempty(Winstep);Winstep=floor(wn(1)/2);end
is_fm=true;% now using the 
% Parameters:
[tx, nch]=size(x);

if tx<nch
    warning('Dimention wrong, switched.')
    x=x';
    [tx, nch]=size(x);
end
fr=fr/Fs*2*pi;% home made fourier.
nfr=length(fr);
if length(kn)<2
    H=sigwin.parzenwin(kn);
    ku=generate(H);
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
% if is_fm
    %%  using the frequency domain method:
    % no problem with this part.
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
    gt=lwn:Winstep:(tx-lwn);
    nt=length(gt);
    Spec=zeros(nch,nch,nfr,nt);
    for k=1:nt
        for n=1:nfr
            t=gt(k)+[0:(lwn-1)]-floor(lwn/2);
            Spec_tmp=bsxfun(@times,wn(end:(-1):1),sq(xlt(t,:,n))).'*sq(xlt(t,:,n));
            Spec(:,:,n,k)=real(Spec_tmp+Spec_tmp')/2;
        end
    end
    clear xlt
    Spec=reshape(Spec,nch,nch,nfr,nt);

end
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
