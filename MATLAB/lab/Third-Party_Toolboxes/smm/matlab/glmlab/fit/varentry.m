function varentry(action,option)
%VARENTRY  Allows user-interactive variable manipulations

%Copyright 1997 Peter Dunn
%28/05/1997

chosenlist=get(findobj('tag','chosenlisttag'),'String');

if isstr(chosenlist), 
   chosenlist=cellstr(chosenlist); 
end;

masterlist=cellstr(get(findobj('tag','masterlisttag'),'String'));

if strcmp(action,'add'),
   varnum=get(findobj('tag','masterlisttag'),'value');
   newvar=masterlist{varnum};

   if length(chosenlist)==0,
      set(findobj('tag','takebutton'),'Enable','on');
   end;

   chosenlist{length(chosenlist)+1}=newvar;
   set(findobj('tag','chosenlisttag'),'String',chosenlist,'Value',length(chosenlist));

   if (option==3)|(option==4),
      if length(chosenlist)==1,
         set(findobj('tag','addbutton'),'Enable','off');
      end;
   end;

   if option==1,
      GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');
      if strcmp(GLMLAB_INFO_{1},'binoml'),
         if length(chosenlist)==2,
            set(findobj('tag','addbutton'),'Enable','off');
         end;
      else
         if length(chosenlist)==1,
            set(findobj('tag','addbutton'),'Enable','off');
         end;
      end;
   end;

elseif strcmp(action,'take'),

   varnum=get(findobj('tag','chosenlisttag'),'value');
   takevar=chosenlist{varnum};
   chosenlist{varnum}=[];
   numofvars=length(chosenlist)-1;
   nchosenlist=cell(numofvars,1);

   j=0;
   for i=1:length(chosenlist),
      if ~isempty(chosenlist{i}),
         j=j+1;
         nchosenlist{j}=chosenlist{i};
      end;
   end;

   setnum=min(varnum,length(nchosenlist));
   set(findobj('tag','chosenlisttag'),'Value',setnum,'String',nchosenlist);

   if numofvars==0,
      set(findobj('tag','takebutton'),'Enable','off');
   end;

   if (option==3)|(option==4),
      set(findobj('tag','addbutton'),'Enable','on');
   end;

   if option==1,
      GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');
      if strcmp(GLMLAB_INFO_{1},'binoml'),

         if length(nchosenlist)<2,
            set(findobj('tag','addbutton'),'Enable','on');
         end;

      else

         if length(nchosenlist)<1,
            set(findobj('tag','addbutton'),'Enable','on');
         end;

      end;

   end;

elseif strcmp(action,'fac'),

   varnum=get(findobj('tag','masterlisttag'),'value');
   newvar=masterlist{varnum};

   if length(chosenlist)==0,
      set(findobj('tag','takebutton'),'Enable','on');
   end;

   chosenlist{length(chosenlist)+1}=['fac(',newvar,')'];
   set(findobj('tag','chosenlisttag'),'String',chosenlist,'Value',length(chosenlist));

   if (option==3)|(option==4),
      if length(chosenlist)==1,
         set(findobj('tag','addbutton'),'Enable','off');
      end;
   end;

   if option==1,
      GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');
      if strcmp(GLMLAB_INFO_{1},'binoml'),
         if length(chosenlist)==2,
            set(findobj('tag','addbutton'),'Enable','off');
         end;
      else
         if length(chosenlist)==1,
            set(findobj('tag','addbutton'),'Enable','off');
         end;
      end;
   end;

elseif strcmp(action,'close'),

   NEW=get(findobj('tag','chosenlisttag'),'String');

   if option==1, %Y
      set(findobj('tag','HYV'),'String',NEW);
      evalin('base','yvarcont;');
   elseif option==2, %X
      set(findobj('tag','HXV'),'String',deblank(NEW));
      evalin('base','xvarcont;');
   elseif option==3, %PWEIGHTS
      set(findobj('tag','HPW'),'String',NEW);
      evalin('base','wvarcont;');
   elseif option==4, %OFFSET
      set(findobj('tag','HOS'),'String',NEW);
      evalin('base','ovarcont;');
   end;

   close(findobj('tag','glmlab_varentry'));

end;
