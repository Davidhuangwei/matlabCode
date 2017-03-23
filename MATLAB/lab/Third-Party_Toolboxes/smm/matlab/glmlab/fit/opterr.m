function opterr(num,message)
%OPTERR Some error message for use in  glmlab

%Copyright 1996, 1997 Peter Dunn
%29/05/1997

bell;

if num==1,
   HE=errordlg([' There are no suitable variables in the workspace.  Please define '...
        'some variables, or load a data file.']);
elseif num==2,
   HE=errordlg([' The variable ',message,' has negative values which are not',...
       ' allowed!  Please try another variable name for the prior weights.']);
elseif num==4,
   HE=errordlg({'MATLAB says:',message,' ',['This error message could be cryptic.  ',...
             ' Something is wrong with one of the inputs; ',...
             ' check for matching braces and so on.']});
elseif num==5,
   HE=errordlg(['The variable  ',message,'  is all zero, which means that no',...
      ' points at all are being fitted.  Please try another variable',...
      ' name for the prior weights.']);
elseif num==6,
%   if isstr(message),

%      if isempty(message),

         HE=errordlg(['There was some problem.  You may have pressed ',...
            'CANCEL.  If not, the file you wish to load may not exist. ',...
            'If it does, then MATLAB cannot read the file. ',...
            'If these are not the problem, then sorry, but I can''t help!']);

%      else
%
%         HE=errordlg(['The data file called  ',message,...
%            '  is in a format that  MATLAB  can''t understand.']);
%
%      end;
%
%   else
%      HE=errordlg(['There was either an error, or you pressed CANCEL.',...
%         '  If there was an error, please try again, being very careful.']);
%   end;

elseif num==7,
   HE=warndlg(['The file named  ',message,'  was successfully loaded.'],...
      'File successfully loaded');
elseif num==8,
   HE=errordlg(['The user-defined link function ',message,' does not have an associated ',...
      'file in the  link  directory.  Please create a file or use another link function.']);
elseif num==9,
   HE=errordlg(['The user-defined error distribution ',message,' does not have an associated ',...
      'file in the  dist  directory.  Please create a file or use another error distribution.']);

elseif num==10,
   HE=errordlg([' I can''t understand the ',message,' variable!  ',...
      'Check brackets are matching, and so on.']);
end;

set(HE,'WindowStyle','modal');
watchoff(findobj('tag','glmlab_main'));
