function ri=rindex(dist,partition)
%function ri=rindex(dist,partition)
%
%PURPOSE
%
%To compute a clustering validity index called R-index. Input
%argument 'partition' defines different clustering results,
%parititions, of the same data. Clustering result that has minimum
%value for R-index among the compared ones is the "best" one. 
%
%INPUT
%
% dist      (NxN matrix) matrix of pairwise between N objects
% partition (KxN matrix) K partitions of the same N objects  
%
%OUTPUT
%
% ri (Kx1 vector) ri(k) is the value of R-index for clustering
%      given in partition(k,:).
%
%DETAILS
%
%R-index is defined in Jain & Dubes (1988). The clustering that has
%the minimum value among is the best in terms of R-index.
%
%Each row of matrix 'partition', i.e., partition(i,:), represents a
%division of N obejects into K(i) clusters (classes). On each row,
%clusters must be labeled with integers 1,2,...,K(i), where K(i) is
%the number of clusters that may be different on each row.  
%
%SEE ALSO
% hcluster.m

%Example: partition=[[1 2 3 4];[1 1 1 1];[1 1 2 2]] gives three
%different partitions where partition(1,:) means every object being
%in its own clusters; partition(2,:) means all objects being in a
%single cluster, and in partition(3,:) objects 1&2 belong to
%cluster 1 and 3&4 to cluster 2.

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

N=size(partition,1);

% Number of clusters in each partition
Ncluster=max(partition');

% This is for computing the waitbar
completed=cumsum(Ncluster.^2);

for k=1:N,
  if Ncluster(k)>1,
    % Initialize internal scatter vector and between scatter matrice 
    Sin=zeros(Ncluster(k),1); 
    Sout=zeros(Ncluster(k));
    for i=1:Ncluster(k),
      % Find inter-cluster distances and compute their average
      thisPartition=find(i==partition(k,:));
      d_=dist(thisPartition,thisPartition); 
      Sin(i,1)=mean(d_(:));
      
      % Compute cluster min distances
      for j=i+1:Ncluster(k),
	d_=dist(thisPartition,j==partition(k,:)); 
	Sout(i,j)=min(d_(:));
      end 
    end
    % Make between-cluster distance matrix symmetric, self-distance
    % to Inf (we take min)
    Sout=Sout+Sout'; Sout(eye(Ncluster(k))==1)=Inf;
    % Compute R index
    ri(k,1)=mean(Sin(:)'./min(Sout)); 
  else
    % Degenerate partition (all in the same cluster)
    ri(k,1)=NaN;
  end
  clc;
  disp(['Computing R-index: ', ...
	sprintf('%3d', round(100*completed(k)/completed(end))), ...
	'% completed']);

end

