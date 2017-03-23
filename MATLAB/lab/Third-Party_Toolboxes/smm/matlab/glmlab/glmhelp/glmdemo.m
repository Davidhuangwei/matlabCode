%GLMDEMO A demo of glmlab in operation

%Copyright 1997 Peter Dunn
%19/04/1997
global GLMDEMO_NUM_ GLMDEMO_STEP_

%Disable the demo button and fitting buttons so nothing goes awry
set(findobj('tag','gldemo'),'enable','off');
set(findobj('String','FIT SPECIFIED MODEL'),'Callback','');
set(findobj('String','RESIDUAL PLOTS...'),'Callback','');

%Prepare
newmodel;

%Create demo buttons on window
GLMDEMO_STEP_=-1; GLMDEMO_NUM_=1;

uicontrol(findobj('tag','glmlab_main'),'Style','Text','FontSize',10,...
 'String',{' ','glmlab DEMONSTRATION'},'Position',[.23 .15 .54 .15],'tag','demotext');
uicontrol(findobj('tag','glmlab_main'),'Style','Pushbutton',...
 'String','Next Step...','Position',[.05 .15 .15 .1],...
 'Callback','demowork;GLMDEMO_STEP_=GLMDEMO_STEP_+1;',...
 'tag','demonext');
uicontrol(findobj('tag','glmlab_main'),'Style','Pushbutton',...
 'String','QUIT Demo','Position',[.80 .15 .15 .1],...
 'Callback','GLMDEMO_NUM_=2;demowork;','tag','demoquit');
