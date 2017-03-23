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

[T,ndim]=size(X);
if length(X)~=T,
  X=X';
  [T,ndim]=size(X);
end;

K=hmm.K;


switch hmm.obsmodel
 case 'Gauss',
  for k=1:K
    if update(k),
      hs=hmm.state(k);			% temporary structure
      hpr=hmm.state(k).prior;		% temporary structure
      
      % Update posterior Normals
      postprec=Gammasum(k)*hs.Wish_alpha*hs.Wish_iB+hpr.Norm_Prec;
      postvar=inv(postprec);
      weidata=X'*Gamma(:,k); % unnormalised sample mean
      
      Norm_Mu=postvar*(hs.Wish_alpha*hs.Wish_iB*weidata+ ...
		       hpr.Norm_Prec*hpr.Norm_Mu);
      Norm_Prec=postprec;
      Norm_Cov=postvar;
      
      %Update posterior Wisharts
      Wish_alpha=0.5*Gammasum(k)+hpr.Wish_alpha;
      
      dist=X-ones(T,1)*Norm_Mu';
      sampvar=zeros(ndim);
      for n=1:ndim,
	sampvar(n,:)=sum((Gamma(:,k).*dist(:,n))*ones(1,ndim).*dist,1);
      end;
      Wish_B=0.5*(sampvar+Gammasum(k)*Norm_Cov)+hpr.Wish_B;
      Wish_iB=inv(Wish_B);
      
      hmm.state(k).Norm_Mu=Norm_Mu;
      hmm.state(k).Norm_Prec=Norm_Prec;
      hmm.state(k).Norm_Cov=Norm_Cov;
      hmm.state(k).Wish_alpha=Wish_alpha;
      hmm.state(k).Wish_B=Wish_B;
      hmm.state(k).Wish_iB=Wish_iB;
    end
  end;
 case 'Dirichlet',
  for k=1:K
    hs=hmm.state(k);			% temporary structure
    hpr=hmm.state(k).prior;		% temporary structure
    if update(k),
      for d=1:ndim,
	for c=1:length(hs.cells(d,:))-1,
	  ndx=((hs.cells(d,c)<=X(:,d)) & (X(:,d) <hs.cells(d,c+1)));
	  hs.Dir_alpha(d,c)=sum(Gamma(find(ndx),k))+hpr.Dir_alpha(d,c);
	end;
      end;
    end;
    hmm.state(k)=hs;
  end;
 case 'Poisson',
  for k=1:K
    hs=hmm.state(k);			% temporary structure
    hpr=hmm.state(k).prior;		% temporary structure
    if update(k),
      hs.Gamma_alpha=sum(Gamma(:,k).*X(:,2),1)+hpr.Gamma_alpha;
      hs.Gamma_beta=sum(Gamma(:,k).*X(:,1),1)+hpr.Gamma_beta;
      hmm.state(k)=hs;
    end;
  end;
 case 'LIKE',
    % The observations are themselves likelihoods
    % There is no observation model to update
  otherwise
    disp('Unknown observation model');
end
