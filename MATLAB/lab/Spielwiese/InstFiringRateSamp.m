function [Rate t] = InstFiringRateSamp(FileBase,Res,tx,varargin)
[SampRate,Smoother] = DefaultArgs(varargin,{1,10});

%% computes the instantaneous firing rate of neuron with spikes Res
%% Res: spiket(find(spikeind==i)); Sampling rate of Res and tx is 20kHz 
%% SampRate: sampling rate of Rate
%% time bins in Res sampling size
%% 

%if isempty(tx)
%  Par= LoadPar([FileBase '.par']);
%  nt=FileLength([FileBase '.eeg'])/Par.nChannels/2;
%  tx=[1:nt];
%  SampRate = 1250;
%else
%  if isempty(SampRate)
%    error('No sampling rate given!');
%  end
%end
  
%keyboard

%% turn spikes into continuous instantaneous firing rate
[hspike] = histcI(Res,tx);
hspike = hspike/SampRate;
fhspike = mySmooth(hspike,Smoother);

%% use for analysis histogram or smoothed histgaram
Rate = fhspike;

t=tx(1:end-1)+(tx(2)-tx(1))/2;

return;
