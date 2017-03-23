function [chindx,lnames]=LayerInShank(channels,chanLoc)
lnames=fieldnames(chanLoc);
nl=length(lnames);
chindx=cell(nl,1);
inc=true(nl,1);
for k=1:nl
    [~,chindx{k}]=getindex(channels,chanLoc.(lnames{k}));
    if isempty(chindx{k})
       inc(k)=false;
    end
end
chindx=chindx(inc);
lnames=lnames(inc);