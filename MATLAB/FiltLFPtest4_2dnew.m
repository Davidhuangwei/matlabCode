% figure(224)
% for kk=1:2
%     subplot(2,3,1+kk*3-3)
%     imagesc(timelag2s,timelags,sq(abs(plv(:,:,kk))))
%     subplot(2,3,2+kk*3-3)
%     imagesc(timelag2s,timelags,sq(abs(pci(:,:,kk,2))))%,[0 .05]
%     subplot(2,3,3+kk*3-3)
%     imagesc(timelag2s,timelags,sq(abs(cci(:,:,kk,2))))%,[0 .05]
%     drawnow
% end 
% figure(1)
% imagesc(timelag2s,timelags,sq(cci(:,:,2,1)-cci(:,:,1,1)),[-.6, 0])
% colorbar

% no future1, no past2 and condition on effect 4 lags before.
% function out=FiltLFPtest4_2d(datat, frb)
clear all
close all
datat='compLFP3778';
frb=2;

FileBase='4_16_05_merged';
a=40;
b= [12,15,20]';%8,3,5,:5:3012;%15;%
b=b(frb);
cd ~/data/sm/4_16_05_merged/
load(datat)
FreqBins=[a-b,a+b]
timelags=-100:4:100;% choose from -200 :200 % or -45 ?
timelag2s = -97:4:(-1);
nt1=length(timelags);
nt2 = length(timelag2s);
% nt=size(lfp,1);
pl=zeros(nt1,nt2,2);

% cnames={'pl','pci','cci','cpap'};
Null_dist=cell(nt1,nt2,2,2);
pci=zeros(nt1,nt2,2,2);% nt1,nt2,2sides,2way to codition
pst=zeros(nt1,nt2,2,2);
cst=zeros(nt1,nt2,2,2);
cci=zeros(nt1,nt2,2,2);
cpap=zeros(nt1,nt2,2,2);
par.width=.3;
showr=false;%true;%
% cause and effect are in the  same frequency range
% clr={'r','g','b','c','y','k'};
labels={'con on past','con on future'};
pstp=3;
fstp=3;
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
            plv(k,m,kk)=mean(fangle(ca1.*conj(ca3)));
            for ln=1:2
                if abs(timelag2)>4 
                [oci, Null_dist{k,m,kk,ln}]=...
                    KCIcausal_new(fangle(ca3),fangle(ca1),[(2-ln)*fangle(squeeze(LFP(:,201+timelag + timelag2-pstp,cnm)))+(ln-1)*fangle(squeeze(LFP(:,201+timelag + timelag2+fstp,cnm))),fangle(squeeze(LFP(:,201+timelag-4,enm))),fangle(squeeze(LFP(:,201+timelag+timelag2,enm)))],par,0,0);%
                else
                    [oci, Null_dist{k,m,kk,ln}]=...
                    KCIcausal_new(fangle(ca3),fangle(ca1),[(2-ln)*fangle(squeeze(LFP(:,201+timelag + timelag2-pstp,cnm)))+(ln-1)*fangle(squeeze(LFP(:,201+timelag + timelag2+fstp,cnm))),fangle(squeeze(LFP(:,201+timelag+timelag2,enm)))],par,0,0);%
                end
                pci(k,m,kk,ln)=oci(1);
                pst(k,m,kk,ln)=oci(2);
                cst(k,m,kk,ln)=oci(3);
                cci(k,m,kk,ln)=oci(5);
                cpap(k,m,kk,ln)=oci(7);
            end
        end
        if 1
        figure(224)
        subplot(2,3,1+kk*3-3)
        imagesc(timelag2s,timelags,sq(abs(plv(:,:,kk))))
        subplot(2,3,2+kk*3-3)
        imagesc(timelags,timelag2s,sq(abs(pci(:,:,kk,1))))
        subplot(2,3,3+kk*3-3)
        imagesc(timelags,timelag2s,sq(abs(cci(:,:,kk,1))))
        drawnow
        end
    end
    disp('one side done')
end
clear LFP
datan=sprintf([FileBase, '.', datat, '.2dKCIcpcfnew.f%dto%dHz.mat'],FreqBins);
cd ~/data/sm/4_16_05_merged/
save(datan)% 724all bursts 
out.dataname=datan;
out.pci=pci;
out.cci=cci;
out.pst=pst;
out.cst=cst;
out.cpap=cpap;
out.Null_dist=Null_dist;
if 0
        nc=3;
        nl=2;
        k=1:nl;
        for m=1:2
            figure(225+ln)
            subplot(nl,nc,(m-1)*nc+1)
            imagesc(sq(abs(pl(:,m,:))))%,[0,.26]
            set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
            if m==1
                title(['pair independent', labels{ln}])
            else
                title('inv pair independent')
            end
            subplot(nl,nc,(m-1)*nc+2)            
            imagesc(sq(pci(:,m,:)),[0, .05])
            set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
            if m==1
                title('pair independent')
            else
                title('inv pair independent')
            end
            subplot(nl,nc,(m-1)*nc+3)            
            imagesc(sq(cci(:,m,:)),[0, .05])
            set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
            if m==1
                title('c independent')
            else
                title('inv c independent')
            end
        end
        drawnow
end

directions={[datat, '3 to 1'],[datat, '1 to 3']};
methodsname={'condition on past','condition on future'};
figure(223);
for k=1:2
    for n=1:2
subplot(4,2,n+k*2-2)
imagesc(timelag2s, timelags,sq(out.cci(:,:,k,n)))
if n==1
    ylabel(directions{k});
end
if k==1
    title(methodsname{n});
end
    end
end
subplot(4,2,5)
imagesc(timelag2s, timelags,sq(out.cst(:,:,2,1)-out.cst(:,:,1,1)))
ylabel('compare p-val of 2 sides')
subplot(4,2,6)
imagesc(timelag2s, timelags,sq(out.cst(:,:,2,2)-out.cst(:,:,1,2)))
subplot(4,2,7)
imagesc(timelag2s, timelags,sq(abs(plv(:,:,1))))
ylabel('phase locking for directions')
subplot(4,2,8)
imagesc(timelag2s, timelags,sq(abs(plv(:,:,2))))