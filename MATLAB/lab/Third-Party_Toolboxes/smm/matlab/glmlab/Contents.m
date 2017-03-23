% GLMLAB: fitting generalised linear models
% Version 2.3, December 1998.
% Copyright 1996--1998 Peter Dunn
%
% BASICS:   some glmlab basics
% CHANGES:  a list of changes
% Contents: you're reading it!
% Readme.vxy: Info about  glmlab  version x.y
% bugs.txt: known bugs
% glmlab:   opens the glmlab main window
% glmsplsh: the glmlab splash screen
% intro.txt: an introduction to glmlab
% menuwork: does the hard work for  glmlab's  main window
% whatsnew.txt: what's new in this version.
%
%In the /fit directory:
% extrctgl: extracts information from the User Data property
% fac:      declares a factor and makes a matrix of full-rank of the levels
% facfidle: fiddles with factor terms in the covariates
% findres:  finds the residuals after fitting a model
% findvars: finds the location of different types of x-variables
% fitscrpt: the script that is run when a model is fitted
% fixmeup:  fixes up variable name inputs into glmlab
% glmfit:   the general routine for fitting glms
% interact: coordiniates the interactions terms in general cases
% irls:     iteratively reweighted least squares: does the calculating
% loseint:  finds the incidence matrix after losing terms due to interactions
% makefac:  makes a new factor (like the GLIM %gl command)
% newmodel: declares a new model or data is being used
% opterr:   some error messages used in glmlab
% ovarcont: controls naming the offset variable name
% oventry:  coordinates the interactive entry of the offset variable in  glmlab
% paramtrs: some program defaults that the user can feel free to monkey with
% preint:   does some work before  interact  is called
% resetgl:  resets the User Data property
% varok:    makes sure the variables given are ok
% varentry: allows user-interactive variable manipulations
% wvarcont: controls naming the prior weights variable name
% wventry:  coordinates the interactive entry of the prior weights variable in  glmlab
% xvarcont: controls naming the x-variable name
% xventry:  coordinates the interactive entry of the x-variable in  glmlab
% yvarcont: controls naming the y-variable nam
% yventry:  coordinates the interactive entry of the y-variable in  glmlab
%
%In the /fit/dist subdirectory:
% dbinoml:  information for the binomial distribution
% dgamma:   information for the gamma distribution
% dinv_gam: information for the inverse Gaussian distribution
% dlist:    the list of error distributions  glmlab  sees
% dnormal:  information for the normal distribution
% dpoisson: information for the poisson distribution
% dstyle:   the template style for user defined distributions
% pdf_ig:   pdf information for the inverse Gaussian distribution
%
%In the /fit/link subdirectory:
% lcomplog:  information for the complemetary log-log link
% lid:       information for the identity link
% llist:     the list of link functions  glmlab  sees
% llog:      information for the logarithm link
% llogit:    information for the logit (logistic) link
% lprobit:   information for the probit link
% lpower:    information for the power link
% lrecip:    information for the reciprocal link
% lsqroot:   information for the square root link
% lstyle:    the template style for user defined link functions
%
%In the /plotting directory:
% glmplot:  presents a menu from which to choose the required plots
% npplot:   produces a normal probability plot
% plotwork: does the hard work for glmplot
% title2:   a  MathWorks  files to produce two-line titles on plots
%
%In the /misc directory:
% bell:     produces a noise (for warnings, etc)
% cel2lstr: Converts cell to in-line strings
% cdfbino:  the cdf of the binomial distribution
% cdfgam:   the cdf of the gamma distribution
% cdfnorm:  the cdf of the normal distribution
% cdfpoiss: the cdf of the poisson distribution
% findmat:  finds strings scattered throughout a matrix
% invnorm:  inverse cdf of the normal distribution
% lstr2cel: Converts in-line strings to cells
% omit:     omits certain columns from the incidence matrix
% pad:      pads a string with blanks to make it a certain length
% rpeatstr: finds the occurences of repeated string in a cell array
% wildfind: finds a string using a wildcard character (*)
%
%In the /glmhelp directory:
% demowork     :the file that does the work for the demo
% glhelp       :for displaying help screens
% glmdemo      :organises the demo
% helpget      :the help screen for obtaining  glmlab
% helpcont     :the help screen for contacting the author
% helpint      :the help screen for interactions
% helpopt      :the help screen for the menu options
% helpov       :the help screen for output variables
% helpplot     :the helpscreen for plotting
% helpvar      :the help screen for variables areas
%
%In the /data directory:
% chemical.hlp:  A file explaining  chemical.mat
% chemical.mat:  The data from Example 3.2 of `Learning glmlab'
% dummydta.m:    A file to quickly find the data directory
% loadme.hlp:    A file explaining  loadme.mat
% loadme.mat:    An example data set (see section 2.3 of `Learning glmlab')
% leuk.hlp:      A file explaining  leuk.mat
% leuk.mat:      An example data set
% tester.hlp:    A file explaining  tester.txt
% tester.txt:    An example data set (see section 2.3 of `Learning glmlab')
% turkey.hlp:    A file explaining  turkeys.mat.
% turkeys.mat:   The data from Example 3.1 of `Learning glmlab'
