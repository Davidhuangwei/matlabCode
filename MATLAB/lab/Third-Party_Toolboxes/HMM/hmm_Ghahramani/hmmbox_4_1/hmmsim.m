function [simdata] = hmmsim (hmm,N)
% [simdata] = hmmsim (hmm,N)
%
% simulates the output of an HMM with gaussian observation model 
% and HMM parameters
%   hmm.Pi = prior probability
%   hmm.P  = state transition probability
%   N  = number of samples generated
%
% The function returns:
%
%   data.Xseries sampled observation sequence
%   data.Xclass  sampled state sequence
% 
%   data.sorted  same as above but with sorted cart. state sequence
%   
% e.g.
% N=4096;
% hmm.Pi=[1/2 1/2];
% hmm.P=[3/4 1/2; 1/4 1/2];
% hmm.K=2;
% hmm.obsmodel='Gauss';
% hmm.state(1).Mu=-5;hmm.state(2).Mu=0;
% hmm.state(1).Cov=2;hmm.state(2).Cov=1;
% [simdata] = hmmsim (hmm,N)
  
  if ~isfield(hmm,'Pi');
    disp('Need to specify prior probability');
    return;
  else
    Pi=hmm.Pi;
  end;

  if ~isfield(hmm,'P');
    disp('Need to specify transition probability');
    return;
  else
    P=hmm.P;
  end;
  
  
  if (length(Pi)~=size(P,1)) & (length(Pi)~=size(P,2))
    disp('Prior vector and transition matrix non-conformant');
    return;
  end;

  if ~isfield(hmm,'K')
    disp('Need to specify state space dimension K ');
    return;
  else,
    K=hmm.K;
  end;
   
  if ~isfield(hmm,'obsmodel'),
    disp('Need to specify observation model');
    return;
  end;
  
switch hmm.obsmodel
 case {'GaussComm', 'Gauss'},
  if ~isfield(hmm.state,'Mu'),
    disp('Missing mean vector for Gaussian observation model');
    return;
  elseif ~isfield(hmm.state,'Cov'),
      disp('Missing covariance matrix for Gaussian observation model');
      return;
  end
 case {'AR'},
  disp('Sorry. Not supporting AR at the moment');
  return;
 case {'LIKE'},
 otherwise
  disp('Unknown observation model');
  return
end;
  
% now sampling states
for i=1:N,
  for i==1,
    c(i)=find(multinom(Pi,1,1));		% sampling prior
  else
    c(i)=find(multinom(P(:,c(i-1)),1,1));
  end;
  % sample from each observation model
  switch hmm.obsmodel
   case {'GaussComm', 'Gauss'},
    x(i,:)=sampgauss(hmm.state(c(i)).Mu,hmm.state(c(i)).Cov,1)';
   case {'AR'},
    disp('Sorry. Not supporting AR at the moment');
    return;
   case {'LIKE'},
    x(i,:)=c(i);
  end; 
end;


% sorting to obtain a presentable viterbi path
[sc,ndx]=sort(c);
sx=x(ndx,:);

simdata.Xseries=x;
simdata.Xclass=c(:);

simdata.sorted.Xseries=sx;
simdata.sorted.Xclass=sc(:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [y,p_avg,p_std]=multinom(p,m,n)
%Performs random sampling from a binomial distribution
%
% [y]=multinom(p,m,n)
% where p=1-by-k vector of probabilities of occurrence 
%       n=sample size
% and   m= number of trials
%       y=samples-matrix of size k-by-m
%
% for picking out one of k mixture components, set n=1;
%
k=length(p);
x=rand(n,m);

if (sum(p)~=1) , 
  p(k+1)=1-sum(p); 
  k=k+1; 
end;
p=cumsum(p);

y(1,:)=sum(x<=p(1));
for i=2:k,
  y(i,:)=sum(x>p(i-1) & x<=p(i));
end;

p_avg=mean(y'./n);
p_std=std(y'./n);