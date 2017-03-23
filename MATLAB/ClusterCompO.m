function [nm, lost, dists]=ClusterCompO(LA,SA,ka)
% function [nm, mD]=ClusterComp(LA,SA,ka)
% or        [nm, mD]=ClusterComp(LA,SA,ka,usePC)
% ka is the conductence 
% if usePC == true, use PC of instead of original IC, capture the shape. 
% Here I use this to do the clusterring of ICs get from different chunck. 
% use distance computed by CompDist.m .
%
% see also: CompDist, ClusterComp

% LA=bsxfun(@minus,LA,mean(LA,1));
% SA=bsxfun(@minus,SA,mean(SA,1));
LA=bsxfun(@rdivide,LA,sqrt(sum(LA.^2,1)));
[nch,nLA]=size(LA);
nSA=length(SA);
dd=cell(nSA,1);
id=cell(nSA,1);
nm=cell(nLA,1);
lost=cell(nSA,1);
for k=1:nSA
SA{k}=bsxfun(@rdivide,SA{k},sqrt(sum(SA{k}.^2,1)));
D=CompDist(LA,SA{k},ka);
[dd{k},id{k}]=max(D,[],1);
lost{k}=[];
for n=1:nLA
    if k==1
    nm{n}=zeros(nch,nSA);
    end
    slct=find(id{k}==n);
    if ~isempty(slct)
    [dummy,sid]=max(dd{k}(slct));
    nm{n}(:,k)=SA{k}(:,slct(sid))*sign(LA(:,n)'*SA{k}(:,slct(sid)));
    lslct=length(slct);
    lst=setdiff(1:lslct,sid);
    if ~isempty(lst)
    lost{k}=[lost{k};[repmat([k n],lslct-1,1),SA{k}(:,slct(lst))']];
    end
    end
end
end
dists.dd=dd;
dists.id=id;
figure
for k=1:nLA
    subplot(1,nLA,k)
    plot(nm{k},1:nch)
    vv=var(nm{k})>10^-10;
    hold on
    plot(LA(:,k),1:nch,'k','Linewidth',2)
    axis tight
    title([num2str(sum(vv)), 'comps'])
    xlabel(num2str(find(~vv)))
    plot([0 0],[1 nch],'r:')
end
ForAllSubplots('axis xy')
ForAllSubplots('axis ij')
figure
for k=1:nSA
    subplot(1,nSA,k)
    if ~isempty(lost{k})
    plot(bsxfun(@plus,lost{k}(:,3:end),lost{k}(:,2)),1:nch)
    grid on
    axis tight
    xlabel(num2str(unique(lost{k}(:,2))))
    end
    title(['time', num2str(k)])
end
ForAllSubplots('axis xy')
ForAllSubplots('axis ij')