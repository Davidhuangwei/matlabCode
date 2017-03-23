function Rips = InternRipsPeaks(FileBase,varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Ripple detection
%% (needs: FileBase.elc, FileBase.evt)
%% (output: Rips >> FileBase.spw)
%% 
[overwrite] = DefaultArgs(varargin,{0});

if ~FileExists([FileBase '.elc'])
  error('no channel for ripple detection is specified.\n');
else
  load([FileBase '.elc'],'-MAT');
end
  
if  ~FileExists([FileBase '.spw']) | overwrite
  fprintf('Ripple detection...\n');
  %getRips=DetectRipples(FileBase,elc.rip,[100 250],7);
  
  %keyboard
  
  getRips=DetectPeaks(FileBase,-1,3,1.5,1,1250,[],[],[100 250],elc.theta,[],0);

  Rips.t = getRips(1).Bursts(:,1); 
  Rips.len = getRips(1).Bursts(:,2); 
  Rips.pow = getRips(1).Bursts(:,3);
  Rips.at = getRips(1).Peaks(:,1);
  save([FileBase '.spw'],'Rips');
  
else
  load([FileBase '.spw'],'-MAT');
end

return;