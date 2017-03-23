function [Stat, pval]=GroupUIndtest(rlfp,lfp,w)
% [Stat, pval]=GroupUIndtest(rlfp,lfp,w)
% compute pairwise Unconditional independent test.
% nm is supposed to be entropy of itself...

[nt, nch]=size(lfp);
[nc,ncomp]=size(w);
if nc~=nch
    if ncomp~=nch
        error('dimention mismatch')
    else
        w=w';
        [~,ncomp]=size(w);
    end
end
if nt < 200
    width = 0.8;
elseif nt < 1200
    width = 0.5;
else
    width = 0.3;
end
lfp=bsxfun(@minus,lfp,mean(lfp,1));
icasig=lfp*w;
icasig=zscore(icasig);
Stat=zeros(2,ncomp);
pval=zeros(2,ncomp);
for k=1:ncomp
    for n=1:2
        if n==1
            a=icasig(:,k);
            b=rlfp;
            ny=GaussionProcessRegression(a,b,width,.05,a);% use a to predict b
             [Stat(n,k), pval(n,k)]=UInd_KCItestnb(b-ny,a,.01);
        else
            a=rlfp;
            b=icasig(:,k);
            ny=GaussionProcessRegression(a,b,width,.05,a);% use a to predict b
             [Stat(n,k), pval(n,k)]=UInd_KCItestnb(b-ny,a,.01);
        end
    end
end

end
function nx=zscore(x)
nx=bsxfun(@minus,x,mean(x,1));
nx=bsxfun(@rdivide,x,sqrt(mean(x.^2)));
end