function [toler,maxits,illctol]=paramtrs(imaxits,itoler,iillctol,detailsfile)
%PARAMTRS The default parameters for  glmlab  that the user can safely alter
%USE:  [toler, maxits, illctol]=parametrs(imaxits,itoler,iillctol);
%   where  maxits  is the maximum number of iteration performed when using
%                  iteratively reweighted least squares with irls.m;
%          toler  is the tolerance for finding parameters.  Basically, this
%                 determines the accuracy of the estimates;
%          illctol  is the tolerance for declaring an ill-conditioned matrix.
%   The three input parameters alter the current setting of that parameter.
%
%   The settings are saved in the file  PARAVALS.mat.

%Copyright 1996, 1997 Peter Dunn
%01 August 1997

%BE VERY CAREFUL WHEN ALTERING THIS FILE.  
%IF ANYTHING GOES WRONG, RESTORE TO THE FOLLOWING DEFAULT VALUES:
% maxits=20;
% toler=0.00005;
% illctol=1e-10;

%%Extract info:
%extrctgl;

parfile=strrep(detailsfile,'DETAILS.m','PARAVALS.mat');
   %A file saving the current parameter values

if exist(parfile); 
   load(parfile); 
else %When first time used
   disp('-------------------------------------------');
   disp(' Creating file of parameter settings named');
   disp( parfile );
   illctol=1e-10; toler=0.00005; maxits=20;
   oops=0;
   eval('save(parfile,''maxits'',''toler'',''illctol'');','oops=1;');
   if (oops)
      disp(' Error creating PARAVALS.mat.   Make sure that you have');
      disp(' write permission to the directory mentioned above.');
   else
      disp(' File successfully created.');
      disp(' This file will not need to be created in the future.');
   end
   disp('-------------------------------------------');
end;

if isempty(iillctol),
   illctol=1e-10; 
else 
   illctol=iillctol;
end;

if isempty(itoler), 
   toler=0.00005; 
else 
   toler=itoler;
end;

if isempty(maxits),
   maxits=20; toler=0.00005; illctol=1e-10;
else
   maxits=imaxits;
end;

save(parfile,'maxits','toler','illctol');

if nargout==0,
   disp(' The current parameter settings are:')
   disp(['   Maximum number of iterations:             ',num2str(maxits)]);
   disp(['   Tolerance (accuracy of estimates):        ',num2str(toler)]);
   disp(['   Tolerance for detecting ill-conditioning: ',num2str(illctol)]);
end; 
