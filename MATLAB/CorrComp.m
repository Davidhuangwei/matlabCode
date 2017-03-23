function corrcomp=CorrComp(icasig,t,varargin)
% function corrcomp=CorrComp(icasig)
% icasig is a cell vector, lenght=nshanks
% and icasig{i} is in the shape of ncomp*nsample, which is
% the result given directly by ica functions. 
lic=length(icasig);
lct=size(icasig{1},2);
if nargin>2
    tt=varargin{1};
else
    tt=1:lct;
end
lct=length(tt);
% 
corrcomp=cell(lic,lic);
xc=zeros(lic,1);
lt=length(t);
if lt==1
    t=(-t):t;
    lt=lt*2+1;
elseif lt==2
    t=(-t(1)):t(2):t(1);
    lt=length(t);
end
for k=1:lic 
    xc(k)=size(icasig{k},1);
    icasig{k}=zscore(icasig{k}(:,tt)');
end
for k=1:lic
    for n=k:lic
        corrcomp{k,n}=zeros(xc(k),xc(n),lt);
        for nt=1:lt
            if t(nt)<0
                corrcomp{k,n}(:,:,nt)=icasig{k}((1-t(nt)):end,:)'*icasig{n}(1:(end+t(nt)),:)/(lct-abs(t(nt)));
%                 fprintf('%d',nt)
            else
                corrcomp{k,n}(:,:,nt)=icasig{k}(1:(end-t(nt)),:)'*icasig{n}((1+t(nt)):end,:)/(lct-abs(t(nt)));
            end
        end
    end
end
        