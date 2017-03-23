function sessions = FindSessions(FileBase,list,varargin)
[overwrite] = DefaultArgs(varargin,{0});

if ~FileExists([FileBase '.sessions']) | overwrite
  lngth = 0;
  for n=1:length(list)

    Par = LoadPar([list{n} '/' list{n} '.par']);
    interval(n,1) = lngth+1;
    lngth = lngth+FileLength([list{n} '/' list{n} '.eeg'])/2/Par.nChannels;
    interval(n,2) = lngth;
    
    fprintf(['The different states of ' list{n} ': \n']);
    fprintf('Sleep: 1 \n');
    fprintf('Run/track: 2 \n');
    fprintf('Run/open field: 3 \n');
    fprintf('Run/wheel: 4 \n');
    types(n) = input('What type of session is this ? ');
  end
  
  sessions.itv = interval;
  sessions.type = types;
  sessions.label = {'sleep' 'track' 'field' 'wheel'};
  
  save([FileBase '.sessions'],'sessions');
else
  load([FileBase '.sessions'],'-MAT'); 
end
