function [Parameters] = GenerateParamaters()

% [Param] = GenerateParamaters()
%
% This function is helpful to fill the parameters of the deflation algorithm 
%
% Author : Pierre JALLON
% Date of creation : 04/22/2005
% Date of last modification : 04/22/20005
%


ParamStruct = struct(...
    'LFilter'               ,1,...      % Extracting filter length (1 for instantaneous mixture)
    'Seuil'                 ,1e-3,...   % Stop criteria : Difference of two filters norms
    'NbIterationMax'        ,100,...    % Maximal number of algorithm iteration
    'SeuilStopAlgo'         ,1e-2,...   % Stop criteria : Difference of two filters norms
    'LSubstractFiltreAC'    ,0,...      % Length of anti-causal substracting filter
    'LSubstractFiltreC'     ,0);        % Length of causal substracting filter

Parameters = struct(ParamStruct);


%%%%%
% Extracting filter length
answer = input('Extracting filter length : \n- 1 for instantaneous mixture\n- 15 for convolutive mixture\nPlease enter a value : [1]');
if (length(answer)==0)
    Parameters.LFilter = 1;
else
    Parameters.LFilter = double(answer);
end

%%%%%
% LSubstractFiltreAC
answer = input('\nAnti-causal part of substracting filter length : \n- 0 for instantaneous mixture\n- 80 for convolutive mixture\nPlease enter a value : [0]');
if (length(answer)==0)
    Parameters.LSubstractFiltreAC = 0;
else
    Parameters.LSubstractFiltreAC = double(answer);
end

%%%%%
% LSubstractFiltreC
answer = input('\nCausal part of substracting filter length : \n- 0 for instantaneous mixture\n- 20 for convolutive mixture\nPlease enter a value : [0]');
if (length(answer)==0)
    Parameters.LSubstractFiltreC = 0;
else
    Parameters.LSubstractFiltreC = double(answer);
end


%%%%%
% Stop criteria
answer = input('\nStop criteria : \nDifference between the norm of one computed filter and the following one\nPlease enter a value [1e-3]','s');
if (length(answer)==0)
    Parameters.Seuil = 1e-3;
else
    Parameters.Seuil = str2double(answer);
    if (isnan(Parameters.Seuil))
        Parameters.Seuil = 1e-3;
    end
end

%%%%%
% Maximal number of iteration
answer = input('\nMaximal number of iteration: \n- 300 for instantaneous mixture\n- 1000 for convolutive mixture\nPlease enter a value : [300]','s');
if (length(answer)==0)
    Parameters.NbIterationMax = 300;
else
    Parameters.NbIterationMax = str2double(answer);
    if (isnan(Parameters.NbIterationMax))
        Parameters.NbIterationMax = 300;
    end
end


%%%%%
% Algorithm end
answer = input('\nCriteria to stop the algorithm (remaining mixture power divided by its initial value) \nPlease enter a value [1e-2]','s');
if (length(answer)==0)
    Parameters.SeuilStopAlgo = 1e-2;
else
    Parameters.SeuilStopAlgo = str2double(answer);
    if (isnan(Parameters.SeuilStopAlgo))
        Parameters.SeuilStopAlgo = 1e-2;
    end
end

