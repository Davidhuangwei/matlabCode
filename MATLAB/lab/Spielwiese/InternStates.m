function State = InternStates(FileBase,varargin)
[overwrite]=DefaultArgs(varargin,{0}); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% detect states: run/sleep
%% (needs: FileBase.elc, FileBase.evt)
%% (output: nThetInt >> FileBase.sts.run  FileBase.sts.slp)
%%
fprintf('Select rem/run... \n');
if  ~FileExists([FileBase '.eegseg.par']) | ~FileExists([FileBase '.sts.run']) | overwrite
  
  if ~FileExists([FileBase '.elc'])
    error('no channel for theta detection is specified.\n');
  else
    load([FileBase '.elc'],'-MAT');
  end
  msave([FileBase '.eegseg.par'],elc.theta);
  
  CheckEegStates(FileBase);
  
end

State = load([FileBase '.sts.run']);

return;
