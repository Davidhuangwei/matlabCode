function [nm, mD, discD]=ClusterComp(LA,SA,ka,varargin)
% function [nm, mD]=ClusterComp(LA,SA,ka)
% or        [nm, mD]=ClusterComp(LA,SA,ka,usePC)
% ka is the conductence 
% if usePC == true, use PC of instead of original IC, capture the shape. 
% Here I use this to do the clusterring of ICs get from different chunck. 
% use distance computed by CompDist.m .
%
% see also: CompDist

% LA=bsxfun(@minus,LA,mean(LA,1));
% SA=bsxfun(@minus,SA,mean(SA,1));
varA=[sum(LA.^2,1),sum(SA.^2,1)];
LA=bsxfun(@rdivide,LA,sqrt(sum(LA.^2,1)));
SA=bsxfun(@rdivide,SA,sqrt(sum(SA.^2,1)));
% LA=zscore(LA);
% SA=zscore(SA);rand(size(LA))+
D=CompDist(LA,SA,ka);
[~,mD]=max(D,[],1);
lmD=unique(mD);
lLA=size(LA,1);
nm=zeros(lLA,length(lmD));
if nargin>3
usepc=varargin{1};
else
    usepc=0;
end
for k=1:length(lmD)
    oLA=lmD(k);
    nSA=SA(:,mD==oLA);
    if usepc
        [u,~,~]=svd(cov(nSA'));
        nm(:,k)=u(:,1);
    else
    nm(:,k)=mean(bsxfun(@times,nSA,sign(LA(:,oLA)'*nSA)),2);
    end
end
% nm=bsxfun(@rdivide,nm,sqrt(sum(nm.^2,1)));
thr=prctile(D(:),100);%8.5;%0;0;%;98
LSA=[LA,SA];
discD=(sum(diff(LSA,2,1).^2)./var(LSA,1))>400 ;%| varA<prctile(varA,10)[];
LSA(:,discD)=[];
if usepc
    LSA=zscore(LSA);
end
cmp=15;
oosum=10^-15;
kk=0;
gonm=LA;
while cmp
    kk=kk+1;
    onm=nm;
  D=CompDist(rand(size(nm))*.1+nm,LSA,ka);
[~,mD]=max(D,[],1);
lmD=unique(mD);
nm=zeros(lLA,length(lmD));
for k=1:length(lmD)
    oLA=lmD(k);
    nSA=LSA(:,mD==oLA); 
    if usepc
        [u,~,~]=svd(cov(nSA'));
        nm(:,k)=u(:,1);
    else
    nm(:,k)=mean(bsxfun(@times,nSA,sign(onm(:,oLA)'*nSA)),2);
    end
    
    if sum(mD==oLA)<2
        nm(:,k)=nm(:,k)*0;
    end
    %mean(bsxfun(@times,nSA,sign(LA(:,oLA)'*nSA)),2);
end
if ~usepc
nm=bsxfun(@rdivide,nm,sqrt(sum(nm.^2,1)));
end
D=CompDist(nm,nm,ka)-eye(size(nm,2));
    merg=find(D(:)>thr);
    if ~isempty(merg)
        c=ceil(merg(1)/length(lmD));
        r=merg(1)-(c-1)*length(lmD);
        nm(:,c)=(nm(:,c)*sign(nm(:,c)'*nm(:,r))+nm(:,r))/2;
%         nm(:,c)=nm(:,c)/sqrt(nm(:,c)'*nm(:,c));
        nm(:,r)=[];
    end
    if ~mod(kk,100)
    figure(11);plot(1:size(LA,1),bsxfun(@plus,nm,1:size(nm,2)),'Linewidth',2);
%     pause(.5)
    fprintf('res%d',mean(1-max(c,[],1)))
%     if ~mod(kk,100)
%     turnback=1;
%     end
%     if turnback
    nm=[nm,gonm];
%     turnback=0;
%     end
    end
nm=bsxfun(@rdivide,nm,sqrt(sum(nm.^2,1)));
c=CompDist(onm,nm,ka);
fprintf('*')%,sum(min(c,[],1))
if (mean(1-max(c,[],1))<oosum) && size(onm,2)==size(nm,2)
    oosum=mean(1-max(c,[],1))+1*10^-17
    gonm=nm;
    if cmp>1
        [~,od]=sort(rand(size(LSA,2),1));
    nm=[nm, LSA(:,od(1:min(10,size(LSA,2))))];%
    end
%     figure(1);plot(1:size(LA,1),bsxfun(@plus,nm,1:size(nm,2)),'Linewidth',2);
%     pause(.5)
        cmp=cmp-1;
%         if oosum<0.002
%             cmp=0;
%         end
        kk=0;
        fprintf('\n')
%         
%     D=CompDist(nm,nm,ka)-eye(size(nm,2));
%     merg=find(D(:)>thr);
%     fprintf('\n')
%     if isempty(merg)
%         cmp=false;
%     else
%         c=ceil(merg(1)/length(lmD));
%         r=merg(1)-(c-1)*length(lmD);
%         nm(:,c)=(nm(:,c)*sign(nm(:,c)'*nm(:,r))+nm(:,r))/2;
% %         nm(:,c)=nm(:,c)/sqrt(nm(:,c)'*nm(:,c));
%         nm(:,r)=[];
%     end
end
end
[od, mxD]=reorderc(LA,nm,ka);
nm=nm(:,od);
D=CompDist(nm,LSA,ka);
[~,mD]=max(D,[],1);
if 0
  D=CompDist(nm,LSA,ka);
[~,mD]=max(D,[],1);
lmD=unique(mD);
nm=zeros(lLA,length(lmD));
for k=1:length(lmD)
    oLA=lmD(k);
    nSA=LSA(:,mD==oLA); 
    if usepc
        [u,~,~]=svd(cov(nSA'));
        nm(:,k)=u(:,1);
    else
    nm(:,k)=mean(bsxfun(@times,nSA,sign(onm(:,oLA)'*nSA)),2);
    end
    if sum(mD==oLA)<2
        nm(:,k)=nm(:,k)*0;
    end
    %mean(bsxfun(@times,nSA,sign(LA(:,oLA)'*nSA)),2);
end
end
fprintf('\n finish :)')
end
function [od, mxD]=reorderc(nm,anm,ka)
% function [od, mxD]=reorder(nm,anm)
D=CompDist(nm,anm,ka);
[dummy,mxD]=max(D,[],1);
[dummy,od]=sort(mxD);
end