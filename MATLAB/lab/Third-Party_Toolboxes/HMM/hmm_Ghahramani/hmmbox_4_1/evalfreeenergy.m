function [FrEn] = evalfreeenergy (X,Gamma,Xi,hmm);
% [FrEn] = evalfreeenergy (X,Gamma,Xi,hmm);
%
% Computes the Free Energy of an HMM depending on observation model
% 
% INPUT
%
% X            observations
% Xi           joint probability of past and future states conditioned on data 
% Gamma        probability of states conditioned on data 
% hmm  data structure 
%
% OUTPUT
%
% FrEn estiamted variational free energy
%

K=hmm.K;
[T,ndim]=size(X);
if length(X)~=T,
  X=X';
  [T,ndim]=size(X);
end;

Gammasum=sum(Gamma,1);

% compute entropy of hidden states
% Entropy of initial state
Entr=sum((Gamma(1,:)+eps).*log(Gamma(1,:)+eps),2); 
Xi=Xi+eps;				% avoid log(0)
Psi=zeros(size(Xi));			% P(S_t|S_t-1)
for k=1:K,
  sXi=sum(squeeze(Xi(:,:,k)),2);
  Psi(:,:,k)=Xi(:,:,k)./repmat(sXi,1,K);
end;
Psi=Psi+eps;				% avoid log(0)
Entr=Entr+sum(Xi(:).*log(Psi(:)),1);	% entropy of hidden states


% Free energy terms for model not including obs. model
% avLL for hidden state parameters and KL-divergence
avLL=0; 
PsiDir2d_alpha=zeros(K,K);
PsiDir_alpha=zeros(1,K);
% initial state Psi
PsiDir_alphasum=digamma(sum(hmm.Dir_alpha,2)); 
% initial state KL-div
KLdiv=dirichlet_kl(hmm.Dir_alpha,hmm.prior.Dir_alpha);
for l=1:K,
  % KL-divergence for transition prob
  KLdiv=[KLdiv dirichlet_kl(hmm.Dir2d_alpha(l,:),hmm.prior.Dir2d_alpha(l,:))];
  % initial state Psi(alpha)
  PsiDir_alpha(l)=digamma(hmm.Dir_alpha(l));
  avLL=avLL+Gamma(1,l)*(PsiDir_alpha(l)-PsiDir_alphasum);
  PsiDir2d_alphasum=digamma(sum(hmm.Dir2d_alpha(l,:),2));
  for k=1:K,
    PsiDir2d_alpha(l,k)=digamma(hmm.Dir2d_alpha(l,k));
    avLL=avLL+sum(Xi(:,l,k),1)*(PsiDir2d_alpha(l,k)-PsiDir2d_alphasum);
  end;
end;

switch hmm.obsmodel
 case 'Gauss',
  ltpi=ndim/2*log(2*pi);
  for k=1:K,
    hs=hmm.state(k);		% for ease of referencing
    pr=hmm.state(k).prior;
    
    dist=mdist(X,hs.Norm_Mu,hs.Wish_iB*hs.Wish_alpha);
    NormWishtrace=0.5*trace(hs.Wish_alpha*hs.Wish_iB*hs.Norm_Cov);
    ldetWishB=0.5*log(det(hs.Wish_B));
    PsiWish_alphasum=0;
    for d=1:ndim,
      PsiWish_alphasum=PsiWish_alphasum+...
	  digamma(hs.Wish_alpha+0.5-d/2);
    end;
    PsiWish_alphasum=0.5*PsiWish_alphasum;

    avLL=avLL+Gammasum(k).*(PsiWish_alphasum-ldetWishB-NormWishtrace-ltpi)+...
	 sum(Gamma(:,k).*dist);
    
    % KL divergences of Normals and Wishart
    VarDiv=wishart_kl(hs.Wish_B,pr.Wish_B,hs.Wish_alpha,pr.Wish_alpha);
    MeanDiv=gauss_kl(hs.Norm_Mu,pr.Norm_Mu,hs.Norm_Cov,pr.Norm_Cov);
    KLdiv=[KLdiv MeanDiv VarDiv];

  end;
 case 'Dirichlet',
  for k=1:K  
    hs=hmm.state(k);
    pr=hmm.state(k).prior;
    
    PsiDir_alphasum=digamma(sum(sum(hs.Dir_alpha)));
    Ds=sum(sum(hs.Dir_alpha));
    for d=1:ndim,
      for c=1:length(hs.cells(d,:))-1,
	ndx=(hs.cells(d,c)<=X(:,d) & X(:,d) <hs.cells(d,c+1));
	PsiDir_alpha=digamma(hs.Dir_alpha(d,c));
	avLL=avLL+sum(Gamma(ndx,k).*(PsiDir_alpha-PsiDir_alphasum));
      end;
    end;
  end;
 case 'Poisson',
  logYfac=-gammaln(X(:,2)+1);		% -log(y_i!)
  YlogX=X(:,2).*log(X(:,1));	% y_i log x_i
  for k=1:K,
    hs=hmm.state(k);
    pr=hmm.state(k).prior;
    
    E_lograte(k)=digamma(hs.Gamma_alpha)-log(hs.Gamma_beta); % <log(theta)>
    E_rate(k)=hs.Gamma_alpha./hs.Gamma_beta;
    avLL=avLL+sum(Gamma(:,k).*(logYfac+YlogX+X(:,2).*E_lograte(k)-...
	X(:,1)*E_rate(k)));
  end;
case 'LIKE',
  for k=1:K,
    avLL=avLL+sum(Gamma(:,k).*X(:,k));
  end;
 otherwise
  disp('Unknown observation model');
end

FrEn=[Entr -avLL +KLdiv];