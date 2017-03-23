function [W, beta, llhLog] = gtm_trn(T, FI, W, l, cycles, beta, m, q)
% Optimize (train) the parameters of a GTM model, using an EM algorithm.
%
% Synopsis:	[W, beta, llhLog] = gtm_trn(T, FI, W, l, cycles, beta, m, q)
%		[W, beta] = gtm_trn(T, FI, W, l, cycles, beta)
%
% Arguments:	T  -	matrix containing a sample of the distribution 
%			to be modeled; N-by-D
%
%		FI -	matrix containing the output values from
%			the basis functions, when fed the latent
%			variable sample; K-by-(M+1)
%
%		W -	an initial weight matrix; (M+1)-by-D
%
%		l -	weight regularisation factor
%
%		cycles - no of training cycles
%
%		beta -	an initial value for beta, the inverse variance of 
%			the Gaussian mixture generated in the data space
%
%		m - 	mode of calculation; it can be set to 0, 1 or 2 
%			corresponding to increasingly elaborate 
%			measure taken to reduce the amount of
%			numerical errors; mode = 0 will be fast but 
%			less accurate, mode = 2 will be slow but 
%			more accurate; the default mode is 1 
%
%		q -	quiet execution; if q equals the string 'quiet',
%			the plotting and echoing of the values of log- 
%			likelihood and beta during traaining is supressed. 
%			This argument is optional; if omitted the training 
%			is run non-quiet.
%
% Return:	W, beta -	the corresponding weight matrix and
%				inverse variance after training
%
%		llhLog -	the log-likelihood after each cycle of
%				training; optional output argument
%				

% Version:	The GTM Toolbox v1.0 beta
%
% Copyright:	The GTM Toolbox is distributed under the GNU General Public 
%		Licence (version 2 or later); please refer to the file 
%		licence.txt, included with the GTM Toolbox, for details.
%
%		(C) Copyright Markus Svensen, 1996

% sort out optional input arguments
if (nargin == 6)
  quiet = 0;
  mode = 1;
elseif (nargin == 7)
  if (isstr(m))
    if (strcmp(m, 'quiet'))
      quiet = 1;
      mode = 1;
    else
      error(['Value of argument q is invalid: ', q]);
    end
  else
    mode = m;
    quiet = 0;
  end
elseif (nargin == 8)
  if (isstr(m))
    error(['Value of argument m is invalid: ', m]);
  else
    mode = m;
  end
  if (strcmp(q, 'quiet'))
    quiet = 1;
  else
    error(['Value of argument q is invalid: ', q]);
  end
else
  error('Wrong number of input arguments!');
end

if (nargout > 2)
  llhLog = zeros(cycles,1);
end

% Calculate various quantities that remain constant during training
FI_T = FI';
[K,Mplus1] = size(FI);

[N, D] = size(T);
ND = N*D;

% Declare global variables
global gtmGlobalDIST;
global gtmGlobalR;

if (mode > 0)
  global gtmGlobalMinDist;
  global gtmGlobalMaxDist;
end

% Pre-allocate matrices
gtmGlobalDIST = zeros(K, N);
gtmGlobalR = zeros(K, N);
if (mode > 0)
  gtmGlobalMinDist = zeros(1, N);
  gtmGlobalMaxDist = zeros(1, N);
end
A = zeros(Mplus1, Mplus1);
cholDcmp = zeros(Mplus1, Mplus1);

% Use a sparse representation for the weight reguarizing matrix.
if (l > 0)
  LAMBDA = l*speye(Mplus1);
  LAMBDA(Mplus1, Mplus1) = 0;
end  

% Calculate initial distances
gtm_dstg(T, FI*W, mode); 
	% accesses the global variable gtmGlobalDIST

% "Training" loop
for cycle = 1:cycles

  % Calculate responsabilities
  llh = gtm_rspg(beta, D, mode); 
	% accesses the global variable gtmGlobalDIST and gtmGlobalR

  % Plotting and printing of diagnostic info
  if (~quiet)
    if cycle == 1
      hold off;
      plot(cycle,llh,'x');
      xlabel('Training cycle');
      ylabel('log-likelihood');
      drawnow;
      hold on;
    else
      plot(cycle,llh,'x');
      drawnow;
    end
    fprintf('Cycle: %g\tlogLH: %g\tBeta: %g\n', cycle, llh, beta);
  end

  if (nargout > 2)
    llhLog(cycle) = llh;
  end
  

  % Calculate matrix be inverted (FI'*G*FI + lambda*I in the papers).
  % Sparse representation of G normally executes faster and saves
  % memory
  if (l > 0)
    A = full(FI_T*spdiags(sum(gtmGlobalR')', 0, K, K)*FI + (LAMBDA./beta));
  else
    A = full(FI_T*spdiags(sum(gtmGlobalR')', 0, K, K)*FI);
  end

  % A is a symmetric matrix likely to be positive definite, so try
  % fast Cholesky decomposition to calculate W, otherwise use SVD.
  % (FI_T*(gtmGlobalR*T)) is computed rigth-to-left, as gtmGlobalR
  % and T are normally (much) larger than FI_T.
  [cholDcmp singular] = chol(A);
  if (singular)
    if(~quiet)
      fprintf('gtm_trn: Warning -- M-Step matrix singular, using pinv.\n');
    end
    W = pinv(A)*(FI_T*(gtmGlobalR*T));
  else
    W = cholDcmp \ (cholDcmp' \ (FI_T*(gtmGlobalR*T)));
  end

  % Calculate new distances
  gtm_dstg(T, FI*W, mode);
	% accesses the global variable gtmGlobalDIST

  % Calculate new value for beta
  beta = ND / sum(sum(gtmGlobalDIST.*gtmGlobalR));

end

if (~quiet)
  hold off;
end

% clearing (possibly) non-existent variables is harmless
clear global gtmGlobalDIST gtmGlobalR gtmGlobalMinDist gtmGlobalMaxDist;











