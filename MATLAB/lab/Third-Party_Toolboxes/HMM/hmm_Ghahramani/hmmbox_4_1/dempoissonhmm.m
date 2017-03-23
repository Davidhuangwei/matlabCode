% A demonstration of the HMM software using a Poisson observation
% model on count data
clear all

load dempoisson
BPM=300;
Xtrain=[countdat*BPM];
Xtrain=[Xtrain ones(length(Xtrain),1)*BPM];
T=length(Xtrain);


plot(countdat);
title('Original data');
disp('The data are the number of counts');
disp(' ');
disp('Press a key to continue');
pause


disp(' ');
disp('We will take random samples to initialise the HMM.');
disp(' ');
disp('Press a key to continue');
pause

% Train up HMM on this data
hmm=struct('K',2);

disp(' ');
hmm=hmminit(Xtrain,hmm);
hmm.obsmodel='Poisson';
obsoptions=struct('prrasc',1);
hmm=obsinit(Xtrain,hmm,obsoptions);

disp('Mean rates of HMM initialisation');
hmm.state(1).Gamma_alpha./hmm.state(1).Gamma_beta
hmm.state(2).Gamma_alpha./hmm.state(2).Gamma_beta

% Train up HMM on observation sequence data using Baum-Welch
% This uses the forward-backward method as a sub-routine
disp('We will now train the HMM using Baum/Welch');
disp(' ');
disp('Press a key to continue');
pause
disp('Estimated HMM');

hmm.train.cyc=30;
hmm.train.obsupdate=ones(1,hmm.K);    % update observation models ?
hmm.train.init=1;         % Yes, we've already done initialisation

hmm=hmmtrain(Xtrain,T,hmm);
disp('Rates');
hmm.state(1).Gamma_alpha./hmm.state(1).Gamma_beta
hmm.state(2).Gamma_alpha./hmm.state(2).Gamma_beta
disp('Initial State Probabilities, Pi');
hmm.Pi
disp('State Transition Matrix, P');
hmm.P

[block]=hmmdecode(Xtrain,T,hmm);

% Find most likely hidden state sequence using Viterbi method
figure
plot(block(1).q_star);
axis([0 T 0 3]);
title('Viterbi decoding');

