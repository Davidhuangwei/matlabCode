function [trial] = FindTrials(FileBase,varargin)
[WhlRate,EvtRate,overwrite] = DefaultArgs(varargin,{39.0625,1250,0});
%% find events in Michael's data and identify trials in whl sampling rate

if ~FileExists([FileBase '.trials']) | overwrite

  Rate = EvtRate/WhlRate; %% Michaels event files are in EEG sampling rate (1250Hz)
  %Rate = 32; %% Michaels event files are in EEG sampling rate (1250Hz)
  %keyboard
  if ~FileExists([FileBase '.evt'])
    evt = load([FileBase '.events']);
  else 
    evt = load([FileBase '.evt']);
  end
    
  evt(:,1) = round(evt(:,1));
  
  %% find position of events 
  % first letter:
  tevt.l1 = 65; % leave 1 
  tevt.a1 = 97; % arrive 1
  tevt.l2 = 66; % leave 2
  tevt.a2 = 98; % arrive 2
  tevt.st = 88; % stimmulation
		
  % second letter:
  tevt.yst = 83; % stimmulation on
  tevt.nst = 78; % stimmulation off
  
  nevt = evt(find(evt(:,2)==tevt.l1 | evt(:,2)==tevt.l2),:);
  
  %% check for missing time stamps:
  if ~min(abs(diff(nevt(:,2))))
    fprintf('WARNING: time stamps are missing\n');
  end
  
  evtt = round(nevt(:,1)/Rate);
  evtt(evt(:,1)==0)=1;
  
  %% identify trials
  ntrials = sortrows([evtt(:,:); evtt(2:end-1,:)-1],1);
  xtrials = reshape(ntrials,2,length(ntrials)/2)';
  xtdir = sign(diff(nevt(:,2)));
  
  trials = xtrials(xtdir~=0,:);
  tdir = xtdir(xtdir~=0,:);
    
  figure;
  hist((trials(:,2)-trials(:,1))/WhlRate,100);
  title('determine threshold for duration of trial');
  [thx thy] = ginput(1);
  close;
  
  good = find((trials(:,2)-trials(:,1))/WhlRate<thx);
  gtrials = trials(good,:);
  gtdir = tdir(good);
  
  figure;
  hist((gtrials(:,2)-gtrials(:,1))/WhlRate,100);
  title('determine threshold for duration of trial');
  [thx thy] = ginput(1);
  close;
    
  ggood = find((gtrials(:,2)-gtrials(:,1))/WhlRate<thx);
  
  trial.itv = gtrials(ggood,:);
  trial.dir = gtdir(ggood);
  
  %% mark stimmulation
  trial.stim = round(evt(find(evt(:,2)==tevt.st),1)/Rate);
  
  save([FileBase '.trials'],'trial');
  
else
  load([FileBase '.trials'],'-MAT');
end
  
return;

