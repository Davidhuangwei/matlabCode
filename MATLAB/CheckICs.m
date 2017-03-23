function CheckICs(W,lfp,Period)
icasig=lfp*W';
luP=size(Period,1);
ncomp=size(W,1);
figure(2046);
for k=1:ncomp
    subplot(ncomp+1,ncomp,(k-1)*ncomp+k)
    hist(icasig(:,k),500)
    subplot(ncomp+1,ncomp,ncomp*ncomp+k)
    hist(diff(icasig(:,k),1),500)
end
for k=1:luP
    t=Period(k,1):Period(k,2);
    for kn=1:(ncomp-1)
        for nn=(kn+1):ncomp
            figure(2046);
    subplot(ncomp+1,ncomp,(kn-1)*ncomp+nn)
    plot(icasig(t,kn),icasig(t,nn),'.')
    
    subplot(ncomp+1,ncomp,(nn-1)*ncomp+kn)
    plot(diff(icasig(t,nn),1),diff(icasig(t,kn),1),'.')
        end
    end
    pause
end
