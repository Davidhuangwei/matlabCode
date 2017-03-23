%OVARCONT   Control of the OFFSET-variable naming in glmlab

%Copyright 1996, 1997 Peter Dunn
%01 August 1997

GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');
OLDNAMEOS=GLMLAB_INFO_{12};OLDOFFSET=GLMLAB_INFO_{17};
GLMLAB_INFO_{22}=1;GLMLAB_INFO_{12}=get(findobj('tag','HOS'),'String');

if ~isempty(GLMLAB_INFO_{12}),

   GLMLAB_INFO_{12}=fixmeup(GLMLAB_INFO_{12});
   eval('GLMLAB_INFO_{17}=evalin(''base'', GLMLAB_INFO_{12});GLMLAB_INFO_{17}=GLMLAB_INFO_{17}(:);',...
        'GLMLAB_INFO_{17}=['' '',lasterr];');
   if isstr(GLMLAB_INFO_{17}),
      opterr(4,GLMLAB_INFO_{17}); GLMLAB_INFO_{12}=OLDNAMEOS;
   else
      set(findobj('tag','HOS'),'String',GLMLAB_INFO_{12});
   end;

else

   GLMLAB_INFO_{12}=[];GLMLAB_INFO_{17}=[];

end;

set(findobj('tag','glmlab_main'),'Userdata',GLMLAB_INFO_);
clear OLDNAMEOS OLDOFFSET GLMLAB_INFO_

GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');
