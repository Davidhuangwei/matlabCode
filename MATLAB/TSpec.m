function [Spec, fr]= TSpec(x,Fs,fr,wn,kn,Winstep)
% [Spec, fr]= TSpec(x,kn,wn,Fs,fr,Winstep)
% Get instantaneouse spectrum.
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
% Spec: spectrum in size of: [nch,nfr,nt]
%
% refernece: Pham 2002, Exploiting source non stationary and coloration in
% blind source separation.
% any bug: YY 
if isempty(x);Spec=[];fr=[];return;end
if isempty(Fs)||nargin<2;Fs=1250;warning('Sampling frequency is set to 1250 Hz.');end
if isempty(fr)||nargin<3; fr=35:10:200;warning('Computing gamma band.');end
if isempty(wn)||nargin<4;wn=[ceil(Fs/min(fr)*2), 3, 5];end
if isempty(kn)||nargin<5; kn=wn(1);end
if isempty(Winstep)||nargin<6;Winstep=floor(wn(1)/2);end
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
%     H=sigwin.parzenwin(kn);
%     ku=generate(H);
    ku=parzenwin(kn);
else
    ku=kn;
end
kn=length(ku);
if length(wn)<4
        wn=hann(wn(1));
        wn=wn/sum(wn);
        lwn=length(wn);
else
    [lwn,nwn]=size(wn);
end
gt=lwn:Winstep:(tx-lwn);
% t=gt+[0:(lwn-1)]-floor(lwn/2);
Spec=zeros(length(gt),nch,nfr);
%%  using the frequency domain method:
% no problem with this part.
xlt=exp(bsxfun(@times,repmat([1:tx]',nch,1),-1i*fr)).*repmat(x(:),1,nfr);
clear x
xlt=reshape(xlt,[tx,nch*nfr]);
ku=ku_regenerator(ku,.001,1,kn);% computed as discribed in the paper.
for k=1:(nch*nfr)
    xlt(:,k)=conv(xlt(:,k),ku(:),'same');
end
xlt=reshape(xlt,tx,nch*nfr);
xlt=xlt.*conj(xlt);
for k=1:(nch*nfr)  
    Spec_tmp=conv(xlt(:,k),wn,'same');
        Spec(:,k)=Spec_tmp(gt,:);
end
clear xlt
fr=fr*1250/2/pi;
fprintf('\n-')
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
