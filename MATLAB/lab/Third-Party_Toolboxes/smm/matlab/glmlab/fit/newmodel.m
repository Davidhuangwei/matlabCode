%NEWMODEL Resets the variables for use in  glmlab
%USE: newmodel

%Copyright 1996--1999 Peter Dunn
%08 February 1999

GLMLAB_INFO_=cell(25,1);
GLMLAB_INFO_{1}='normal';
GLMLAB_INFO_{2}='id';
GLMLAB_INFO_{3}='md';
GLMLAB_INFO_{4}='pearson';
GLMLAB_INFO_{5}=0;
GLMLAB_INFO_{6}=1;
GLMLAB_INFO_{7}=[0 1 1];
GLMLAB_INFO_{22}=1;
GLMLAB_INFO_{23}=0;
GLMLAB_INFO_{24}=0;
GLMLAB_INFO_{25}='backtrace';

set(findobj('tag','HYV'),'String',[]);
GLMLAB_INFO_{9}='';GLMLAB_INFO_{14}=[];
set(findobj('tag','HXV'),'String',[]);
GLMLAB_INFO_{10}='';GLMLAB_INFO_{15}=[];
set(findobj('tag','HPW'),'String',[]);
GLMLAB_INFO_{11}='';GLMLAB_INFO_{16}=[];
set(findobj('tag','HOS'),'String',[]);
GLMLAB_INFO_{12}='';GLMLAB_INFO_{17}=[];
set(findobj('tag','rplots'),'Enable','off');

%The file name of the file recording things
ddir=which('dummylog.m');
GLMLAB_INFO_{8}=strrep(ddir,'dummylog.m','DETAILS.m');
if exist(GLMLAB_INFO_{8}),
   delete(GLMLAB_INFO_{8});
end;

set(findobj('tag','glmlab_main'),'UserData',GLMLAB_INFO_);

disp(' ');
disp('+----------------------------------------+');
disp('| New Model Declared:  Defaults restored |');
disp('+----------------------------------------+');
