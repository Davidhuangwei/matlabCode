function S=reducesim(S,minLimit,partition,scatter,scatterLimit)
%function S=reducesim(S,minLimit)
% or
%function S=reducesim(S,minLimit,partition,scatter,scatterLimit)
% 
%PURPOSE
%
%To reduce the number of lines that are drawn when the similarity
%matrix is visualized. That is, to set similarities - below certain
%threshold to zero, and optionally, also within-cluster
%similarities above certain threshold to zero.
%
%INPUTS 
%
% Two input arguments:
%
% S        (matrix) NxN similarity matrix
% minLimit (scalar) all values below this theshold in S are st to
%            zero
% Five input arguments:
%
% S         (matrix) NxN similarity matrix
% minLimit  (scalar) all values below this theshold in S are st to
%             zero
% partition (vector) Nx1 partition vector into K clusters 
% scatter   (vector) Kx1 vector that contains within-scatter for
%             each cluster i=1,2,...,K implied by vector partition 
% scatterLimit (scalar) threshold for within-cluster scatter.
%
%SEE ALSO
% clusterstat.m
% icassoShow.m

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

if nargin==2|nargin==5,
  ;
else
  error('You must specify 2 or 5 input arguments!');
end

%%% Maximum number of lines
MAX_NLINES=5000;

%%% Set within-cluster similarities above certain threshold to zero
if nargin==5,
  Ncluster=max(partition);
  for i=1:Ncluster,
    index=partition==i;
    if scatter(i)>scatterLimit;
      S(index,index)=0;
    end
  end
end

%%% We assume symmetric matrix and don't care about
%self-similarities upper diagonal is enough

S=tril(S); S(eye(size(S))==1)=0;

%% Number of lines to draw
Nlines=sum(sum(S>minLimit));

%%% If too many lines, try to fork better miLimit
if Nlines>MAX_NLINES,
  warning('Creates overwhelming number of lines');
  warning('Tries to change the limit...');
  minLimit=fork(S,MAX_NLINES);
  warning(['New limit =' num2str(minLimit)]);
end

%%% Set values below minLimit to zero
S(S<minLimit)=0;


function climit=fork(c,N)

%function climit=fork(c,N)

C=c(:);
if N>=length(C),
  climit=0;
  return;
elseif N==0,
  error('Zero not allowed.');
end

k=0;

lLimit=0;
hLimit=1;
limit=(lLimit+hLimit)/2;

n=sum(C>=limit);

while abs(n-N)>(N*0.01),
   k=k+1;
   if n>N,
      lLimit=limit;
      limit=(limit+hLimit)/2;
   elseif n<N,
      hLimit=limit;
      limit=(limit+lLimit)/2;
   else
      break;
   end
   n=sum(C>limit & C);
   if k>100,
     error('Failed to reduce lines.');
   end
end

climit=limit;




