% Generate data points that follow a 3D helix curve
% with little additive noise

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.

srcdim = 1;
nsampl = 1000;
noisestd = .05;

truesources = probdist(zeros(srcdim, 1), ones(srcdim, 1));
inputs = makeinput(truesources * ones(1, nsampl));
data = [cos(pi*inputs); sin(pi*inputs); inputs];
data = data + noisestd * randn(size(data));
