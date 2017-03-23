function [dc_dsm, dc_dsv, dc_dnetm, dc_dnetv, dx] =...
    feedbackac(x, net, sources, data, noiseparam)

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

noisevar = normalvar(noiseparam);

[datadim, nsampl] = size(data);
nsources = size(sources, 1);

datavars = noisevar * ones(1, nsampl);

dx{4}.var = .5 ./ datavars;
dx{4}.e = (x{4}.e - data) ./ datavars;
dx{4}.extra = dx{4}.var;
dx{4}.multi = repmat(shiftdim(sources.var, -1), [datadim 1 1])...
    .* repmat(reshape(dx{4}.var, [datadim 1 nsampl]), [1 nsources 1])...
    .* (2 * x{4}.multivar);

multivar = zeros(size(sources));

% The first layer (linear)
temp = x{4}.multivar.^2;

% Somewhat more efficient way to calculate
%   multivar(:,i) = temp(:,:,i)' * multivar(:,i);
for i=1:nsources
  multivar(i,:) = sum(reshape(temp(:,i,:), size(dx{4}.var)) .* dx{4}.var, 1);
end

dx{3}.var = net.w2.var' * dx{4}.extra;
dx{3}.e = net.w2.e' * dx{4}.e + (2*net.w2.var' * dx{4}.extra) .* x{3}.e;
dx{3}.extra = net.w2.e' .^2 * dx{4}.extra;

%dx{3}.multi = zeros(size(x{3}.multivar));
%  dx{3}.multi(:,:,i) = net.w2.e' * dx{4}.multi(:,:,i);

d0 = size(net.w2, 2);
[d1 d2 d3] = size(dx{4}.multi);
dx{3}.multi = ...
    reshape(net.w2.e' * reshape(dx{4}.multi, [d1 d2*d3]), [d0 d2 d3]);


[dc_dnetm.w2, dc_dnetv.w2, dc_dnetm.b2, dc_dnetv.b2] = ...
    netgrads(x{3}, dx{4}, net.w2, net.b2);

% The second layer (nonlinear)

%der1 = dasinh(x{2}.e);
%der2 = ddasinh(x{2}.e);
%der3 = dddasinh(x{2}.e);
%[der1, der2, der3] = dasinh(x{2}.e);
[der1, der2, der3] = feval(['d' net.nonlin], x{2}.e);

temp = .5 * der2 .* dx{3}.e;

dx{2}.var = temp .* (temp > 0) + (der1 .^ 2) .* dx{3}.var;

dx{2}.e = dx{3}.e .* (der1 + .5*x{2}.var .* der3 .* (temp > 0)) + ...
          2 * dx{3}.var .* x{2}.var .* der2 .* der1 + ...
	  2 * dx{3}.extra .* x{2}.extravar .* der2 .* der1 + ...
	  reshape(sum(dx{3}.multi .* x{2}.multivar, 2), size(der2)) .* der2;
dx{2}.extra = (der1 .^ 2) .* dx{3}.extra;

dx{2}.multi = repmat(reshape(der1, [size(x{2}.e, 1) 1 nsampl]),...
		     [1 nsources 1]) .* dx{3}.multi;

dx{1}.e = net.w1.e' * dx{2}.e + ...
    (2 * net.w1.var' * (dx{2}.var + dx{2}.extra)) .* x{1}.e;
dx{1}.var = (net.w1.e'.^2 + net.w1.var') * dx{2}.var + ...
    net.w1.var' * dx{2}.extra;


[dc_dnetm.w1, dc_dnetv.w1, dc_dnetm.b1, dc_dnetv.b1] = ...
    netgradstop(x{1}, dx{2}, net.w1, net.b1);

dc_dsm = dx{1}.e + dx{4}.e;
dc_dsv = dx{1}.var + multivar;
