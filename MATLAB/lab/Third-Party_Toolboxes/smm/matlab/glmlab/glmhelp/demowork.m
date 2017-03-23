%DEMOWORK Does the work for the  glmlab  demo

%Copyright 1997 Peter Dunn
%18 October 1997

global GLMDEMO_NUM_ GLMDEMO_STEP_

DT=findobj('tag','demotext');
GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData'); 
GLMLAB_INFO_{6}=1;

if GLMDEMO_NUM_==1, %next step
   switch GLMDEMO_STEP_
      case -1
         demostring={'This demo is rather brief and not very special.','',...
                     ['glmlab has a lot of features that you can explore; this demo will ',...
                      'hopefully get you started.']};
      case 0
         demostring='The first step is usually to load data.';
      case 1
         demostring='This can be done from  glmlab''s FILE menu or from the  MATLAB  prompt.';
      case 2
         demostring='Let''s define some variables at the  MATLAB  prompt and play with them.';
     case 3
         demostring={'At the  MATLAB  prompt, we could type','  >> fuelcon=[10.1  13.3  14.6  16.1  18.2]'';',...
               '  >> km100=[1.3  2.3  1.4  3.8  2.3]'';','  >> mintemp=[-9  -1  5  4  11]'';'};
         echo on;
fuelcon=[10.1 13.3 14.6 16.1 18.2]';
km100=[1.3 2.3 1.4 3.8 2.3]'; 
mintemp=[-9 -1 5 4 11]';
         echo off;
      case 4
         demostring='This declares three variables:  fuelcon, km100 and mintemp.';
      case 5
         demostring={'Suppose that we now wanted to fit the multiple regression model',...
                     ' fuelcon = \beta_0 + \beta_1 km100',' + \beta_2 mintemp.'};
      case 6
         demostring=['For this model, the response variable is  fuelcon, so we enter  fuelcon',...
            '  in the window labelled   Response (y):'];
         GLMLAB_INFO_{9}='[fuelcon]';GLMLAB_INFO_{14}=[10.1 13.3 14.6 16.1 18.2]';
         set(findobj('tag','HYV'),'String','fuelcon');yvarcont;
         GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');
      case 7
         demostring=['Likewise, the covariates are  km100  and  mintemp, so these are entered',...
            ' in the window labelled   Covariates (X):  on separate lines.'];
         GLMLAB_INFO_{10}='[km100, mintemp]';
         GLMLAB_INFO_{15}=[[1.3 2.3 1.4 3.8 2.3]',[-9 -1 5 4 11]'];
         GLMLAB_INFO_{13}=str2mat(pad('km100',27),'mintemp');
         set(findobj('tag','HXV'),'String',lstr2cel('km100, mintemp'));
         set(findobj('tag','glmlab_main'),'UserData',GLMLAB_INFO_);
         xvarcont;
         GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');
      case 8
         demostring='To fit the model, we then press the button below labelled  FIT SPECIFIED MODEL';
         set(findobj('tag','HVY'),'String','fuelcon');
     case 9
         demostring='This produces output in the MATLAB command window.  Have a look if you like.';
         varok;
         GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');
         %make sure the options are all set OK (dist, link, etc...)
         %The user, smart, could have fiddled them you see.
         GLMLAB_INFO_{1}='normal';
         GLMLAB_INFO_{2}='id';
         GLMLAB_INFO_{3}=1;
         GLMLAB_INFO_{4}='pearson';
         GLMLAB_INFO_{5}=0;
         GLMLAB_INFO_{6}=1;
         GLMLAB_INFO_{7}=[0 1];
         GLMLAB_INFO_{20}=[];
         GLMLAB_INFO_{21}=[];
         set(findobj('tag','glmlab_main'),'UserData',GLMLAB_INFO_);
         glmfit;
      case 10
         demostring='That was pretty basic stuff.  There is a lot more that  glmlab  can do.';
      case 11
         demostring=['We can also have qualitative data (or factors).  This is data',...
            ' that can only have distinct values--like, for example, gender.'];
      case 12
         demostring={['We could use a  1  to represent males, and a  2  to represent females.',...
                  '  Then we can define a new variable:'],'  >> gender=[1  2  2  1  2]'';'};
         echo on;
gender=[1 2 2 1 2]';
         echo off;
      case 13
         demostring=['In this variable, the 1''s and 2''s are not really numerical; they ',...
             'just indicate which people are males and females.'];
      case 14
         demostring=['To use the factor  gender  in the model, we need to use the  glmlab  command',...
             '  fac  .  To include gender, we therefore enter  fac(gender).',...
             '  Then press  FIT SPECIFIED MODEL'];
         GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');
         GLMLAB_INFO_{10}='km100, mintemp, fac(gender)';
         GLMLAB_INFO_{15}=[km100 mintemp fac(gender)];
         GLMLAB_INFO_{13}=str2mat(pad('km100',27),'mintemp','fac(gender)');
         set(findobj('tag','HXV'),'String','km100, ,mintemp, fac(gender)');xvarcont;
         GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');
         GLMLAB_INFO_{1}='normal';
         GLMLAB_INFO_{2}='id';
         GLMLAB_INFO_{3}=1;
         GLMLAB_INFO_{4}='pearson';
         GLMLAB_INFO_{5}=0;
         GLMLAB_INFO_{6}=1;
         GLMLAB_INFO_{7}=[0 1];
         GLMLAB_INFO_{20}= 0.431144;
         GLMLAB_INFO_{21}=2;
         glmfit;
         set(findobj('tag','glmlab_main'),'UserData',GLMLAB_INFO_);
         GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');
      case 15
         demostring=['We can also include interaction between variables using the  @  ',...
               'symbol.  Simply place a  @  between any number of variables.'];
      case 16
         demostring=['To include the interaction between  gender  and  km100, we would',...
               ' enter  km100@fac(gender).  (Remember that  gender  is qualitative!)'];
      case 17
         demostring='Suppose we now wish to include  km100@fac(gender)  and  km100  as covariates.';
         GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');
         GLMLAB_INFO_{10}='km100, mintemp, fac(gender), fac(gender)@km100';
         GLMLAB_INFO_{15}=[km100 mintemp fac(gender) interact(fac(gender),km100)];
         GLMLAB_INFO_{13}=str2mat(pad('km100',27),'fac(gender)','fac(gender)@km100');
         set(findobj('tag','HXV'),'String','km100, fac(gender), fac(gender)@km100');xvarcont;
         GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');
         GLMLAB_INFO_{1}='normal';
         GLMLAB_INFO_{2}='id';
         GLMLAB_INFO_{3}=1;
         GLMLAB_INFO_{4}='pearson';
         GLMLAB_INFO_{5}=0;
         GLMLAB_INFO_{6}=1;
         GLMLAB_INFO_{7}=[0 1];
         GLMLAB_INFO_{20}=0.393429;
         GLMLAB_INFO_{21}=1;
         glmfit;
         set(findobj('tag','glmlab_main'),'UserData',GLMLAB_INFO_);
      case 18
         demostring=['We could also have more involved interactions; for example ',...
               ' fac(gender)@mintemp@km100.'];
      case 19
         demostring={['After fitting a model,  glmlab  creates ten variables in the workspace',...
               ' with which to play.  These include'],'FITS (the fitted values);'};
      case 20
         demostring={'RESIDS (the residuals);',[' COVB (the cov. matrix of parameter ',...
               'estimates);'],'BETA (the parameter estimates);','SERRORS (the standard deviation of parameter estimates)'};
      case 21           
         demostring=['glmlab  of course can do much more; it can handle generalised ',...
            'linear models where the data may have non-normal distributions.'];
      case 22
         demostring=['glmlab allows distributions such as gamma, Poisson, binomial ',...
            'or inverse Gaussian distributions.  You can even define your own!'];
      case 23
         demostring=['Distributions, link functions, scale parameters and residuals ',...
            'can all be set by choosing the appropriate menu at the top of the screen.'];
      case 24
         demostring=['The menus also allows the user to set all sort of options, and ',...
            'obtain some basic help.'];
      case 25
         demostring=['I hope you enjoy using  glmlab.  It is meant to be easy to use, ',...
            'so hopefully this demo has given you enough info to get started.'];
      case 26
         set(findobj('String','Next Step...'),'String','RESTART');
         demostring={['Press the  QUIT DEMO  button to quit the demo and use  glmlab  ',...
            'as usual; or'],'press  RESTART  to start the demo again'};
      end
      if GLMDEMO_STEP_==27, 
        demostring={' ','glmlab DEMONSTRATION'};
        GLMDEMO_STEP_=-2; 
        set(findobj('String','RESTART'),'String','Next Step...');
      end;
      set(DT,'String',demostring);
      set(findobj('tag','glmlab_main'),'Userdata',GLMLAB_INFO_);
elseif GLMDEMO_NUM_==2, %QUIT DEMO
   %remove demo buttons
   delete(findobj('tag','demonext'));
   delete(findobj('tag','demotext'));
   delete(findobj('tag','demoquit'));
   set(findobj('tag','gldemo'),'Enable','on');
   set(findobj('String','FIT SPECIFIED MODEL'),'Callback','fitscrpt');
   set(findobj('tag','glmlab_main'),'UserData',GLMLAB_INFO_);
   set(findobj('String','RESIDUAL PLOTS...'),'Callback','glmplot;return;');
   set(findobj('String','FIT SPECIFIED MODEL'),'Enable','off');
   newmodel;
   clear global GLMDEMO_STEP_ GLMDEMO_NUM_
   clear GLMLAB_INFO_ DT demostring  
   %Leave fuecon etc in case user wants to play with them.
end
