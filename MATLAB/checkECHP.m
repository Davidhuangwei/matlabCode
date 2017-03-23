cd /home/weiwei/data/g10-20130528/
load chanLoc.mat
HP=[17:25,27:32,33:64];%17:32;%33:64;
Periods = load([FileBase '.sts.SWS']);
Par = LoadXml([FileBase '.xml']);
% Periods=[1 Periods(1)-1];
LFP = LoadBinary([FileBase '.lfpinterp'],HP,Par.nChannels,4,[],[],Periods)';
%%
load g10-20130528.SWS.freqR.CSD.span.1.1.Ch.17.32.mat
lfp=ButFilter(LFP,4,Par.FreqB/625,'bandpass');

nfr=size(Par.freqB,1);
nr=length(Par.r);
nMI=cell(nr,nfr);
for k=1:nr
    for n=1:nfr
       LFP=ButFilter(lfp,4,Par.freqB(n,:)/625,'bandpass');
       A=imkCSD(S(k,n).gbsnm',r(k),Par.HP,Par.HP,Par.lambda,Par.theta);
       W=pinv(A);
       ncomp=size(A,2);
       isig=LFP(:,1:(end-32))*W';
       LFP=LFP(:,(end-31):end);
       nMI{k,n}=zeros(2,32,ncomp);
       for nic=1:ncomp
           for nhp=1:32
               nMI{k,n}(1,nhp,nic)=information(LFP(:,nhp)',isig(:,nic)')/information(LFP(:,nhp)',LFP(:,nhp)');
               nMI{k,n}(2,nhp,nic)=information(LFP(5:end,nhp)',isig(1:(end-4),nic)')/information(LFP(5:end,nhp)',LFP(5:end,nhp)');
           end
       end
    end
end
save g10-20130528.SWS.freqR.CSD.span.1.1.Ch.17.32.nMI.mat nMI

%%
[nr, nfr]=size(nMI);
for k=2
    for n=1:nfr
        figure(n)
        ncomp=size(nMI{k,n},3);
        clim=max(nMI{k,n}(:));
        for m=1:ncomp
            subplot(2,ncomp,m)
            imagesc(reshape(sq(nMI{k,n}(1,:,m)),8,4),[0 clim])
            subplot(2,ncomp,m+ncomp)
            imagesc(reshape(sq(nMI{k,n}(2,:,m)),8,4),[0 clim])
        end
    end
end