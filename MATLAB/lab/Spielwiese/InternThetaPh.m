function ThPhase = InternThetaPh(FileBase,varargin)
[overwrite] = DefaultArgs(varargin,{0}); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Theta Phase and power
%% (needs: FileBase.elc, FileBase.par)
%% (output: ThPhase >> FileBase.phase)
%%
fprintf('  theta phase and power... \n');
if ~FileExists([FileBase '.phase']) | overwrite
  if ~FileExists([FileBase '.elc'])
    elc = InternElc(FileBase);
    %%error('no channel for theta phase detection is specified.');
  else
    load([FileBase '.elc'],'-MAT');
  end
  Par = LoadPar([FileBase '.par']);
  Eeg = LoadBinary([FileBase '.eeg'],elc.theta,Par.nChannels);
  [Phase.deg Phase.amp] = myThetaPhase(Eeg,[4 10],4,20,Par.lfpSampleRate);
  ThPhase = Phase;
  save([FileBase '.phase'],'Phase');
  %% msave([FileBase '.phase'],'ThPhase','-MAT');
else
  %% ThPhase = load([FileBase '.phase']);
  load([FileBase '.phase'],'-MAT');
  ThPhase = Phase;
end

return;

