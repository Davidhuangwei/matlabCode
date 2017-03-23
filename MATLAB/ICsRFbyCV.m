function [mA,mW,As,Ws,normAs,nWs]=ICsRFbyCV(lfp,w,ns)
[nt,nch]=size(lfp);
[ncomp,nchw]=size(w);
if nt<nch
    lfp=lfp';
    [nt,nch]=size(lfp);
end
if nchw~=nch
    if ncomp==nch
        w=w';
        ncomp=size(w,1);
    else
        error('data and unmixing matrix dimention mismatch.')
    end
end
if isempty(ns);ns=20;end
W=cell(ns,1);
A=cell(ns,1);
J=zeros(ns,1);
wn=floor(nt/ns);
for k=1:ns
    [~, A{k}, W{k}, J(k)]=wKDICA(lfp(setdiff(1:nt,((k-1)*wn+1):(k*wn)),:)',ncomp,0,0,0);%
end
[As,Ws,normAs,nWs]=ClustICbasic(pinv(w),A,W);
mA=normAs{1};
mW=nWs{1};
for k=2:ns
mA=mA+normAs{k};
mW=mW+nWs{1};
end
mA=mA/ns;
mW=mW/ns;