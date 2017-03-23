function [beta,serrors,mu,res,covarbeta,covdiff,devlist,linpred,xnames]=glmfit(y,x, inc_const, errdis, link, scalepar, pwvar, osvar, restype )
%GLMFIT Fits a generalised linear model (glm)
% USE: [beta,serrors,fits,res,covarbeta,covdiff,devlist,linpred]=glmfit(y,x)
%   where  y  is the response variable;
%             (For a binomial response, y  has two columns:
%              the first contains  y, the second has the sample sizes)
%          x  is the covariate matrix 
%             (the number of columns of  x  is the number of variables.
%          beta  contains the parameters estimates;
%          serrors   are the standard errors;
%          fits  are the fitted values;
%          covarbeta  covariance matrix of the parameter estimates;
%          res  are the standardised residuals:
%             (y-fits)*sqrt(prior wt / (scale parameter*variance function))
%          covdiff  is the var/covariance matrix of standard error of parameter
%             differences.
%          devlist  is a vector of residual deviance for iterations of the fit.
%          linpred  is the linear predictor.
%          xnames  is a string array of the names of the variables (as in the output).
%
% Both vectors  y,  x,  should be the same length: the number of observations.
%
% Only  y  is needed.  If  x  is not supplied, only the constant term is fitted.
%
%ALSO SEE:  glmlab (fitting glm's using glmfit) where  glmfit  is used.

%Copyright 1996--1998 Peter Dunn
%30 July 1998

global DEVIANCE

%Setup
beta=[];
serrors=[];
mu=[];
res=[];
covarbeta=[];
covdiff=[];
devlist=[];
linpred=[];
xnames=[];

%Inputs
if nargin < 3, inc_const = 1; end
if nargin < 4, errdis = 'normal'; end;
if nargin < 5, 
   if strcmp( errdis , 'normal' ) , 
      link='id';
   elseif strcmp( errdis , 'poisson' ),
      link='log';
   end;
end;
if nargin < 6, scalepar = 1; end;
if nargin < 7, pwvar = ones(size(y(:,1))); end;
if nargin < 8, osvar = zeros(size(y(:,1))); end;
if nargin < 9, restype = 'pearson'; end;

%%Extract info:
%extrctgl;                     %extract  GLMLAB_INFO_
%DFORMAT=GLMLAB_INFO_{7};
%DETAILSFILE=GLMLAB_INFO_{8};
%DEVIANCE=GLMLAB_INFO_{20};
%y=yvar;
DETAILSFILE = 'DETAILS.m';
DFORMAT=[1 1 1];


%%A check on links/distns:
%if(editerrs),
%   return;
%end;


%Some necessary fiddling
[yrows,ycols]=size(y);

%Make each row an observation
%can't use  y=y(:)  since the binomial case has two columns
if yrows<ycols, 
   y=y';
end;

ylen=length(y);

if ycols==2,		%Binomial case: extract responses and sample sizes

   m=y(:,2);
   y=y(:,1);

else

   m=ones(size(y));

end;
m=m(:);

if exist('rownamexv')==1,   %rownamexv = GLMLAB_INFO_{13}
   namelist=rownamexv;
end;

%X variables names
if inc_const,                 %if include_constant, tag such on

   x=[ones(yrows,1),x];
%   namexv=['[Const,',cel2lstr(namexv),']'];
%   namelist=str2mat('Constant',rownamexv);

else

   x=x;
%   namexv=cel2lstr(namexv);

end;

%end of that bit of fiddling


if ~exist('pwvar'), 
   GLMLAB_INFO_{16}=ones(yrows,1);
   pwvar=GLMLAB_INFO_{16};
end;

if ~exist('osvar'), 
   GLMLAB_INFO_{17}=zeros(yrows,1);
   osvar=GLMLAB_INFO_{17};
end;

zerowts=sum(pwvar==0);			%Number of points with zero wight
effpts=ylen-zerowts;			%Effective number of points
line=' ------------------------------------------------------------';


%DISPLAY FITTING INFORMATION
if DFORMAT(1),

   disp(line);

   if isstr(link), 
      l=upper(link); 
   else 
      l=['TO POWER OF ',num2str(link)];
   end;

   disp([' INFORMATION: Distribution/Link: ',upper(errdis),'/',l]);

   if zerowts>0,
      add='s';
      if effpts==1,
         add='';
      end;

      disp([blanks(14),'Fitting based on:  ',...
            num2str(effpts),' observation',add]);
   end;

   if (sum((pwvar/max(pwvar))==1))~=ylen,   %Only enter if weights not all one
      disp([blanks(14),'Prior Weights:     ',namepw]);

   end;

   if (sum(osvar==0))~=ylen, %Enter if offsets is not all zeros
      disp([blanks(14),'Offset Variable:   ',nameos]);
   end;

   if isstr(scalepar),
     disp([blanks(14),'Scale parameter estimated from mean deviance.']);
   else
      disp([blanks(14),'Scale parameter set to ',num2str(scalepar),'.']);
   end

   disp([blanks(14),'Residual Type:     ',upper(restype)]);

end;

%resetgl;

%Obtain link and distribution file names
if isstr(link),
   linkinfo=['l',link];
else
   linkinfo='lpower';
end;

distinfo=['d',errdis];

%Check they exist (user-defined case)
if ~exist(linkinfo),
   opterr(8,linkinfo(2:length(linkinfo)));
   return;
end;

if ~exist(distinfo),
   opterr(9,distinfo(2:length(distinfo)));
   return;
end;

%%%DO THE NUMBER CRUNCHING:
   [beta,mu,xtwx,devlist,l,linpred]=birls(y,x,m, errdis, link, DFORMAT, pwvar, osvar,DETAILSFILE);
%%%DONE THE NUMBER CRUNCHING


%DISPLAY RESULTS
disp(line);
GLMLAB_INFO_{22}=0;


if ~isempty(devlist),               %if empty, an error

   curdev = devlist(end);           %deviance for current model
   curdf=effpts-length(beta);       %df for current model

   if (curdf<0), 		    %if more estimates that points
      curdf=0;
   end;

   if ( strcmp(errdis,'normal')|strcmp(errdis,'gamma') ) & (curdf==0),

      dispers=Inf;                   %Otherwise gives warning: Divide by zero

   else

      if ~isstr(scalepar),
         dispers=scalepar;
      else
         dispers=curdev/curdf;
      end;

   end;

   covarbeta=real(pinv(xtwx)*dispers);


   %Determine variable names
   varno=1;
   estno=1;
   xnames=[];
   numcols = 1;

   while estno<=size(x,2)

       vn = ['Var ',num2str(varno) ];
%      vn=namelist(varno,:);
      varno=varno+1;

      if strcmp(deblank(vn),'Constant'),
         numcols=1;
      else
         if isempty(findstr(deblank(vn),'@')), %no interactions
            if strcmp( vn(1:4), 'Var ')   %then a glmlab  Var ?
               numcols = 1;
            else
               evstr=['size(',deblank(vn),',2);'];
               evalin('base', ['numcols=',evstr],'numcols = 1;' );
            end;
         end
      end

      if numcols==1,

         xnames=str2mat(xnames,deblank(vn));
         estno=estno+1;
      else

         for j=1:numcols
            xnames=str2mat(xnames,[deblank(vn),'(:,',num2str(j),')']);
            estno=estno+1;
        end

      end

   end

   xnames(1,:)=[];


   %Display results
   if DFORMAT(2)|nargout>0, %display the parameter estimates

      if DFORMAT(2),
         disp('   Estimate        S.E.      Variable');
         disp(line);
      end;

      jj=0;
      bb=zeros(size(x,2),1);
      serrors = bb;
      estno=1;
      varno=1;

      for varno=1:size(x,2);
         vn=xnames(varno,:);
         varno=varno+1;

         if any(l==estno), %unaliased variables
            jj=jj+1; 
            se=sqrt(covarbeta(jj,jj));

            if isinf(se)&DFORMAT(2),
               fprintf(' %12.6f     %s    %s\n',beta(jj),'???????',vn);
            elseif DFORMAT(2),
               fprintf(' %12.6f %12.6f   %s\n',beta(jj),se,vn);
            end;

            serrors(estno) = se;
            bb(estno) = beta(jj);

         else  %aliased variables

            if DFORMAT(2),
               fprintf(' %12.6f     %s   %s\n',0.0,' aliased',vn);
            end;

         end;

         estno=estno+1;

      end;

   end;

   beta=bb;
   disp(line);

   if ~isempty(DEVIANCE),              %deviance already exists so we print changes

      deldev=curdev-DEVIANCE;          %defined as in GLIM
      deldf=curdf-GLMLAB_INFO_{21}; 

      if ~isstr(scalepar),

         sdev=curdev/scalepar;
         sdeldev=deldev/scalepar;
         fprintf('Scaled Deviance: %13.6f    (change: %+13.6f)\n',sdev,sdeldev);

      else

         fprintf('Deviance: %20.6f    (change: %+13.6f)\n',curdev,deldev);

      end;

      %Write to DETAILS file
      FID=fopen(DETAILSFILE,'a');
      fprintf('Residual df: %17.0f    (change: %+13.0f)\n',curdf,deldf);
      fprintf(FID,'%12.6f %13.6f %3.0f %5.0f     %s\n',...
              curdev,deldev,curdf,deldf);

   else %deviance doesn't exist, so this is the first fit

      if ~isempty(scalepar),

        if isstr(scalepar), 
           sdev=curdev; 
        else 
           sdev=curdev/scalepar; 
        end;

        if isstr(link),
           fprintf('Scaled deviance: %13.6f           Link: %s\n',curdev,upper(link));
        else
           fprintf('Scaled deviance: %13.6f           Link: Power of %8.5f\n',curdev,link);
        end;

      else

        if isstr(link),
           fprintf('Deviance: %19.6f            Link: %s\n',curdev,upper(link));
         else
           fprintf('Deviance: %19.6f            Link: Power of %8.5f\n',curdev,link);
         end

      end;

      fprintf('Residual df: %17.0f   Distribution: %s\n',curdf,upper(errdis));
      FID=fopen(DETAILSFILE,'a');
%      fprintf(FID,'(Created at %s on %s.)\n',mytime,date);
      fprintf(FID,'   Deviance        Change   df  Change   Variables\n');
      fprintf(FID,'%12.6f      %12.0f           %s\n',...
                curdev,curdf);

   end;

   devlist=[devlist;curdev];

%   if (~isempty(namepw))|(~isempty(nameos)),
%      fprintf(FID,'   The above fit includes the following:\n');
%   end;
%
%   if (~isempty(namepw))&(~isempty(nameos)),
%      fprintf(FID,'      Prior weights: %s; Offset: %s\n',namepw,nameos);
%   else
%      if ~isempty(namepw), fprintf(FID,'      Prior weights: %s\n',namepw);end;
%      if ~isempty(nameos), fprintf(FID,'      Offset:        %s\n',nameos);end;
%   end;

   fclose(FID);

   if ~finite(dispers),
      fprintf('Dispersion parameter cannot be found: O degrees of freedom.\n');
   else
      fprintf('Scale parameter (dispersion parameter): %16.6f\n', dispers);
   end;

   disp(' Output variables:  BETA SERRORS FITS RESIDS COVB COVD');
   disp('                    DEVLIST LINPRED XMATRIX XVARNAMES');
   disp(' ');


   %Update parameters
   GLMLAB_INFO_{20}=curdev;
   DEVIANCE=curdev;
   GLMLAB_INFO_{21}=curdf;

   k=1; %scale parameter used
   if ~isempty(scalepar), 

      if ~isstr(scalepar), 
         k=scalepar; 
     end; 

   end;


   %calculate the RESIDUALS
   res=bfindres(y,m,mu,k,pwvar, errdis, restype);


   if ~isfinite(dispers)
      disp(' WARNING:  Non-finite dispersion.');
   end;


   %calculate other OUTPUT VARIABLES
   if nargout>4,

      covdiff=zeros(size(covarbeta));

      for ii=1:length(covarbeta),

         for jj=ii+1:length(covarbeta),

            cvd=real( sqrt( covarbeta(ii,ii)+covarbeta(jj,jj)-2*covarbeta(ii,jj) ) );
            covdiff(ii,jj)=cvd;
            covdiff(jj,ii)=cvd;

         end;

      end;

   end;

   %Allow the proper residual plots to be available
   if strcmp(GLMLAB_INFO_{1},'binoml')|strcmp(GLMLAB_INFO_{1},'poisson')|...
      strcmp(GLMLAB_INFO_{1},'gamma')|strcmp(GLMLAB_INFO_{1},'inv_gsn'),
      set(findobj('tag','resvxf'),'Enable','on');
   end;

   if strcmp(lower(GLMLAB_INFO_{4}),'quantile'),
      set(findobj('tag','qequiv'),'Enable','off');
   end;

   if isempty(GLMLAB_INFO_{10}),
      set(findobj('tag','resvc'),'Enable','off');
   else
      set(findobj('tag','resvc'),'Enable','on');
   end;

else

   errordlg('The model cannot be fitted sensibily; check the inputs and settings.',...
            'Model not fitted.')
   res = [];

   %Disallow residual plots
   set(findobj('tag','rplots'),'Enable','off');

end

%fix up some things for use elsewhere
GLMLAB_INFO_{19}=mu; 
GLMLAB_INFO_{18}=res;
M=m;

%enable residual plots
if isempty(GLMLAB_INFO_{18}),
   set(findobj('tag','rplots'),'Enable','off');
else
   set(findobj('tag','rplots'),'Enable','on');
end;


%Reset variables
resetgl;

return;
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   SUBFUNCTION mytime

function [time] = mytime()

%MYTIME Return the current time in the format hh:mm:ss(am or pm)
%USE:   mytime

%Copyright 1996 Peter Dunn
%11 November 1996

ss=fix(clock);
if ss(4)>12,		%HOUR
   time=[num2str(ss(4)-12),':'];
   tag='pm';
else
   time=[num2str(ss(4)),':'];
   tag='am';
end;

if ss(5)<10, 		%MINUTES
   time=[time,'0',num2str(ss(5)),':'];
else
   time=[time,num2str(ss(5)),':'];
end;

if ss(6)<10,		%SECONDS
   time=[time,'0',num2str(ss(6)),tag];
else
   time=[time,num2str(ss(6)),tag];
end;

return;
