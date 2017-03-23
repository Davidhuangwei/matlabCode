O = 2;
T = 5;
nex = 10;
M = 1;
Q = 2;

data = randn(O,T,nex);
[prior0, transmat0, mixmat0, mu0, Sigma0] =  init_mhmm(data, Q, M, 'diag', 0);

[LL, init_state_prob, transmat, mu, Sigma, mixmat] = ...
    learn_mhmm(data, prior0, transmat0, mu0, Sigma0, mixmat0, 5);

