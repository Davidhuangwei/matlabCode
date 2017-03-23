function [spiketorig, spikeind, spikepos, numclus, spikeph, ClustByEl] = SpikePos(FileBase,whl,varargin)
[rateWhl,AllSpikes,SpikeRate,onlygoodspikes] = DefaultArgs(varargin,{39.0625,0,20000,1});
%%
%% function [spiketorig, spikeind, spikepos, numclus, spikeph, ClustByEl] = SpikePos(FileBase,whl,varargin)
%% [cutoffR,rateWhl] = DefaultArgs(varargin,{0,39.0625});
%% 
%% Get positions of spikes.
%% whl is nx2

RateFactor = SpikeRate/rateWhl;

%% get parameter file
Par = LoadPar([FileBase '.par']);

info = FileInfo(FileBase);
RateFactor = Par.SampleRate/info.WhlRate;

%keyboard

%% get spikes
[xspiket, xspikeind, numclus, spikeph, ClustByEl] = ReadEl4CCG(FileBase,[1:Par.nElecGps]);

if ~isempty(whl)
  
  %% conv. spike time to whl rate
  spike = round(xspiket/RateFactor);
  
  %% spikes times within ranges of whl-file
  goodsp = find(spike<length(whl)& spike>0);
  
  %% build position matrix, same length as xspike*
  xspikepos = -ones(length(spike),2);
  xspikepos(goodsp,:) = whl(spike(goodsp),:);
  
  %% index of all spikes with existing position (>-1)
  if AllSpikes
    spindex = [1:length(xspiket)];
  else
    spindex = find(xspikepos(:,1)>0);
  end

  if onlygoodspikes
    %% only good spikes
    spiket = spike(spindex);
    spikeind = xspikeind(spindex);
    %spikeph = spikeph(spindex);
    spikepos = xspikepos(spindex,:);
    
    %% good spiketime in original sampling rate;
    spiketorig = xspiket(spindex);
  else
    %% all spikes
    spiket = spike;
    spikeind = xspikeind;
    %spikeph = spikeph;
    spikepos = xspikepos;
    
    %% good spiketime in original sampling rate;
    spiketorig = xspiket;
  end
    
else
  spiketorig = xspiket;
  spikeind = xspikeind;
  spikepos = [];
end
  
return;


