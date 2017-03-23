function errflag = varok
%VAROK   Check to see if the variables in the  glmlab  edit ui's are OK.

%Copyright 1996--1998 Peter Dunn
%31 August 1998

errflag = 0;

%Extract details
extrctgl;

GLMLAB_INFO_{24}=0;            %reset flag
evalin('base','yvarcont');     %check x,y, weights and offset variables:
evalin('base','xvarcont');
evalin('base','wvarcont');
evalin('base','ovarcont');
resetgl;

extrctgl;                      %extract data

if strcmp(get(findobj('tag','constant'),'checked'),'on'),
   GLMLAB_INFO_{6}=1;          %set constant flag
else
   GLMLAB_INFO_{6}=0;
end;

resetgl;                       %reset

%check variables sizes are compatible
vsizes=[];
is_there=[0 0 0 0];

if (size(yvar,1)==1)&(size(yvar,2)~=1), 
   %try transposing y
   GLMLAB_INFO_{9}=[deblank(nameyv(1:length(nameyv)-1)),''']'];
   set(findobj('tag','HYV'),'String',GLMLAB_INFO_{9});
   resetgl;
   yvarcont;
end;

extrctgl;

if ~isempty(nameyv),
   if isstr(yvar)

      opterr(10,'y');
      errflag = 1;
      return;
      
   else

      is_there(1)=1;
      vsizes=[vsizes,length(yvar)];

   end;
end;

%x-vars
if ~isempty(namexv),
   if size(xvar,1)~=size(yvar,1),
      if size(xvar,2)==size(yvar,1), 
         %try transposing x
         if (namexv(1) == '[') 
            GLMLAB_INFO_{10}=[deblank(namexv(1:end-1)),''']'];
         else
            GLMLAB_INFO_{10}=[deblank(namexv(1:end)),''' '];
         end
         set(findobj('tag','HXV'),'String',deblank(GLMLAB_INFO_{10}));
         resetgl;
         xvarcont;
      end;
   end;
end;

extrctgl;

if ~isempty(namexv), 
   if isstr(xvar)

      opterr(10,'X');
      errflag = 1;
      return;
      
   else

      is_there(2)=1;
      vsizes=[vsizes,size(xvar,1)]; 

   end;
end;

if ~isempty(namepw), 
   if isstr(pwvar),

      opterr(10,'prior weights');
      errflag = 1;
      return;
   
   else

      is_there(4)=1;
      vsizes=[vsizes,length(pwvar)]; 

   end;
end;

if ~isempty(nameos), 
   if isstr(osvar),
   
      opterr(10,'offset');
      errflag = 1;
      return;

   else

      is_there(3)=1;
      vsizes=[vsizes,length(osvar)]; 

   end;
end;

vsizes=vsizes-max(vsizes);

if any(vsizes~=0),
   GLMLAB_INFO_{24}=1;

   errstr1=[];
   errstr2=[];
   errstr3=[];
   errstr4=[];

   if is_there(1),
      errstr1=['   Length of the response (y):    ',num2str(length(yvar))];
   end;

   if is_there(2),
      errstr2=['   Length of the covariates (X):  ',num2str(size(xvar,1))];
   end;

   if is_there(3),
      errstr3=['   Length of the offset:          ',num2str(length(osvar))];
   end;

   if is_there(4),
      errstr4=['   Length of the prior weights:   ',num2str(length(pwvar))];
   end;

   bell;
   HE_=errordlg({'The fitted variables must all be the same length, but here I have:',...
           errstr1,errstr2,errstr3,errstr4}); 
   set(HE_,'WindowStyle','modal');
   set(findobj('tag','glmlab_main'),'UserData',GLMLAB_INFO_);
      errflag = 1;
   return;
end;

%Error message:

if GLMLAB_INFO_{23},
   disp(' ');
   disp(' === INFO :-| ========================================================');
   disp(' Because of errors, some variables have been changed.');
end;

%Display variables:
if GLMLAB_INFO_{7}(3),

   disp(' === INFO :-| ========================================================');

   if ~isempty(nameyv),
      disp([' Response Variable:      ',nameyv]);
   end;

   if ~isempty(cel2lstr(namexv)),
      disp([' Covariates:             ',cel2lstr(namexv)]);
   end;

   if inc_const,
      disp('    - fitting a constant term/intercept');
   end;

   if ~isempty(nameos),
      disp([' Offset Variable:        ',nameos]);
   end;

   if ~isempty(namepw),
      disp([' Prior Weights Variable: ',namepw]);
   end;

   if recycle,
      disp(' Recycling fitted values as starting values.');
   end;

end;

resetgl;

%Check for link/distribution errors:
editerrs; 

return;
