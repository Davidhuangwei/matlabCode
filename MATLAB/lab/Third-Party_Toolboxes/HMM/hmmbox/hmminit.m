function [hmm] = hmminit (X,hmm,covtype,gamma)

% function [hmm] = hmminit (X,hmm,covtype,gamma)
%
% Initialise Gaussian observation HMM model 
% using a static Gaussian Mixture Model (using NetLab routines)
%
% X		N x p data matrix
% hmm		hmm data structure
% covtype	'full' or 'diag' covariance matrices
% gamma		weighting of each of N data points 
%		(default is 1 for each data point)

N=size(X,1);
if nargin < 4 | isempty(gamma), gamma=ones(N,1); end

p=size(X,2);
mix=gmm(p,hmm.K,covtype);

%options=foptions;
options = zeros(16,1);
options(14) = 5; % Just use 5 iterations of k-means initialisation
mix = gmminit(mix, X, options);

options = zeros(1, 18);
options(1)  = 0;                % Prints out error values.

% Termination criteria
options(3) = 0.000001;          % tolerance in likelihood
options(14) = 100;              % Max. Number of iterations.

% Reset cov matrix if singular values become too small
options(5)=1;              

[mix, options, errlog] = wgmmem(mix, X, gamma,options);
hmm.gmmll=options(8);     % Log likelihood of gmm model

for k=1:mix.ncentres;
  hmm.state(k).Mu=mix.centres(k,:);
  switch covtype
    case 'full',
      hmm.state(k).Cov=squeeze(mix.covars(:,:,k));
      hmm.init_val(k).Cov = hmm.state(k).Cov; % In case we need to re-init
    case 'diag',
      hmm.state(k).Cov=diag(mix.covars(k,:));
      hmm.init_val(k).Cov = hmm.state(k).Cov; % In case we need to re-init
    otherwise,      
      disp('Unknown type of covariance matrix');
    end
end

hmm.train.init='gmm';

hmm.mix=mix;
