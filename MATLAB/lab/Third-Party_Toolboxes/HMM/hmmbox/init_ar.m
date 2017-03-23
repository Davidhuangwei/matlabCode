function [hmm] = init_ar (x, ns, p, hmm, V, ALPHA, EV_THRESH, PLOT)
  
% function [hmm] = init_ar (x, ns, p, hmm, V, ALPHA, EV_THRESH, PLOT)
% Initialise AR models in an HMM-AR model using GMM clustering of
% AR vectors derived from a DAR model
% x		time series
% ns		sampling rate
% p		order of AR models
% hmm		hmm data structure
% V		observation noise; DEFAULT (calculated using global AR model)
% ALPHA		smoothing coefficient DAR model; DEFAULT=0.01
% EV_THRESH	in clustering stage, throw away AR vectors with evidence
%		less than this; DEFAULT = 0.5
% PLOT		plot AR spectra (1-YES, 0-NO); DEFAULT=1 

if nargin < 5 | isempty(V)
  th=ar(x,p,'yw');
  V=sqrt(th(1,1))/hmm.K;
  disp(sprintf('Estimates observation noise = %f',V));
end
if nargin < 6 | isempty(ALPHA)
  ALPHA=0.01;
end
if nargin < 7 | isempty(EV_THRESH)
  EV_THRESH=0.5;
end
if nargin < 8 | isempty(PLOT)
  PLOT=1;
end
  
% Use Dynamic AR model (this has variable state noise)
kftype='dar';
[A,ev,error,gain,sigma_obs,sigma_wu,pvol,state_noise,sigma_wu_q0]=dar(x,p,V,ALPHA);

% disp('Now train a Gaussian Mixture Model on AR features');
% disp('The GMM centres will be used to initialise the AR models.');

sA=A(find(ev>EV_THRESH),:);
NsA=size(sA,1);

if (NsA<10)
  disp('Error in init_ar: decrease EV_THRESH');
  m1=max(ev);
  m2=mean(ev);
  m3=min(ev);
  disp(sprintf('Max Ev= %f, Mean Ev=%f, Min Ev=%f',m1,m2,m3));
  return
end

disp(sprintf('Clustering on %d AR vectors',NsA));
hmm = hmminit(sA,hmm,'full');

for k=1:hmm.K,
  hmm.state(k).p=length(hmm.state(k).Mu);
  hmm.state(k).a=hmm.state(k).Mu';
  hmm.state(k).v=V;
end

if PLOT
	% Plot associated spectra
	figure
	for k=1:hmm.K,
	  [p,f] = ar_spec (hmm.state(k).a,hmm.state(k).v,ns);
	  subplot(hmm.K,1,k);
	  plot(f,p);
	end
end