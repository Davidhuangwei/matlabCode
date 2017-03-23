%YVARCONT   Control of the Y-variable naming in glmlab

%31 August 1998
%Copyright 1996, 1997 Peter Dunn
GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'Userdata');
GLMLAB_INFO_{22}=1;
OLDNAMEYV=GLMLAB_INFO_{9};OLDYVAR=GLMLAB_INFO_{14};
GLMLAB_INFO_{9}=get(findobj('tag','HYV'),'String');

if ~isempty(GLMLAB_INFO_{9}),
   GLMLAB_INFO_{9}=fixmeup(GLMLAB_INFO_{9});
   eval('GLMLAB_INFO_{14}=evalin(''base'',[''['',GLMLAB_INFO_{9},'']'']);',...
        'GLMLAB_INFO_{14}=['' '',lasterr];');
   if isstr(GLMLAB_INFO_{14}),
      opterr(4,GLMLAB_INFO_{14});GLMLAB_INFO_{9}=OLDNAMEYV;
   else
      set(findobj('tag','HYV'),'String',GLMLAB_INFO_{9});
      GLMLAB_INFO_{9}=[ '[' GLMLAB_INFO_{9} ']' ];
   end;
else
   GLMLAB_INFO_{9}=[];GLMLAB_INFO_{14}=[];
end;


set(findobj('tag','glmlab_main'),'UserData',GLMLAB_INFO_);
if ((GLMLAB_INFO_{6}==0)&(isempty(GLMLAB_INFO_{10}))) | isempty(GLMLAB_INFO_{9}),
   set(findobj('String','FIT SPECIFIED MODEL'),'Enable','off');
   set(findobj('tag','rplot'),'Enable','off');
else
   set(findobj('String','FIT SPECIFIED MODEL'),'Enable','on');
   set(findobj('tag','rplot'),'Enable','on');
end;
clear OLDNAMEYV OLDYVAR NAMEYV GLMLAB_INFO_

GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');
