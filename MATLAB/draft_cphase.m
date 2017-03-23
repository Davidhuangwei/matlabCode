jnm=2*nlag+1;
for n=1:jnm
    figure(224)
    subplot(3,jnm,n)
    plot(angle(filtLFP_temp(nRes,1)),angle(filtLFP_temp(nRes+5*(n-12),1)),'.')
    subplot(3,jnm,n+jnm)
    plot(angle(filtLFP_temp(nRes,1)),angle(filtLFP_temp(nRes+5*(n-12),2)),'.')
    subplot(3,jnm,n+2*jnm)
    plot(angle(filtLFP_temp(nRes+5*(n-12),2)),angle(filtLFP_temp(nRes+5*(n-12)+5,2)),'.')
end
save('LFPnBurstsRUN416ch3778','nRes','Clu','lfp','chanLoc','repch','Par')