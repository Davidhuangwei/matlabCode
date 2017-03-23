function [B] = obslike (X,T,n,hmm)

% function [B] = obslike (X,T,n,hmm)
%
% Evaluate likelihood of data given observation model
% for hmm.obsmodel = 'GaussCom','Gauss','AR' or 'LIKE'
% 
% X          N by p data matrix
% T          length of series to learn
% n          block index (time series data can be split into many blocks)
% hmm        hmm data structure
%
% B          Likelihood of N data points

p=length(X(1,:));
K=hmm.K;
B=zeros(T,K);
k1=(2*pi)^(-p/2);
switch hmm.obsmodel
  case 'GaussCom',  
    iCov=inv(hmm.state(1).Cov);  % All Covs are the same
    k2=k1/sqrt(det(hmm.state(1).Cov));
    for i=1:T
      for l=1:K
	d=hmm.state(l).Mu-X((n-1)*T+i,:);
	B(i,l)=k2*exp(-0.5*d*iCov*d');
      end
    end
  case 'Gauss',
    for l=1:K  
      state(l).iCov=inv(hmm.state(l).Cov);
      state(l).k2=k1/sqrt(det(hmm.state(l).Cov));
    end
    for i=1:T
      for l=1:K
	d=hmm.state(l).Mu-X((n-1)*T+i,:);
	B(i,l)=state(l).k2*exp(-0.5*d*state(l).iCov*d');
	%if isnan(B(i,l))
	%  keyboard
	%end
      end
    end
    
  case 'AR',
    % Autoregressive observation model
    for l=1:K
	[x,y]=arembed(X((n-1)*T+1:n*T,:),hmm.state(l).p);
	y_pred = -x * hmm.state(l).a;

	k2=k1/sqrt(hmm.state(l).v);
	B(hmm.state(l).p+1:T,l)=k2*exp(-0.5*((y-y_pred).^2)/hmm.state(l).v);
	% Set first p values to arbitrary values
	B(1:hmm.state(l).p,l)=0.1*ones(hmm.state(l).p,1);
    end	
  case 'LIKE',
    % The observations are themselves likelihoods
    for l=1:K
        B(:,l)=X(:,l);
    end    
  otherwise
    disp('Unknown observation model');
end
    

