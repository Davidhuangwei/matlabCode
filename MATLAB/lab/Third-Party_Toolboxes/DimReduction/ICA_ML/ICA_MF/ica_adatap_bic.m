function [P,logP]=ica_adatap_bic(X,prior,par,K,draw)  
% ICA_ADATAP_BIC  Mean field independent component analysis (ICA) 
%    [P,logP]=ICA_ADATAP_BIC(X,[par],[prior],[K],[draw])     
%    Uses ICA_ADATAP and the the Bayes Information criterion 
%    (BIC) [1] to estimate the number of sources. 
%
%    Input and output arguments: 
%       
%     X        : Mixed signal
%     prior    : Specifies the prior used in ICA_ADATAP
%     par      : Specifies the parameters used in ICA_ADATAP
%     K        : Vector or scalar holding the number of 
%                source to be investigated. Values must be 
%                greater than 1. Default K=[2:10].
%     draw     : Output run-time information if draw=1 or 2. 
%                Default draw=0.            
%     P        : Normalized model probability.
%     logP     : Model log probability.
%                                       
% - by Ole Winther 2002 - IMM, Technical University of Denmark
% - version 1.0

% Bibtex references:
% [1]  
%   @incollection{mackay92bayesian,
%       author = "D.J.C. MacKay",
%       title = "Bayesian Model Comparison and Backprop Nets",
%       booktitle = "Advances in Neural Information Processing Systems 4",
%       publisher = "Morgan Kaufmann Publishers",
%       editor = "John E. Moody et al.",
%       pages = "839--846",
%       year = "1992",
% }

% parse input
if nargin<2
  prior=[];
end
if nargin<3
  par=[];
end
if nargin<4,
  K=[2:10];
end
if nargin<5,
  draw=0;
end
try 
  par.A_init;
  nerror('par.A_init is not allowed be defined')
end 

index=0;  
N=size(X,2);
for k=K,
  index=index+1;
  if draw==1,disp(sprintf('Number of sources = %d',k));end

  % estimate ICA
  par.sources=k;
  [S,A,loglikelihood,Sigma]=ica_adatap(X,prior,par,draw);fprintf('\n');

  % bic term
  [D,M]=size(A);
  if size(Sigma,2)~=1 % full covariance
    Sigma_par=D*(D+1)/2;
  else
    Sigma_par = length(Sigma);
  end
  dim = D*M + Sigma_par; % number of parameters not integrated over
  
  logP(index)=N*loglikelihood - 0.5*dim*log(N); % loglikelihood is loglikelihood per sample
end;

% Normalize
P=exp((logP-max(logP))/N ); 
P=P/sum(P);

if nargout<1,
  bar(K,P); ylabel('P(K)'); xlabel('K');
end