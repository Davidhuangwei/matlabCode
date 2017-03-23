function sR=icassoExp(sR)
%function sR=icassoExp(sR)
%
%PURPOSE
%
%To prepare Icasso result struct for explorative analylsis, i.e.,
%to compute (dis)similarity matrix, clustering, and projection. 
%
%%First we produce an Icasso struct...
% load sf12
% sR=icassoEst('randinit',sf12,10);
%
%The following command performs the procedure explained in the
%publication:
%
% sR=icassoExp(sR);
%
%The next step would be to launch the interactive visualizations of
%the results: icassoViz(sR) or icassoShow(sR).
%
%DETAILS
%
% sR=icassoExp(sR) is equivalent of giving commands
%
% sR=icassoSimilarity(sR,'abscorr');   % Phase 1 similarities
% sR=icassoSim2Dis(sR,'sim2dis');      % Phase 2 dissimilarities
% sR=icassoCluster(sR,'AL');           % Phase 3 clustering 
% sR=icassoClusterValidity(sR,'auto'); % Phase 4 clust. validity
% sR=icassoProjection(sR,'cca');       % Phase 5 projection
%
% The user can customize the Icasso procdure by using script
% as a model.
%
% If sR contains readily computed results, and some phase
% is recomputed, the results from the rest of the phases are
% cleared in the ouput data struct as follows:
% 
% If phase 1 is recomputed results from phases 2-5 are cleared.
% If phase 2 is recomputed results from phases 3-4 are cleared.
% If phase 3 is recomputed results from phase  4 are cleared.
%
% That is, projection results (phase 5) do not depend on phases 2-4

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Phase 1
%
% Compute similarities between sR estimates as absolute values of
% their mutual linear correlations.
%
% 1.1 Compute similarities S between sR estimates
%     S=icassoSimilarity(sR,'abscorr')  
% 1.2 Record the similarity function into sR.cluster.simfcn, in
%     this case, 'abscorr'. Other possibilities are 'power' and 'corr'
% 1.3 store the similarity matrix S in field sR.cluster.similarity. 
%

sR=icassoSimilarity(sR,'abscorr');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Phase 2 (other function(s) involved: sim2dis, sim2dis2, corr2eucdist)
%
% 2.1 Compute dissimilarity matrix , e.g., 
%     D=sim2dis(sR.cluster.similarity) 
% 2.2 Store D into field sR.cluster.dissimilarity. 
% 2.3 Store the name of the similarity-to-dissimlarity
%     transformation function that is called into field
%     sR.cluster.sim2dis: in this case the name is 'sim2dis'. 
%     Other possibilities 'sim2dis2', 'corr2eucdist'

sR=icassoSim2Dis(sR,'sim2dis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Phase 3 (other function(s) involved: hcluster)
%
% Compute hierarchical clustering according to readily computed
% dissimilarities using average-linkage strategy. Other
% possibilities: 'CL' (comptele link) 'SL' (single-link)
%
% 3.1 Compute P=hcluster(sR.cluster.dissimilarity,'AL');
% 3.2 Store the partition P into field sR.cluster.partition
% 3.3 Store the agglomeration strategy in sR.cluster.strategy

sR=icassoCluster(sR,'AL');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Phase 4 (function(s) involded: rindex, balanceindex)
%
% Compute some clustering validity indices up to L clusters
% where L is the smaller one of 
%  - ceil(1.5*number_of_original signals) or
%  - number of estimates
%  - R-index L is at most 60 due to computational load
%
% L can be also specified explicitly 
%
% 4.1 Compute balance index up to L clusters
% 4.2 Store in into field sR.cluster.index.balance
% 4.4 Store them into field sR.cluster.index.dunn
% 4.5 Compute R-index up to L clusters - but at most 60 clusters.
% 4.6 Store them it into field sR.cluster.index.balance and
%     sR.cluster.index.balance and  
 
sR=icassoClusterValidity(sR,'auto');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Phase 5 
%
%Computes the coordinates for correlation graph using Curvilinear
%component analysis (see icassoProjection)
%
sR=icassoProjection(sR,'cca');

%%%
