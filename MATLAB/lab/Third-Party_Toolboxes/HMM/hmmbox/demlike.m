% A demonstration of the HMM software using the 'Likelihood' observation
% model. There are K=2 time series where EACH TIME SERIES IS THE 
% LIKELIHOOD OF THE DATA GIVEN THAT STATE - in effect there is 
% no observation model; the likelihood of each data point is simply
% set to the value of each data point.

load demlike

figure
plot(pp_t(:,1));
title('Original data - series 1');

disp('The plot shows the likelihood of data given state/class 1');
disp(' ');
disp('Press a key to train up an HMM');
disp(' ');
pause

Xseries=pp_t;
hmm.K=2;

hmm.obsmodel='LIKE';
hmm.train.obsupdate=0;
hmm.train.init=1;   % We've already initialised (nothing to do anyway)

T=size(Xseries,1);

% Train HMM
hmm=hmmtrain(Xseries,T,hmm);

[block,LL]=hmmdecode(Xseries,T,hmm);
        
% Find most likely hidden state sequence using Viterbi method
figure
plot(block(1).q_star);
axis([0 800 0 3]);
title('Viterbi decoding');

disp('State transition matrix is:');
hmm.P


disp('The Viterbi decoding plot shows that the time series');
disp('has been correctly partitioned.');
