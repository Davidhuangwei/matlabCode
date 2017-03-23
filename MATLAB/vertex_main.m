% the simulation 
%% Tissue Parameters
TissueParams.X = 2500;
TissueParams.Y = 400;
TissueParams.Z = 200;
TissueParams.neuronDensity = 25000;

TissueParams.numLayers = 1;
TissueParams.layerBoundaryArr = [200, 0];% z-depths. top of the highest layer to the bottom of the lowest one.
TissueParams.numStrips = 10;
% strips...


TissueParams.tissueConductivity = 0.3;
TissueParams.maxZOverlap = [-1 , -1];% hei hei hei.... up --> down

%% Neuron
NeuronParams(1).modelProportion = 1;% only one kind, so take 100%
NeuronParams(1).somaLayer = 1;
NeuronParams(1).neuronModel = 'passive';
NeuronParams(1).neuronModel = 'poisson';
NeuronParams(1).firingRate = 5;
NeuronParams(1).numCompartments = 1;% well.. we should do multicompartment
%----------------example: cortex layer 2/3 pyramidal neuron models (Tomsett et al. 2014)We assume the neurons’ compartmental structure will always be a tree,
NeuronParams(1).numCompartments = 8;
NeuronParams(1).compartmentParentArr = [0, 1, 2, 2, 4, 1, 6, 6];
NeuronParams(1).compartmentLengthArr = [13 48 124 145 137 40 143 143];
NeuronParams(1).compartmentDiameterArr = ...
  [29.8, 3.75, 1.91, 2.81, 2.69, 2.62, 1.69, 1.69];
NeuronParams(1).compartmentXPositionMat = ...
[   0,    0;
    0,    0;
    0,  124;
    0,    0;
    0,    0;
    0,    0;
    0, -139;
    0,  139];
NeuronParams(1).compartmentYPositionMat = ...
[   0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0];
NeuronParams(1).compartmentZPositionMat = ...
[ -13,    0;
    0,   48;
    48,   48;
    48,  193;
    193,  330;
    -13,  -53;
    -53, -139;
    -53, -139];
NeuronParams(1).axisAligned = 'z';

%  neurons’ passive properties:
NeuronParams(1).C = 1.0 * 2.96;
NeuronParams(1).R_M = 20000 / 2.96;
NeuronParams(1).R_A = 150;
NeuronParams(1).E_leak = -70;% mV

NeuronParams(1).basalID = [6, 7, 8];
NeuronParams(1).apicalID = [2 3 4 5];

%% Connection

ConnectionParams(1).numConnectionsToAllFromOne{1} = 2000;% connections to postsynaptic neurons in group 1 (index of the cell array)
ConnectionParams(1).synapseType{1} = 'i_exp';
ConnectionParams(1).tau{1} = 2;
ConnectionParams(1).weights{1} = 10;
ConnectionParams(1).targetCompartments{1} = ...
  [NeuronParams(1).basalID, NeuronParams(1).apicalID];
%  axonal arbour properties.
ConnectionParams(1).axonArborSpatialModel = 'gaussian';
ConnectionParams(1).sliceSynapses = true;
ConnectionParams(1).axonArborRadius = 250;
ConnectionParams(1).axonArborLimit = 500;

ConnectionParams(1).axonConductionSpeed = 0.3;
ConnectionParams(1).synapseReleaseDelay = 0.5;

%% Recording settings multi-electrode array

RecordingSettings.saveDir = '~/VERTEX_results_tutorial_1/';
RecordingSettings.LFP = true;
[meaX, meaY, meaZ] = meshgrid(0:500:2500, 200, 600:-200:0);
% 2.5 mm by 0.7 mm MEA with 208 electrodes, at a constant y-coordinate of
% 0.2 mm, with an inter-electrode spacing of 0.1 mm 
RecordingSettings.meaXpositions = meaX;
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20;% no neuronal compartment can be positioned too close to an electrode tip
RecordingSettings.v_m = 500:500:4500;% to look at differences in membrane potentials across the space of the model

RecordingSettings.maxRecTime = 100;
%  for large MEAs the file sizes and memory usage do not grow too large
RecordingSettings.sampleRate = 1000;

%% General simulation settings
SimulationSettings.simulationTime = 500;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = false;
%  If you want to run a parallel simulation, set parallelSim to true, and
%  provide the Matlab pool size parallel profile to use:

SimulationSettings.poolSize = 4;
SimulationSettings.profileName = 'local';

%% Generate the network
[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);
          
%% Run the simulation

runSimulation(params, connections, electrodes);
% This function will run the dynamics in the simulation according to the
% specified parameters and previously generated network, storing the
% variables that have been specified to record from in the location set in
% RecordingSettings.    
Results = loadResults(RecordingSettings.saveDir);
% Recordings.v_m contains the soma membrane potential of each neuron we
% specified should be recorded from in RecordingSettings 

%% check
figure(1) % To plot all the spikes in a spike raster
plot(Results.spikes(:, 2), Results.spikes(:, 1), 'k.')
axis([0 500 -50 5050])
set(gcf,'color','w');
set(gca,'YDir','reverse');
set(gca,'FontSize',16)
title('Tutorial 1: spike raster', 'FontSize', 16)
xlabel('Time (ms)', 'FontSize', 16)
ylabel('Neuron ID', 'FontSize', 16)

figure(2) % plot the LFP from electrode 3
plot(Results.LFP(3, :), 'LineWidth', 2)
set(gcf,'color','w');
set(gca,'FontSize',16)
title('Tutorial 1: LFP at electrode 3', 'FontSize', 16)
xlabel('Time (ms)', 'FontSize', 16)
ylabel('LFP (mV)', 'FontSize', 16)

figure(3) % plot the membrane potential of neuron 1500 
plot(Results.v_m(3, :), 'LineWidth', 2)
set(gcf,'color','w');
set(gca,'FontSize',16)
title('Tutorial 1: membrane potential for neuron 1500', 'FontSize', 16)
xlabel('Time (ms)', 'FontSize', 16)
ylabel('Membrane potential (mV)', 'FontSize', 16)