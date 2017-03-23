function elc = InternElc(FileBase,varargin)
overwrite = DefaultArgs(varargin,{0});
%%
%% 
%%
fprintf('Select good channels...\n');

if ~FileExists([FileBase '.elc'])
  Par = LoadPar([FileBase '.par']);
  system(['neuroscope ' FileBase '.eeg']);
  channels = [1:Par.nChannels];
  elc.rip = input('channels with ripples: ');
  elc.bad = input('bad channels: ');
  elc.good = channels(~ismember(channels,elc.bad));
  elc.theta = input('channel for theta detection: ');
  save([FileBase '.elc'],'elc');
else
  load([FileBase '.elc'],'-MAT');
  if overwrite
    ask = input('really overwrite [0/1]? ');
    if ask    
      Par = LoadPar([FileBase '.par']);
      system(['neuroscope ' FileBase '.eeg'])
      channels = [1:Par.nChannels];
      elc1.rip = input(['channels with ripples (' num2str(elc.rip) '): ']);
      elc1.bad = input(['bad channels (' num2str(elc.bad) '): ']);
      elc1.good = channels(~ismember(channels,elc.bad));
      elc1.theta = input(['channel for theta detection (' num2str(elc.theta) '): ']);
      elc = elc1;
      save([FileBase '.elc'],'elc');
    end
  end
end

return;

