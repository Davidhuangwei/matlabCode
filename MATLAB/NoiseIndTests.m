function out=NoiseIndTests(datat,frb)
cd ~/data/sm/4_16_05_merged/
% datat='compLFP3778';%trough
load(datat)
nt=size(LFP,1);
% frb=1;% frequency band31
timelags=-190:2:190;% choose from -200 :200 % or -45 ?
timelag2s = -190:2:190;
nt1=length(timelags);
nt2 = length(timelag2s);
usangle=NaN(nt1,nt2,2);
uscp=NaN(nt1,nt2,2);
plv=NaN(nt1,nt2);
for k=1:nt1
    for m=1:nt2
        timelag=timelags(k);
        timelag2=timelag2s(m);
        if abs(timelag+timelag2)<199
        ca3=squeeze(LFP(:,201+timelag + timelag2,2*frb));
        % ca1=squeeze(LFP(:,201+timelag,2*frb-1));
        ca1=squeeze(LFP(:,201+timelag,2*frb-1));
        plv(k,m)=mean(fangle(ca1.*conj(ca3)));
        
        aca3 = angle(ca3);
        aca1 = angle(ca1);
        Ind_ca3_to_ca1 = find((aca1-aca3)<0);
        aca1_new = aca1;
        aca1_new(Ind_ca3_to_ca1) = aca1_new(Ind_ca3_to_ca1)+ 2 * pi;
        Error_ca3_to_ca1 = aca1_new - aca3;
        % disp('Ind test for ca3 -> ca1:')
        pval1 = UInd_KCItest(aca3, Error_ca3_to_ca1);
        
        % under hypothesis ca3 -> ca1
        Ind_ca1_to_ca3 = find((aca3-aca1)<0);
        aca3_new = aca3;
        aca3_new(Ind_ca1_to_ca3) = aca3_new(Ind_ca1_to_ca3)+ 2 * pi;
        Error_ca1_to_ca3 = aca3_new - aca1;
%         disp('Ind test for ca1 -> ca3:')
        pval2 = UInd_KCItest(aca1, Error_ca1_to_ca3);
        
        usangle(k,m,:)=[pval1;pval2];
        pva1 = cUInd_KCItest(fangle(ca3),fangle(ca3.*conj(ca1)));
        pva2 = cUInd_KCItest(fangle(ca1),fangle(ca3.*conj(ca1)));
        uscp(k,m,:)=[pva1;pva2];
        end
    end
end
matname=sprintf([datat, 'NoisIndTest.f%dto%dHz.mat'],FreqBins(frb,:));
save(matname,'uscp','usangle','plv','datat','frb')
out.uscp=uscp;
out.usangle=usangle;
out.plv=plv;
out.datat=datat;
out.frb=frb;
frt=sprintf('f: %d to %d Hz',FreqBins(frb,:));
figure(224)
subplot(221)
imagesc(timelag2s,timelags,usangle(:,:,1))
xlabel('timelag2')
ylabel('timelag1')
title([datat,frt])
subplot(222)
imagesc(timelag2s,timelags,usangle(:,:,2))
xlabel('timelag2')
ylabel('timelag1')
title(['CA1 to CA3 with real angle', frt])
subplot(223)
imagesc(timelag2s,timelags,uscp(:,:,1))
xlabel('timelag2')
ylabel('timelag1')
title(['CA3 to CA1 with cplx', frt])
subplot(224)
imagesc(timelag2s,timelags,uscp(:,:,2))
xlabel('timelag2')
ylabel('timelag1')
title(['CA1 to CA3 with cplx', frt])
% figure(225)
% subplot(211)
% imagesc(timelag2s,timelags,usangle(:,:,2)-usangle(:,:,1),[0,.05])
% subplot(212)
% imagesc(timelag2s,timelags,uscp(:,:,2)-uscp(:,:,1),[0,.05])
% figure(226)
% subplot(211)
% imagesc(timelag2s,timelags,usangle(:,:,1)-usangle(:,:,2),[0,.05])
% subplot(212)
% imagesc(timelag2s,timelags,uscp(:,:,1)-uscp(:,:,2),[0,.05])
figure(227)
usangles=ceil(usangle-.05);
uscps=ceil(uscp-.05);
subplot(211)
imagesc(timelag2s,timelags,usangles(:,:,1)-usangles(:,:,2),[-1,1])
title('ceil(Pval_{ca3 to ca1}) - ceil(Pval_{ca1-ca3})')
subplot(212)
imagesc(timelag2s,timelags,uscps(:,:,1)-uscps(:,:,2),[-1 1])
title([datat,frt])
figure(226)
imagesc(timelag2s,timelags,abs(plv))
title(['phase locking value', datat,frt])