function sR=icassoProjection(sR, method, varargin)
%function sR=icassoProjection(sR, method, 'identifier1',val1,'identifier2',val2,...))
%
%PURPOSE
%
%To project points on plane so that Euclidean distances between the
%projected points correspond to the similarity matrix between IC
%estimates in Icasso result struct. 
%
%EXAMPLE OF BASIC USAGE
%
% sR=icassoProjection(sR); 
%
%Takes the similarities in the given Icasso result data struct, and
%makes the projection using default parameters, which is equivalent to
%giving command 
%
% sR=icassoProjection(sR, 'cca', 'sim2dis',{'sim2dis',1}, ...
%  'epochs',70, 'radius', [], 'alpha',0.7);
%
%In the following exmaple, icassoSim2Dis(sR,'sim2dis2',0.5)
%is used to make the similarity-to-dissimilarity transformation and
%MMDS is used for making the projection:
%
% sR=icassoProjection(sR,'method','mmds','sim2dis',{'sim2dis2',0.5}):
%
%INPUTS []'s mean optional
%
% sR       (struct) Icasso result data struct: output of function 
%            icassoEst.m 
% [method] (string) 'cca' (defalut) | 'mmds' | 'sammon' 
%
% rest of the inputs are given as pairs 
% ['indentifier1', value1, 'indentifier2', value2, ...
%  accpeted indentifiers: 'sim2dis', 'epochs', 'alpha', 'radius' 
%
%OUTPUT
%
% sR (struct) Updated Icasso result struct, 
%
%The function updates _only_ the following fields:
%  
% sR.projection.method    (string)    
% sR.projection.paramters (cell array) the given paramters
% sR.projection.coordinates (Mx2 matrix) coordinates for estimates
%
%DETAILS
%
%The function transforms the similarities S in field
%sR.cluster.similarities into dissimilarities using function
%D=sqrt(1-abs(S)) as default. Note, that this may be different from
%the transformation that was used for making clustering. On these
%distances the function can use three methods to do the projection  
% Curvilinear Component Analysis (CCA) (preferred)
% Torgerson's linear metric Multi-Dimensional Scaling (MMDS) 
% Sammon's projection (Sammon) 
%CCA and Sammon require some parameters. The default values are set
%according to experience to suit the needs of Icasso. They can be
%altered if necessary. MMDS is automatically used as an initial
%projection for both Sammon and CCA.  
%
%'sim2dis' (string or cell array of strings) 
%            similarity to dissimilarity transformation function, 
%            See also icassoSim2Dis 
%            Examples: Value           Function
%                     {'sim2dis2',1}   D=sqrt(1-abs(D)) (default)
%                     {'sim2dis2',0.5} D=sqrt(1-abs(D).^0.5)
%                      'sim2dis'       D=1-S 
%              
%'epochs'  (scalar) the number of epochs for CCA or Sammon.
%           Ignored for MMDS.
%           default(s): CCA: 40, Sammon: 100
%            
%'radius'  (scalar) CCA intial radius. Ignored for Sammon and MMDS
%            default(s) CCA: max(10,M/20) where M is the number of
%            estimates
%             
%'alpha'   (scalar) learning rate factor for CCA or Sammon.
%            ignored for MMDS
%            default(s): CCA: 0.7, Sammon: 0.7
%
%SEE ALSO
% icassoSim2Dis
% mmds
% cca (in SOM Toolbox)
% sammon (in SOM Toolbox)

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

% Set default projection method
if nargin<2|isempty(method),
  method='cca';
end

% Check the method
method=lower(method);
switch method
 case {'sammon','cca','mmds'}
  ;
 otherwise
  error('Unknown projection.');
end

% We project onto plane
outputDimension=2;

% Set default parameters for proj, methods
switch method 
 case 'sammon'
  default={'alpha',0.7,'epochs',100,'sim2dis',{'sim2dis2',1}};
 case 'cca'
  default={'alpha',0.7,'epochs',40,...
	   'radius',max(icassoGet(sR,'M')/20,10),'sim2dis',{'sim2dis2',1}};
 case 'mmds'
  default={'sim2dis',{'sim2dis2',1}};
end

%% Check optional arguments and add defaults
projectionparameters=processvarargin(varargin,default);
num_of_args=length(projectionparameters);

%% check arguments
for i=1:2:num_of_args;
  switch lower(projectionparameters{i})
   case 'sim2dis'
    sim2dis=projectionparameters{i+1};
   case 'epochs'
    epochs=projectionparameters{i+1};
   case 'alpha'
    alpha=projectionparameters{i+1};
   case 'radius'
    CCAradius=projectionparameters{i+1};
   otherwise
    error(['Indentifier ' projectionparameters{i} ' not recognized.']);
  end
end

% Make sim2dis transformation
if iscell(sim2dis) 
  % multiple arguments given 
  D=icassoSim2Dis(sR,sim2dis{:});
else
  % only one input argument
  D=icassoSim2Dis(sR,sim2dis);
end
% actually, we need only the distances!
D=D.cluster.dissimilarity;

disp([char(13) 'Projection, using ' upper(method) char(13)]);

switch method 
 case 'mmds'
  P=mmds(D); 
  P=P(:,1:outputDimension);
 otherwise
  % Start from MMDS
  initialProjection=mmds(D);
  switch method
   case 'sammon' % Use SOM Toolbox Sammon 
    P=sammon(initialProjection,outputDimension,epochs,'steps',alpha,D);
   case 'cca'    % Use SOM Toolbox CCA 
    P=cca(initialProjection,outputDimension,epochs,D,alpha,CCAradius);
  end
end

sR.projection.method=method;
sR.projection.parameters=projectionparameters;
sR.projection.coordinates=P;

% This gives random initial projection instead of MMDS
% initialProjection=rand(size(D,1),outputDimension);





