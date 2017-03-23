% NLFA_ITER  script to do the actual iteration
%
%    For initialization needed, see NLFA_INIT
%
%    Returned values (variables):
%      sources		Estimate for the sources (probdist)
%      foundsources	Estimate for the sources (double)
%      net		Estimate for the network (probdist)
%      status.kls	Kullback-Leibler divergences for each iteration
%      params		Estimated "prior" variances for different variables
%      hypers		Estimated values for hyperparameters of the model
%      founddata	Data reconstructed from the sources (probdist)

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if status.this_run_iters == 0
  status.this_run_iters = status.iters;
end

nsampl = size(data, 2);

nlfa_batches = 1:status.batch_size:nsampl;

nlfa_batch = [nlfa_batches', [nlfa_batches(2:end)-1, nsampl]'];

while status.this_run_iters > 0

  dcp_dnetm = netgrad_zeros(net);
  dcp_dnetv = netgrad_zeros(net);
  fs = probdist(zeros(size(data)), ones(size(data)));

  newkls = kl_static(net, params, hypers, priors);

  for k = 1:size(nlfa_batch, 1),
    curbatch = nlfa_batch(k,1):nlfa_batch(k,2);

    % Do feedforward calculations
    x = feedfw( sources(:, curbatch) , net);
    fs(:, curbatch) = probdist(x{4}.e, x{4}.var);

    % Calculate and possibly display current value of the cost function
    newkls = newkls + kl_batch(fs(:, curbatch), sources(:, curbatch), ...
			       data(:, curbatch), params);
    
    if k == size(nlfa_batch, 1)
      fprintf('Iteration #%d: %f\n', size(status.kls, 2), newkls)
      status.kls = [status.kls newkls];
    end

    % Calculate partial derivatives for parameters to adapt
    [dcp_dsm, dcp_dsv, newdcp_dnetm, newdcp_dnetv] =...
	feedback(x, net, sources(:, curbatch), data(:, curbatch), ...
		 params.noise);

    [newdcp_dsm, newdcp_dsv] = ...
	feedback_srcpriors(sources(:, curbatch), params.src);

    dcp_dsm = dcp_dsm + newdcp_dsm;
    dcp_dsv = dcp_dsv + newdcp_dsv;

    dcp_dnetm = sum_structs(dcp_dnetm, newdcp_dnetm);
    dcp_dnetv = sum_structs(dcp_dnetv, newdcp_dnetv);

    % Get new values for sources and alphas if appropriate
    if max([status.updatesrcs, status.updatesrcvars]) >= 0
      newsources = ...
	  updatesources(sources(:, curbatch), dcp_dsm, dcp_dsv, x{4}, ...
			params.src, params.noise);

      if status.updatesrcs < 0
	sources(:, curbatch) = ...
	    probdist_alpha(sources.e(:, curbatch), newsources.var, ...
			   sources.malpha(:, curbatch), newsources.valpha, ...
			   sources.msign(:, curbatch), newsources.vsign);
      else
	sources(:, curbatch) = newsources;
      end
    end
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

  % Update the network and alphas if appropriate  
  if status.updatenet < 0
    status.updatenet = status.updatenet + 1;
  else
    net = updatenetwork(net, dcp_dnetm, dcp_dnetv);
  end

  % Update estimates for different parameters if appropriate
  if status.updateparams < 0
    status.updateparams = status.updateparams + 1;
  else
    params.noise = estimatevars(fs-data, hypers.noise, params.noise);
    params.src   = estimatevars(sources, hypers.src, params.src);
    params.net.w2var = estimatevars(net.w2, hypers.net.w2var, ...
				    params.net.w2var, 1);
    
    [hypers.net.w2var.mean, hypers.net.w2var.var] = ...
	estimatemeanvars(params.net.w2var, priors.net.w2var.mean, ...
		       priors.net.w2var.var, hypers.net.w2var.var);
    [hypers.noise.mean, hypers.noise.var] = ...
	estimatemeanvars(params.noise, priors.noise.mean, ...
		       priors.noise.var, hypers.noise.var, 1);
    [hypers.net.b1.mean, hypers.net.b1.var] = ...
	estimatemeanvars(net.b1, priors.net.b1.mean, ...
		       priors.net.b1.var, hypers.net.b1.var, 1);
    [hypers.net.b2.mean, hypers.net.b2.var] = ...
	estimatemeanvars(net.b2, priors.net.b2.mean, ...
		       priors.net.b2.var, hypers.net.b2.var, 1);
    [hypers.src.mean, hypers.src.var] = ...
	estimatemeanvars(params.src, priors.src.mean, ...
		       priors.src.var, hypers.src.var, 1);

  end

  foundsources = sources.e;
  status.this_run_iters = status.this_run_iters - 1;
end

fs = probdist(zeros(size(data)), ones(size(data)));

newkls = kl_static(net, params, hypers, priors);

for k = 1:size(nlfa_batch, 1),
  curbatch = nlfa_batch(k,1):nlfa_batch(k,2);

  % Do feedforward calculations
  x = feedfw( sources(:, curbatch) , net);
  fs(:, curbatch) = probdist(x{4}.e, x{4}.var);

  newkls = newkls + kl_batch(fs(:, curbatch), sources(:, curbatch), ...
			     data(:, curbatch), params);
end

founddata = fs;
fprintf('Finally after %d iterations: %f\n', size(status.kls, 2), newkls)
