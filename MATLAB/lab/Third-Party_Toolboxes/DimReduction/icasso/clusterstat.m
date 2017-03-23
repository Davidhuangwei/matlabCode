function Stat=clusterstat(S,partition,between)
%
%function Stat=clusterstat(S,partition,[between])
%
%PURPOSE
%
%To compute various intra- and extra-cluster statistics.
%
%INPUTS []'s are optional
% 
% S         (matrix) NxN similarity or distance matrix between N
%             objects. Must be symmetric.  
% partition (1xN vector) contains partition of objects into
%             clusters, partition(i)  is the number of cluster that
%             object i belongs to. Cluster numbers must be
%             intergers 1,2,...,K where K is the number of
%             clusters. 
% [between] (scalar)  1: compute between cluster similariy/distance matrix, 
%                     0: (default) don't compute
% 
%OUTPUT
% 
% All fields are vectors of size 1xK, where K is the number of clusters
% 
% Stat.N(i)             the number of objects in cluster i
%
% Stat.internal.min(i)  minimum/avrage/max internal similarity/distance 
% Stat.internal.avg(i)  in cluster i
% Stat.internal.max(i)  
%
% Stat.external.min(i)  minimum/average/max external similarity/distance from
% Stat.external.avg(i)  objects of cluster i to the objects of other clusters
% Stat.external.max(i)
%
%DETAILS
%
%"Internal" for cluster k refers to all pairwise
%distances/similarities between objects belonging to the same
%cluster, i.e, for objects i for which partition(i)==k. 

%"External" for cluster k refers to all pairwise
%distances/simialrities between the members of the cluster and
%members of the other clusters, i.e., the whole similarity matrix
%excluding the internal similarities of cluster k.
%
%If between is set to 1 the function computes also the following
%KxK matrices 
%
%Stat.external.between.min(i,j)
%Stat.external.between.avg(i,j)
%Stat.external.between.max(i,j)
%
%These include distances/similarities  between clusters i and j
%defined as min/average/max pairwise distaces between objects
%belonging to clusters i and j, respectively. 
%

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

if nargin<2,
   error('You must give at least two input arguments.');
end

if nargin<3|isempty(between)
  between=0;
end

Ncluster=max(partition);
for cluster=1:Ncluster,
  thisPartition=partition==cluster;
  S_=S(thisPartition,thisPartition);
  Stat.N(cluster)=size(S_,1);
  S_(eye(size(S_))==1)=[];
  if isempty(S_),
    Stat.internal.sum(cluster)=1;
    Stat.internal.min(cluster)=1;
    Stat.internal.avg(cluster)=1;
    Stat.internal.max(cluster)=1;
  else
    Stat.internal.sum(cluster)=sum(S_);
    Stat.internal.min(cluster)=min(S_);
    Stat.internal.avg(cluster)=mean(S_);
    Stat.internal.max(cluster)=max(S_);
  end 
  if Ncluster>1,
    S_=S(thisPartition,~thisPartition);
    Stat.external.sum(cluster)=sum(S_(:));
    Stat.external.min(cluster)=min(S_(:));
    Stat.external.avg(cluster)=mean(S_(:));
    Stat.external.max(cluster)=max(S_(:));
  else
    Stat.external.sum(cluster)=NaN;
    Stat.external.min(cluster)=NaN;
    Stat.external.avg(cluster)=NaN;
    Stat.external.max(cluster)=NaN;
  end  
end

if between,
  Stat.external.between.min=zeros(Ncluster,Ncluster);
  Stat.external.between.max=zeros(Ncluster,Ncluster);
  Stat.external.between.avg=zeros(Ncluster,Ncluster);

  for i=1:Ncluster,
    Pi=find(i==partition);
    for j=i+1:Ncluster,
      Pj=find(j==partition);
      d_=S(Pi,Pj); 
      Stat.external.between.min(i,j)=min(d_(:));
      Stat.external.between.avg(i,j)=mean(d_(:));		
      Stat.external.between.max(i,j)=max(d_(:));		;		
    end
  end  
  
  Stat.external.between.min=Stat.external.between.min+ ...
    Stat.external.between.min';
  Stat.external.between.max=Stat.external.between.max+ ...
      Stat.external.between.max';
  Stat.external.between.avg=Stat.external.between.avg+ ...
      Stat.external.between.avg';
end