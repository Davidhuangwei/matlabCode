function  [spikeph eegph] = GetSpikePhase(eeg,spiket,varargin);
%function  [spikeph eegph] = GetSpikePhase(FileBase,spiket);
%
%% IN: eeg and spike times (same sampling rate!!) 
%% OUT: spike phases
[SamplRate,freq] = DefaultArgs(varargin,{1250,[4 10]});

[Phase.deg Phase.amp] = myThetaPhase(eeg,freq,4,20,SamplRate);

spikeph = mod(Phase.deg(spiket),2*pi); %%% 0 is PEAK of theta!!
eegph = Phase.deg;


%% unwraped phase
%UThPhase = unwrap(ThPhase.deg);
%spikeuph = UThPhase(round(spiket/16)); 
%spikeuph=[];

return;