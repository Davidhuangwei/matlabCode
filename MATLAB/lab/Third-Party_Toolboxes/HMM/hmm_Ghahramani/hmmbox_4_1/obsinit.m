function [hmm] = obsinit (X,hmm,options)

% function [hmm] = obsinit (X,hmm,options)
%
% Initialise observation model in HMM
% 
% X         N x p data matrix
% hmm       hmm data structure
% options. 
%         covtype	'full' or 'diag' covariance matrices
%         gamma		weighting of each of N data points 
%         Bins          Number of bins for Dirichlet observation model
%         prrasc        prior range scale (scales prior variances);

obsmodelist={'Gauss','Dirichlet','Poisson'};


K=hmm.K;
[T,ndim]=size(X);
if length(X)~=T,
  X=X';
  [T,ndim]=size(X);
end;

if ~isfield(hmm,'obsmodel')
  hmm.obsmodel='Gauss';
else
  if ~ismember(hmm.obsmodel,obsmodelist);
    error('Error: Undefined observation model');
  end;
end


defaultoptions=struct('covtype',[],'gamma',[],'Bins',[]);
defaultoptions.covtype='full';
defaultoptions.gamma=ones(T,1);
defaultoptions.Bins=10;
MaX=max(X,[],1);  MiX=min(X,[],1); 
gsc=(1./defaultoptions.Bins+1).^sign(MaX);
lsc=(1-1./defaultoptions.Bins).^sign(MiX);
MaX=gsc.*MaX; MiX=lsc.*MiX;
RaX=(MaX-MiX)./defaultoptions.Bins;
for d=1:ndim,
  defaultoptions.cells(d,:)=MiX(d):RaX(d):MaX(d);
end;
defaultoptions.Bins=size(defaultoptions.cells,2);

if nargin<3
  options=defaultoptions;
else
  if ~isfield(options,'covtype'),
    options.covtype=defaultoptions.covtype;
  elseif ~ismember(options.covtype,{'full','diag'}),
    options.covtype=defaultoptions.covtype;
  end;
  if ~isfield(options,'gamma') 
    options.gamma=ones(T,1); 
  end
  if ~isfield(options,'Bins')
    options.Bins=defaultoptions.Bins;
  end;
  if ~isfield(options,'cells')
    options.cells=defaultoptions.cells;
  end;
end;

hmm=initpriors(X,hmm,options);
hmm=initpost(X,hmm,options);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hmm] = initpriors(X,hmm,options)

[T,ndim]=size(X);

if ~isfield(options,'prrasc'),
  rangescale=1;
else
  rangescale=options.prrasc;
end;
% define priors
switch hmm.obsmodel
 case 'Gauss';
  % priors
  for k=1:hmm.K,
    defstateprior(k)=struct('Norm_Mu',[],'Norm_Cov', ...
			    [],'Norm_Prec',[],'Wish_B',[],'Wish_iB',[],...
			    'Wish_alpha',[],'Wish_k',[]);
    midpoint=mean(X)';
    midscale=median(X)';
    drange=range(X)'.*rangescale;
    defstateprior(k).Norm_Mu=midscale;
%    defstateprior(k).Norm_Mu=midpoint;
    defstateprior(k).Norm_Cov=diag(drange.^2);
    defstateprior(k).Norm_Prec=inv(defstateprior(k).Norm_Cov);
    defstateprior(k).Wish_B=diag(drange);
    defstateprior(k).Wish_iB=inv(defstateprior(k).Wish_B);
    defstateprior(k).Wish_alpha=ndim+1;
    defstateprior(k).Wish_k=ndim;
  end;
 case 'Dirichlet',
  for k=1:hmm.K,
    defstateprior(k)=struct('Dir_alpha',[],'Dir_k',[]);
    defstateprior(k).Dir_alpha=ones(ndim,options.Bins);
    defstateprior(k).Dir_k=options.Bins;
  end;
 case 'Poisson',
  for k=1:hmm.K,
    defstateprior(k)=struct('Gamma_alpha',[],'Gamma_beta',[]);
    defstateprior(k).Gamma_alpha=1;	% 1 count per interval
    defstateprior(k).Gamma_beta=1;	% mean HR=60BPM
  end;
end;

% assigning default priors for observation models
if ~isfield(hmm,'state') | ~isfield(hmm.state,'prior'),
  for k=1:hmm.K,
    hmm.state(k).prior=defstateprior(k);
  end;
else
  for k=1:hmm.K,
    % prior not specified are set to default
    statepriorlist=fieldnames(defstateprior(k));
    fldname=fieldnames(hmm.state(k).prior);
    misfldname=find(~ismember(statepriorlist,fldname));
    for i=1:length(misfldname),
      priorval=getfield(defstateprior(k),statepriorlist{i});
      hmm.state.prior=setfield(hmm.state,k,'prior',statepriorlist{i}, ...
					  priorval);
    end;
  end;
end;      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hmm] = initpost(X,hmm,options)

[T,ndim]=size(X);



% Initialising the posteriors
switch hmm.obsmodel
 case 'Gauss',
  mix=gmm(ndim,hmm.K,options.covtype);
  netlaboptions=foptions;
  netlaboptions(14) = 5; % Just use 5 iterations of k-means initialisation
  mix = gmminit(mix, X, netlaboptions);
  netlaboptions = zeros(1, 18);
  netlaboptions(1)  = 0;                % Prints out error values.
  % Termination criteria
  netlaboptions(3) = 0.000001;          % tolerance in likelihood
  netlaboptions(14) = 100;              % Max. Number of iterations.
  % Reset cov matrix if singular values become too small
  netlaboptions(5)=1;              
  [mix, netlaboptions, errlog] = wgmmem(mix, X, options.gamma, ...
					netlaboptions);
  hmm.gmmll=netlaboptions(8);     % Log likelihood of gmm model
  if mix.ncentres~=1
    Ecentre=mean(mix.centres)';		% Expectation of means
    Covcentre=cov(mix.centres);		% Covariance of means 
    Covcentre=cov(X);			% better if means are correl.
  else
    Ecentre=mix.centres';		% nothing sensible if K=1;
    Covcentre=cov(X);
  end;
  for k=1:mix.ncentres;
    switch options.covtype
     case 'full',
      % do nothing, just copy
      Sigma(:,:,k)=mix.covars(:,:,k);
     case 'diag'
      Sigma(:,:,k)=diag(mix.covars(k,:));
     otherwise,      
    end;
  end;

  ESigma=squeeze(sum(Sigma,3))./mix.ncentres;	
  % Expectation of Covariances Covariance of Covariances
  if mix.ncentres~=1
    Sigmatmp=reshape(Sigma,ndim*ndim,mix.ncentres)';
    CovSigma=reshape(cov(Sigmatmp),ndim*ndim,ndim*ndim);
  else
    CovSigma=repmat(Sigma,ndim,ndim);
  end;
  % Expected Counts per state
  Nm=round(mix.priors*T);
 
  for k=1:hmm.K,
    % Mean
    ndx=ceil(rand(1,1)*T);
    hmm.state(k).Norm_Mu=X(ndx,:)';
    %hmm.state(k).Norm_Mu=mix.centres(k,:)';
    hmm.state(k).Norm_Cov=Covcentre;
    hmm.state(k).Norm_Prec=inv(Covcentre);
    % Covariances
    Sigmatmp=squeeze(Sigma(:,:,k));
    alpha=Nm(k);
    hmm.state(k).Wish_alpha=alpha;
    hmm.state(k).Wish_B=Sigmatmp*alpha;
    hmm.state(k).Wish_iB=inv(hmm.state(k).Wish_B);
  end;
  hmm.train.init='gmm';
  hmm.mix=mix;
 case 'Dirichlet',
  for k=1:hmm.K,
    ndx=floor(rand(1,T./hmm.K)*T+1);	% randomly select from train-set
    for d=1:ndim,
      N(d,:)=histc(X(ndx,d),options.cells(d,:))';
    end
    N=N+ones(size(N));			% minimum count
    hmm.state(k).Dir_alpha=N;
    hmm.state(k).Dir_k=prod(size(N));
    hmm.state(k).cells=options.cells;
  end;
 case 'Poisson'
  for k=1:hmm.K,
    ndx=floor(rand(1,1)*T+1);		% randsom sample size
    ndx=floor(rand(1,ndx)*T+1);		% randomly select from train-set
    s=sum(X(ndx,1),1);
    n=sum(X(ndx,2),1);
    hmm.state(k).Gamma_alpha=n;
    hmm.state(k).Gamma_beta=s;
%    hmm.state(k).Gamma_alpha=sum(X((k-1)*600+1:(k)*600,2));
%    hmm.state(k).Gamma_beta=sum(X((k-1)*600+1:(k)*600,1));
  end
  
 otherwise
  disp('Unknown observation model');
end
hmm.options=options;    
