function MergeClu2(FileBaseNew,FileBaseList,varargin)
%% merge clu files 
%% 
%% IN:  'FileBaseNew' file base of new clu files
%%      'FileBaseList' array of file bases
%%      'elec' - optional - list of electodes (default [1:4])
%% OUT: saves clu files
%% 
%% 
[elec] = DefaultArgs(varargin,{[1:4]});

%% MergeClu('a03_maze40.4.6',{'a03_maze40.004' 'a03_maze40.006'})
%% FileBaseNew = 'a03_maze40.4.6';
%% FileBaseList = {'a03_maze40.004' 'a03_maze40.006'}
%% elec = [1:4];

if ~FileExists(FileBaseNew)
  system(['mkdir ' FileBaseNew]);
end

for el=elec

  clu=[];
  clugood = [];
  numclu = 0;
  for fi=1:length(FileBaseList) 
    FileBase = FileBaseList{fi};
    
    cluload = load([FileBase '/' FileBase '.clu.' num2str(el)]); 
     
    cumnumber = cluload(1);
    ficlu = cluload(2:end);
    
    newclu = ficlu;
    newclu(find(ficlu>1)) = ficlu(find(ficlu>1))+numclu;
    
    numclu = max(newclu)-1;
    clugood = [clugood; newclu]; 
    clear  newclu ficlu;
    
  end
  
  clu(2:length(clugood)+1,1) = clugood;
  clu(1,1)=length(unique(clugood));

  %%% merge individual clusters based on likelyhood
  % save([FileBaseNew '/' FileBaseNew '.clu.' num2str(el)], 'clu', '-ascii');
  msave([FileBaseNew '/' FileBaseNew '.clu.' num2str(el)],clu);

end

return;
