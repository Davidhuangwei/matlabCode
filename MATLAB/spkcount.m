function [x, indx]=spkcount(clu)
% [x, indx]=spkcount(clu)
% count spikes belong to cluster n
% indx return the index
x=repmat(unique(clu),1,2);
indx=zeros(size(clu));
for k=1:size(x,1)
    tmp= clu==x(k,1);
    x(k,2)=sum(tmp);
    indx(tmp)=k;
end