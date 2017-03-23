function h=glmsplsh(flag)
%GLMSPLSH The initial splash screen for  glmlab

%Copyright 1996--1998 Peter Dunn
%11 March 1998

h=figure('Name','glmlab Splash Screen','tag','splash');

axis('off');
text(0.3,0.95,'glmlab','FontSize',40);
text(0.33,0.8,'Version 2.3.1','FontSize',20);
text(0.15,0.7,'Generalised Linear Models','FontSize',20);
text(0.27,0.6,'using MATLAB','FontSize',20);
text(0.15,0.4,'Copyright 1996--1998 Peter Dunn','FontSize',15);
text(0.25,0.3,'dunn@sci.usq.edu.au','FontSize',15);
text(-0.1,0.2,'http://www.sci.usq.edu.au/staff/dunn/glmlab/glmlab.html',...
 'FontSize',15);
if nargin==1,
   uicontrol(gcf,'Style','Pushbutton','String','FINISHED',...
    'Units','normalized','Position',[.3 .05 .40 .1],...
    'Callback','delete(gcf);return;');
else
   text(0,0.1,'glmlab  is setting up; it will be with you in a moment.','FontSize',15);
end;
drawnow;

return;
