O = 3;
T = 5;
nex = 10;
Q = 2;

%data = sample_discrete([0.3 0.7], nex, T);
prior0 = normalise(rand(Q,1));
transmat0 = mk_stochastic(rand(Q,Q));
obsmat0 = mk_stochastic(rand(Q,O));
data = sample_dhmm(prior0, transmat0, obsmat0, T, nex);
[LL, prior, transmat, obsmat] = learn_dhmm(data, prior0, transmat0, obsmat0, 5);


