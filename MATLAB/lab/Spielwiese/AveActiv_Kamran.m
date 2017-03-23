%% Script to loop through several of Kamran's files

list = LoadStringArray('listInter.txt');

%% file selection (f=[] all files from list)
%file = [61 62 63 64 65 66 67 68 69 70 71 72];
file = [67 68 69 70 71 72];
%file = [61];

if isempty(file);
  file = [1:length(list)];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOOP THROUGH FILES
%%
for f=file
  
  FileBase = [list{f} '/' list{f}];
  fprintf('=========================\n');
  fprintf('FILE %d: %s\n',f,list{f});
   
  PlotAveActiv_Kamran(FileBase)
  
  
  WaitForButtonpress
  
  %kk = waitforbuttonpress;
  %if kk == 0
  %  continue;
  %else
  %  break
  %end
end