function list=dllist(fname,charflag)
%DLLIST Produces a list of dist/link function available in  glmlab
%USEAGE  list=dllist(fname)
%   where  fname  is the name of the file to read
%           (not necessary, but a workaround to a MATLAB windows bug)
%          charflag  is 'd' for dist, 'l' for links; a character flag
%          list  is a call array, one dist/link per line;
%   This info is used in forming menus

%Copyright 1996--1999 Peter Dunn
%29 March 1999

%This  if  shouldn't be needed; a MATLAB bug in Windows
if strcmp(computer,'PCWIN'),        %open file
   fid=fopen(fname,'r');
else
   fid=fopen(fname,'rt');
end;

if fid == -1,

   bell;
   HE = errordlg(['Cannot find file  ',fname],'Error finding file');
   set(HE,'WindowStyle','modal');
   watchoff(findobj('tag','glmlab_main'));

end;

tlists={};                          %prepare
nlines=1;                           %number of lines in file

while ~feof(fid),
   tlists{nlines}=fgetl(fid);       %read file line by line
   nlines=nlines+1;                 %update number of lines
end;

fclose(fid);                        %close file

nlines=nlines-1;                    %correct nlines
addrow=1;                           %row to next add in final list
list={};                            %initialise

for i=1:nlines,                     %for each line...

   l=tlists{i};                     %obtain line info
   l=strrep(l,'.m','  ');           %remove  .m (if there)

   if ~isempty(deblank(l))          %skip blank lines

      if strcmp(l(1),charflag)      %only for lines with first char  l  flag...
         list{addrow}=l(2:length(deblank(l)));
                                    %...add remaining text to list
         addrow=addrow+1;           %...update next row number to add
      end

   end

end;
