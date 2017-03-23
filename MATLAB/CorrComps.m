function corrcomp=CorrComps(lfp,W,t,nf,of)
% function corrcomp=CorrComp(icasig)
% icasig is a cell vector, lenght=nshanks
% and icasig{i} is in the shape of ncomp*nsample, which is
% the result given directly by ica functions.
if iscell(W)
    l=length(W);
    nl=cell(1,l);
    n=size(W{1},2);
    for k=1:l
        nl{k}=lfp(:,[1:n]+(k-1)*n)*W{k}';
    end
    lfp=cell2mat(nl);
    W=cell2mat(W');
    clear nl
else
    lfp=lfp*W';
end

lfp=zscore(resample(lfp,nf,of));
lct=size(lfp,1);
lic=size(W,1);
lt=t*2+1;
t=(-t):t;
corrcomp=zeros(lic,lic,lt);
for nt=1:lt
    if t(nt)<0
        corrcomp(:,:,nt)=lfp(1:(end+t(nt)),:)'*lfp((1-t(nt)):end,:)/(lct-abs(t(nt)));
        %                 fprintf('%d',nt)
    else
        corrcomp(:,:,nt)=lfp((1+t(nt)):end,:)'*lfp(1:(end-t(nt)),:)/(lct-abs(t(nt)));
    end
end
