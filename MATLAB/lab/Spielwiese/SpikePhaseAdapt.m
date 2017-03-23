function  [spikeph spikeuph] = SpikePhaseAdapt(FileBase,spiket,varargin);
%function  [spikeph spikeuph] = SpikePhaseAdapt(FileBase,spiket,varargin);
%
[SampleRate,EegRate,overwrite] = DefaultArgs(varargin,{20000,1250,0});

RateFactor = SampleRate/EegRate;

if ~FileExists([FileBase '.elc'])
  elc = InternElc(FileBase);
  %%error('no channel for theta phase detection is specified.');
else
  load([FileBase '.elc'],'-MAT');
end

if ~FileExists([FileBase OutFile]) | overwrite

  [ThPhase, ThAmp, ThFr] = ThetaParams(FileBase,elc.theta,overwrite,[],[],[],'adapt');
  
  %[ThPh, ThAmp, ThFr] = ThetaParamsOne(FileBase, eeg, eFs,1,0,
  
  spikeph = mod(ThPhase(round(spiket/RateFactor)),2*pi); %%% 0 is PEAK of theta!!
  
  %% unwraped phase
  %UThPhase = unwrap(ThPhase.deg);
  %spikeuph = UThPhase(round(spiket/16)); 
  spikeuph=[];

else
  load([FileBase OutFile],'-MAT')
end


return;