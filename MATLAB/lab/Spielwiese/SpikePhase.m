function  [spikeph spikeuph] = SpikePhase(FileBase,spiket,varargin);
%function  [spikeph spikeuph] = SpikePhase(FileBase,spiket,varargin);
%
[SampleRate,EegRate,overwrite] = DefaultArgs(varargin,{20000,1250,0});

RateFactor = SampleRate/EegRate;

ThPhase = InternThetaPh(FileBase,overwrite);

spikeph = mod(ThPhase.deg(round(spiket/RateFactor)),2*pi); %%% 0 is PEAK of theta!!

%% unwraped phase
%UThPhase = unwrap(ThPhase.deg);
%spikeuph = UThPhase(round(spiket/16)); 
spikeuph=[];

return;