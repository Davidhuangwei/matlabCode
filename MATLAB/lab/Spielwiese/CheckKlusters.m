function CheckKlusters(FileList,varargin)
[file] = DefaultArgs(varargin,{[]});
%%
%% opens klusters for electrodes in files 'file' of file list 'FileList'
%%


List = LoadStringArray(FileList);

if isempty(file);
  file = [1:length(List)];
end


for j=file
  
  FileBase = [List{j} '/' List{j}];
  
  %% Read in Par file
  Par = LoadPar([FileBase '.par']);
  
  
  for c=1:Par.nElecGps
    
    Command = ['klusters ' FileBase '.fet.' num2str(c) '&'];
    system(Command);
    
    if input('go')
      continue
    end
        
  end
  
  
end

