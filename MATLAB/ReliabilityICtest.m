function [Sep,malpha,n]=ReliabilityICtest(W,lfp,varargin)
% function Separability=ReliabilityICtest(W,lfp,nB,tn,method)
% test the Reliability of IC components. 
% W is ncomp*nch
% lfp=nt*nch
% nB: number of bootstraps; default: 100
% tn: number of samples in bootstrap. default: full length
% method: 1. KDICA
%         2. Spectrum AJD
%         3. refine by rotation 
% Output:
% Sep: separability matrix
% ref: Frank Meinecke 2002 A resampling approach to estimate the stability
% of one-dimensional or multidimensional independent components 
% error: YYC 

[nt,nch]=size(lfp);
[ncomp,nchw]=size(W);
if nch~=nchw
    error('W,LFP dimention mismatch')
end
if (nargin<3)||isempty(varargin{1});nB=100;else nB=varargin{1};end
if (nargin<4)||isempty(varargin{2});tn=min(nt,50000);else tn=varargin{2};end
if (nargin<5)||isempty(varargin{3});mtd=1;else mtd=varargin{3};end
lfp=bsxfun(@minus,lfp,mean(lfp,1));
lfp=lfp*W';
% lfp=bsxfun(@rdivide,lfp,sqrt(mean(lfp.^2,1)));
Sep=nan(ncomp,ncomp,nB);
fprintf('begin...\n')
n=0;
for k=1:nB
   tmp=randi(nt,[tn,1]); 
   slfp=lfp(tmp,:);
   slfp=slfp/(chol((slfp'*slfp)/tn));
   if (mtd==1)
       [icasig, ~, rW, ~]=wKDICA(slfp',ncomp,0,0,0,'W0',eye(ncomp));
   elseif mtd==2
       [rW, ~]=SSpecJAJD(lfp,1250,400,400,[45 70 90 140 180],100,ncomp,0,tmp);
%        rW=rerank(rW,W);% too stupid.... why not just do it in the
%        transformed matrix!
   elseif (mtd==3)
       [~,~,rW]=RefinICsRot(eye(ncomp),slfp);
   end
   [~,ids]=max(abs(rW),[],2);
   while length(unique(ids))<ncomp
       nkk=bsxfun(@eq,ids,1:ncomp);
       s=find(sum(nkk,1)<1,1,'first');
       m=find(sum(nkk,1)>1,1,'first');
       mi=find(ids==m);
       [~,nid]=max(abs(rW(mi,s)));
       ids(mi(nid))=s;
   end
   for kk=1:ncomp
   rW(kk,:)=rW(kk,:)*sign(rW(kk,ids(kk)));
   end
   [~,nid]=sort(ids);
   rW=rW(nid,:);
   R=logm(rW');%triu() so the image part means the rotation in the orthorognal plane. so the only thing I would need to keep is the real part. 
   % or indeed this means that there is an axis actually rotate in the 
   if isreal(R)
%        R=(R-R')/2
       R=R.*(R<=(pi/4)).*(R>=(-pi/4))+((pi/4)-R).*(R>=(pi/4))+(-(pi/4)-R).*(R<=(-pi/4));
   Sep(:,:,k)=R;%log()
   for nk=1:(ncomp-1)
       for nn=nk:ncomp
           Sep(nn,nk,k)=information(icasig(nk,:),icasig(nn,:));
       end
   end
   else
%        Sep(:,:,k)=real(R);%
       n=n+1;
   end
   fprintf('%d-',k)
end
fprintf('\n finish. you have %d times of complex.\n ',n)
% Sep(:,:,isnan(Sep(1,1,:)))=[];
malpha=mean(Sep,3);
% Sep=sqrt(mean(Sep.^2,3));
end