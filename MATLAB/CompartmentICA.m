function [icasig, A, W, Ress,fA]=CompartmentICA(lfp,dlfp,chanLoc,ncomp,roder)
[nt,nch]=size(lfp);
chs=size(chanLoc,1);
if mod(nch,chs)
    error('please enter a full shank.')
end
lfp=lfp/sqrt(var(lfp(:)));
dlfp=dlfp/sqrt(var(dlfp(:)));
fA=cell(nch,1);
 Ress=zeros(nt,nch);
 for k=1:nch
     if mod(k,chs)>1
         [Ress(:,k),fA{k}]=BasicRegression([ones(nt,1),lfp(:,k),bsxfun(@power,lfp(:,k+1)-lfp(:,k),1:roder),bsxfun(@power,lfp(:,k-1)-lfp(:,k),1:roder)],dlfp(:,k));
     end
 end
 %%
 Ress=Ress(:,mod(1:nch,chs)>1);
 [icasig, A, W, m]=wKDICA(Ress',ncomp,0,0,0);%