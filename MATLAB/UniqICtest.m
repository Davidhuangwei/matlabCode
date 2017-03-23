function [vMI, R, rMI]=UniqICtest(W,lfp,varargin)
% function [vMI, R, rMI]=UniqICtest(W,lfp) 
% test the uniqueness of IC components. 
% W is ncomp*nch
% lfp=nt*nch
% rMI return the MI at each theta
if nargin<3
    theta=linspace(-pi/4,pi/4,240);
else
    theta=varargin{1};
    theta=reshape(theta,1,[]);
end
lfp=Zscore(lfp,1);
% takesig=sum(bsxfun(@ge,(lfp),prctile(abs(lfp),60)),2)>0;
ntheta=length(theta);
ncomp=size(W,1);
W=normW(W);
icasig=lfp*W';
% icasig=icasig(takesig,:);
% icasig=bsxfun(@minus,icasig,mean(icasig,1));
% icasig=bsxfun(@rdivide,icasig,sqrt(sum(icasig.^2,1)));

rMI=zeros(ncomp,ncomp,ntheta);
for kt=1:ntheta
    rot=[cos(theta(kt)), -sin(theta(kt));sin(theta(kt)),cos(theta(kt))];
    for k=1:(ncomp-1)
        for n=(k+1):ncomp
            x=icasig(:,[k,n])*rot';
            rMI(k,n,kt)=information(x(:,1)',x(:,2)');
            rMI(n,k,ntheta-kt+1)=rMI(k,n,kt);
        end
    end
end
MI=reshape(rMI,[],ntheta);
mMI=mean(MI,2);
vMI=reshape(sum(bsxfun(@minus,MI,mMI).^2,2)/ntheta,ncomp,ncomp);
[~,R]=min(MI,[],2);
R=triu(reshape(theta(R),ncomp,ncomp));
end