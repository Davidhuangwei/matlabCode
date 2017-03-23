function [vMI,R,W,rMI]=RefinICsRot(W,lfp,varargin)
% function [vMI,R,W,rMI]=RefinICsRot(W,lfp,varargin)
% refine IC components by rotation
% W is ncomp*nch
% lfp=nt*nch
% 

if (nargin<3)||isempty(varargin{1})
    theta=linspace(-pi/4,pi/4 -0.0001,200);
else
    theta=varargin{1};
    theta=reshape(theta,1,[]);
end
if nargin<4||isempty(varargin{2})
    lfpthr=20;
else
    lfpthr=varargin{2};
end
lfp=Zscore(lfp,1);
takesig=sum(bsxfun(@le,abs(lfp),prctile(abs(lfp),lfpthr)),2)>0;
ntheta=length(theta);
ncomp=size(W,1);
icasig=lfp*W';
% icasig=bsxfun(@minus,icasig,mean(icasig,1));
icasig=bsxfun(@rdivide,icasig,sqrt(sum(icasig.^2,1)));
rMI=zeros(ntheta,1);
A=eye(size(W))';
nA=pinv(W);
R=eye(ncomp);
m=1;
maxit=200;
icasig=icasig(takesig,:);
while (amariIdx(A,nA)>10^-2)&&(m<maxit)
    A=nA;
    for k=1:(ncomp-1)
        for n=(k+1):ncomp
            for kt=1:ntheta
                rot=[cos(theta(kt)), -sin(theta(kt));sin(theta(kt)),cos(theta(kt))];
                x=icasig(:,[k,n])*rot';
                rMI(kt)=information(x(:,1)',x(:,2)');
                
            end
%             [~,rotthetaid]=min(rMI);%angle(exp(1i*theta*4)*(max(rMI)-rMI))min(rMI)
            rottheta=angle(exp(1i*theta)*(max(rMI)-rMI));%theta(rotthetaid);
%             if rottheta<0
%                 rottheta=rottheta+2*pi;
%             end
%             rottheta=rottheta/4;
            rot=[cos(rottheta), -sin(rottheta);sin(rottheta),cos(rottheta)];
            
            W([k,n],:)=rot*W([k,n],:);
            R([k,n],:)=rot*R([k,n],:);
            icasig(:,[k,n])=icasig(:,[k,n])*rot';
        end
    end
    m=m+1;
    nA=pinv(W);
    fprintf('-%d|%d--',m,amariIdx(A,nA))
end
[vMI, Rr, rMI]=UniqICtest(W,lfp);