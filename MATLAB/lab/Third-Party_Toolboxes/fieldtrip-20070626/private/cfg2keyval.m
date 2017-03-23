function [optarg] = cfg2keyval(cfg);

% CFG2KEYVAL converts between a structure and a cell-array with key-value
% pairs which can be used for optional input arguments.
%
% Use as
%   [optarg] = cfg2keyval(cfg)

optarg = [fieldnames(cfg) struct2cell(cfg)]';
optarg = optarg(:)';
