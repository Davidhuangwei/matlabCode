function [hmm]=hmmtrain(X,T,hmm)

% function [hmm]=hmmtrain(X,T,hmm)
%
% Train Hidden Markov Model using Baum Welch/EM algorithm
%
% INPUTS:
%
% X - N x p data matrix
% T - length of each sequence (N must evenly divide by T, default T=N)
% hmm.K - number of states (default 2)
% hmm.P - state transition matrix
% hmm.obsmodel -  'Gauss','GaussCom','AR' or 'LIKE'
% hmm.train.cyc - maximum number of cycles of Baum-Welch (default 100)
% hmm.train.tol - termination tol (prop change in likelihood) (default 0.0001)
% hmm.train.init - Already initialised the obsmodel (1 or 0) ? (default=0)
% hmm.train.obsupdate - Update the obsmodel (1 or 0) ?  (default=1)
% hmm.train.pupdate - Update transition matrix (1 or 0) ? (default=1)
%
% OUTPUTS
% hmm.Pi - priors
% hmm.P - state transition matrix
% hmm.state(k).$$ - whatever parameters there are in the observation model
% hmm.LLtrain  - training log likelihood
%

% ALGORITHM
%
% Iterates until a proportional change < tol in the log likelihood 
% or cyc steps of Baum-Welch


% Copy in and check existence of parameters from hmm data structure

if ~isfield(hmm,'obsmodel')
  disp('Error in hmm_train: obsmodel not specified');
  return
end

p=length(X(1,:));
N=length(X(:,1));


if isfield(hmm,'K')
  K=hmm.K;
else
  disp('Error in hmmtrain: K not specified');
  return
end

if ~isfield(hmm,'train')
  disp('Error in hmmtrain: hmm.train not specified');
  return
end

if isfield(hmm.train,'cyc')
  cyc=hmm.train.cyc;
else
  cyc=100; 
end

if isfield(hmm.train,'tol')
  tol=hmm.train.tol;
else
  tol=0.0001; 
end

if ~isfield(hmm.train,'init')
  traininit=0;
else
  traininit=hmm.train.init;
end

if ~isfield(hmm.train,'obsupdate')
  updateobs=ones(1,hmm.K);  % update observation models for all states
else
  updateobs=hmm.train.obsupdate;
end

if ~isfield(hmm.train,'pupdate')
  updatep=1;
else
  updatep=hmm.train.pupdate;
end

% Initialise stuff

if (rem(N,T)~=0)
  disp('Error: Data matrix length must be multiple of sequence length T');
  return;
end;

N=N/T;
if ~traininit
  hmm=obsinit(X,hmm);
end

Pi=rand(1,K);
Pi=Pi/sum(Pi);


if ~isfield(hmm,'P')
  P=rand(K);
  P=rdiv(P,rsum(P));
else
  P=hmm.P;
end

LL=[];
lik=0;

alpha=zeros(T,K);
beta=zeros(T,K);
gamma=zeros(T,K);


for cycle=1:cyc
  
  %%%% FORWARD-BACKWARD 
  
  Gamma=[];
  Gammasum=zeros(1,K);
  Scale=zeros(T,1);
  Xi=zeros(T-1,K*K);
  
  for n=1:N
    
    B = obslike(X,T,n,hmm);
    scale=zeros(T,1);
    alpha(1,:)=Pi.*B(1,:);
    scale(1)=sum(alpha(1,:));
    alpha(1,:)=alpha(1,:)/scale(1);
    for i=2:T
      alpha(i,:)=(alpha(i-1,:)*P).*B(i,:);
      scale(i)=sum(alpha(i,:));
      alpha(i,:)=alpha(i,:)/scale(i);
    end;
    
    beta(T,:)=ones(1,K)/scale(T);
    for i=T-1:-1:1
      beta(i,:)=(beta(i+1,:).*B(i+1,:))*(P')/scale(i); 
    end;
    
    gamma=(alpha.*beta); 
    gamma=rdiv(gamma,rsum(gamma));
    gammasum=sum(gamma);
    
    xi=zeros(T-1,K*K);
    for i=1:T-1
      t=P.*( alpha(i,:)' * (beta(i+1,:).*B(i+1,:)));
      xi(i,:)=t(:)'/sum(t(:));
    end;
    
    Scale=Scale+log(scale);
    Gamma=[Gamma; gamma];
    Gammasum=Gammasum+gammasum;
    Xi=Xi+xi;
  end;
  
  %%%% M STEP 
  
  % transition matrix 
  sxi=rsum(Xi')';
  sxi=reshape(sxi,K,K);
  if updatep
    P=rdiv(sxi,rsum(sxi));
  end
  
  % priors
  Pi=zeros(1,K);
  for i=1:N
    Pi=Pi+Gamma((i-1)*T+1,:);
  end
  Pi=Pi/N;
  
  % Observation model
  if sum(updateobs) > 0
    hmm=obsupdate (X,T,Gamma,Gammasum,hmm,updateobs);
  end

  oldlik=lik;
  lik=sum(Scale);
  LL=[LL lik];
  fprintf('cycle %i log likelihood = %f ',cycle,lik);  

  if (cycle<=2)
    likbase=lik;
  elseif (lik<oldlik) 
    fprintf('violation');
  elseif ((lik-likbase)<(1 + tol)*(oldlik-likbase)|~isfinite(lik)) 
    fprintf('\n');
    break;
  end;
  fprintf('\n');

end


hmm.P=P;
hmm.Pi=Pi;
hmm.LLtrain=lik;

hmm.data.Xtrain=X;
hmm.data.T=T;

