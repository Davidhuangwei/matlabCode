function [gamma, xi, loglik] = forwards_backwards(prior, transmat, obslik, filter_only)
% FORWARDS_BACKWARDS Compute the posterior probs. in an HMM using the forwards backwards algo.
% [gamma, xi, loglik] = forwards_backwards(prior, transmat, obslik, filter_only)
% 'filter_only' is an optional argument (default: 0). If 1, we do filtering, if 0, smoothing.
% Use obslik = mk_dhmm_obs_lik(data, b) or obslik = mk_ghmm_obs_lik(data, mu, sigma) first.
%
% Inputs:
% PRIOR(I) = Pr(Q(1) = I)
% TRANSMAT(I,J) = Pr(Q(T+1)=J | Q(T)=I)
% OBSLIK(I,T) = Pr(Y(T) | Q(T)=I)
%
% Outputs:
% gamma(i,t) = Pr(X(t)=i | O(1:T))
% xi(i,j,t)  = Pr(X(t)=i, X(t+1)=j | O(1:T)) t <= T-1

if nargin < 4, filter_only = 0; end

T = size(obslik, 2);
Q = length(prior);

scale = ones(1,T);
loglik = 0;
alpha = zeros(Q,T); 
gamma = zeros(Q,T);
xi = zeros(Q,Q,T-1);

t = 1;
alpha(:,1) = prior(:) .* obslik(:,t);
[alpha(:,t), scale(t)] = normalise(alpha(:,t));
transmat2 = transmat';
for t=2:T
  [alpha(:,t),scale(t)] = normalise((transmat2 * alpha(:,t-1)) .* obslik(:,t));
  if filter_only
    xi(:,:,t-1) = normalise((alpha(:,t-1) * obslik(:,t)') .* transmat);
  end
end
loglik = sum(log(scale));

if filter_only
  gamma = alpha;
  return;
end

beta = zeros(Q,T); % beta(i,t)  = Pr(O(t+1:T) | X(t)=i)
gamma = zeros(Q,T);
beta(:,T) = ones(Q,1);
gamma(:,T) = normalise(alpha(:,T) .* beta(:,T));
t=T;
for t=T-1:-1:1
  b = beta(:,t+1) .* obslik(:,t+1); 
  beta(:,t) = normalise((transmat * b));
  gamma(:,t) = normalise(alpha(:,t) .* beta(:,t));
  xi(:,:,t) = normalise((transmat .* (alpha(:,t) * b')));
end

