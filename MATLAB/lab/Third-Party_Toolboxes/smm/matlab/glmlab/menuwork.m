function menuwork(num,value)
%MENUWORK  Does the hard slog for option setting within  glmlab
%USE:    menuwork(num,value);
%   where  num is the section to use;
%          value  is the value of the parameter;

%Copyright 1996--1998 Peter Dunn
%02 November 1998

watchon;                               %watch on

extrctgl;                              %extract UserData info

dfname=which('dlist');                 %where to find dists
lfname=which('llist');                 %where to find links
d1=dllist(dfname,'d');                 %list of dists
l1=dllist(lfname,'l');                 %list of links

if num==1,                             %dist

   GLMLAB_INFO_{1}=value;              %current value
   set(findobj(findobj(gcf,'tag','distm'),'checked','on'),...
    'checked','off');                  %check off dist that is on
   set(findobj(findobj(gcf,'tag','linkm'),'checked','on'),...
    'checked','off');                  %check off link that is on
   set(findobj(findobj(gcf,'tag','linkm'),'Enable','off'),...
    'enable','on');                    %enable all
   set(findobj(gcf,'tag',value),...        %check on selected option
    'checked','on');
   set(findobj(gcf,'tag','quantile'),...   %initially enable quantile resids
    'Enable','on');
   set(findobj(gcf,'tag','resvxf'),...     %initially enable transform resids plot
    'Enable','off');
   set(findobj(findobj(gcf,'tag','scalem'),'checked','on'),...
    'checked','off');                  %check off scale par selection that is on
   if strcmp(value,'poisson'),         %set Poisson defaults
      set(findobj(gcf,'tag','log'),...
       'checked','on');
      set(findobj(gcf,'tag','logit'),...   %disable binomial options
       'Enable','off');
      set(findobj(gcf,'tag','probit'),...
       'Enable','off');
      set(findobj(gcf,'tag','complog'),...
       'Enable','off');
      set(findobj(gcf,'tag','val'),...
       'checked','on',...
       'Label','Fixed Value: 1');
      GLMLAB_INFO_{2}='log';           %update
      GLMLAB_INFO_{3}=1;
   elseif strcmp(value,'binoml'),      %set binomial defaults
      set(findobj(gcf,'tag','logit'),...
       'checked','on');
      set(findobj(gcf,'tag','val'),...
       'checked','on',...
       'Label','Fixed Value: 1');
      GLMLAB_INFO_{2}='logit';         %update
      GLMLAB_INFO_{3}=1;
   elseif strcmp(value,'gamma'),       %set gamma defaults
      set(findobj(gcf,'tag','logit'),...
       'Enable','off');
      set(findobj(gcf,'tag','probit'),...
       'Enable','off');
      set(findobj(gcf,'tag','complog'),...
       'Enable','off');
      set(findobj(gcf,'tag','recip'),...
       'checked','on');
      set(findobj(gcf,'tag','md'),...
       'checked','on');
      GLMLAB_INFO_{2}='recip';         %update
      GLMLAB_INFO_{3}='md';
   elseif strcmp(value,'inv_gsn'),     %inverse Gaussian defaults
      set(findobj(gcf,'tag','logit'),...
       'Enable','off');
      set(findobj(gcf,'tag','probit'),...
       'Enable','off');
      set(findobj(gcf,'tag','complog'),...
       'Enable','off');
      set(findobj(gcf,'tag','power'),...
       'checked','on');
      set(findobj(gcf,'tag','md'),...
       'checked','on');
      set(findobj(gcf,'tag','power'),...
       'Label','power: -2');
      GLMLAB_INFO_{2}=-2;              %update GLMLAB_INFO_
      GLMLAB_INFO_{3}='md';
   else                                %normal/user defaults
      if ~strcmp(value,'normal')       %user defaults
         set(findobj(findobj(gcf,'tag','linkm'),'checked','on'),...
          'checked','off');
         set(findobj(gcf,'tag','quantile'),...   %no quantile resids!
          'checked','off',...
          'enable','off');
         set(findobj(gcf,'tag','pearson'),...    %...default to pearson
          'checked','on');
         GLMLAB_INFO_{4}='pearson';          %update 
      end;
      set(findobj(gcf,'tag','resvxf'),...  %no transforming for normal/user
       'Enable','off');
      set(findobj(gcf,'tag','logit'),...   %no binomial links
       'Enable','off');
      set(findobj(gcf,'tag','probit'),...
       'Enable','off');
      set(findobj(gcf,'tag','complog'),...
       'Enable','off');
      set(findobj(gcf,'tag','id'),...      %set defaults
       'checked','on');
      set(findobj(gcf,'tag','md'),...
       'checked','on');
      GLMLAB_INFO_{2}='id';            %update
      GLMLAB_INFO_{3}='md';
   end;

   FID=fopen(GLMLAB_INFO_{8},'a');     %Update LOG file
   fprintf(FID,' Changed to: %s, %s\n',GLMLAB_INFO_{1},GLMLAB_INFO_{2});
   fclose(FID);
                                       %command window display
   disp([' * Distribution changed to ',GLMLAB_INFO_{1}]);
   disp([' * Defaults for the ',GLMLAB_INFO_{1},' distribution:']);
   if isstr(GLMLAB_INFO_{2}),
      disp(['  - Link changed to ',GLMLAB_INFO_{2}]);
   else
      disp(['  - Link changed to Power of ',num2str(GLMLAB_INFO_{2})]);
   end;
   if isstr(GLMLAB_INFO_{3}),
      disp('  - Scale Parameter changed to Mean Deviance');
   else
      disp(['  - Scale Parameter changed to ',num2str(GLMLAB_INFO_{3})]);
   end;
   watchoff;

elseif num==2, %link

   GLMLAB_INFO_{2}=value;
   if strcmp(GLMLAB_INFO_{2},'power'),    %Power link options
      OLINK=[];                           %olink is value returned of dialog box
      OLDLINKVAL=strrep(get(findobj(gcf,'tag','power'),'Label'),'power','');
                                          %old value of link mpower
      OLDLINKVAL=strrep(OLDLINKVAL,': ',''); %remove colon
      if isempty(OLDLINKVAL),
         OLDLINKVAL='1';                  %is empty, use '1'
      end;
      while isempty(OLINK)                %keep going till input is OK
         OLINK=inputdlg('Value of Power for Link Function:',...
          'Power Link Function',1,{OLDLINKVAL});
         if sum(size(OLINK))==0,
            watchoff;return;              %CANCEL PRESSED
         end; 
         OLINK=str2num(OLINK{1});         %turn value into number
      end;
      switch OLINK                        %turns powers into other links
         case 1
            GLMLAB_INFO_{2}='id';
         case 0.5
            GLMLAB_INFO_{2}='sqroot';
         case -1
            GLMLAB_INFO_{2}='recip';
      end;
      value=GLMLAB_INFO_{2};
   end;
   set(findobj(findobj(gcf,'tag','linkm'),'checked','on'),...
    'checked','off');                     %check off what link is checked on
   set(findobj('tag',value),...           %turn on power link
    'checked','on');
   if strcmp(GLMLAB_INFO_{2},'power'),
      GLMLAB_INFO_{2}=OLINK;              %
      disp([' * Link changed to power of ',num2str(GLMLAB_INFO_{2})]);
      set(findobj(gcf,'tag','power'),'Label',['power: ',num2str(GLMLAB_INFO_{2})]);
   else
      disp([' * Link changed to ',GLMLAB_INFO_{2}]);
   end;
   clear OLINK
   FID=fopen(GLMLAB_INFO_{8},'a');
   fprintf(FID,' Changed to: %s, %s\n',GLMLAB_INFO_{1},GLMLAB_INFO_{2});
   fclose(FID);
   watchoff;

elseif num==3, %resids

   set(findobj(findobj(gcf,'tag','residm'),'checked','on'),...
    'checked','off');                     %check off what resids are on
   if value==1,                           %set new value
      set(findobj(gcf,'tag','pearson'),'checked','on'); %check new type
      GLMLAB_INFO_{4}='pearson';          %update
   elseif value==2,
      set(findobj(gcf,'tag','deviance'),'checked','on');
      GLMLAB_INFO_{4}='Deviance';
   else
      set(findobj(gcf,'tag','quantile'),'checked','on');
      GLMLAB_INFO_{4}='Quantile';
   end;
   disp([' * Residual Type changed to ',GLMLAB_INFO_{4}]); %display on screen
   watchoff;

elseif num==4,                            %scale

   if value==1,                           %mean deviance
      GLMLAB_INFO_{3}='md';
   else                                   %fixed value
      OSCALEPAR=[];                       %value returned from dialog box
      OLDPARVAL=strrep(get(findobj(gcf,'tag','val'),'Label'),'Fixed Value: ','');
                                          %get last value (remove text)
      if isempty(OLDPARVAL),              %in case old value empty
         OLDPARVAL='1';
      end;
      while ( isempty(OSCALEPAR)|(OSCALEPAR<0) )   %while inapt scale par
         OSCALEPAR=inputdlg('Enter Scale Parameter:',...
          'User Defined Scale Parameter',1,{OLDPARVAL});
         if sum(size(OSCALEPAR))==0,
            watchoff; return;
         end;                             %CANCEL pressed
         OSCALEPAR=str2num(OSCALEPAR{1}); %convert to number
      end;
      GLMLAB_INFO_{3}=OSCALEPAR;          %update
      clear OSCALEPAR;
   end;
   set(findobj(findobj(gcf,'tag','scalem'),'checked','on'),'checked','off');
                                          %check off what was on
   if value==1,                           %mean deviance
      disp(' * Scale Parameter changed to Mean Deviance'); %display
      set(findobj(gcf,'tag','md'),'checked','on');           %check
   else                                   %fixed value
      disp([' * Scale Parameter changed to ',num2str(GLMLAB_INFO_{3})]);
      set(findobj(gcf,'tag','val'),'checked','on',...
       'Label',['Fixed Value: ',num2str(GLMLAB_INFO_{3})]);
   end;
   disp(' ')
   watchoff;

elseif num==7, %restore defaults

   %Turn off current checks
   set(findobj(findobj(gcf,'tag','distm'),'checked','on'),'checked','off');
   set(findobj(findobj(gcf,'tag','linkm'),'checked','on'),'checked','off');
   set(findobj(findobj(gcf,'tag','residm'),'checked','on'),'checked','off');
   set(findobj(findobj(gcf,'tag','scalem'),'checked','on'),'checked','off');
   set(findobj(gcf,'tag','normal'),'checked','on'); %normal distn
   set(findobj(gcf,'tag','id'),'checked','on');     %id link
   set(findobj(gcf,'tag','md'),'checked','on');     %mean deviance scale par
   set(findobj(gcf,'tag','quantile'),'enable','on'); %enable quantile resids
   set(findobj(gcf,'tag','pearson'),'checked','on'); %pearson resids
   set(findobj(gcf,'tag','logit'),'enable','off');  %disable binomial links
   set(findobj(gcf,'tag','probit'),'enable','off');
   set(findobj(gcf,'tag','complog'),'enable','off');
   set(findobj(gcf,'tag','val'),'Label','Fixed Value: 1'); %relabel fixed value scaled par
   set(findobj(gcf,'tag','power'),'Label','power');    %relabel power link
   set(findobj(gcf,'tag','fitinf'),'checked','off');   %display options
   set(findobj(gcf,'tag','pvals'),'checked','on');
   set(findobj(gcf,'tag','varinf'),'checked','on');
   set(findobj(gcf,'tag','recycle'),'checked','off');  %don't recycle
   set(findobj(gcf,'tag','constant'),'checked','on');  %include constant
   GLMLAB_INFO_=get(findobj(gcf,'tag','glmlab_main'),'Userdata');  %update
   old_status=GLMLAB_INFO_{25};                    %warning message status
   set(findobj(gcf,'tag',['ws_',old_status]),'Checked','off'); %check off
   warning backtrace                            %reset backtrace
   set(findobj(gcf,'tag','ws_backtrace'),'Checked','on'); %check on

   GLMLAB_INFO_{1}='normal';                    %update
   GLMLAB_INFO_{2}='id';
   GLMLAB_INFO_{3}='md';
   GLMLAB_INFO_{4}='pearson';
   GLMLAB_INFO_{7}=[0 1 1];
   GLMLAB_INFO_{5}=0;
   GLMLAB_INFO_{6}=1;
   GLMLAB_INFO_{25}='backtrace';
   disp(' * Defaults Restored:');                 %display new settings
   disp('  - Distribution set to normal');
   disp('  - Link set to id');
   disp('  - Scale parameter set to mean deviance'); 
   disp('  - Residual Type set to Pearson');
   disp('  - Constant included in the model');
   disp(' ');
   watchoff;

elseif num==8,                                  %new model

   replyq=questdlg(['Declaring a new model will reset all ',...
                    'settings.  Continue?']);
   if strcmp(replyq,'Yes')                      %continue...
      newmodel;
      menuwork(7);
   else                                         %cancel...
      watchoff;
   end;

   return;

elseif num==21,                                 %Save model

   ddir=which('dummylog.m');                    %Find default directory
   ddir=strrep(ddir,'dummylog.m','');           %just get directory
   [filename,pathname]=uiputfile([ddir,'*.glg'],'Save glmlab Model');
                                                %Name of file to save as

   %Ensure that  filename  has a glg suffix
   if ~isempty(filename)
      filename = deblank(filename);             %remove any trailing blanks
      if length(filename)<5,
         filename = [ filename, '.glg' ];
      end
      if ~strcmp( filename(end-3:end) , '.glg'), %if  glg  not the suffix...
         filename = [ filename, '.glg' ];       %...then make it the suffix
      end
   end

   %Save workspace as mat file, GLMLAB_INFO as glg file
   GLI = GLMLAB_INFO_;GLI
   GLI{8} = [];                                 %remove DETAILS file path
   savename=[pathname,filename];                %construct file/path
   savename=['''',savename,''''];               %add quotes
   stop=0;                                      %default
   if pathname==0;                              %if cancel pressed...
      stop=1;                                   %...flag stop as 1
   end;
   if ~logical(stop),                           %if cancel not pressed
      glgfname=savename;                        %*.glg file name
glgfname
      matfname=strrep(glgfname,'.glg','.mat');  %*.mat file name
      evalin('base',['save(',matfname,');']);   %save!
      eval(['save ',glgfname,' GLI;'],'whoa=0');         %Save GLMLAB_INFO_
   end;
   watchoff;

elseif num==22, %Load model
                                                %Confirm
   replyq=questdlg(['Loading a model over-writes the current ',...
                   'settings.  Continue?'],...
                   'Load a glmlab Model');
   if ~strcmp(replyq,'Yes')                     %return if not continue
      watchoff;return;
   end;

   ddir=which('dummylog.m');                    %Find default directory
   ddir=strrep(ddir,'dummylog.m','');           %get path
   [filename,pathname]=uigetfile([ddir,'*.glg'],'Load glmlab Model');
                                                %Get file to load
   stop=0;                                      %Load workspace
   loadstr=[pathname,filename];                 %get path/file

   if pathname==0,
      stop=1;
   end;

   if ~logical(stop),
      stop = 0;
      glgfname=loadstr;                         %*.glg file name
      eval(['load ',glgfname,' -mat'],'stop=1;'); %Load GLMLAB_INFO_ (glg file)
      if exist('GLI')                           %for past compatibility
         GLMLAB_INFO_ = GLI;
      end

      GLMLAB_INFO_{8} = [ deblank(ddir),'DETAILS.m' ];

      matfname=strrep(glgfname,'.glg','.mat');  %Load workspace mat file
      evalin('base',['load ',matfname],'stop=1;'); %load!

      if logical(stop),                         %if error 
         errordlg('Error loading file!');       %error message
      else                                      %if OK
         set(findobj(gcf,'tag','HYV'),...           %Restore variable names
          'String',GLMLAB_INFO_{9});
         set(findobj(gcf,'tag','HXV'),...
          'String',deblank(GLMLAB_INFO_{10}));
         set(findobj(gcf,'tag','HPW'),...
          'String',GLMLAB_INFO_{11});
         set(findobj(gcf,'tag','HOS'),...
          'String',GLMLAB_INFO_{12});
   
         menuwork(1,GLMLAB_INFO_{1});           %Restore distribution
      
         if isstr(GLMLAB_INFO_{2}),             %Restore link
            menuwork(2,GLMLAB_INFO_{2});
         else                                   %power link
            set(findobj(findobj(gcf,'tag','linkm'),'checked','on'),...
             'checked','off');                  %uncheck
            set(findobj(gcf,'tag','power'),...      %label, check
             'Label',['power: ',num2str(GLMLAB_INFO_{2})],...
             'Checked','on');
            disp([' * Link changed to power of ',num2str(GLMLAB_INFO_{2})]);
         end
      
         res=lower(GLMLAB_INFO_{4});         %Restore residuals
         if strcmp(res,'pearson'),
            menuwork(3,1);
         elseif strcmp(res,'deviance'),
            menuwork(3,2);
         else
            menuwork(3,3);
         end;
         
         if isstr(GLMLAB_INFO_{3}),         %Restore scale parameter
            menuwork(4,1);
         else
            set(findobj(gcf,'tag','val'),...
             'Checked','on',...
             'Label',['Fixed Value: ',num2str(GLMLAB_INFO_{3})]);
            set(findobj(gcf,'tag','md'),'Checked','off');
         end
      
         if GLMLAB_INFO_{6},          %include constant
            set(findobj(gcf,'tag','constant'),'Checked','on');
         else
            set(findobj(gcf,'tag','constant'),'Checked','off');
         end
      
         allowfm=1;                    %Allow fit model?
         if isempty(GLMLAB_INFO_{9}),
            allowfm=0;                 %no y var
         end;
         if isempty(GLMLAB_INFO_{10}),
            if GLMLAB_INFO_{6}==0,
               allowfm=0;              %no x-value
            end;
         end
         if logical(allowfm),          %allow
            set(findobj(gcf,'String','FIT SPECIFIED MODEL'),'Enable','on');
         else                          %disallow
            set(findobj(gcf,'String','FIT SPECIFIED MODEL'),'Enable','off');
         end
      end;
   end;

   drawnow;
      
   watchoff;

elseif num==23,                        %Load data

   evalin( 'base',['LOADDIR_ = strrep(which(''dummydta''),',...
                   ' ''dummydta.m'',''*.mat'');'] ); 
   evalin('base', '[AA_, BB_] = uigetfile(LOADDIR_,''Load Data'');' );
   evalin('base', 'load([BB_,AA_]);opterr(7,AA_);', 'opterr(6);');
   evalin('base', 'clear LOADDIR_ AA_ BB_');

elseif num==40,                        %Setting options

   if value==1,                        %display information
      if strcmp(get(findobj(gcf,'tag','fitinf'),'checked'),'on'),
         set(findobj(gcf,'tag','fitinf'),'checked','off');
         GLMLAB_INFO_{7}(1)=0;         %update
      else
         set(findobj(gcf,'tag','fitinf'),'checked','on');
         GLMLAB_INFO_{7}(1)=1;
      end;
   elseif value==2,
      if strcmp(get(findobj(gcf,'tag','pvals'),'checked'),'on'),
         set(findobj(gcf,'tag','pvals'),'checked','off');
         GLMLAB_INFO_{7}(2)=0;
      else
         set(findobj(gcf,'tag','pvals'),'checked','on');
         GLMLAB_INFO_{7}(2)=1;
      end;
   elseif value==3,
      if strcmp(get(findobj(gcf,'tag','varinf'),'checked'),'on'),
         set(findobj(gcf,'tag','varinf'),'checked','off');
         GLMLAB_INFO_{7}(3)=0;
      else
         set(findobj(gcf,'tag','varinf'),'checked','on');
         GLMLAB_INFO_{7}(3)=1;
      end;
   elseif value==4,                       %recycling
      if strcmp(get(findobj(gcf,'tag','recycle'),'checked'),'on'),
         set(findobj(gcf,'tag','recycle'),'checked','off');
         GLMLAB_INFO_{5}=0;
      else
         set(findobj(gcf,'tag','recycle'),'checked','on');
         GLMLAB_INFO_{5}=1;
      end;
   end;
   disp(' * Options altered');
   watchoff;

elseif num==50,                           %Quit  glmlab and Loose Settings

   replyq=questdlg(['Do you really want to quit  glmlab  ',...
                   'and lose all settings?'],...
                   'Quitting  glmlab');

   if strcmp(replyq,'Yes'),
      watchoff;
      delete(findobj('Name','glmlab Main Window')); %delete glmlab window
   else
      watchoff;
   end;

elseif num==65,                           %Quit MATLAB

   replyq=questdlg(['Do you really want to quit  MATLAB  ',...
                   'and lose everything?'],...
                   'Quit  MATLAB');
   if strcmp(replyq,'Yes'),
      quit
   else
      watchoff;
   end;

elseif num==70,                           %toggle constant

   if strcmp(get(findobj(gcf,'tag','constant'),'checked'),'on'),
                                          %don't include constant
      set(findobj(gcf,'tag','constant'),'checked','off');
      GLMLAB_INFO_{6}=0;                  %update
      disp(' * Constant Term now omitted from the model');
   else                                   %include constant
      set(findobj(gcf,'tag','constant'),'checked','on');
      GLMLAB_INFO_{6}=1;
      disp(' * Constant Term now included in the model');
   end;
   watchoff;
   return;

elseif num==75,                           %Warning Status

   GLMLAB_INFO_=get(findobj(gcf,'tag','glmlab_main'),'Userdata');
   old_status=GLMLAB_INFO_{25};           %turn off old status
   set(findobj(gcf,'tag',['ws_',old_status]),'Checked','off');
   new_status=value;
   eval(['warning ',new_status]);         %new status
   set(findobj(gcf,'tag',['ws_',new_status]),'Checked','on');
   GLMLAB_INFO_{25}=new_status;           %update
   watchoff;

elseif num==80,                           %Fitting Parameters

   [tol,maxits,illctol]=paramtrs;         %current values
   retry=1;                               %flag for valid values
   while (retry),
      retry=0;
      userp=inputdlg({'Maximum Number of Iterations (default=20):',...
                'Parameter Accuracy (default=5e-05):',...
                'Ill Conditioning Tolerance (default=1e-10):'},...
                'Fitting Parameters',[1 1 1],{maxits,tol,illctol});
      if isempty(userp),                  %cancel pressed
         retry=0;
         nmaxits=maxits;                  %set to old values
         ntol=tol;
         nillctol=illctol;
      else
         nmaxits=str2num(userp{1});
         ntol=str2num(userp{2});
         nillctol=str2num(userp{3});
         if any([isempty(ntol),isempty(nmaxits),isempty(nillctol)]),
            retry=1;
         end;
         if (ntol<=0)|(ntol>1),           %tolerance out of range
            warnstr=' tolerance for parameter accuracy ';
            retry=1;
         end;
         if (nmaxits<=0)|(nmaxits>10000), %num its out of range
            warnstr=' maximum number of iterations ';
            retry=1;
         end 
         if (nillctol<=0)|(nillctol>0.1), %ill conditioning out of range
            warnstr=' ill-conditioning tolerance ';
            retry=1;
         end   
      end;
      if retry,                           %Warning dialog
         HE=errordlg(['The given',warnstr,'is inadequate; please try again.']);  
         set(HE,'WindowStyle','modal');
         uiwait(HE);retry=1;      
      end
   end
   paramtrs(nmaxits,ntol,nillctol);       %set new values
   watchoff;

end;

%Mostly, if menuwork is called, it's probably a good time to turn off the
%residual plots button, as the model specified is not the model for which
%residual plots will be printed.  But there are exceptions:
if ~((num==8)|(num==50)|(num==40)|(num==65)),
   set(findobj(gcf,'tag','rplots'),'Enable','off');
end;

if (num~=65)&(num~=50),

   if ((GLMLAB_INFO_{6}==0)&(isempty(GLMLAB_INFO_{10}))) ...
       | isempty(GLMLAB_INFO_{9}),
      set(findobj(gcf,'String','FIT SPECIFIED MODEL'),'Enable','off');
   else
      set(findobj(gcf,'String','FIT SPECIFIED MODEL'),'Enable','on');
   end;

   resetgl;                            %reset UserData 

   drawnow;

end;

return;
