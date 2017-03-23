function [hmm] = hmminit (X,hmm)

% function [hmm] = hmminit (X,hmm)
%
% Initialise  HMM Chain 
%
% X		N x p data matrix
% hmm		hmm data structure
%
% e.g.   hmm=struct(K,2);
%        hmm=hmmint(X,hmm); 

[T,ndim]=size(X);
if length(X)~=T,
  X=X';
  [T,ndim]=size(X);
end;

% Initialising the posteriors
for k=1:hmm.K,
  % Initial state
  hmm.Dir_alpha(k)=1;
  hmm.Pi(k)=hmm.Dir_alpha(k)./hmm.K;
  % State transitions
  hmm.Dir2d_alpha(k,:)=ones(1,hmm.K);
  hmm.Dir2d_alpha(k,k)=2; 
  hmm.P(k,:)=hmm.Dir2d_alpha(k,:)./sum(hmm.Dir2d_alpha(k,:),2);
end;



% define P-priors
defhmmprior=struct('Dir2d_alpha',[],'Dir_alpha',[]);
  
defhmmprior.Dir_alpha=ones(1,hmm.K);
defhmmprior.Dir2d_alpha=ones(hmm.K);

% assigning default priors for hidden states
if ~isfield(hmm,'prior'),
  hmm.prior=defhmmprior;
else
  % priors not specified are set to default
  hmmpriorlist=fieldnames(defhmmprior);
  fldname=fieldnames(hmm.prior);
  misfldname=find(~ismember(hmmpriorlist,fldname));
  for i=1:length(misfldname),
    priorval=getfield(defhmmprior,hmmpriorlist{i});
    hmm.prior=setfield(hmm.prior,hmmpriorlist{i},priorval);
  end;
end;


