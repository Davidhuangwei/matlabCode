function [score,in_avg,ext_avg,in_min,ext_max]=icassoClusterRank(sR,graph,L,F)
%function score=icassoClusterRank(sR,graph,L,[F])
%
%PURPOSE
%
%To compute and/or plot the cluster ranking index on the specified
%dendrogram level. See publication for details in ranking.
%
%EXMAPLES OF BASIC USAGE
%
%First we produce an Icasso struct...
% load sf12
% sR=icassoEst('randinit',sf12,10);
% sR=icassoExp(sR);
%
%The following shows the ranking of clusters at dendrogram level
%L=20 (i.e. twenty clusters) with detailed representation
%
% icassoClusterRank(sR,'detailed',20);
%
%Same as previous but only computes results and returns them into
%workspace variable 'score'.
%
% score=icassoClusterRank(sR,'none',20);
%
%INPUTS []'s mean optional
%
% sR     Icasso result data struct. similarity and partition must be computed
% graph (string) 'detailed' | 'simple' | 'none' 
% L     (scalar) dendrogram levelm i.e. the number of clusters
% [F]   (string) 'mean' (default) | 'minmax' 
%
%OUTPUTS
%
% score (Lx1 matrix) score(i) contains the index for cluster C
%
%DETAILS
%
%In graph mode 'none'
% The function only computes the ranking index and returns it. No
% graphical output. score(C) contains the rank index for cluster
% C (That is, for estimates sR.cluster.partition(L,:)==C, see icassoStruct)
%In graph mode 'simple'
% The function computes the ranking index and plots the index in
% the active axis (gca) as follows: 
% The X-axis shows the value of the index for clusters that
% are ranked on the Y-axis in descending order according to the
% index. The Y-axis legend shows the cluster number (the same as in
% sR.cluster.partition(L,:)). The values are indicated by black
% circles connected into each other by a dotted line. 
%In graph mode 'detailed'
% As previous one but instead of the rank index of each clusteritself
%some statistics are shown. 
% Clear blue bar indicates the maximum external similarity in a cluster 
% Clear red                    minimum internal 
% Light blue                   average external
% Light red                    average internal
%
%The intra-cluster similarities for cluster C means the mutual
%similarities between the estimates in C, and the extra-cluster
%similarities for C are the similarities between the estimates in C
%and the estimates not in C. The default way of computing the index
%is to subtract the average extra-cluster similarity from the
%average intra-cluster similarity. You can also specify a more
%conservative but less robust criteria ('minmax') where the maximum
%extra-cluster similarity is subtracted from the minimum
%intra-cluster similarity. 
%
%SEE ALSO
% clusterrank
% icassoViz
% icassoShow

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

if nargin<4|isempty(F),
  F='mean';
end

partition=sR.cluster.partition(L,:);

[score1,in_avg,ext_avg,rank1]=clusterrank('mean',sR.cluster.similarity,partition);
[score2,in_min,ext_max,rank2]=clusterrank('minmax',sR.cluster.similarity,partition);

switch lower(F)
 case 'mean'
  titletext='R=avg(S(i)_{int})-avg(S(i)_{ext})';
  score=score1; rank=rank1;
 case 'minmax'
  titletext='R=min(S(i)_{int})-max(S(i)_{ext})';
  score=score2; rank=rank2;
 otherwise
  error('F must be ''mean'' or ''minmax''.');
end

switch lower(graph)
 case 'none'
  return;
 case 'simple'
  cla;
  h_score=plot(score(rank),1:L,'o:');
  set(h_score,'color','k','markersize',8);
  sample=h_score(1); lab='R';
  set(gca,'ytick',1:L,'yticklabel',rank,'ydir','reve');
  ax=axis;
  axis([ax(1) 1  0.5 L+.5]); 
  grid on;
 case 'detailed'
  cla;
  h_in_avg=barh(in_avg(rank),0.7); hold on
  h_ext_max=barh(-ext_max(rank),0.35); 
  h_in_min=barh(in_min(rank),0.35); 
  h_ext_avg=barh(-ext_avg(rank),0.7); 
  axis on
  set(h_in_avg,'facecolor',[1 0.7 0.7]); hold on;
  set(h_in_min,'facecolor',[1 0 0])
  set(h_ext_avg,'facecolor',[0.7 0.7 1])
  set(h_ext_max,'facecolor',[0 0 1])
  axis([-1 1 0.5 L+.5]); 
  
  set(gca,'ytick',1:L,'yticklabel',rank,...
	  'ydir','reve','xtick',[-1 -.5 0 .5 1],...
	  'xgrid','on',...
	  'xticklabel',{'1' '0.5 ' '0' '0.5' '1'});
  lab={'mean S_{in}' 'mean S_{ex}' 'min S_{in}' 'max S_{ex}'};
  sample=[h_in_avg(1),h_ext_avg(1),h_in_min(1),h_ext_max(1)];
 otherwise
  error('Graphmode must be ''none'',''simple'' or ''detailed''.');
end

title(titletext);
ylabel('Cluster #');
legend(sample,lab,-1);
  

