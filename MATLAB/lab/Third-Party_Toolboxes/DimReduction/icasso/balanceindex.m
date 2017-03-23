function en=balanceindex(partition);
%function en=balanceindex(partition);
%
%PURPOSE
%
%To evaluate how balanced a partition is in terms of number of
%objects in each cluster:
%
%Normalized entropy is computed from the number of items belonging
%to each cluster 1,2,...,K(i) in each division, i.e., paritition(i,:). 
%%The normalized entropy is close to 1 for partitions where the
%clusters are of equal size and close to zero for unbalanced
%partitions.
%
%INPUT
%
% partition (LxN matrix) L (e.g, hierachical) partitions (rows) for
% the N objects.
%
%OUTPUTS
%
%en    (Nx1 vector) en(k) contains normalized entropy for partition(k,:)
%
%DETAILS
%
%Each row of matrix 'partition', i.e., partition(i,:), represents a
%division of N obejects into K(i) clusters (classes). On each row,
%clusters must be labeled with integers 1,2,...,K(i), where K(i) is
%the number of clusters that may be different on each row.  
%
%The index is computed as follows
%
%  n=hist(partition(i,:),1:K(i));
%  freq=n./sum(n);
%  en(i,1)=-sum(freq.*log10(freq))./log10(K(i));
%
%n(i) contains the number of items for cluster j in
%partition(k,:), and K(i) is the number of clusters in that partition.

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

N=size(partition,1),
M=size(partition,2);

% Number of clusters K at each row of partition
K=max(partition');

% This is for showing how computing advacnes...
completed=cumsum(K);

for i=1:N,
  if K(i)>1,
    n=hist(partition(i,:),1:K(i));
    freq=n./sum(n);
    en(i,1)=-sum(freq.*log10(freq))./log10(K(i));
  else
    en(i,1)=NaN;
  end
  clc;
  disp(['Computing ''balance'' index: ', ...
	sprintf('%3d', round(100*completed(i)/completed(end))), ...
       '% completed']);
end
