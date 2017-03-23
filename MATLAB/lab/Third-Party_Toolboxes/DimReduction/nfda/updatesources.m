function news = updatesources(s, dcp_dsm, dcp_dsvn, ojaco, pjaco, ...
                              srcparam, noiseparam, newac)
% UPDATESOURCES Update sources according to the back propagation rule

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

nsampl = size(s, 2);

minalpha = 1e-100;

% Jacobian matrices of observation and prediction mappings

[d1 d2 d3] = size(ojaco);
ojaco = ojaco ./ repmat(sqrt(normalvar(noiseparam)), [1 d2 d3]);
pjaco = pjaco ./ repmat(sqrt(normalvar(srcparam)), [1 d2 d3-1]);

% Compute the stepsize assuming that each variable is the only one to change

bpnewvn = .5 ./ dcp_dsvn;

%diagonal elements of the Hessian
hes = reshape(sum(ojaco .^ 2, 1), [d2 d3]) + ...
    [reshape(sum(pjaco .^ 2, 1), [d2 d3-1]) zeros(d2,1)] + ...
    repmat(1./normalvar(srcparam), [1 d3]);
bpstep = -dcp_dsm ./ hes / 2;

% Correction to stepsize (each variable is not the only one to change)

% Expected stepsize assuming the variable is the only one to change

expstep = hes .* bpstep + 1e-200;

% Actual stepsize

fstep = sum(ojaco .* repmat(reshape(bpstep, [1 d2 d3]), [d1 1 1]), 2);
sstep = -reshape(bpstep ./ repmat(sqrt(normalvar(srcparam)), [1 d3]), ...
    [d2 1 d3]);
sstep(:,:,2:end) = sstep(:,:,2:end) + sum(pjaco .* ...
    repmat(reshape(bpstep(:,1:end-1), [1 d2 d3-1]), [d2 1 1]), 2);

truestep = reshape(sum(repmat(fstep, [1 d2 1]) .* ojaco, 1), [d2 d3]) - ...
    reshape(sstep, [d2 d3]) ./ repmat(sqrt(normalvar(srcparam)), [1 d3]);
truestep(:,1:end-1) = truestep(:,1:end-1) + ...
    reshape(sum(repmat(sstep(:,:,1:end-1), [1 d2 1]) .* pjaco, 1), [d2 d3-1]);

% dalpha tells how much too large the stepsize is

dalpha = truestep ./ expstep;
dalpha = dalpha .* (dalpha >= .5) + .5 * (dalpha < .5);

malpha = s.malpha .* (.8 + .25 * (sign(bpstep) == s.msign));
malpha = cut(malpha, 1, minalpha);
msign = sign(bpstep);

valpha = s.valpha .* (.8 + .25 * ((bpnewvn>s.nvar) == s.vsign));
valpha = cut(valpha, 1, minalpha);
vsign = bpnewvn>s.nvar;

bpnewvn = (bpnewvn .^ valpha) .* (s.nvar .^ (1 - valpha));

news = acprobdist_alpha(s.e + bpstep ./ dalpha .* malpha, bpnewvn, ...
                        malpha, valpha, msign, vsign);
