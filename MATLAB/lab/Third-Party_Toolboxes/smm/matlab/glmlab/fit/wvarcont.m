%WVARCONT   Control of the WEIGHT-variable naming in glmlab

%31 August 1998
%Copyright 1996--1998 Peter Dunn

GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');
OLDNAMEPW=GLMLAB_INFO_{11};
OLDWEIGHTS=GLMLAB_INFO_{16};
GLMLAB_INFO_{22}=1;
GLMLAB_INFO_{11}=get(findobj('tag','HPW'),'String');

if ~isempty(GLMLAB_INFO_{11}),

   GLMLAB_INFO_{11}=fixmeup(GLMLAB_INFO_{11});
   eval('GLMLAB_INFO_{16}=evalin(''base'', GLMLAB_INFO_{11});GLMLAB_INFO_{16}=GLMLAB_INFO_{16}(:);',...
        'GLMLAB_INFO_{16}=['' '',lasterr];');

   if isstr(GLMLAB_INFO_{16}),
      opterr(4,GLMLAB_INFO_{16}); 
      GLMLAB_INFO_{11}=OLDNAMEPW;
   else
      if ~isempty(GLMLAB_INFO_{16}),
         if any(GLMLAB_INFO_{16}<0), 
            opterr(2,GLMLAB_INFO_{11}); 
            GLMLAB_INFO_{11}=OLDNAMEPW;
            GLMLAB_INFO_{16}=OLDWEIGHTS;
            UNFIT=1;
         end;
         if all(GLMLAB_INFO_{16}==0),
            opterr(5,GLMLAB_INFO_{11});
            GLMLAB_INFO_{11}=OLDNAMEPW;
            GLMLAB_INFO_{16}=OLDWEIGHTS;
            UNFIT=1;
         end;
      end;
      set(findobj('tag','HPW'),'String',GLMLAB_INFO_{11});
   end;

else

   GLMLAB_INFO_{11}=[];
   GLMLAB_INFO_{16}=[];

end;

set(findobj('tag','glmlab_main'),'Userdata',GLMLAB_INFO_');
clear OLDNAMEPW OLDWEIGHTS GLMLAB_INFO_

GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');
