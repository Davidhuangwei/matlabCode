function sR=icassoClusterValidity(sR,L)
%function sR=icassoClusterValidity(sR,[L])
%
%PURPOSE 
%
%To compute cluster validity indices (R-index and 'balance' index)
%according to the readily computed dissimilarity matrix
%D=sR.cluster.dissimilarity and partition matrix
%P=sR.cluster.partition. 
%
%EXAMPLE OF BASIC USAGE
%
% sR=icassoClusterValidity(sR,30);
% 
%where sR is Icasso result struct. This computes the validity
%indices for all levels of dendrogram up to L=30 clusters, i.e.,
%for parititions having 1,2,...,30 clusters 
%
% sR=icassoClusterValidity(sR,'auto');
%
%determines L heuristically: L=ceil(1.25*original data dimension),
%however, for R-index in maximum 60 (too slow for bigger L). 
%
%INPUT []'s mean optional 
%
% sR  (struct) Icasso result struct 
% [L] (scalar) or string 'auto' (default) dendrogram level (max. number of
%       clusters) 
%
%OUTPUT
%
% sR (struct) Updated Icasso result struct, 
%
%The function updates _only_ the following fields:
%(M is number of estimates)
%
% sR.cluster.index.rindex  (Mx1 vector) values of R-index. Minimum
%   value shows the "best" clustering 
% sR.cluster.index.balance (Mx1 vector) maximum value shows the
%   clustering where the cluster sizes measured by number of elements
%   in clusters are most balanced. 
%
%Value NaN indicates that the cluster validity index
%hasn't been computed for that level of dendrogram 
%
%SEE ALSO
% rindex
% balanceindex
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

if nargin<2|isempty(L),
  L='auto';
end

% number of estimates;
M=icassoGet(sR,'M');

% Init the variables
balance=ones(M,1)*NaN;
R=ones(M,1)*NaN;
dim=size(sR.signal,1);

if isnumeric(L),
  % The user has specified max number for clusters
  
  % Check L 
  if fix(L)~=L,
    error('L must be integer.');
  elseif L<2,
    error('L must be at least 2.');
  elseif L>M,
    error('L cannot be more than the number of estimates.');
  end
  L,
  pause,
  sR.cluster
  sR.cluster.index.balance(1:L)=...
      balanceindex(sR.cluster.partition(1:L,:));
  L
  sR.cluster.index.R(1:L,:)=...
      rindex(sR.cluster.dissimilarity,sR.cluster.partition(1:L,:));  
  %sR.cluster.index.dunn(1:L,:)=...
  %    dunnindex(sR.cluster.dissimilarity,sR.cluster.partition(1:L,:));  
else
  if ~strcmp(lower(L),'auto'),
    error('Integer value or ''auto'' expected for ''validityindex''.');
  end
  % some heuristics for limiting the computation of clustering
  % validity indices
  
  % Compute balance index up to 1.5*original signal dim
  L=ceil(1.5*dim);
  % But no more than there are clusters 
  if L>M;
    L=M;
  end
  
  sR.cluster.index.balance(1:L)=balanceindex(sR.cluster.partition(1:L,:));
  
  % However, don't compute more than 60 for R-index: too heavy
  if L>60,
    L=60;
  end
  
  % Compute R-index up to L (<=60)
    sR.cluster.index.R(1:L,:)= ...
      rindex(sR.cluster.dissimilarity,sR.cluster.partition(1:L,:));
    %sR.cluster.index.dunn(1:L,:)=...
    %  dunnindex(sR.cluster.dissimilarity,sR.cluster.partition(1:L,:));

end
