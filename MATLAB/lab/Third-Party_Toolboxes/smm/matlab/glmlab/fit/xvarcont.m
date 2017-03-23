%XVARCONT   Control of the X-variable naming in glmlab

%Copyright 1996, 1997 Peter Dunn
%31 August 1998

watchon;

%Obtain all the info
GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'Userdata');

%Store the current string
OLDXVARS=GLMLAB_INFO_{15};

GLMLAB_INFO_{22}=1;
if ~isempty(get(findobj('tag','HXV'),'String')),

   if isempty(GLMLAB_INFO_{10}), 
      GLMLAB_INFO_{10}=''; 
   end;

   OLDNAMEXV=cellstr(GLMLAB_INFO_{10});
   GLMLAB_INFO_{10}=cellstr(get(findobj('tag','HXV'),'String'));
   GLMLAB_INFO_{10}=fixmeup(GLMLAB_INFO_{10}); 
         %The xvar list as on screen all fixed up

   LGLM10=cel2lstr(GLMLAB_INFO_{10}); %In line string
   CGLM10=lstr2cel(GLMLAB_INFO_{10}); %Cell array

   if isnumeric(CGLM10),     %error
      GLMLAB_INFO_{24} = 1; %flag as error
      set(findobj('tag','HXV'),'String',OLDNAMEXV);
      resetgl;
      return; 
   end;
   RUNNAMEXV=strrep(LGLM10,'@',','); %The var list less interactions...
                                     %for making sure all the vars are legit
   eval('GLMLAB_INFO_{15}=evalin(''base'',[''['',RUNNAMEXV,'']'']);',...
        'GLMLAB_INFO_{15}=['' '',lasterr];');

   if isstr(GLMLAB_INFO_{15}),
      opterr(4,GLMLAB_INFO_{15}); 
      GLMLAB_INFO_{10}=OLDNAMEXV;
   else
      set(findobj('tag','HXV'),'String',deblank(CGLM10));
      LGLM10=[ '[' LGLM10 ']' ];
      if ~isempty(str2num(RUNNAMEXV)),
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %THE x-VARIABLES ARE LISTED AS NUMBERS, NOT BY A MATLAB VAR NAME%
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         GLMLAB_INFO_{13}=[];
 
         for THISI=1:size(str2num(LGLM10),2),
            GLMLAB_INFO_{13}=str2mat(GLMLAB_INFO_{13},['Var ',num2str(THISI)]);
         end;

         clear THISI

         if isempty(GLMLAB_INFO_{13}),
            bell;watchoff;GLMLAB_INFO_{24}=1;
            disp(' === ERROR :-< =======================================================');
            HE=errordlg([' Sorry, but I couldn''t process the x-variables.  ',...
               'Please define variables, and use variable names in',...
               ' the glmlab window.']);
            set(HW,'WindowStyle','modal');
            set(findobj('tag','glmlab_main'),'UserData',GLMLAB_INFO_);
            clear GLMLAB_INFO_
            GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'Userdata');
            return;
         else
            GLMLAB_INFO_{13}(1,:)=[];
         end;

      else 

         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %USE THE NAMES OF THE VARIABLES; REQUIRES A LOT OF FIDDLING%
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

         %First, obtain a list version of NAMEXV
         % Removes repeats of variable names first:
         DUP=rpeatstr(lstr2cel(CGLM10));
         CGLM10=CGLM10(~DUP,:);
         clear DUP

         LGLM10=[ '[' cel2lstr(CGLM10) ']' ];
         [INTROWS,FACROWS,OTHERROWS,SORTLIST]=findvars(LGLM10);

         GLMLAB_INFO_{10}=SORTLIST;
         set(findobj('tag','glmlab_main'),'UserData',GLMLAB_INFO_);
         set(findobj('tag','HXV'),'String',deblank(GLMLAB_INFO_{10}));

         %Remove occurences of the same variable appearing more than once:
         DUP=rpeatstr(SORTLIST);
         SORTLIST=SORTLIST(~logical(DUP),:);
         clear DUP

         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %Now we have:                                                  %
         % SORTLIST  is  the variables sorted in the order:             %
         %     OTHERROWS FACROW INTROWS                                 %
         %    (eg:  x1                                                  %
         %          fac(f2)                                             %
         %          fac(f2)@fac(f4)   )                                 %
         % INTROWS contains the row numbers with INTeractions, etc...   %
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

         %Fix up XVARS properly now:
         if strcmp(get(findobj('tag','constant'),'checked'),'on'),
            GLMLAB_INFO_{6}=1;CONEQUIV=1;
                %CONEQUIV=1  if the constant term (or equivalent) is present
         else
            GLMLAB_INFO_{6}=0;CONEQUIV=0;
         end;

         [DUMMY,INTORDER]=findmat(SORTLIST,'@');
         clear DUMMY
         EVALLIST=SORTLIST;   %EVALLIST will soon be eval-able, line by line
         GLMLAB_INFO_{15}=[]; %Contains the X matrix
         GLMLAB_INFO_{13}=[]; %Contains the names to print in the output
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %ROWS containing only QUANTITATIVE variables%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        for II=OTHERROWS,
            GLMLAB_INFO_{15}=[GLMLAB_INFO_{15},eval(EVALLIST(II,:))];
            GLMLAB_INFO_{13}=str2mat(GLMLAB_INFO_{13},SORTLIST(II,:));
         end;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Now ROWS containing only QUALITATIVE variables%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

         for II=FACROWS,
            [CONEQUIV,EVALLIST]=facfidle(1,II,CONEQUIV,SORTLIST,EVALLIST);
            ADDX=eval(EVALLIST(II,:));
            [GLMLAB_INFO_{13},GLMLAB_INFO_{15}]=facfidle(2,II,ADDX,SORTLIST,...
                                      GLMLAB_INFO_{15},EVALLIST,GLMLAB_INFO_{13});
         end;

         clear OTHERROWS FACROWS
         SEPLIST='|'; %SEPLIST is the var list, vars separated by  |

         for I=1:size(SORTLIST,1),
            SEPLIST=[SEPLIST,deblank(SORTLIST(I,:)),'|'];
         end;

         for II=INTROWS, %for each row containing interaction terms...
            INTTERM=preint(SORTLIST,II);
            eval(['[INTX,INDVEC]=interact(',deblank(INTTERM),');']);
            %Now delete the appropriate rows from INDVEC and cols
            %from  INTX  using  loseint
            [GLMLAB_INFO_{13},INTX,GLMLAB_INFO_{15},CONEQUIV]=loseint(...
                  SORTLIST(II,:),SEPLIST,INTX,INDVEC,GLMLAB_INFO_{15},...
                  GLMLAB_INFO_{13},CONEQUIV);
         end;
         clear INTROWS
         GLMLAB_INFO_{13}(1,:)=[];
      end;
   end;

else

   OLDNAMEXV=GLMLAB_INFO_{10};
   GLMLAB_INFO_{10}=get(findobj('tag','HXV'),'String');
   GLMLAB_INFO_{15}=[];
   GLMLAB_INFO_{10}='';

end;

NEWNAMELIST=[];
for II=1:size(GLMLAB_INFO_{13},1),
   NEWROW=strrep(GLMLAB_INFO_{13}(II,:),'fac(',''); 
   NEWROW=strrep(NEWROW,')(','(');
   NEWNAMELIST=str2mat(NEWNAMELIST,NEWROW);
end;

if ~isempty(NEWNAMELIST), 
   GLMLAB_INFO_{13}=NEWNAMELIST;
   GLMLAB_INFO_{13}(1,:)=[]; 
end;

set(findobj('tag','glmlab_main'),'UserData',GLMLAB_INFO_);
if ((GLMLAB_INFO_{6}==0)&(isempty(GLMLAB_INFO_{10}))) | isempty(GLMLAB_INFO_{9}),
   set(findobj('String','FIT SPECIFIED MODEL'),'Enable','off');
   set(findobj('tag','rplot'),'Enable','off');
else %empty XVar string
   set(findobj('String','FIT SPECIFIED MODEL'),'Enable','on');
   set(findobj('tag','rplot'),'Enable','on');
end;

if ((GLMLAB_INFO_{6}==0)&(isempty(GLMLAB_INFO_{10}))) | isempty(GLMLAB_INFO_{9})
,
   set(findobj('String','FIT SPECIFIED MODEL'),'Enable','off');
   set(findobj('tag','rplot'),'Enable','off');
else
   set(findobj('String','FIT SPECIFIED MODEL'),'Enable','on');
   set(findobj('tag','rplot'),'Enable','on');
end;

clear OLDNAMEXV OLDXVARS II INTROWS NEWROW SORTLIST EVALLIST CONEQUIV GLMLAB_INFO_
clear RUNNAMEXV INTX INDVEC ADDX SEPLIST NEWNAMELIST INTTERM I THISI INTORDER CGLM10 LGLM10

GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'Userdata');

watchoff;
