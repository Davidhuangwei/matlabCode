function net = updatenetwork(net, dcp_dnetm, dcp_dnetv)
% UPDATENETWORK Update network weights according to the back propagation rule.

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

minalpha = 1e-100;


w2vnew = .5 ./ dcp_dnetv.w2;
w2estep = -w2vnew .* dcp_dnetm.w2;
w1vnew = .5 ./ dcp_dnetv.w1;
w1estep = -w1vnew .* dcp_dnetm.w1;
b2vnew = .5 ./ dcp_dnetv.b2;
b2estep = -b2vnew .* dcp_dnetm.b2;
b1vnew = .5 ./ dcp_dnetv.b1;
b1estep = -b1vnew .* dcp_dnetm.b1;

w2malpha = net.w2.malpha .* (.8 + .25 * (sign(w2estep) == net.w2.msign));
w1malpha = net.w1.malpha .* (.8 + .25 * (sign(w1estep) == net.w1.msign));
b2malpha = net.b2.malpha .* (.8 + .25 * (sign(b2estep) == net.b2.msign));
b1malpha = net.b1.malpha .* (.8 + .25 * (sign(b1estep) == net.b1.msign));

w2valpha = net.w2.valpha .* ...
    (.8 + .25 * ((w2vnew>net.w2.var) == net.w2.vsign));
w1valpha = net.w1.valpha .* ...
    (.8 + .25 * ((w1vnew>net.w1.var) == net.w1.vsign));
b2valpha = net.b2.valpha .* ...
    (.8 + .25 * ((b2vnew>net.b2.var) == net.b2.vsign));
b1valpha = net.b1.valpha .* ...
    (.8 + .25 * ((b1vnew>net.b1.var) == net.b1.vsign));

w2malpha = cut(w2malpha, 1, minalpha);
w1malpha = cut(w1malpha, 1, minalpha);
b2malpha = cut(b2malpha, 1, minalpha);
b1malpha = cut(b1malpha, 1, minalpha);
w2valpha = cut(w2valpha, 1, minalpha);
w1valpha = cut(w1valpha, 1, minalpha);
b2valpha = cut(b2valpha, 1, minalpha);
b1valpha = cut(b1valpha, 1, minalpha);

w2msign = sign(w2estep);
w1msign = sign(w1estep);
b2msign = sign(b2estep);
b1msign = sign(b1estep);
w2vsign = w2vnew>net.w2.var;
w1vsign = w1vnew>net.w1.var;
b2vsign = b2vnew>net.b2.var;
b1vsign = b1vnew>net.b1.var;

w2estep = w2malpha .* w2estep;
w1estep = w1malpha .* w1estep;
b2estep = b2malpha .* b2estep;
b1estep = b1malpha .* b1estep;
  
w2vnew = (w2vnew .^ w2valpha) .* (net.w2.var .^ (1 - w2valpha));
w1vnew = (w1vnew .^ w1valpha) .* (net.w1.var .^ (1 - w1valpha));
b2vnew = (b2vnew .^ b2valpha) .* (net.b2.var .^ (1 - b2valpha));
b1vnew = (b1vnew .^ b1valpha) .* (net.b1.var .^ (1 - b1valpha));

net.w2 = probdist_alpha(net.w2.e + w2estep, w2vnew, ...
			w2malpha, w2valpha, w2msign, w2vsign);
net.w1 = probdist_alpha(net.w1.e + w1estep, w1vnew, ...
			w1malpha, w1valpha, w1msign, w1vsign);
net.b2 = probdist_alpha(net.b2.e + b2estep, b2vnew, ...
			b2malpha, b2valpha, b2msign, b2vsign);
net.b1 = probdist_alpha(net.b1.e + b1estep, b1vnew, ...
			b1malpha, b1valpha, b1msign, b1vsign);
