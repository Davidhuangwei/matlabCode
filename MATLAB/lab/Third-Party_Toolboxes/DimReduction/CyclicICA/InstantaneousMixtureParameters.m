function [Parameters] = InstantaneousMixtureParameters()

% [Parameters] = InstantaneousMixtureParameters()
%
% This function fill the CMA parameters for
% source extraction of instantaneous mixtures.
%
% Author : Pierre JALLON
% Date of creation : 04/23/2005
% Date of last modification : 04/23/20005
%


ParamStruct = struct(...
    'LFilter'               ,1,...      % Extracting filter length (1 for instantaneous mixture)
    'Seuil'                 ,1e-5,...   % Stop criteria : Difference of two filters norms
    'NbIterationMax'        ,100,...    % Maximal number of algorithm iteration
    'SeuilStopAlgo'         ,1e-2,...   % Stop criteria : for the detection of source signals in the mixture
    'LSubstractFiltreAC'    ,0,...      % Length of anti-causal substracting filter
    'LSubstractFiltreC'     ,0);        % Length of causal substracting filter

Parameters = struct(ParamStruct);

Parameters.LFilter = 1;
Parameters.Seuil = 1e-4;
Parameters.NbIterationMax = 1000;
Parameters.SeuilStopAlgo = 1e-2;
Parameters.Method = 1;
Parameters.LSubstractFiltreAC = 0;
Parameters.LSubstractFiltreC = 0;

