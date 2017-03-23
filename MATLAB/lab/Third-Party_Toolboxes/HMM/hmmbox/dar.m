function [A,ev,error,gain,sigma_obs,sigma_wu,pvol,state_noise,sigma_wu_q0] = dar(Z,p,V,ALPHA);

% function [A,ev,error,gain,sigma_obs,sigma_wu,pvol,state_noise,sigma_wu_q0] = dar(Z,p,V,ALPHA);
%
%  Dynamic autoregressive model (a type of Kalman filter)
%  Its different to RLS in that we have non-zero state noise (W!=0)
%  The state noise is set so as to maximise the evidence of the data
%  using Jazwinski's algorithm
%  The observation noise is fixed at V
%
%  Z           univariate time series 
%  p           order of model
%  V           observation noise (default=1.0)
%  ALPHA       smoothing coefficient for estimating state noise (default 0.9)
%
%  A	       estimated model parameters at each time step
%  ev          evidence (likelihood) of each data point
%  error       prediction error
%  gain        kalman gain
%  sigma_obs   estimated prediction variance due to noise
%  sigma_wu    estimated prediction variance due to weight uncertainty
%  pvol        average prior variance of state variables
%  state_noise estimated state noise
%  sigma_wu_q0 est prediction var due to weight uncert with q=0

if nargin < 2, error('dar needs at least two arguments'); end
if nargin < 3 | isempty(V), V=1; end
if nargin < 4 | isempty(ALPHA), ALPHA=0.9; end

Z=Z(:);

SEG = p;
SHIFT = 1;				

q=0;            % Global state noise parameter
W = q*eye(p);   % Initial state noise covariance matrix

y_pred = zeros(size(Z));		
error  = zeros(size(Z));		
sigma_obs  = V*ones(size(Z));		
sigma_wu  = zeros(size(Z));		
sigma_wu_q0  = zeros(size(Z));		
pvol  = zeros(size(Z));		
A      = zeros(length(Z),p);		
N = round(size(Z,1)/SHIFT - SEG/SHIFT);


% Do linear regression to get initial parameters
F = -1*Z(1:SEG);
a = pinv(F')*Z(SEG+1);				


% initial covariance for a(0)
% (estimated noise is V) 
% standard result from linear regression
C = V*F*F';
%C=eye(p);

h=waitbar(0,'Dynamic autoregressive model');

% Set s to start collecting samples of observation noise estimates
s=1;
for t = 1:N
  n = (t-1)*SHIFT + SEG +1;			% one-step predictor

  D= Z(1+(t-1)*SHIFT:(t-1)*SHIFT + SEG+1,:);
  
  F = -1*D(1:SEG,:);	                        % p-past samples
						% negative sign
						% for compatibility with
						% AR routines
						

  y = D(SEG+1,:);				% one step predictor

  % Because W=0 and G=I the prior covariance simply
  % equals the posterior covariance from the last step
  R = C + W;					% Prior covariance
  y_pred(n,:) = a'*F;				% make one-step forecast
  Q = F'*R*F + V;				% covariance of posterior P(Y_t|D_t-1)
  Qqzero = F'*C*F + V;				% cov of post given q=0
  ev(n,:)=gauss(y_pred(n,:),Q,y);               % evidence (likelihood) 
                                                % of new data point
  K = R*F/Q;					% Kalman gain factor
  a = a + K*(y-y_pred(n,:))';			% posterior mean of P(a|D_t)

  % Get new posterior cov of P(a|D_t)  
  C = R-K*F'*R;					

  e = (y_pred(n,:)-y)'*(y_pred(n,:)-y);		% prediction error 

  if t>1
    % dont make any calculations based on initial R values
    sigma_wu (n) = F'*R*F;                      % pred error due to 
                                                % weight uncertainty
    sigma_wu_q0 (n) = F'*(R-W)*F;               % pred error due to 
                                                % weight uncertainty
    pvol(n)=(1/p)*trace(R);
  end

  % Update state noise using smoothed version of Jazwinski's formula
  new_q=(e-Qqzero)/(F'*F);						
  new_q=new_q*(new_q>0);
  q = ALPHA*q + (1-ALPHA)*new_q;;
  W=q*eye(p);
  
  A(n,:) = a';  
  gain(n,:)=K';
  error(n)=e;
  state_noise(n)=q;
  waitbar(t/N);
end;

close(h);

% Reverse order of coefficients for compatibility with AR routines
A=A(:,p:-1:1);