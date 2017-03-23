function whl = GetWhl(FileBase,varargin)
[overwrite,states,statesrate] = DefaultArgs(varargin,{0,[],[]});
%%
%% function whl = GetWhl(FileBase,varargin)
%% [overwrite,states] = DefaultArgs(varargin,{0,[]});
%% 
%% INPUT: states: nx2 matrix of beginnings and ends of recording sessions in EEG sampling rate!!! 
%%                if empty: states = [beginning end] if whole session 
%% 
%% POSITION:
%% whl.ctr :   center of lights (IN CM!)
%% whl.plot:   does not contain -1
%% whl.speed:  speed of rat (cm/s)
%% whl.rate:   sampling rate of whl file
%% whl.ncol:   number of colums that contain position.
%% whl.xyratio: [x y] multipyers to convert into cm

%% Get Whl Parameters
if ~FileExists([FileBase '.whl.info']) | overwrite
  whl.rate = input('sampling rate of whl file [R]: ');
  whl.ncol = input('which columns have position [a b c d]: ');
  whl.xyratio = input('cm/pixel in x and y direction [x y]: ');
  whl.run = input('is there any running at all?? [0/1] ');
  save([FileBase '.whl.info'],'whl');
else
  load([FileBase '.whl.info'], '-MAT');
end

%% get sampling rates etc
info = FileInfo(FileBase);

if isempty(statesrate)
  statesrate = info.WhlRate;
end

%% for sleep only
if ~isfield(whl,'run') 
  whl.run = input('is there any running at all?? [0/1] ');
  save([FileBase '.whl.info'],'whl');
end
if whl.run==0
  if FileExists([FileBase '.whl'])
    whl.itv = load([FileBase '.whl']);
  else
    LL = FileLength([FileBase '.eeg']);
    Par = LoadPar([FileBase '.par']);
    whl.itv = -1*ones(round(LL/2/Par.nChannels/(info.EegRate*whl.rate)),4);
    msave([FileBase '.whl'],whl.itv);
  end
  whl.ctr = whl.itv(:,1:2);
  whl.extra = whl.itv;
  whl.speed = whl.ctr*0;
  whl.plot = whl.ctr;
  return;
end

[whl.itv whl.ctr whl.extra] = InterpolWhl(FileBase,overwrite,states,statesrate,whl.ncol);
whl.ctr(:,1) = whl.ctr(:,1)*whl.xyratio(1);
whl.ctr(:,2) = whl.ctr(:,2)*whl.xyratio(2);
whl.plot = whl.ctr(find(whl.ctr(:,1)>0),:);

%% Speed of rat !! in pixels/t
whl.speed = RatSpeed(whl.ctr,whl.rate);


return;


