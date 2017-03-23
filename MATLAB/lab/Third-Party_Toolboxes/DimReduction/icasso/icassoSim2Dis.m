function sR=icassoSim2Dis(sR,fcn,p)
%function sR=icassoSim2Dis(sR,[fcn],[p])
%
%PURPOSE 
%
%To transform the similarities between ICA estimates into
%dissimilarities.
%
%EXAMPLE OF BASIC USAGE
%
% sR=icassoCluster(sR,'sim2dis'); 
% 
%transforms the similarity matrix S stored in
%sR.cluster.similarity, uses function sim2dis.m, i.e, D=1-S, to
%transform it into dissimilarity matrix D and stored it in
%sR.cluster.dissimilarity. 
%
% sR=icassoCluster(sR,'sim2dis2',1);
%
%As previous, but uses sim2dis2.m with additional input parameter
%=1; performs D=sqrt(1-abs(S)). The results are copied into a
%new workspace variable newR.  
%
%INPUT []'s mean optional
%
% sR    (struct) Icasso result struct
% [fcn] (string) name of a function (must be available in
%          workspace); defines the operation that is performed. 
%          Default: 'sim2dis'.
% [p]   (scalar) additional parameter given as argument to fcn 
%
%OUTPUT
%
% sR (struct) Updated Icasso result struct 
%
%The function updates _only_ the following fields:
%  
% sR.cluster.sim2dis (string)     fcn 
%                    (cell array) {fcn,p} if fcn _and_ p are given.
%
% sR.cluster.dissimilarity 
%                    (MxM matrix) dissimilarity matrix D, that is 
%                     dissimilarities between ICA estimates
%
%There are other fields in Icasso result struct sR that depend on
%mutual dissimilarities. They are not recomputed or cleared
%automatically by icassoSim2Dis, but remain unchanged in
%the output, and must be updated by calling the appropriate
%functions. See icassoStruct. 
%
%SEE ALSO 
% sim2dis.m 
% sim2dis2.m 
% corr2eucdist.m
% icassoStruct.m
% icassoSimilarity.m
% icassoExp.m

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

% Check similarities
S=sR.cluster.similarity;
if isempty(S),
  error('Similarities must be computed first: use icassoSimilarity!');
end

%% Set default fcn
if nargin<2|isempty(fcn),
  fcn='sim2dis';
end

% we are case insensitive
fcn=lower(fcn);

if nargin==3,
  D=feval(fcn,S,p);
  sR.cluster.sim2dis={fcn,p};
else
  D=feval(fcn,S);
  sR.cluster.sim2dis=fcn;
end

sR.cluster.dissimilarity=D;



