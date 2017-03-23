% NDFA_INIT  script to initialize everything for the run
%
%   Parameters that effect the initialization
%   Variables that must be set beforehand:
%     data		Input data for the algorithm with individual
%			samples as column vectors of the matrix
%     hidneurons	Number of hidden neurons in the observation network
%     thidneurons	Number of hidden neurons in the dynamics network
%     searchsources	Number of sources to look for
%   Variables to set afterwards:
%     net.nonlin	String containing the name of the
%			nonlinearity used in the network (default 'tanh')
%     status.iters      Number of iterations per one run of ndfa_iter
%     status.updatenet, status.updatetnet, status.updatesrcvars,
%     status.updatesrcs, status.updateparams
%                       Control the onset of updates of various parameters
%                       The value is negative (wait) or zero (update)
%

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

% Number of hidden neurons for the network
if exist('hidneurons') ~= 1
  error('Number of hidden neurons must be specified in variable ''hidneurons''')
end

% Number of sources to look for
if exist('searchsources') ~= 1
  error('Number of sources must be specified in variable ''searchsources''')
end

% Number of hidden neurons for the temporal network
if exist('thidneurons') ~= 1
  error('Number of hidden neurons must be specified in variable ''thidneurons''')
end

nsampl = size(data, 2);

net = createnet_alpha(searchsources, hidneurons, size(data,1), 'tanh', ...
                      1, 1, 1, 1, .01, .01);

net.b2.e = net.b2.e + mean(data, 2);

tnet = createnet_alpha(searchsources, thidneurons, searchsources, 'tanh', ...
                       1, 1, 0.1, 0.01, .01, .01);

zs=ones(searchsources, nsampl);
sources = acprobdist_alpha(0*zs, .0001*zs);

params.net.w2var = probdist(zeros(1, hidneurons), ...
			.5 / size(data, 1) * ones(1, hidneurons));
params.tnet.w2var = probdist(zeros(1, thidneurons), ...
			  .5 / size(data, 1) * ones(1, thidneurons));
params.noise = probdist(.5 * log(.1) * ones(size(data, 1), 1), ...
			.5 / nsampl * ones(size(data, 1), 1));
params.src = probdist(zeros(searchsources, 1), ...
		      .5 / nsampl * ones(searchsources, 1));

hypers.net.w2var = nlfa_inithyper(0, .1, 0, .1);
hypers.net.b1 = nlfa_inithyper(0, .1, 0, .1);
hypers.net.b2 = nlfa_inithyper(0, .1, 0, .1);
hypers.tnet.w2var = nlfa_inithyper(0, .1, 0, .1);
hypers.tnet.b1 = nlfa_inithyper(0, .1, 0, .1);
hypers.tnet.b2 = nlfa_inithyper(0, .1, 0, .1);
hypers.noise = nlfa_inithyper(0, .1, 0, .1);
hypers.src = nlfa_inithyper(0, .1, 0, .1);

priors.net.w2var = nlfa_initprior(0, log(100), 0, log(100));
priors.net.b1 = nlfa_initprior(0, log(100), 0, log(100));
priors.net.b2 = nlfa_initprior(0, log(100), 0, log(100));
priors.tnet.w2var = nlfa_initprior(0, log(100), 0, log(100));
priors.tnet.b1 = nlfa_initprior(0, log(100), 0, log(100));
priors.tnet.b2 = nlfa_initprior(0, log(100), 0, log(100));
priors.noise = nlfa_initprior(0, log(100), 0, log(100));
priors.src = nlfa_initprior(0, log(100), 0, log(100));

status.iters = 300;
status.kls = [];
status.this_run_iters = 0;

% How many iterations to wait before starting to update these values
status.updatenet = 0;
status.updatetnet = 0;
status.updatesrcvars = 0;
status.updatesrcs = -50;
status.updateparams = -100;

clear zs
