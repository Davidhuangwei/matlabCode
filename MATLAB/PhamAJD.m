function B=PhamAJD(P)
% function B=PhamAJD(P)
% to apply Joint Diagonalization according to Pham's 2002 paper.
% probably slow, can wait for some better algrithm...
% YY
[nch,nch1,nt]=size(P);
if nch~=nch1
    error('dimention error, input should be instantaneous cross spectrum.')
end
% initialize B
B=zeros(nch,nch*nt);
for k=1:nt
    [u,~,~]=svd(sq(P(:,k)));
    B(:,nch*(k-1)+[1:nch])=u;
end
[B,~,~]=svd(B);
B=B';
fdiag=repmat(eye(nch),1,nt);
% Joint diagonalization
BPB=zeros(nch,nch*nt);
nstp=true;
while nstp
    for k=1:nt
        BPB(:,nch*(k-1)+(1:nch))=B*sq(P(:,:,k))*B.';
    end
    dBPB=reshape(sum(BPB.*fdiag,1),nch,nt);
    w=((1./dBPB)*dBPB')/nt;
    g=sum(reshape(BPB./reshape(repmat(dBPB,nch,1),nch,[]),nch,nch,nt),3)/nt;
    h=(g.'- g.*w')./(ones(nch)-w.*w'+eye(nch));
    T=2*h./(1+sqrt(1-4*h.*h'));
    Bo=B;
    B=B-T*B;
%     fprintf('%d~',sum(sum(abs(Bo-B))))
    if sum(sum(abs(Bo-B)))<10^-5
        nstp=false;
    end
end