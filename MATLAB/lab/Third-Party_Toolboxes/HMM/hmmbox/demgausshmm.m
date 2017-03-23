% A demonstration of the HMM software using a Gaussian observation
% model on AR features

load demgauss
T=size(arp,1);

% X   original time series
% arp AR(4) features

plot(X);
title('Original data');
disp('The middle section of data is mainly 10Hz activity');
disp('wheras the beginning and end sections are just noise');
disp(' ');
disp('Press a key to continue');
pause


disp(' ');
disp('We will train a  Gaussian Mixture Model on AR-4 features derived from');
disp('overlapping blocks of the time series.');
disp('The resulting GMM will be used to initialise an HMM.');
disp(' ');
disp('Press a key to continue');
pause

% Train up GMM on this data
hmm.K=2;

disp(' ');
hmm=hmminit(arp,hmm,'full');

disp('Means of HMM initialisation');
hmm.state(1).Mu
hmm.state(2).Mu

% Train up HMM on observation sequence data using Baum-Welch
% This uses the forward-backward method as a sub-routine
disp('We will now train the HMM using Baum/Welch');
disp(' ');
disp('Press a key to continue');
pause
disp('Estimated HMM');

hmm.train.cyc=30;
hmm.obsmodel='Gauss';
hmm.train.obsupdate=ones(1,hmm.K);    % update observation models ?
hmm.train.init=1;         % Yes, we've already done initialisation

hmm=hmmtrain(arp,T,hmm);
disp('Means');
hmm.state(1).Mu
hmm.state(2).Mu
disp('Initial State Probabilities, Pi');
hmm.Pi
disp('State Transition Matrix, P');
hmm.P

[block]=hmmdecode(arp,T,hmm);

% Find most likely hidden state sequence using Viterbi method
figure
plot(block(1).q_star);
axis([0 T 0 3]);
title('Viterbi decoding');

disp('The Viterbi decoding plot shows that the time series');
disp('has been correctly partitioned.');