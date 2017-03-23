function [ML, MR, RL, N, par]=LagShiftPL()
FileBase='4_16_05_merged';
State='RUN';
load('/gpfs01/sirota/data/bachdata/data/weiwei/m_sm/4_16_05_merged_par.mat');
load /gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/4_16_05_merged/ChanInfo/ChanLoc_Full.eeg.mat
repch=RepresentChan(Par);
[~,rad]=getindex(repch,chanLoc.rad);
cd /gpfs01/sirota/data/bachdata/data/weiwei/m_sm/
if exist([FileBase, '_SP_', State, '.mat'])
    load([FileBase, '_SP_', State, '.mat'], 'SP','FreqB')
else
    disp(['you do not have SP for ', State])
end
display=1;
nprd=length(SP);
nlag=81;
% this lag shift extend for +-80 sample
% ch*fr*lag
frbs=[1,5;9,12;11,14;15 22];
lfrbs=size(frbs,1);
for sjn=1:nprd
    load([FileBase, '_LFPsig_', State, num2str(sjn)])
    if sjn==1
        Freq=out.FreqBins;
        nfr=size(Freq,1);
        nvar=size(out.LFPsig,2);
        nch=nvar/nfr; 
        RL=zeros(nch,lfrbs,nlag);
        N=0;
        ML=zeros(nch,lfrbs,nlag);
        MR=zeros(nch,lfrbs,nlag);
    end
    nt=size(out.LFPsig,1);
    lf=zeros(nt,nch,lfrbs);
    N=N+nt-80;
    out.LFPsig=reshape(out.LFPsig,nt,nch,nfr);
    
    for k=1:lfrbs
        lf(:,:,k)=sq(sum(out.LFPsig(:,:,frbs(k,1):frbs(k,2)),3));
    end
    out.LFPsig=lf;
    clear lf
    %% phase locking to it's own frequency band
    cLFP=sq(mean(out.LFPsig(:,rad,:),2));
    
    for k=1:81
        RL(:,:,k)=RL(:,:,k)+sq(sum(fangle(reshape(reshape(out.LFPsig(k:(end+k-81),:,:),(nt-80)*nch,lfrbs).*conj(repmat(cLFP(k:(end+k-81),:),nch,1)),nt-80,nch,lfrbs)),1));%nt*nch*nfr*nlag
        temp=reshape(reshape(out.LFPsig(k:(end+k-81),:,:),(nt-80)*nch,lfrbs).*conj(repmat(cLFP(k:(end+k-81),:,:),nch,1)),nt-80,nch,lfrbs);
        ML(:,:,k)=ML(:,:,k)+sq(sum(temp,1));
        MR(:,:,k)=MR(:,:,k)+sq(sum(abs(temp),1));
    end
end
% MapSilicon(abs(nPhiClu.ampphi{9}(fr,:,nfr)),[],out.Par,[],[],[0, .15],[],[],1);
if display
    np=ML./MR;
    p=RL/N;
    for k=1:lfrbs
        figure(224)
        subplot(1,lfrbs,k)
        imagesc(1:81,1:93,sq(abs(np(:,k,:))))%,[0, .15]
        figure(225)
        subplot(1,lfrbs,k)
        imagesc(1:81,1:93,sq(abs(p(:,k,:))))%,[0, .15]
    end
    
    lname=fieldnames(chanLoc);
    repch=RepresentChan(Par);
    lyrch=[];
    endlabel=zeros(length(lname),1);
    for k=1:length(lname)
        lyrch=[lyrch;chanLoc.(lname{k})(:)];
        endlabel(k)=length(lyrch);
    end
    [~,ilyrch]=getindex(repch,lyrch);
    par.lname=lname;
    par.lyrch=lyrch;
    par.ilyrch=ilyrch;
    for k=1:lfrbs
        figure(224)
        subplot(1,lfrbs,k)
        imagesc(sq(abs(np(ilyrch,k,:))))%,[0, .15]
        set(gca,'Ytick',endlabel,'Yticklabel',lname);
        figure(225)
        subplot(1,lfrbs,k)
        imagesc(sq(abs(p(ilyrch,k,:))))%,[0, .15]        
        set(gca,'Ytick',endlabel,'Yticklabel',lname);
    end
end
