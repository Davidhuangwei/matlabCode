function [P] = init_trans (K, av_dur, ns)

% function [P] = init_trans (K, av_dur, ns)
%
% Initialise state transition matrix to specified
% average state duration density. The remaining probabilities
% are shared between the off-diagonal transitions
%
% K       number of states
% av_dur  average state duration density (in seconds)
% ns      sample_rate
%
% P	  returned state transition matrix

samples=av_dur*ns;
Pii= 1 - (1/samples);
P=diag(Pii*ones(1,K));

if K==2
  P(1,2)=1-Pii;
  P(2,1)=1-Pii;
else
  r=(1-Pii)/(K-1);
  for i=1:K,
    for j=1:K,
      if ~(i==j)
	P(i,j)=r;
      end
    end
  end
end