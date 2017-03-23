function [spiketorig, spikeind, spikepos, numclus, spikeph, ClustByEl] = SpikeAll(FileBase,whl,varargin)
[rateWhl] = DefaultArgs(varargin,{39.0625});
%%
%% function [spiketorig, spikeind, spikepos, numclus, spikeph, ClustByEl] = SpikePos(FileBase,whl,varargin)
%% [cutoffR,rateWhl] = DefaultArgs(varargin,{0,39.0625});
%% 
%% Get positions of spikes.
%% whl is nx2

RateFactor = 20000/rateWhl;

%% get parameter file
Par = LoadPar([FileBase '.par']);

%keyboard

%% get spikes
[xspiket, xspikeind, numclus, spikeph, ClustByEl] = ReadEl4CCG(FileBase,[1:Par.nElecGps]);

%% conv. spike time to whl rate
spike = round(xspiket/RateFactor); 

%% spikes times within ranges of whl-file
goodsp = find(spike<length(whl)& spike>0); 

%% build position matrix, same length as xspike*
xspikepos = -ones(length(spike),2);
xspikepos(goodsp,:) = whl(spike(goodsp),:);

%% 
spiket = spike;
spikeind = xspikeind;
spikepos = xspikepos;

%% spiketime in original sampling rate;
spiketorig = xspiket;

return;


