function [inactivity, exactivity]=GetInternalActivity(LFP)
% [inactivity, exactivity]=GetInternalActivity(LFP)
% all matrix shaped in nsample*nvar
% 
nt=size(LFP,1);
a=[-2*LFP(:,[2,end-1])+LFP(:,[1,end-2])+LFP(:,[3,end]),sum(LFP(:,[2,end-1])-LFP(:,[1,end]),2)];
C=cov(a);
Uz=C\a'*LFP/nt;
exactivity=a*Uz;
inactivity=LFP-exactivity;
