function W = hminu_st(U,V,neig,a,b,W0,pltfun);

% K Spatial PCs in cols of U.
% K Temporal PCs in cols of V.

% K = neig = num cols in U and V.

w0 = W0(:); % pack W0 into vector

% unconstrained minimisation over w
tol = 1e-4;
options(2)=tol;
options(3)=tol;
options = foptions;
options(14) = 200;	% max number of calls to heval
% options(9) = 1;	% check gradient calculation

% CHECK THIS ...
Ss = cov(U); % neigxneig cov matrix 
St = cov(V); % neigxneig cov matrix
jsize(Ss,'Ss');jsize(St,'St');
jsize(a,'a'); jsize(b,'b');
pltfun
w = jfminu('entropy', w0, options, [], U, V, Ss, St, a, b, pltfun);

[nic M] = size(W0);
% 18/4/98 JVS altered nic from K which was wrong.
W = reshape(w, nic, M); % unpack w into matrix

