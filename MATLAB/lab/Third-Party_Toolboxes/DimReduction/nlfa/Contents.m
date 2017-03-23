% Nonlinear Factor Analysis Matlab package
% version 0.9.4, 2001-11-01
%
% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.
%
% For usage examples, see the modules found at
%   http://www.cis.hut.fi/projects/ica/bayes/ .
%
%
% Basic usage:
%
% data = [data with different samples as column vectors];
% nlfa_init
% status.iters = number_of_iterations;
% nlfa_iter
% [the results can be found in structures 'sources' and 'net']
%
% For more information see the help texts of 'nlfa_init' and 'nlfa_iter'
