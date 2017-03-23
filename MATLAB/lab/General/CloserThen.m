%function [ia, ib] = CloserThen(a,b,delta)
% finds in a elements that are close to b 
% in absolute measure then some delta
% WARNING: can take a lot of memory!!!
function [ia, ib] = CloserThen(a,b,delta)

a=a(:); b=b(:);
na=length(a); nb=length(b);
clu = [ones(na,1); ones(nb,1)*2];
res = [a; b];
[ccg,t,pairs ] = CCG(res,clu, delta, 0, 1, [1 2],'count');
ia = intersect(pairs(:,1), find(clu==1));
ib = intersect(pairs(:,2), find(clu==2));
ia = unique(ia); ib = unique(ib)-na;
%Dab = 
return
d = repmat(a,1,nb) - repmat(b',na,1);
[ia, ib] = find(abs(d) < delta);
Dab = diag(d(ia,ib));




