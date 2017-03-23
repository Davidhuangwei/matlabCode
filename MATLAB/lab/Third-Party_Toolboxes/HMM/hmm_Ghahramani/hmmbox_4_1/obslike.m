function [B] = obslike (X,T,n,hmm)

% function [B] = obslike (X,T,n,hmm)
%
% Evaluate likelihood of data given observation model
% for hmm.obsmodel = 'Gauss','Poisson','Dirichlet' or 'LIKE'
% 
% X          N by p data matrix
% T          length of series to learn
% n          block index (time series data can be split into many blocks)
% hmm        hmm data structure
%
% B          Likelihood of N data points

[T,ndim]=size(X);
if length(X)~=T,
  X=X';
  [T,ndim]=size(X);
end;
K=hmm.K;

B=zeros(T,K);
switch hmm.obsmodel
 case 'Gauss',
    for k=1:K  
      hs=hmm.state(k);
      ldetWishB=0.5*log(det(hs.Wish_B));
      PsiWish_alphasum=0;
      for d=1:ndim,
	PsiWish_alphasum=PsiWish_alphasum+...
	    digamma(hs.Wish_alpha+0.5-d/2);
      end;
      PsiWish_alphasum=PsiWish_alphasum*0.5;
      NormWishtrace=0.5*trace(hs.Wish_alpha*hs.Wish_iB*hs.Norm_Cov);
      dist=mdist(X,hs.Norm_Mu,hs.Wish_iB*hs.Wish_alpha);
      
      B(:,k)=PsiWish_alphasum-ldetWishB+dist-ndim/2* ...
		 log(2*pi);
    end
    B=exp(B);
 case 'Dirichlet',
  for k=1:K  
    hs=hmm.state(k);
    PsiDir_alphasum=digamma(sum(sum(hs.Dir_alpha)));
    Ds=sum(sum(hs.Dir_alpha));
    for d=1:ndim,
      for c=1:length(hs.cells(d,:))-1,
	ndx=(hs.cells(d,c)<=X(:,d) & X(:,d) <hs.cells(d,c+1));
	PsiDir_alpha=digamma(hs.Dir_alpha(d,c));
	B(ndx,k)=PsiDir_alpha-PsiDir_alphasum;
      end;
    end;
  end;
  B=exp(B);
 case 'Poisson',
  logYfac=-gammaln(X(:,2)+1);		% -log(y_i!)
  YlogX=X(:,2).*log(X(:,1));	% y_i log x_i
  for k=1:K,
    hs=hmm.state(k);
    E_lograte(k)=digamma(hs.Gamma_alpha)-log(hs.Gamma_beta); % <log(theta)>
    E_rate(k)=hs.Gamma_alpha./hs.Gamma_beta;
    B(:,k)=logYfac+YlogX+X(:,2).*E_lograte(k)-X(:,1)*E_rate(k);
  end;
  B=exp(B);
 case 'LIKE',
  % The observations are themselves likelihoods
  for l=1:K
    B(:,l)=X(:,l);
  end    
 otherwise
  disp('Unknown observation model');
end
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dist] = mdist (x,mu,C)
%
%   [dist] =  mdist(x,mu,C)
%
%   computes from x values given mean mu and precision C
%   the distance, actually the quantity
%                           
%        -0.5  (x-mu)' C (x-mu)  

d=size(C,1);
if (size(x,1)~=d)  x=x'; end;
if (size(mu,1)~=d)  mu=mu'; end;

[ndim,N]=size(x);
d=x-mu*ones(1,N);

% too slow
% dist=zeros(N,1);
% for l=1:N,
%   dist(l)=-0.5*d(:,l)'*C*d(:,l);
% end;


d=x-mu*ones(1,N);
Cd=C*d;
% costs memory
% dist=-0.5*diag(d'*C*d);

% less expensive 
dist=zeros(1,N);
for l=1:ndim,
  dist=dist+d(l,:).*Cd(l,:);
end
dist=-0.5*dist';

return;

