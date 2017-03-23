function ut=contract(A,Aind,B,Bind)
%
% contract(A,Aind)
%
% Sums over indices Aind in A.
% Aind is either a vector with two elements or a matrix with two rows.
%
% B=contract(A_{ijkl},[1 3]) imply that  B_{il}=sum_i A_{ijil}
%
% B=contract(A_{ijkl},[[1;3],[2;4]]) imply that B=sum_{i,j} A_{ijij}
%
% contract(A,[1 2]) is the same as diag(A) for matrices.
%
% ----
% In order to avoid excessive use of memory you should apply contract
% to the result of krontensor, but instead use the two argument form
% of contract:
%
% contract(A,Aind,B,Bind)
%
% C=contract(A_{ij},2,B_{kl},1) imply that C_{il}=sum_i A_{ij} B_{il}
%
% It is the same as contract(krontensor(A,B),[Aind,Bind+ndims(A)]);
% except that the number of dimensions for a vector is one.
%
% contract(A,2,B,1) is the same as A*B for matrix*matrix (or vector).

if (nargin<4)
  if (nargin~=2) error('Wrong number of arguments for contract');end;
  if (size(Aind,1)==1) Aind=Aind';end;
  if (size(Aind,1)~=2) 
    error('Sum over two indicies');
  end;
  si=size(A);
  if any(si(Aind(1,:))~=si(Aind(2,:)))
    error('Must sum over equal size');
  end;
  nsum=prod(si(Aind(1,:)));
  ndims=length(si);
  testunique(Aind,ndims);
  outsize=si;
  outsize(Aind(:))=[];
  if (nsum==1)
    ut=reshape(A,makesize(outsize));
  else
    index=makeindex(si,Aind);
    ut=reshape(sum(reshape(A(index),nsum,prod(outsize))),makesize(outsize));
  end;
else
  if (nargin~=4) error('Wrong number of arguments for contract');end;
  if (length(Aind)~=length(Bind))
    error('Sum over equal number of indicies');
  end;
  Aind=Aind(:)';
  Bind=Bind(:)'; % To compatible with makeindex.
  siA=size(A);
  siB=size(B);
  if (any(siA(Aind)~=siB(Bind)))
    error('Must sum over equal size');
  end;
  testunique(Aind,prod(siA));
  testunique(Bind,prod(siB));
  indA=makeindex(siA,Aind);
  indB=makeindex(siB,Bind);
  siA(Aind)=[];
  siB(Bind)=[];
  utsize=makesize([siA siB]);
  ut=reshape(reshape(A(indA'),size(indA,2),size(indA,1))* ...
             reshape(B(indB),size(indB,1),size(indB,2)),utsize);
end;

function testunique(ind,dim)
% Make sure that we do not have duplicate entries.
%
if (any(ind>dim)|any(ind<1))
 error('Illegal dimension');
end;
if (any(sparse(ind,1,1)>1))
 error('Duplicate entries');
end;

function si=makesize(siz)
% Construct a suitable size after contraction.
si=siz;
if (length(si)<2) 
  si=[si,ones(1,2-length(si))];
end;


% -----------
function ind=makeindex(siz,index)
% Construct the index for the elements.
% This is the kronecker product of the elements we sum over and
% the elements we do not sum over.
idx=makeind(siz,index);
idy=makenonindex(siz,index);
ind=repmat(idx(:),[1 prod(size(idy))])+repmat(idy(:)',[prod(size(idx)) 1]);

%-----------
function idx=makeind(siz,index);
% Index for the elements we sum over.
idx=zeros(prod(siz(index(1,:))),length(siz));
cpr=1;
for i=1:size(index,2)
  ns=siz(index(1,i));
  x=repmat((0:ns-1),[cpr 1]);
  idx(:,index(:,i))=repmat(x(:),[size(idx,1)/ns/cpr size(index,1)]);
  cpr=cpr*ns;
end;
idx=offset2ind(siz,idx);

%------------
function idy=makenonindex(siz,index);
% Offset for the elements we sum over.
nonindex=1:length(siz);
nonindex(index)=[];
idy=0;
for i=1:length(nonindex)
  column=nonindex(i);
  cpr=prod(siz(1:column-1));  
  idy=repmat(idy(:),[1 siz(column)])+...
    repmat((0:siz(column)-1)*cpr,[length(idy(:)) 1]);
end;	

% --------------
function idx=offset2ind(siz,idx)
% Construct the index from the offsets.
si2=[1,siz(1:end-1)];
idx=1+(idx*cumprod(si2(:)));

  