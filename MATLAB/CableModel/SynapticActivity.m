function Inputs=SynapticActivity(InC,CN,CS,tt)
% Inputs=SynapticActivity(InC,CN,CS,tt)
%       =[ncomp,nt,3] glu,gabaA, gabaB
ncomp=size(CN.conn{1},1);
nt=length(tt);
Inputs=zeros(ncomp,nt,3);
for k=1:length(InC)
    Inputs(:,:,CS.type(k))=Inputs(:,:,CS.type(k))+CN.conn{k}*InC{k}(:,tt);
end