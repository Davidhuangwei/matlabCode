function out=FiltLFPtest4_2dBS(datat)
% clear all
% close all
FileBase='4_16_05_merged';
a=40;
b= 15;%[12,15,20]';%8,3,5,:5:3012;%15;%
frb=2;
% b=b(frb);
cd ~/data/sm/4_16_05_merged/
load(datat)
FreqBins=[a-b,a+b];
timelags=-100:4:100;% choose from -200 :200 % or -45 ?
timelag2s = -98:4:(-1);
nt1=length(timelags);
nt2 = length(timelag2s);
ns=size(LFP,1);
bs_time=500;
% sorder=ShuffleNr(ns,ns,bs_time);
[~,sorder]=sort(rand(ns,bs_time));
% nt=size(lfp,1);
pl=zeros(nt1,nt2,2);

% cnames={'pl','pci','cci','cpap'};
Null_dist=cell(nt1,nt2,2,2);
pst=zeros(nt1,nt2,2,2);% nt1,nt2,2sides,2way to codition
cst=zeros(nt1,nt2,2,2);
kwidth=.3;
% cause and effect are in the  same frequency range
pstp=2;
fstp=2;
for kk=1:2
    
    if kk==1
        cnm=2*frb;
        enm=2*frb-1;
    else
        cnm=2*frb-1;
        enm=2*frb;
    end
    for k=1:nt1
        for m=1:nt2
            timelag=timelags(k);
            timelag2=timelag2s(m);
            ca3=squeeze(LFP(:,201+timelag + timelag2,cnm));
            ca1=squeeze(LFP(:,201+timelag,enm));
            pl(k,m,kk)=mean(fangle(ca1.*conj(ca3)));
            for ln=1:2
                [pst(k,m,kk,ln), cst(k,m,kk,ln)]=...
                    CInd_test_new_withGPnb(fangle(ca3),fangle(ca1),[(2-ln)*fangle(squeeze(LFP(:,201+timelag + timelag2-pstp,cnm)))+(ln-1)*fangle(squeeze(LFP(:,201+timelag + timelag2+fstp,cnm))),fangle(squeeze(LFP(:,201+timelag+timelag2,enm)))],kwidth);%
                Null_dist{k,m,kk,ln}=zeros(bs_time,2);
               for bsn=1:bs_time
                   Null_dist{k,m,kk,ln}(bsn,:)=...
                       CInd_test_new_withGPnb(fangle(ca3(sorder(:,bsn))),fangle(ca1),[(2-ln)*fangle(squeeze(LFP(sorder(:,bsn),201+timelag + timelag2-pstp,cnm)))+(ln-1)*fangle(squeeze(LFP(sorder(:,bsn),201+timelag + timelag2+fstp,cnm))),fangle(squeeze(LFP(:,201+timelag+timelag2,enm)))],kwidth);%
               end
            end
        end
        if 1
        figure(224)
        subplot(2,3,1+kk*3-3)
        imagesc(sq(abs(pl(:,:,kk))))
        subplot(2,3,2+kk*3-3)
        imagesc(sq(abs(pst(:,:,kk,1))))
        subplot(2,3,3+kk*3-3)
        imagesc(sq(abs(cst(:,:,kk,1))))
        drawnow
        end
    end
    disp('one side done')
end
clear LFP
datan=sprintf([FileBase, '.', datat, '.2dKCIcpcf.bs.f%dto%dHz.mat'],FreqBins);
cd ~/data/sm/4_16_05_merged/
save(datan)% 724all bursts 
out.dataname=datan;
out.pl=pl;
out.pst=pst;
out.cst=cst;
out.Null_dist=Null_dist;