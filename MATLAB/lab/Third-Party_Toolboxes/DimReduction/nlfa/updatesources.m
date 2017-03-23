function news = updatesources(s, dcp_dsm, dcp_dsv, outputs, ...
			      srcparam, noiseparam)
% UPDATESOURCES Update sources according to the back propagation rule

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

nsampl = size(s, 2);

minalpha = 1e-100;

bpnewv = .5 ./ dcp_dsv;
bpstep = -dcp_dsm .* bpnewv;
temp = outputs.multivar;
[d1 d2 d3] = size(temp);
temp = temp ./ repmat(sqrt(normalvar(noiseparam)), [1 d2 d3]);
temp2 = (reshape(sum(temp .^ 2, 1), [d2 d3]) + ...
    repmat(1./normalvar(srcparam), [1 d3])) .* bpstep + 1e-200;
%for i = 1:nsampl
%  w = temp(:,:,i);
%  dalpha(:,i) = (w' * w * bpstep(:,i)) ./ temp2(:,i);
%end
dalpha = (reshape(sum(repmat(sum(temp .* repmat(reshape(bpstep, [1 d2 d3]), ...
    [d1 1 1]), 2), [1 d2 1]) .* temp, 1), [d2 d3]) + bpstep ./ ...
    repmat(normalvar(srcparam), [1 d3])) ./ temp2;

dalpha = dalpha .* (dalpha >= .5) + .5 * (dalpha < .5);


malpha = s.malpha .* (.8 + .25 * (sign(bpstep) == s.msign));
malpha = cut(malpha, 1, minalpha);
msign = sign(bpstep);

valpha = s.valpha .* (.8 + .25 * ((bpnewv>s.var) == s.vsign));
valpha = cut(valpha, 1, minalpha);
vsign = bpnewv>s.var;

bpnewv = (bpnewv .^ valpha) .* (s.var .^ (1 - valpha));

news = probdist_alpha(s.e + bpstep ./ dalpha .* malpha, bpnewv, ...
		      malpha, valpha, msign, vsign);
