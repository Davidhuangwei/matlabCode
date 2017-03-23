function errflag=editerrs
%EDITERRS  Error messages for errors in edit ui's in  glmlab

%Copyright 1997 Peter Dunn
%28 April 1997

errflag=0;
extrctgl;

[yrows,ycols]=size(yvar);            	%Check number of columns of y

if isempty(pwvar), 
   pwvar=ones(size(yvar,1),1); 		%Make up a prior weight of ones
end;

if yrows<ycols, 
   yvar=yvar';				%Make each row an observation
   [yrows,ycols]=size(yvar);
end;

ylen=length(yvar);

%Do some more fiddling and error checks:
if ycols>2,				%more than two columns is an error

   bell;
   HE=errordlg(['The response variable should be a single column vector (or, in the',...
         ' case of a binomial variable, have two columns).  Your response',...
         ' variable, however, has ',num2str(ycols),' columns... and',...
         ' I don''t know what to do with such an input!'],...
         'Wrong number of columns in response','replace');
   errflag=1;
   set(HE,'WindowStyle','modal');

elseif ycols==2, 			%set up for binoml

   m=yvar(:,2);
   yvar=yvar(:,1);

   if ~strcmp(errdis,'binoml'),		%message if binomial not selected
      HW=errordlg([' The response variable is not set up for a normal ',...
            'distribution--the response should be one column only.  ',...
            'Two columns in the response variable are only for binomial distributions.'],...
            'Wrong number of columns in response','replace');
      set(HW,'WindowStyle','modal');
      errflag=1;
   end;

   if strcmp(errdis,'binoml'),
      if any( m<yvar ), m=[]; 		%somewhere there are more obs than sample
         bell;HE=errordlg([' There is an error with the vector of sample sizes',...
               ' (that is, the second column of the response variable)!',...
               '  The number of observations can''t be more than the',...
               ' sample size!  Please check the input.'],...
               'Response variable error','replace');
         set(HE,'WindowStyle','modal');
         errflag=1;
      end;
   end;

else 					%one column; not binomial

   if strcmp(errdis,'binoml'),

      if ~(all(yvar>=0)&all(yvar<=1)),
         HW=errordlg({['The response variable is not set up for a binomial ',...
               'distribution---two columns are needed: '],...
               '        [the counts   the sample sizes].  ',...
               ['If one column is used for the binomial distribution, all elements must ',...
               'be between 0 and 1 (ie probabilities).']},...
               'Response variable error','replace');
         set(HW,'WindowStyle','modal');
         errflag=1;
      end;

   end;

end;

%Ensure no negative responses for Poisson distribution
if strcmp(errdis,'poisson'),

   if any(pwvar.*yvar<0),
      HE=errordlg([' For the Poisson distribution, responses must all',...
            ' be non-negative.  Some responses are negative.'],...
            'Response variable/Distribution incompatibility!','replace');
      set(HE,'WindowStyle','modal');
      errflag=1;bell;
   end;

end;

%Ensure *positive* responses for gamma and inverse Gaussian
if strcmp(errdis,'gamma')|strcmp(errdis,'inv_gsn'),

   if any((~(yvar>0)).*pwvar),
      HE=errordlg([' For the ',errdis,' distribution, responses must all',...
         ' positive.  Some responses are non-positive.'],...
         'Response variable/Distribution incompatibility!','replace');
      set(HE,'WindowStyle','modal');bell;
      errflag=1;
   end;

end;

%Ensure non-negative responses for square root link 
if strcmp(link,'sqroot')&any(yvar.*pwvar<0),

   HE=errordlg([' For the square root link function, all responses must be',...
      ' non-negative.  Some negative responses are present.'],...
      'Link function error!','replace');
   set(HE,'WindowStyle','modal');bell;
   errflag=1;

end;

%Ensure recip link has no zero responses
if strcmp(link,'recip')&any(yvar.*pwvar==0),

   HE=errordlg([' For the reciprocal link function, all responses must be',...
      ' non-zero.  Some zero responses are present.'],...
      'Link function error!','replace');
   set(HE,'WindowStyle','modal');bell;
   errflag=1;

end;

%Ensure log link has no zero responses
if strcmp(link,'log')&any(yvar.*pwvar<0),

   bell;HE=errordlg([' The log link requires that the response variable is always',...
      ' non-negative.  Some non-positive responses are present.'],...
      'Link function error','replace');
   set(HE,'WindowStyle','modal');
   errflag=1;

end;

set(findobj('tag','glmlab_main'),'UserData',GLMLAB_INFO_);
