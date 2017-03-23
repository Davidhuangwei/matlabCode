function [hmm] = obsinit (X,hmm)

% function [hmm] = obsinit (X,hmm)
%
% Initialise observation model in HMM
% for hmm.obsmodel = 'GaussCom' or 'Gauss'
% 
% X         N x p data matrix
% hmm       hmm data structure

p=length(X(1,:));
K=hmm.K;
switch hmm.obsmodel
  case 'GaussCom','Gauss',
    Cov=diag(diag(cov(X)));
    Mu=randn(K,p)*sqrtm(Cov)+ones(K,1)*mean(X);
    for k=1:K,
      hmm.state(k).Mu=Mu(k,:);  % Init different cov matrices to global cov
      hmm.state(k).Cov=Cov;  % Init different cov matrices to global cov
      hmm.init_val(k).Cov = Cov; % In case we need to re-initialise
    end
  case 'AR',
    for k=1:K,
      if isfield(hmm.state(k),'p')
	th=ar(X,hmm.state(k).p,'yw');
        a=th2par(th);
	hmm.state(k).v = th(1,1); % Residual from global AR(p) model

	F=arembed(X,hmm.state(k).p);
	perturbation=sqrt(hmm.state(k).v)*randn(1,1)*F(1,:);
	
	hmm.state(k).a=(a+perturbation)';  % Global AR model with perturbation 
      else	
	disp('Error in obsinit: you must specify order of AR models: hmm.state(k).p');
        return
      end
    end
  otherwise
    disp('Unknown observation model');
end
    



