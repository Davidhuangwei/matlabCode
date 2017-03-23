function elc = InternKlust(List,varargin)
overwrite = DefaultArgs(varargin,{0});
fprintf('Check Clusters...\n');
list = LoadStringArray('list.txt');
file = [1:length(list)];

for i=file
  FileBase = [list{i} '/' list{i}];
  Par = LoadPar([FileBase '.par']);
  
  for n=1:Par.nElecGps
    system(['klusters ' FileBase '.fet.' num2str(n)]);
  end

  %%go = input('close all, then press 1');
  
end
  
return;

