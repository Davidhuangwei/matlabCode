function W = hminu(im, K, a, b, pltfun, W0)

% K = neig = num rows in x.

nt = size(im, 2);
x = im';

M = nt; % number of mixtures

if nargin < 6 | isempty(W0) 
	W0 = randn(K, M); % random initial un-mixing
end

w0 = W0(:); % pack W0 into vector

% unconstrained minimisation over w
tol = 1e-6;
options(2)=tol;
options(3)=tol;
options = foptions;
options(14) = 2000;	% max number of calls to heval
% options(9) = 1;	% check gradient calculation

S = cov(x');
w = jfminu('heval', w0, options, 'hgrad', x, S, a, b, pltfun);

nic = size(W0,1);
% 18/4/98 JVS altered nic from K which was wrong.
W = reshape(w, nic, M); % unpack w into matrix
