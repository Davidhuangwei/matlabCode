function [P,Z,order]=hcluster(D,link)
%function [P,Z,order] = hcluster(D,[link])
%
%PURPOSE
%
%To perform hierarchical agglomerative clustering on distance
%matrix D.
%
%INPUT 
%
% D        (MxM matrix) distance matrix  
% link     (string)     agglomeration strategy, (linking) 
%                        'average'  (group average link) 
%                        'single',  (nearest neighbor)
%                        'complete' (furthest neighbor)
%OUTPUT
% 
%  P (NxN matrix) contains the partitions on each level of the
%                 dendrogram. 
%  Z,order        arguments returned by som_linkage. Needed for 
%                 drawing dendrogram with som_dendrogram. See
%                 additional help in som_linakge. 
%
%DETAILS 
%
%The function clusters M objects according to a
%MxM matrix of distances between them. D(i,j) is the distance
%between objects i and j.
%
% 1.Applies hierarchical agglomerative clustering to D using the
%   selected strategy..
% 2.Returns matrix P (of size MxM) where each row presents a partition.
%   The partitions present the clustering of the objects on each level
%   of the dendrogram. Let c=P(L,i); Now, c is the cluster that
%   object i belongs to at level L. On each row P(L,:), cluster labels are
%   integers 1,2,...,L.
%
%Note, that the cluster labels cannot be comapared over
%partitions. The same cluster may appear at different
%level(s) but it does not necessarily have the same label in every
%'partition vector' P(L,:).
%
%SEE ALSO
% som_linkage.m
% icassoCluster.m

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

N=size(D,1);
[Z,order]=som_linkage(ones(N,1),'linkage',link,'dist',D);
P=Z2partition(Z);

function partition=Z2partition(Z)
%
% function partition=Z2partition(Z)
%
% Recode SOM Toolbox presentation for hierachical clustering (Z)
% into partition vectors(s)

N=size(Z,1)+1;
C=zeros(N);
C(1,:)=1:N;

for i=2:N,
  C(i,:)=C(i-1,:); 
  C(i,(Z(i-1,1)==C(i,:))|(Z(i-1,2)==C(i,:)))=N-1+i;
end

for i=1:size(C,1),
  [u,tmp,newindex]=unique(C(i,:));
  C(i,:)=newindex(:)';
end

partition=C(end:-1:1,:);

