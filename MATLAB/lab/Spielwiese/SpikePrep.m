function [spiket spikeind ClustByEl] = SpikePrep(FileBase)


Par = LoadPar([FileBase '.par']);

%% get spikes
[spiket, spikeind, numclus, spikeph, ClustByEl] = ReadEl4CCG(FileBase,[1:Par.nElecGps]);

return;
