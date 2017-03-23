function [x,activity]=ThetaPhaseTriggeredAve(theta,lfp,nbins)
% function [x,activity]=ThetaPhaseTriggeredAve(theta,lfp,nbins)
% input:
% theta contains:
%   theta phase:        ThPh
%   theta frequency:    ThFr
%   theta amplitude:    ThAmp
% lfp
% nbins=[bin number theta phase;
%        bin number theta frequency];
% output:
% x: the edges (lower bound, (])
% x.Ph and x.Fr
% activity: [nbinsPh,nbinsFr,nch]
% 
% YYC
nt=length(lfp);
if nt<length(theta.ThPh)
    theta.ThPh=theta.ThPh(1:nt);
    theta.ThFr=theta.ThFr(1:nt);
    theta.ThAmp=theta.ThAmp(1:nt);
end
[~,xo,bin] = histcount(theta.ThPh,nbins(1));
[~,xof,binf] = histcount(theta.ThFr,nbins(2));
x.Ph=xo;
x.Fr=xof;
nch=size(lfp,2);
bin=max(1,bin-1);
binf=max(1,binf-1);
activity=zeros(nbins(1),nbins(2),nch);
for k=1:nbins(1)
    for n=1:nbins(2)
    activity(k,n,:)=sum(bsxfun(@times,theta.ThAmp((bin==k)&(binf==n)),lfp((bin==k)&(binf==n),:))/sum(theta.ThAmp((bin==k)&(binf==n))),1);
    end
end