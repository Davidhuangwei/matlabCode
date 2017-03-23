function [hmm] = obsupdate (X,T,Gamma,Gammasum,hmm,update)

% function [hmm] = obsupdate (X,T,Gamma,Gammasum,hmm,update)
% 
% Update observation model
% 
% X             observations
% T             length of series
% Gamma         p(state given X)
% Gammasum      Sum of Gamma over all T
% hmm           hmm data structure
% update        vector denoting which state obsmodels to update 
%               (default = [1,1,...hmm.K])

if nargin < 6 | isempty(update), update=ones(1,hmm.K); end

p=length(X(1,:));
N=length(X(:,1));
N=N/T;

K=hmm.K;
switch hmm.obsmodel
  case 'GaussCom',
    Mu=zeros(K,p);
    Mu=Gamma'*X;
    Mu=rdiv(Mu,Gammasum');
    Cov=zeros(p,p);
    for l=1:K
      if update(l)
	hmm.state(l).Mu=Mu(l,:);
	d=(X-ones(T*N,1)*Mu(l,:));
	Cov=Cov+rprod(d,Gamma(:,l))'*d;
      end
    end
    Cov=Cov/(sum(Gammasum));
    for l=1:K
      if update(l)
	hmm.state(l).Cov=Cov;
      end
    end
  case 'Gauss',
    Mu=zeros(K,p);
    Mu=Gamma'*X;
    Mu=rdiv(Mu,Gammasum');
    for l=1:K
      if update(l)
	hmm.state(l).Mu=Mu(l,:);
	d=(X-ones(T*N,1)*Mu(l,:));
	hmm.state(l).Cov=rprod(d,Gamma(:,l))'*d;
	hmm.state(l).Cov=hmm.state(l).Cov/(sum(Gamma(:,l)));
      end
    end;
    % Check covariances (same check as NetLab GMMEM)
    for l = 1:K
      if update(l)
	if min(svd(hmm.state(l).Cov)) < eps
	  hmm.state(l).Cov = hmm.init_val(l).Cov;
	end
      end
    end    
  case 'AR',
    % Do weighted linear regression for each state
    for l=1:K
      if update(l)
	[hmm.state(l).a,hmm.state(l).v] = arwls (X,1./Gamma(:,l),hmm.state(l).p);
      end
    end	
  case 'LIKE',
    % The observations are themselves likelihoods
    % There is no observation model to update
  otherwise
    disp('Unknown observation model');
end
