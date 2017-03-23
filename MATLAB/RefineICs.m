function nw=RefineICs(lfp,w,thr,varargin)
% function nw=RefineICs(lfp,w)
% pick up sparse periods of ICs, then do the ICA or morphological ICA to
% refine the components until the w converge. 
% and maybe use the refined periods to get the shape of components again.
% ill think of whether it is worth doing it.
if nargin<4
    maxiter=50;
end
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
icasig=lfp*w;
spt=SparseActivity(icasig,thr(1));
nw=mca(lfp(spt));

while (amaridist(nw,w)>thr(2))&&maxiter
%     infow=pwinformation(lfp*w);
%     infonw=pwinformation(lfp*nw);
    w=nw;
    icasig=lfp*w;
    spt=SparseActivity(icasig,thr(1));
    nw=mca(lfp(spt));
    maxiter=maxiter-1;
end
end

function spt=SparseActivity(icasig,thr)
end
