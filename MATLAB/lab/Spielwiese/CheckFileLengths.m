function [LenCF,eeg] =CheckFileLengths(FileList,varargin)
%
% function CheckCluFetLength('list.txt')
% 
% compared the length of clu and fet file and writes length into file
% FileBase.cfl
% 
[overwrite]=DefaultArgs(varargin,{0});

List = LoadStringArray(FileList);

if ~FileExists('CheckLengths') | overwrite
  cnt=0;
  LenCF = [];
  
  
  for j=1:length(List)
    
    %% Read in Par file
    FileBase = [List{j} '/' List{j}];
    Par = LoadPar([FileBase '.par']);
    
    for c=1:Par.nElecGps
      cnt = cnt+1;
      
      LenCF(cnt,1)=j;
      LenCF(cnt,2)=c;
      
      if FileExists([FileBase '.clu.' num2str(c)]);
	LenCF(cnt,3) = FileLines([FileBase '.clu.' num2str(c)])-1; 
      else
	LenCF(cnt,3) = 0;
      end
      if FileExists([FileBase '.fet.' num2str(c)]);
	LenCF(cnt,4) = FileLines([FileBase '.fet.' num2str(c)])-1;
      else
      LenCF(cnt,4) = 0;
      end
      if FileExists([FileBase '.res.' num2str(c)]);
	LenCF(cnt,5) = FileLines([FileBase '.res.' num2str(c)]);
      else
	LenCF(cnt,5) = 0;
      end
      if FileExists([FileBase '.spk.' num2str(c)]);
	LenCF(cnt,6) = FileLength([FileBase '.spk.' num2str(c)])/2/32/length(Par.ElecGp{c});
      else
	LenCF(cnt,6) = 0;
      end
      
      fprintf('(%d/%d,%d/%d) Clu=%d Fet=%d Res=%d Spk=%d\n',j,length(List),c,Par.nElecGps,LenCF(cnt,3),LenCF(cnt,4),LenCF(cnt,5),LenCF(cnt,6));
      
    end
  end
  
  msave('CheckLengths', LenCF);
  
end  
  
LenCF = load('CheckLengths');


%% check eeg:
for j=1:length(List)
  
  FileBase = [List{j} '/' List{j}];
  
  eeg(j,1) = j;
  
  eeg(j,2) = 0;
  eeg(j,3) = 0;
  
  if FileExists([FileBase '.eeg'])
    eeg(j,2) = 1;
  end
  
  if FileExists([FileBase '.eegh'])
    eeg(j,3) = 1;
  end
  
end
