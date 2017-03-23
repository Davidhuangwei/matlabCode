function [score,in,out,rank]=clusterrank(f,S,partition)
%function [score,in,out,rank]=clusterrank(f,S,partition)
%
%PURPOSE
%
%To compute ranking index for the given clusters. The more dense
%and isolated a cluster is the bigger value the index gets. See
%publication.   
%
%INPUT
%
% f          (string) cluster score function 'minmax' or 'mean'
% S          (NxN matrix) similarity matrix
% partition  (Nx1 vector) partition vector
%
%OUTPUT
%
%score       (Kx1 vector) score(k) contains the index value for
% cluster k: score(k)=in(k)-out(k) 
%in          (Kx1 vector)   
%out         (Kx1 vector) 
%rank        (Kx1 vector) rank(k) is the ranking of cluster k
% according to score
%
%DETAILS
%
%If f='mean' the mean extra-cluster similarity is subtracted
% from the mean intra-cluster similarity (see publication)
%
%If f='minmax' the maximum extra-cluster similarity is subtracted from
% the minimum intra-cluster similarity.

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

Ncluster=max(partition);
s=clusterstat(S,partition);

% Compute score
switch lower(f)
 case 'mean'
  in=s.internal.avg;
  out=s.external.avg;
 case 'minmax'
  in=s.internal.min;
  out=s.external.max;
 otherwise
  error('Unrecognized score function.');
end

score=in-out;

% set rank according to the score
i=[1:Ncluster]';
[tmp,order]=sort(-score);
rank=i(order);

