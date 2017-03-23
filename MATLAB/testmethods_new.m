clear all
close all
FileBase='4_16_05_merged';
a=40;
b=[12,15,20]';%3,5,:5:30
nfr=length(b);
FreqBins=[a-b,a+b];
load('/gpfs01/sirota/data/bachdata/data/weiwei/m_sm/4_16_05_merged_par.mat');
cd ~/data/sm/4_16_05_merged/
datat='compLFP3778';%trough
load(datat)
b=[0.001,.01,.01,exp(-[0:.5:10])];% [0.001,exp(-[0:5:30])];
a=1;
funclist={'freal', 'orix', 'dfangle', 'ffangle', 'fabs',};
lf=length(funclist);
np=12;% lags to be calculated
nlevel=.5;
st=randi(800,1)*pi;%randi(size(x,1)-np*400,1);
xt=LFP(:,:,2);
xt=conj(xt');
[nt, ne]=size(xt);
% figure; plot(real(xt))
% nci=zeros(np,lf,7,4);
% par.width=.3;
y=exp(sqrt(-1)*filter(b,a,angle(xt)));
noif=exp(sqrt(-1)*(rand(nt,ne)-.5)*pi*nlevel*2);
y=y.*noif;
timelags=-100:5:100;% choose from -200 :200 % or -45 ?
timelag2s = -40:2:40;
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
        ca3=reshape(xt(201+timelag + timelag2,:),ne,1);
        % ca1=squeeze(LFP(:,201+timelag,2*frb-1));
        ca1=reshape(y(201+timelag,:),ne,1);
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
matname=sprintf('SimulationNoisIndTest.f%dto%dHz.mat',FreqBins(frb,:));
% save(matname,'uscp','usangle','plv','datat','frb','xt','y','nlevel')
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
% for k=[1, 2, 3, 5, 7]
% figure(10+k)
% plot(1:np,sq(nci(:,:,k,1)))
% hold on
% plot(1:np,sq(nci(:,:,k,3)),'+-')
% legend(funclist)
% end