function index2centrotype=icassoCentrotype(sR,mode,K)
%function index2centrotype=icassoCentrotype(sR,mode,K)
%
%PURPOSE
%
%To compute the centrotype of estimates that belong to a subset defined
%by index. Returns index to the centrotype(s). The corresponding
%estimates can be returned using icassoGet or plotted by icassoSourceplot
% 
%EXAMPLE OF BASIC USAGE
%
%For this example variable sR must contain complete results of 
%Icasso randomization & clustering (see functions icassoEst and
%icassoExp):
%
% U=sR.cluster.partition(10,:);
% i=icassoCentrotype(sR,'partition',U);
% icassoSourceplot(sR,i);
%
%plots 10 estimated sources (ICs) each corresponding to a
%centrotype of the 10 clusters at level 10 in the dendrogram.
%
%INPUT
%
% sR   (struct) Icasso result struct
% mode (string) 'index' | 'partition' 
% K    (vector) 1xK vector that togehter with mode 
%        defines the estimates of which the centrotype(s) is/are 
%        calculated
%
%        for 'index' K gives direct indices into the randomized
%        estimates (see icassoGet). The centrotype is computed
%        among these estimates
% 
%        for 'partition' K is a partition vector (see e.g.,
%        icassoCluster). Element index2centrotype(i) in output
%        refers now to the centrotype of cluster i
%        implied by the partition vector given in K.
%
%OUTPUT
% 
% index2centrotype (scalar or vector) index/indices that can be
% used, e.g., when using function icassoGet. See icassoEst for a
% note about the indexing convention.
% 
%SEE ALSO
% centrotype.m
% icassoGet.m
% icassoSourceplot.m

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

if isempty(sR.cluster.similarity),
  error('Similarity matrix is not computed yet!');
end

switch lower(mode)
 case 'index'
  i=centrotype(sR.cluster.similarity(K,K));
  index2centrotype=K(i);
 case 'partition'
  Ncluster=max(K);
  for cluster=1:Ncluster,
    index=find(K==cluster);
    index2centrotype(cluster,1)=icassoCentrotype(sR,'index',index);
  end
% case 'level'
%  if isempty(sR.cluster.partition),
%    error('Clustering is not computed yet!');
%  end 
%  index2centrotype=icassoCentrotype(sR,'partition',sR.cluster.partition(index,:));
 otherwise
  error('Unknown operation mode.')
end


  