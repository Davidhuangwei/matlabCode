function CN=setConnection(CS, NP)
% function CN=setConnection(CS, NP)
% setup connections from synaptic center to compartments. depends on the
% distance from synaptic center to the compartment center. 
% if you do have multiple receive cel classes, then you use n times this
% function to set for each Neuron each time. 
% CN.conn{k}=ncomp*nsyn
CN.dist2=cell(CS.nSource,1);
CN.conn=cell(CS.nSource,1);
for k=1:CS.nSource
    CN.dist2{k}=bsxfun(@minus,NP.LocX(:),CS.Distr{k}(:,1)').^2 ...
        +bsxfun(@minus,NP.LocY(:),CS.Distr{k}(:,2)').^2 ...
         +bsxfun(@minus,NP.LocZ(:),CS.Distr{k}(:,3)').^2;
    CN.conn{k}=CS.weight(k)/sqrt(2*pi)/CS.r(k)*exp(-CN.dist2{k}/2/CS.r(k)^2).*(CN.dist2{k}<=(CS.boundry(k).^2));
   figure;
   imagesc(CN.conn{k}')
   stitle=sprintf('synaptic strength for syn %d to neuron',k);
   title(stitle)
end