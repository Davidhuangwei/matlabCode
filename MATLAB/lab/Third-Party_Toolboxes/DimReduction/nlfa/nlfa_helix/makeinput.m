function c = makeinput(a)
% MAKEINPUT generate random numbers from given Gaussian distribution
%
%   Usage:
%     c = makeinput(A)
%     generates random number from Gaussian distribution A (probdist)

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.

b = randn(size(a));
c = b .* sqrt(a.var) + a.e;
