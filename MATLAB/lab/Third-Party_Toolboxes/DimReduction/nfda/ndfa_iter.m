% NDFA_ITER script to iterate NDFA model
%
%    For initialization needed, see NDFA_INIT
%
%    Returned values (variables):
%      sources		Estimate for the sources (probdist)
%      net		Estimate for the observation network (probdist)
%      tnet		Estimate for the dynamics network (probdist)
%      status.kls	Kullback-Leibler divergences for each iteration
%      params		Estimated variances for different variables
%      hypers		Estimated values for hyperparameters of the model

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if (~isa(sources, 'acprobdist_alpha'))
  sources = updatevar(acprobdist_alpha(sources));
end

if status.this_run_iters == 0
  status.this_run_iters = status.iters;
end

nsampl = size(data, 2);

while status.this_run_iters > 0

  dcp_dnetm = netgrad_zeros(net);
  dcp_dnetv = netgrad_zeros(net);
  dcp_dtnetm = netgrad_zeros(tnet);
  dcp_dtnetv = netgrad_zeros(tnet);
  fs = probdist(zeros(size(data)), ones(size(data)));
  tfs = probdist(zeros(size(sources)), ones(size(sources)));

  % Do feedforward calculations
  x = feedfw( sources , net);
  tx = acfeedfw( sources , tnet);

  % Calculate and display current value of Kullback-Leibler divergence
  fs = probdist(x{4}.e, x{4}.var);
  if (status.freeinitial)
    tfs = probdist([sources.e(:,1) tx{4}.e], ...
		   [zeros(size(sources, 1), 1) tx{4}.var]);
  else
    tfs = probdist([zeros(size(sources, 1), 1) tx{4}.e], ...
		   [zeros(size(sources, 1), 1) tx{4}.var]);
  end

  newkls = kldiv(tfs, fs, sources, data, net, tnet, params, hypers, priors);
  fprintf('Iteration #%d: %f\n', size(status.kls, 2), newkls)

  % Calculate partial derivatives for parameters to adapt
  [dcp_dsm, dcp_dsv, newdcp_dnetm, newdcp_dnetv] =...
      feedback(x, net, sources, data, params.noise);

  dcp_dnetm = sum_structs(dcp_dnetm, newdcp_dnetm);
  dcp_dnetv = sum_structs(dcp_dnetv, newdcp_dnetv);

  [newdcp_dsm, newdcp_dsv, newdcp_dtnetm, newdcp_dtnetv] = ...
      feedbackac(tx, tnet, sources(:, 1:end-1), sources(:, 2:end).e, ...
		 params.src);

  dcp_dsm(:,1:end-1) = dcp_dsm(:,1:end-1) + newdcp_dsm;
  dcp_dsv(:,1:end-1) = dcp_dsv(:,1:end-1) + newdcp_dsv;
  dcp_dtnetm = sum_structs(dcp_dtnetm, newdcp_dtnetm);
  dcp_dtnetv = sum_structs(dcp_dtnetv, newdcp_dtnetv);

  [newdcp_dsm, dcp_dsvn] = feedback_srcpriors(sources - tfs, params.src);

  dcp_dsm = dcp_dsm + newdcp_dsm;
  [dcp_dsvn, newac] = computevard(dcp_dsv, dcp_dsvn, sources.ac, tx{5});

  % Get new values for sources and alphas if appropriate
  if max([status.updatesrcs, status.updatesrcvars]) >= 0
    newsources = ...
	updatesources(sources, dcp_dsm, dcp_dsvn, x{4}.multivar, ...
		      tx{5}, params.src, params.noise, newac);
      
    if status.updatesrcs < 0
      sources.var = newsources.var;
      sources.nvar = newsources.nvar;
      sources.valpha = newsources.valpha;
      sources.vsign = newsources.vsign;
    else
      sources = newsources;
    end
    sources.ac = newac;
    sources = updatevar(sources);
  end

  if status.updatesrcs < 0
    status.updatesrcs = status.updatesrcs + 1;
  end
  if status.updatesrcvars < 0
    status.updatesrcvars = status.updatesrcvars + 1;
  end

  [newdcp_dnetm, newdcp_dnetv] = ...
      feedback_netpriors(net, params.net, hypers.net);
  dcp_dnetm = sum_structs(dcp_dnetm, newdcp_dnetm);
  dcp_dnetv = sum_structs(dcp_dnetv, newdcp_dnetv);

  [newdcp_dtnetm,newdcp_dtnetv] = ...
      feedback_netpriors(tnet, params.tnet, hypers.tnet);
  dcp_dtnetm = sum_structs(dcp_dtnetm, newdcp_dtnetm);
  dcp_dtnetv = sum_structs(dcp_dtnetv, newdcp_dtnetv);

  % Update the network and alphas if appropriate  
  if status.updatenet < 0
    status.updatenet = status.updatenet + 1;
  else
    net = updatenetwork(net, dcp_dnetm, dcp_dnetv);
  end

  if status.updatetnet < 0
    status.updatetnet = status.updatetnet + 1;
  else
    tnet = updatenetwork(tnet, dcp_dtnetm, dcp_dtnetv);
  end

  % Update estimates for different parameters if appropriate
  if status.updateparams < 0
    status.updateparams = status.updateparams + 1;
  else
    params.noise = estimatevars(fs-data, hypers.noise, params.noise);
    tmpsrc = probdist(sources.e - tfs.e, sources.nvar + tfs.var);
    params.src   = estimatevars(tmpsrc, hypers.src, params.src);
    params.net.w2var = estimatevars(net.w2, hypers.net.w2var, ...
				    params.net.w2var, 1);
    params.tnet.w2var = estimatevars(tnet.w2, hypers.tnet.w2var, ...
				    params.tnet.w2var, 1);
    
    [hypers.net.w2var.mean, hypers.net.w2var.var] = ...
	estimatemeanvars(params.net.w2var, priors.net.w2var.mean, ...
		       priors.net.w2var.var, hypers.net.w2var.var);
    [hypers.tnet.w2var.mean, hypers.tnet.w2var.var] = ...
	estimatemeanvars(params.tnet.w2var, priors.tnet.w2var.mean, ...
		       priors.tnet.w2var.var, hypers.tnet.w2var.var);
    [hypers.noise.mean, hypers.noise.var] = ...
	estimatemeanvars(params.noise, priors.noise.mean, ...
		       priors.noise.var, hypers.noise.var, 1);
    [hypers.net.b1.mean, hypers.net.b1.var] = ...
	estimatemeanvars(net.b1, priors.net.b1.mean, ...
		       priors.net.b1.var, hypers.net.b1.var, 1);
    [hypers.net.b2.mean, hypers.net.b2.var] = ...
	estimatemeanvars(net.b2, priors.net.b2.mean, ...
		       priors.net.b2.var, hypers.net.b2.var, 1);
    [hypers.tnet.b1.mean, hypers.tnet.b1.var] = ...
	estimatemeanvars(net.b1, priors.tnet.b1.mean, ...
		       priors.tnet.b1.var, hypers.tnet.b1.var, 1);
    [hypers.tnet.b2.mean, hypers.tnet.b2.var] = ...
	estimatemeanvars(net.b2, priors.tnet.b2.mean, ...
		       priors.tnet.b2.var, hypers.tnet.b2.var, 1);
    [hypers.src.mean, hypers.src.var] = ...
	estimatemeanvars(params.src, priors.src.mean, ...
		       priors.src.var, hypers.src.var, 1);

  end

  status.kls = [status.kls newkls];

  status.this_run_iters = status.this_run_iters - 1;
end

fs = probdist(zeros(size(data)), ones(size(data)));
tfs = probdist(zeros(size(sources)), ones(size(sources)));

% Do feedforward calculations
x = feedfw(sources, net);
tx = acfeedfw(sources, tnet);

fs = probdist(x{4}.e, x{4}.var);
if (status.freeinitial)
  tfs = probdist([sources.e(:,1) tx{4}.e], ...
		 [zeros(size(sources, 1), 1) tx{4}.var]);
else
  tfs = probdist([zeros(size(sources, 1), 1) tx{4}.e], ...
		 [zeros(size(sources, 1), 1) tx{4}.var]);
end

newkls = kldiv(tfs, fs, sources, data, net, tnet, params, hypers, priors);
fprintf('Finally after %d iterations: %f\n', size(status.kls, 2), newkls)
