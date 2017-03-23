function sR=icassoEst(mode,X,M,varargin)
%function sR=icassoEst(mode,X,M,['FastICAparamName1',value1,'FastICAparamName2',value2,...])
%
%PURPOSE
%
%To compute randomized ICA estimates M times from data X. Output of
%this function (sR) is called 'Icasso result struct' (see
%icassoStruct) sR logs all the methods and paramters used in, and
%the results from Icasso procedure. 
%
%EXAMPLE OF BASIC USAGE
%
% sR=icassoEst('randinit', sf12, 20); 
%
%estimates ICA for 20 times from data matrix sf12 using Icasso
%default parameters for FastICA, that is 
% - symmetrical approach
% - kurtosis as contrast function, 
% - in maximum 100 interations are used for estimating ICA in each
% round. Randomizes only initial conditions.  
%
% sR=icassoEst('both', sf12, 15, 'g', 'tanh', 'approach', 'defl');
%
%estimates ICA for 15 times from data matrix sf12 using 'tanh' as
%contrast function, and deflatory approach in FastICA
%estimation. Applies both bootstrappig the data and randomizing
%initial conditions.
%
%When icassoEst is accomplished, use call  
%
% sR=icassoExp(sR); 
%
%to obatain clustering results in sR.
%See also function 'icassoGet' how to return independent components
%and other estimates from the Icasso data struct
%
%INPUTS []'s mean an optional argument
%
% mode (string)  'randinit' | 'bootstrap | 'both'
% X    (dxN matrix) data d=dimension, N=number of samples
% M    (scalar) number of randomizations (runs)
% ['identifier1',value1, 'identifier2',value2,...] 
%      FastICA parameters.  
%      Default: {'approach','symm','g','pow3','maxNumIterations',100}
%      See function fastica in FastICA toolbox for more information.
%
%OUTPUTS 
%
% sR (struct) Icasso result data struct 
%
%DETAILS 
%
%Meaning of different choices for input arg. 'mode'
% 'randinit': different random initial condition each time
% 'bootstrap': the same initial cond. each time, but data is
%   bootstrapped. The initial condition can be explicitly
%   specified using FastICA parameter 'initGuess'
%  'both': use both data bootstrapping and randomization of 
%    initial condition.
%
%ESTIMATE INDEXING CONVENTION
%
%When function 'icassoEst' is run each estimate gets a unique,
%integer label in order of appearance. The same order and indexing
%is used throughout the Icasso softaware. In many functions one can
%pick a subset of estimates sR by giving vector whose elements
%refers to this unique label.   
%
%NOTE that the following FastICA paramters cannot be used
%
% in all modes ('randinit','bootstrap','both'):
%   using 'sampleSize', 'displayMode', 'displayInterval', and 'only'
%   is not allowed for obvious reasons.
%
% in addtion, 
%  in modes 'randinit' and 'both': 
%   using 'initGuess' is not allowed since initial guess is randomized!
%
%  in modes 'bootstrap' and 'both': 
%   using 'whiteMat' and 'dewhiteMat' are not allowed since they need
%   to be computed for each bootstrap sample individually!
%
%SEE ALSO
% icassoStruct
% icassoExp
% icassoViz
% icassoGet

%COPYRIGHT NOTICE
%This function is a part of Icasso software library
%Copyright (C) 2003 Johan Himberg
%
%This program is free software; you can redistribute it and/or
%modify it under the terms of the GNU General Public License
%as published by the Free Software Foundation; either version 2
%of the License, or any later version.
%
%This program is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.
%
%You should have received a copy of the GNU General Public License
%along with this program; if not, write to the Free Software
%Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
% Set the Icasso struct
sR=icassoStruct(X); 

% Check compulsatory input arguments
if nargin<3,
  error('At least three input args. required');   
end

%% Check mode.
mode=lower(mode);
switch mode
 case {'randinit','bootstrap','both'}
  ;
 otherwise
  error(['Randomization mode must be ''randinit'', ''bootstrap'' or' ...
	 ' ''both''.']);  
end

sR.mode=mode;

%% Set some values
num_of_args=length(varargin);
whitening='not done';

%% Default values for some FastICA options
fasticaoptions={'g','pow3','approach','symm',...
		'maxNumIterations',100,'interactivePCA','off'};

%% flag: initial conditions given (default: not given)
isInitGuess=0;

%% Check varargin & set defaults
fasticaoptions=processvarargin(varargin,fasticaoptions);

num_of_args=length(fasticaoptions);

for i=1:2:num_of_args,
  switch fasticaoptions{i}
   case {'approach','firstEig','lastEig','numOfIC','finetune','mu','g','a1','a2',...
	 'stabilization','epsilon','maxNumIterations','maxFinetune','verbose',...
	 'pcaE','pcaD','interactivePCA'}
    ; % these are ok
      
   %% Get implicit whitening if given & update flag   
   case 'whiteSig'
    whitening='done';
    w=fasticaoptions{i+1};
   case 'whiteMat'
    whitening='done';
    White=fasticaoptions{i+1};
   case 'dewhiteMat'
    deWhite=fasticaoptions{i+1};
    whitening='done';
   case {'sampleSize','displayMode','displayInterval','only'}
    error(['You are not allowed to set FastICA option ''' fasticaoptions{i} ''' in Icasso.']);
    % initGuess depends on mode 
   case 'initGuess'
    switch mode
     case 'randinit'
      error(['FastICA option ''initGuess'' cannot be used in' ...
	     ' sampling mode ''randinit''.']);
     case 'randinit'
      error(['FastICA option ''initGuess'' cannot be used in' ...
	     ' sampling mode ''both''.']);
     case 'bootstrap'
      isInitGuess=1;
     otherwise
      error('Internal error!?');
    end
   otherwise
    error(['Doesn''t recognize FastICA option ''' fasticaoptions{i} '''.']);
  end
end

% Add fixed options
fasticaoptions=...
    [fasticaoptions,{'sampleSize',1,'displayMode','off'}];

%Store
sR.fasticaoptions=fasticaoptions;

%% Compute whitening, if not explicitly given. 

switch whitening
 case 'not done'
  [w,White,deWhite]=fastica(X,'only','white',fasticaoptions{:}); 
 case 'done'
  if strcmp(mode,'bootstrap') | strcmp(mode,'both'),
    error(['FastICA option ''whiteMat'' or ''dewhiteMat'' cannot be' ...
	   ' used in modes ''bootstrap'' and ''both''.']);
  end
 otherwise
  error('There appears to be a bug in icassoEst.');
end

if strcmp(mode,'bootstrap') & ~isInitGuess,
  fasticaoptions{end+1}='initGuess';
  fasticaoptions{end+1}=rand(size(White'))-.5;
end

%% Store whitening
sR.whiteningMatrix=White;
sR.dewhiteningMatrix=deWhite;
    
%% Compute N times FastICA
k=0; index=[];
for i=1:M,
  clc; 
  disp([char(13) 'Randomization using FastICA: Round ' num2str(i) '/' num2str(M) char(13)]);
  
  switch mode
   case 'randinit'
    X_=X;
   case {'bootstrap','both'}
    X_=bootstrap(X);
    [w,White,deWhite]=fastica(X_,'only','white',fasticaoptions{:});
   otherwise
    error('Internal error?!');
  end
  [dummy,A_,W_]=fastica(X_,'whiteMat',White,'dewhiteMat',deWhite,'whiteSig',w,fasticaoptions{:});
  n=size(A_,2);
  if n>0, 
    k=k+1;
    sR.index(end+1:end+n,:)=[repmat(k,n,1), [1:n]'];
    sR.A{k}=A_; sR.W{k}=W_; 
    %if strcmp(mode,'bootstrap'),
    %  sR.whiteningMatrix{k}=White;
    %  sR.dewhiteningMatrix{k}=deWhite;
    %else
    %  ;
    %end
  end
end

function X=bootstrap(X)

N=size(X,2);
index=round(rand(N,1)*N+.5);
X=X(:,index);