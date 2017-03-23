function KlusterPosition(FileBase,time,x,y,direction,overwrite,varargin)
%%
%% filenamebase = [pathname '/' basename]
%%
%%
%% replaces the columns n-1, n-2, n-3 of fet files with position
%% and direction of rat on maze (from whl file) 
%% 
%% input: 
%%   FileBase: [path '/' filebase]
%%   time is in real time
%%   overwrite: 1=overwrite *.fet.* files WITHOUT saving old one          
%%              0=save old *.fet.* as *.fet.bak.*
%%
[elec] = DefaultArgs(varargin,{[2:5]});

pos(:,1) = round(x*1000);
pos(:,2) = round(y*1000);
pos(:,3) = direction*1000;

for i=elec
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% LOOP
  fprintf(['electrode (' num2str(i) ')...']);
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% READ IN RES FILE
  fprintf('read in res data...');
  res = load([FileBase '.res.' num2str(i)])/20000;
  
  reslabel = WithinRanges(res,[min(time) max(time)]);
  spikes(find(reslabel),:) = interp1(time,pos,res(find(reslabel)));
  spikes(find(reslabel==0),:) = 0;
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% READ IN FET FILE
  fprintf('read in fet data...');
  [fet, nfet] = LoadFet([FileBase '.fet.' num2str(i)]);
  
  if ~overwrite
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% SAVE OLD FET FILE
    fprintf('save old fet data...');
    com = ['cp ' FileBase '.fet.' num2str(i) ' ' FileBase '.fet.bak.' num2str(i)];
    system(com);
    %% SaveFet([FileBase '.fet.bak.' num2str(i)],fet);
  end
    
  fet(:,[nfet-3:nfet-1])=spikes;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% SAVE NEW FET FILE
  fprintf('save in new fet data...');
  
  overwrite = input(['if the *.fet.* file is a sympolic link it has to be removed befor saving. Do you want to remove the *.fet.* file [0/1]?']);
  system(['rm ' FileBase '.fet.' num2str(i)]);
  SaveFet([FileBase '.fet.' num2str(i)],fet);


  clear res reslabel spikes fet;

end


return;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FileBase = {'km01.028-032'};
Trial = {'km01.04'};
i=1;
basename = FileBase{i};
trialname = Trial{i};
pathname = ['/u42/caro/Kenji_data/km01/' trialname '/' trialname '.run/' basename];

FileBase = [pathname '/' basename];

%%% GET THE WHL DATA 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% READ IN WHL FILE
fprintf('read in whl data...');
whl = load([pathname '/' basename '.whl']);
%whl = load([DirBase '.run.whl.original/' FileBase '.whl']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CONVERT WHL FILE
fprintf('convert position....');
Rat = PosConv(whl); 
%% Rat = [time angle direction radius speed]
%% time is in samples!

time = Rat(:,1)/39.065;
x = Rat(:,4).*cos(Rat(:,2)/180*pi);
y = Rat(:,4).*sin(Rat(:,2)/180*pi);
direction = Rat(:,3);