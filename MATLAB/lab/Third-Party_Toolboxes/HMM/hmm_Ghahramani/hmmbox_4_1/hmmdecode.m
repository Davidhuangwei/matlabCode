function [block,LL,LL_best]=hmmdecode(X,T,hmm);

% function [block,LL,LL_best]=hmmdecode(X,T,hmm)
%
% Viterbi and single-state decoding for hmm
% X         N x p data matrix
% T         length of each sequence (N must evenly divide by T, default T=N)
% hmm       hmm data structure
%
% block().q_star    maximum likelihood state sequence 
% block().gamma     the posterior: p(q_t=i given X)
% block().delta     proby of each previous state: see eq 33a Rabiner (1989)
% block().psi       most likely pre-cursor state: see eq 33b Rabiner (1989)
% LL                log likelihood of model
% LL_best           log likelihood of best sequence

p=length(X(1,:));
N=length(X(:,1));
tiny=exp(-700);

if (rem(N,T)~=0)
  disp('Error: Data matrix length must be multiple of sequence length T');
  return;
end;
N=N/T;

K=hmm.K;
P=hmm.P;
Pi=hmm.Pi;

alpha=zeros(T,K);
beta=zeros(T,K);
gamma=zeros(T,K);

% Initialise Viterbi bits
delta=zeros(T,K);
psi=zeros(T,K);


Gamma=[];
Gammasum=zeros(1,K);
Xi=zeros(T-1,K*K);
likv=zeros(1,N);

for n=1:N
  
  B=obslike(X,T,n,hmm); 
  scale=zeros(T,1);

  % Scaling for delta
  dscale=zeros(T,1);

  alpha(1,:)=Pi(:)'.*B(1,:);
  scale(1)=sum(alpha(1,:)); 
  alpha(1,:)=alpha(1,:)/(scale(1)+tiny);
  % For viterbi decoding
  delta(1,:) = alpha(1,:);    % Eq. 32(a) Rabiner (1989)
                              % Eq. 32(b) Psi already zero
  for i=2:T
    alpha(i,:)=(alpha(i-1,:)*P).*B(i,:); 
    scale(i)=sum(alpha(i,:));
    alpha(i,:)=alpha(i,:)/(scale(i)+tiny);
  
    for k=1:K,
      v=delta(i-1,:).*P(:,k)';
      mv=max(v);
      delta(i,k)=mv*B(i,k);  % Eq 33a Rabiner (1989)
      if length(find(v==mv)) > 1
        % no unique maximum - so pick one at random
	tmp1=find(v==mv);
	tmp2=rand(length(tmp1),1);
	[tmp3,tmp4]=max(tmp2);
	psi(i,k)=tmp4;
      else      
	psi(i,k)=find(v==mv);  % ARGMAX; Eq 33b Rabiner (1989)
      end
    end;
  
    % SCALING FOR DELTA ????
    dscale(i)=sum(delta(i,:));
    delta(i,:)=delta(i,:)/(dscale(i)+tiny);
    
  end;

  % Get beta values for single state decoding
  beta(T,:)=ones(1,K)/scale(T);
  for i=T-1:-1:1
    beta(i,:)=(beta(i+1,:).*B(i+1,:))*(P')/scale(i); 
  end;
    
  % Get gamma values for single state decoding
  gamma=(alpha.*beta); 
  gamma=rdiv(gamma,rsum(gamma));
  gammasum=sum(gamma);
    
  xi=zeros(T-1,K*K);
  for i=1:T-1
    t=P.*( alpha(i,:)' * (beta(i+1,:).*B(i+1,:)));
    xi(i,:)=t(:)'/sum(t(:));
  end;
    
  likv(n)=sum(log(scale+(scale==0)*tiny));
  lik_best(n)=sum(log(dscale+(dscale==0)*tiny));
  Gamma=[Gamma; gamma];
  Gammasum=Gammasum+gammasum;

  block(n).delta=delta;
  block(n).gamma=gamma;
  block(n).psi=psi;
end;

% Backtracking for Viterbi decoding
for n=1:N
  
  block(n).q_star (T) = find(block(n).delta(T,:)==max(block(n).delta(T,:)));% Eq 34b Rabiner;
  
  for i=T-1:-1:1,
    block(n).q_star(i) = block(n).psi(i+1,block(n).q_star(i+1));
  end
end

LL=sum(likv);

LL_best=sum(lik_best);
