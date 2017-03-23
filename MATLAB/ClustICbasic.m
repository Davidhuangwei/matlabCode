function [As,Ws,normAs,nWs]=ClustICbasic(A,As,Ws)
% function [As,Ws,normAs,nWs]=ClustICbasic(A,As,Ws)
% A: sample A
% As: cell of mixing matrix to be clustered.
% Ws: cell of unmixing matrix to be clustered.

nAs=length(As);
A=bsxfun(@rdivide,A,sqrt(sum(A.^2,1)));
ncomp=size(A,2);
normAs=As;
nWs=Ws;
for k=1:nAs
    tmpA=As{k};
    oA=As{k};
    oW=Ws{k};
    tmpA=bsxfun(@rdivide,tmpA,sqrt(sum(tmpA.^2,1)));
    tmpW=bsxfun(@rdivide,oW,sqrt(sum(oW.^2,2)));
    simA=A'*tmpA;
    [~,maxo]=max(abs(simA),[],1);
    if length(unique(maxo))<length(maxo)
        temp=sort(maxo);
        repnum=temp(~(temp(2:end)-temp(1:(end-1))));
        nonum=setdiff(1:ncomp,unique(maxo));
        lrep=length(repnum);
        repn=zeros(1,length(nonum)+lrep);
        tn=0;
        for n=1:lrep
            trepn=find(maxo==repnum(n));
            lt=length(trepn);
            repn(tn+[1:lt])=trepn;
            tn=tn+lt;
        end
        [~,smaxo]=max(simA(nonum,repn),[],2);
        maxo(repn(smaxo))=nonum;
    end
    for kn=1:length(unique(maxo))
        As{k}(:,maxo(kn))=oA(:,kn)*sign(A(:,maxo(kn))'*oA(:,kn));
        Ws{k}(maxo(kn),:)=oW(kn,:)*sign(A(:,maxo(kn))'*oA(:,kn));
        normAs{k}(:,maxo(kn))=tmpA(:,kn)*sign(A(:,maxo(kn))'*oA(:,kn));
        nWs{k}(maxo(kn),:)=tmpW(kn,:)*sign(A(:,maxo(kn))'*oA(:,kn));
    end
end