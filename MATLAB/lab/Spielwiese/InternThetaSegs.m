function [nThetInt Running Sleep] = InternThetaSegs(FileBase,varargin)
[overwrite] = Defaultargs(varargin,{0}); 
%
%% detect theta states
%% (output: nThetInt >> FileBase.sts.theta)
%%
fprintf('Select theta episodes... \n');

ask=0;
if overwrite
  ask = input('Do you really want to overwrite [1/0]? ');
end
  
if  ~FileExists([FileBase '.eegseg.par']) | ~FileExists([FileBase '.sts.theta']) | ask
  
  if ~FileExists([FileBase '.elc'])
    error('no channel for theta detection is specified.\n');
  else
    load([FileBase '.elc'],'-MAT');
  end
  
  msave([FileBase '.eegseg.par'],elc.theta);

  fprintf('select theta episodes and save in .sts.theta\n' );
  fprintf('select running intervals and save in .sts.run \n');
  fprintf('select sleep intervals and save in .sts.sleep \n');
  
  %if FileExists([FileBase '.sts.theta'])
  %  CheckEegStates(FileBase,'theta');
  %else 
  CheckEegStates(FileBase);
  %end
    
  go=input('go: ');
    
  ThetInt = load([FileBase '.sts.theta']);
  Run = load([FileBase '.sts.run']);
  Sleep = load([FileBase '.sts.sleep']);

  %% remove aretifacts
  if FileExists([FileBase '.evt'])
    Evt = load([FileBase '.evt']);
  elseif FileExists([FileBase '.events'])
    Evt = load([FileBase '.events']);
  else
    Evt = [];
  end
  x1 = 250; x2 = 500; thresh = 500; % in samples
  nThetInt = RemoveArtInt(ThetInt,Evt,x1,x2,thresh);
  
  Running = find(WithinRanges(nThetInt(:,1),Run) & WithinRanges(nThetInt(:,2),Run));
  Sleep = find(WithinRanges(nThetInt(:,1),Sleep) & WithinRanges(nThetInt(:,2),Sleep));
  
  msave([FileBase '.sts.theta'],nThetInt);
  
else
  nThetInt = load([FileBase '.sts.theta']);
  Run = load([FileBase '.sts.run']);
  Sleep = load([FileBase '.sts.sleep']);
  
  Running = find(WithinRanges(nThetInt(:,1),Run) & WithinRanges(nThetInt(:,2),Run));
  Sleep = find(WithinRanges(nThetInt(:,1),Sleep) & WithinRanges(nThetInt(:,2),Sleep));

end

return;
