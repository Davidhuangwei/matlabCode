function [LenCF,eeg] =CheckFileLengthsOne(FileList,varargin)
[file,overwrite]=DefaultArgs(varargin,{[],0});
%
% function CheckCluFetLength('list.txt')
% 
% compared the length of clu and fet file and writes length into file
% FileBase.cfl
% 
%FileList = 'listALL.txt';
%file =[];
%overwrite = 1;


List = LoadStringArray(FileList);

if isempty(file);
  file = [1:length(List)];
end


for j=file
  
  FileBase = [List{j} '/' List{j}];
  
  if ~FileExists([FileBase '.cfl']) | overwrite
    
    %% Read in Par file
    Par = LoadPar([FileBase '.par']);
    
    LenCF = [];
    for c=1:Par.nElecGps
      
      LenCF(c,1)=c;
      
      if FileExists([FileBase '.clu.' num2str(c)]);
	LenCF(c,2) = FileLines([FileBase '.clu.' num2str(c)])-1; 
      else
	LenCF(c,2) = 0;
      end
      if FileExists([FileBase '.fet.' num2str(c)]);
	LenCF(c,3) = FileLines([FileBase '.fet.' num2str(c)])-1;
      else
	LenCF(c,3) = 0;
      end
      if FileExists([FileBase '.res.' num2str(c)]);
	LenCF(c,4) = FileLines([FileBase '.res.' num2str(c)]);
      else
	LenCF(c,4) = 0;
      end
      if FileExists([FileBase '.spk.' num2str(c)]);
	LenCF(c,5) = FileLength([FileBase '.spk.' num2str(c)])/2/32/length(Par.ElecGp{c});
      else
	LenCF(c,5) = 0;
      end
      
      fprintf('(%d/%d)(%d/%d) Clu=%d Fet=%d Res=%d Spk=%d\n',j,length(file),c,Par.nElecGps,LenCF(c,2),LenCF(c,3),LenCF(c,4),LenCF(c,5));

      msave([FileBase '.cfl'],LenCF);
    end
  end
end

%% check eeg:
eeg(1,1) = 0;
eeg(1,2) = 0;

if FileExists([FileBase '.eeg'])
  eeg(1,1) = 1;
  fprintf('eeg file exists\n');
end

if FileExists([FileBase '.eegh'])
  eeg(1,2) = 1;
  fprintf('eegh file exists\n');
end


