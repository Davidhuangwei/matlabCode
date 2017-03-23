function [ThPhHist,BinCtr] = ThetaPhaseHist(spiket,spikeind,spikeph,varargin)
[allcells,overwrite,bin] = DefaultArgs(varargin,{length(unique(spikeind)),0,[0:10:360]});
%% computes prefered theta phase
%% 
%% INPUT:
%%   spiket:     spike times  
%%   spikeind:   spike number  
%%   spikeph:    spike phase  
%% 
%% OUTPUT:
%%   ThPhHist

BinCtr = bin(2:end)-unique(diff(bin))/2;
for n=1:length(allcells)
  indx = find(spikeind==allcells(n));
  
  %% hist
  if ~isempty(spikeph(indx)*180/pi)
    ThPhHist(n,:) = histcI(spikeph(indx)*180/pi,bin);
  else
    ThPhHist(n,:) = zeros(1,length([0:10:360])-1);
  end
  
end

return;
