function [nw, nA]=RefineICsFrIC(lfp,w,varargin)
% function nw=RefineICsFrIC(lfp,w)
% pick up sparse periods of ICs, then do the ICA or morphological ICA to
% refine the components until the w converge. 
% and maybe use the refined periods to get the shape of components again.
% ill think of whether it is worth doing it.
%% first very simple step, using the resulted periods, to refine the shape of ICs
[nt, nch]=size(lfp);
[nc,ncomp]=size(w);
if nc~=nch
    if ncomp~=nch
        error('dimention mismatch')
    else
        w=w';
        [nc,ncomp]=size(w);
    end
end
lfp=bsxfun(@minus,lfp,mean(lfp,1));
icasig=lfp*w;
icasig=bsxfun(@minus,icasig,mean(icasig,1));
thr=prctile(abs(icasig),60);
thru=prctile(abs(icasig),99.99);
if nargin<3
cthr=.999;
else
    cthr=varargin{1};
end
activitys=bsxfun(@ge,icasig,thr)&bsxfun(@le,icasig,thru)  ;
try
[~,~,nw,~]=wKDICA(lfp((sum(activitys,2)>0)&(sum(activitys,2)<(ncomp-2)),:)',cthr,0,0,0);
catch 
    aaa=find((sum(activitys,2)>0)&(sum(activitys,2)<(ncomp-2)));
    [~,od]=sort(rand(length(aaa),1));
    [~,~,nw,~]=wKDICA(lfp(aaa(od(1:min(25000,fix(length(aaa)/5)))),:)',cthr,0,0,0);
end
n=100;
while (mamari(w',nw)>10^-14) && n
    w=nw';
    icasig=lfp*w;
icasig=bsxfun(@minus,icasig,mean(icasig,1));
thr=prctile(abs(icasig),60);
thru=prctile(abs(icasig),99.99);
activitys=bsxfun(@ge,icasig,thr)&bsxfun(@le,icasig,thru)  ;
try
[~,~,nw,~]=wKDICA(lfp((sum(activitys,2)>0)&(sum(activitys,2)<(ncomp-2)),:)',cthr,0,0,0,'W0',nw);
catch 
    aaa=find((sum(activitys,2)>0)&(sum(activitys,2)<(ncomp-2)));
    [~,od]=sort(rand(length(aaa),1));
    try
    [~,~,nw,~]=wKDICA(lfp(aaa(od(1:min(25000,fix(length(aaa)/5)))),:)',cthr,0,0,0);
    catch 
        continue
    end
end
n=n-1;
fprintf('%d-',n)
end
fprintf('\n finish \n')
nw=bsxfun(@rdivide,nw,sqrt(sum(nw.^2,2)));
nA=pinv(nw);
nA=bsxfun(@rdivide,nA,sqrt(sum(nA.^2,1)));
end