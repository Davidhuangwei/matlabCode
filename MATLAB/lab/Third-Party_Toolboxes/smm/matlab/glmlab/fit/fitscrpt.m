%FITSCRPT The script called for fitting the model

%Copyright 1996--1998 Peter Dunn
%31 August 1998

GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');   %get data
XMATRIX=GLMLAB_INFO_{15};			%get X matrix
if GLMLAB_INFO_{6} == 1,                        %add constant if necessary
   XMATRIX = [ ones( size(XMATRIX,1), 1 ), XMATRIX ];
end;

if ~isempty(GLMLAB_INFO_{14}),

   evalin('base','errflag=varok;');			%Ensure vars are OK

   if ( errflag==0 ),
      GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');

      if ~GLMLAB_INFO_{24},
         [BETA SERRORS FITS RESIDS COVB COVD DEVLIST LINPRED XVARNAMES]=glmfit;
      else
         errordlg(['Some error that I can''t identify exists, ',...
                  'probably in the variables.  (Sometimes using ',...
                  'MATLAB functions cause this error.)'],'Error!');

      end;

   end;

end;

GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');

%reset flags
GLMLAB_INFO_{24}=0;
GLMLAB_INFO_{23}=0;

resetgl;

watchoff;

clear GLMLAB_INFO_
