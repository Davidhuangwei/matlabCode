function CheckCluFetLength(List,varargin)
%
% function CheckCluFetLength('list.txt')
% 
% compared the length of clu and fet file and writes length into file
% FileBase.cfl
% 
[overwrite]=DefaultArgs(varargin,{0});

%list = LoadStringArray(FileList);

for i=1:length(List)
  %fprintf('=========================\n');
  %fprintf('FILE %d\n',i);
  
  %% Read in Par file
  fprintf('Read Par file...\n');
  FileBase = List{i}; %% [list{i} '/' list{i}];
  Par = LoadPar([FileBase '.par']);

  %% Good clustered channels
  %% FileLines
  if ~FileExists([FileBase '.cfl']) | overwrite
    fprintf('count lines....\n');
    LenCF = [];
    for c=1:Par.nElecGps
      LenCF(c,1) = FileLines([FileBase '.clu.' num2str(c)]); 
      LenCF(c,2) = FileLines([FileBase '.fet.' num2str(c)]);
      fprintf('(%d/%d,%d/%d) Clu=%d Fet=%d\n',i,length(list),c,Par.nElecGps,LenCF(c,1),LenCF(c,2));
    end
    msave([FileBase '.cfl'], LenCF);
  end
end
