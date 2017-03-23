function sR=icassoCluster(sR,strategy)
%function sR=icassoCluster(sR,[strategy])
%
%PURPOSE 
%
%To cluster the ICA estimates according to the readily computed
%dissimilarity matrix D=sR.cluster.dissimilarity.
%
%EXAMPLE OF BASIC USAGE
%
% sR=icassoCluster(sR); 
% 
%where sR is Icasso result struct. This applies hierarchical
%clustering using group-average linakge agglomeration strategy and
%Stores the results back into workspace variable sR.
%
%INPUT []'s mean optional 
%
% sR         (struct) Icasso result struct
% [strategy] (string) 'AL' (default) | 'SL' | 'CL' 
%             agglomeration strategy, (linking) 
%              'AL' group average link) 
%              'SL' single link (nearest neighbor link)
%              'CL' complete link (furthest neighbor)
%OUTPUT
%
% sR (struct) Updated Icasso result struct, 
%
%The function updates _only_ the following fields:
%  
% sR.cluster.strategy   (string)     agglomeration strategy
% sR.cluster.similarity (MxM matrix) clustering results as
%                         partitions of estimtes on each
%                         level of the dendrogram
%
%There are other fields in Icasso result struct sR that depend on
%clustering. They are not recomputed or cleared automatically by
%icassoCluster, but remain unchanged in the output, and must be
%updated by calling the appropriate functions. See icassoStruct. 
%
%DETAILS
%
%D=sR.cluster.dissimilarity, i.e., the dissimilarity matrix
%between ICA estimates. Function icassoCluster
%- applies hierarchical agglomerative clustering to D using the
%  selected strategy..
%- returns matrix P (of size MxM) where each row presents a partition.
%  The partitions present the clustering of the objects on each level
%  of the dendrogram. Let c=P(L,i); Now, c is the cluster that
%  object i belongs to at level L. On each row P(L,:), cluster
%  labels are integers 1,2,...,L.
%- stores P is in field sR.cluster.partition,
%
%Note, that the cluster labels cannot be comapared over
%partitions. The same cluster may appear at different
%level(s) but it does not necessarily have the same label in every
%'partition vector' P(L,:).
%
%SEE ALSO
% hcluster
% som_linakge
% rindex
% icassoExp

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

% Check dissimilarity matrix
D=sR.cluster.dissimilarity;
if isempty(D),
  error('Dissimilarities not computed: use icassoSim2Dis.');
end

if nargin<2|isempty(strategy),
  strategy='AL';
end

% we are case insensitive
stratgy=upper(strategy);
sR.cluster.strategy=strategy;

% Change Icasso name to SOM Toolbox name
switch strategy
 case 'AL'
  strategy='average';
 case 'CL'
  strategy='complete';
 case 'SL'
  strategy='single';
 otherwise
  error(['Agglomeration strategy ' strategy ' not implemented.']);
end

% Make partition:
sR.cluster.partition=hcluster(D,strategy);

