% Nonlinear Dynamic Factor Analysis Matlab package
% version 0.9, 2002-03-25
%
% Copyright (C) 2002 Harri Valpola and Antti Honkela.
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
% >> data = [data with different samples as column vectors];
% >> hidneurons = 30; thidneurons = 30; searchsources = 10;
% >> ndfa_init
% >> status.iters = number_of_iterations;
% >> ndfa_iter
% The results can be found in structures 'sources', 'net' and 'tnet']
%
% For more information see the help texts of 'ndfa_init' and 'ndfa_iter'
