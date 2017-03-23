function g = rbfderiv(net, x)
%RBFDERIV Evaluate derivatives of network outputs with respect to weights.
%
%	Description
%	G = RBFDERIV(NET, X) takes a network data structure NET and a matrix
%	of input vectors X and returns a three-index matrix G whose I, J, K
%	element contains the derivative of network output K with respect to
%	weight or bias parameter J for input pattern I. The ordering of the
%	weight and bias parameters is defined by RBFUNPAK.
%
%	See also
%	RBF, RBFPAK, RBFGRAD, RBFBKP
%

%	Copyright (c) Ian T Nabney (1996-9)

% Check arguments for consistency
errstring = consist(net, 'rbf', x);
if ~isempty(errstring);
  error(errstring);
end

if ~strcmp(net.outfn, 'linear')
  error('Function only implemented for linear outputs')
end

[y, z, n2] = rbffwd(net, x);
ndata = size(x, 1);

g = zeros(ndata, net.nwts, net.nout);
for k = 1 : net.nout
  delta = zeros(1, net.nout);
  delta(1, k) = 1;
  for n = 1 : ndata
    g(n, :, k) = rbfbkp(net, x(n, :), z(n, :), n2(n, :),...
      delta);
  end
end
 