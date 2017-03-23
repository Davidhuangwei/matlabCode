function KlusterItAll(FileBase,electrode,spikes,varargin)
%%
%% filenamebase = [pathname '/' basename]
%%
%%
%% replaces the columns n, n+1, .. of fet files with whatever
%%
%% puts time as last column.
%% 
%% input: 
%%   FileBase: [path '/' filebase]
%%   spikes: what ever you want to kluster [x y direction speed]. go wild 
%%        size(spikes,1) = size(fet,1) 
%%
[elec,ask] = DefaultArgs(varargin,{[1:4],0});

nvar = size(spikes,2);

i = electrode;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% READ IN FET FILE
fprintf('read in fet data...');

if FileExists([FileBase '.fet.' num2str(i)])
  [fet, nfet] = LoadFet([FileBase '.fet.' num2str(i)]);
elseif FileExists([FileBase '.fet.bak.' num2str(i)])
  [fet, nfet] = LoadFet([FileBase '.fet.bak.' num2str(i)]);
else
  error('the *fet* file does nor exist');
end


if size(fet,1)~=size(spikes,1)
   error('The length of the fet file must be the same as the length of the feature vector!'); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SAVE OLD FET FILE
if ask 
  overwrite = input('do you want to back up the old *.fet.* file [1/0]? ');
  if overwrite
    
    fprintf('save old fet data...');
    com = ['mv ' FileBase '.fet.' num2str(i) ' ' FileBase '.fet.bak.' num2str(i)];
    system(com);
  end
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NEW FET
time = fet(:,nfet);
newfet(:,[nfet:nfet+nvar-1])=spikes(:,:);
newfet(:,[nfet+nvar])=time;
newfet(:,[1:nfet-1]) = fet(:,[1:nfet-1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SAVE NEW FET FILE
fprintf('save in new fet data...');
SaveFet([FileBase '.fet.' num2str(i)],newfet);

%%clear res reslabel spikes fet;


return;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FileBase = 'a03_maze40.006';

whl = load([FileBase '.whl']);

time = find(whl(:,1)>0)/39.065; 
pos = whl(find(whl(:,1)>0),:);
clear whl;
%elec = [1:4];
elec = [1:7];


for n=elec
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% LOOP
  fprintf(['electrode (' num2str(n) ')...']);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% READ IN RES FILE
  fprintf('read in res data...');
  res = load([FileBase '.res.' num2str(n)])/20000;
  
  reslabel = WithinRanges(res,[min(time) max(time)]);
  spikes(1:size(res,1),1:size(pos,2))=-1;
  spikes(find(reslabel),:) = interp1(time,pos,res(find(reslabel)));
  %spikes(find(reslabel==0),:) = -1;

  clear res reslabel;
  
  KlusterItAll(FileBase,n,spikes,[],1);
  
  clear spikes;
end
