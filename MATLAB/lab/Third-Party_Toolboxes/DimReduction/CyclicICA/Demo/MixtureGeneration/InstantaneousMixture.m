function [Parameters] = InstantaneousMixture()


% InstantaneousMixture:
%
% Author : Pierre JALLON
% Date of creation : 04/23/2005
% Date of last modification : 04/23/20005
%


ParamStruct = struct(...
    'NbSrc'                 ,3,...      % Number of source signals
    'NbCpt'                 ,5,...      % Number of sensors
    'NbTrajet'              ,3);        % Number of propagation channel path (1 for instantaneous mixture).

Parameters = struct(ParamStruct);

Parameters.NbSrc = 1;
Parameters.NbCpt = 1;
Parameters.NbTrajet = 1;

