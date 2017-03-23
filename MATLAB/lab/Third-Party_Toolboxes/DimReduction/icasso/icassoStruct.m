function sR=icassoStruct(X)
%
%function sR=icassoStruct([X])
%
%PURPOSE
%
%To initiate an Icasso result data structure, which is meant for
%storing and keeping organized all data, parameters and results
%when performing the Icasso procedure. 
%
%EXAMPLE OF BASIC USAGE
%
% S=icassoStruct(X);
%
%creates an Icasso result struct in workspace variable S. Its
%fields are initally empty except field .signal that contains
%matrix X. 
%
%INPUTS []'s mean optional arguments
%
%[X] (dxN matrix) the original data (signals) consisting of N
%      d-dimensional vectors. Icasso removes sample mean from
%      these and stores it in field .signal. If the argument is not
%      given, or it is empty, the field is left empty.
%
%OUTPUT
%
% sR (struct) Icasso result struct that contains fields
%
%    .mode              (string)
%    .signal            (matrix)
%    .index             (matrix)
%    .fasticaoptions    (cell array)
%    .A                 (cell array)
%    .W                 (cell array)
%    .whiteningMatrix   (matrix)
%    .dewhiteningMatrix (matrix)
%    .cluster           (struct)
%    .projection        (struct)
%
%DETAILS
%
%The following table presents the fields of Icasso result
%struct. Icasso is a sequential procedure that is split into
%several functions. The table shows the order in which the fields
%are computed, the function that is used to change the
%paramters/results in the field, and lastly the other fields that
%the result depends on.  
%
%Phase Field                  Function               Depends on                      
%(1a) .mode                   icassoEst              (user input)   
%(1a) .signal                 icassoEst              (user input)
%(1b) .index                  icassoEst              (1a)
%(1a) .fasticaoptions         icassoEst              (user input)
%(1b) .A                      icassoEst              (1a)
%(1b) .W                      icassoEst              (1a)
%(1b) .whiteningMatrix        icassoEst              (1a)
%(1b) .dewhiteningMatrix      icassoEst              (1a)
%
%(2)  .cluster.simfcn         icassoSimilarity       (user input)
%(2)  .cluster.similarity     icassoSimilarity       (1)
%(3a) .cluster.sim2dis        icassoSim2Dis          (user input)
%(3a) .cluster.dissimilarity  icassoSim2Dis          (1-2)
%(4)  .cluster.strategy       icassoCluster          (user input)
%(4)  .cluster.partition      icassoCluster          (1,2,3a)
%(5)  .cluster.index.balance  icassoClusterValidity  (1,2,3a,4)
%(5)  .cluster.index.R        icassoClusterValidity  (1,2,3a,4)
%
%(3b)  .projection.parameters  icassoProjection      (user input)
%(3b)  .projection.coordinates icassoProjection      (1-2)
% 
%(1a and 1b) Data, ICA paramters, and estimation results
%
%   .mode (string) 
%     type of randomization ('bootstrap'|'randinit'|'both')
%
%   .signal (dxN matrix) 
%     the original signal X (mean has been
%     subtracted) where N is the number of samples and D the dimension
%
%   .index  (Mx2 matrix) 
%     the left column is the number of the estimation round, the
%     right one is the number of the estimate on that round.
%     See also function: icassoGet
%
%The following fields contain parameters and results of the ICA
%estimation using FastICA toolbox. More information can be found,
%e.g., from of function fastica in FastICA toolbox.
%
%   .fasticaoptions (cell array) 
%     contains the options that FastICA used in estimation.
%
%   .A (cell array of matrices) 
%     contains mixing matrices from each estimation cycle
%
%   .W (cell array of matrices) 
%     contains demixing matrices from each estimation cycle
%
%   .whiteningMatrix (matrix) 
%     whitening matrix for sR.signal
%
%   .dewhiteningMatrix (matrix) 
%     dewhitening matrix for sR.signal.
%
%(2,3a) Mutual (dis)similarities and (4) clustering
%
% Parameters and results of 
%  -computing (dis)similarities between the estimates, and
%  -clustering the estimates according to the dissimilarities
% are stores in field .cluster having the following subfields:
%
%   .cluster.simfcn (string)
%     Tells how mutual similarities between estimates are computed;
%     string option for icassoSimilarity function that is used to
%     compute the similarities.
%
%   .cluster.similarity (MxM matrix) 
%     mutual similarities between estimates:
%
%   .cluster.sim2dis (string) 
%     tells how similarities (in field .cluster.similarity) were
%     transformed into dissimilarities (in field .cluster.dissimilarity); 
%     name of the workspace function that was used to transform the
%     similarities 
%
%   .cluster.dissimilarity (MxM matrix) 
%     mutual similarities between estimates
%
%   .cluster.strategy (string) 
%     agglomeration strategy that was used for hierarchical
%     clustering which is done on the dissimilarity matrix  found
%     in .cluster.dissimilarity. 
%
%   .cluster.partition (MxM matrix) 
%     Stores the partitions resulting from the hierarchical
%     clustering.
%
%(5) Clustering valdity indices
%
% The following subfiles of .cluster contain different validity
% scores for the partitions in .cluster.partition. If the score is
% NaN it means that the validity has not been (or can't be)
% computed. 
%
%   .cluster.index.balance (Mx1 vector) 
%
%   .cluster.index.R (Mx1 vector) 
%
%(3b) Projection for visualization
%
% Parameters for performing the projection for visualizing the
% resulting coordinates for each estimate are stored in field
% .projection. 
%
%  .projection has the following subfields. 
%
%  .projection.method (string)
%     projection method used in icassoProjection
%
%  .projection.parameters (cell array)
%     contains paramters used in icassoProjection
%
%  .coordinates (Mx2 matrix)
%     contains the coordinates of the projected estimates
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
%Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
%02111-1307, USA.

if nargin<1|isempty(X),
  X=[];
else
  X=remmean(X);
end

sR.mode=[]; 
sR.signal=X;
sR.index=[];
sR.fasticaoptions=[];
sR.A=[];
sR.W=[];
sR.whiteningMatrix=[];
sR.dewhiteningMatrix=[];
sR.cluster=initClusterStruct;
sR.projection=initProjectionStruct;

function cluster=initClusterStruct

cluster.simfcn=[];
cluster.similarity=[];
cluster.sim2dis=[];
cluster.dissimilarity=[];
cluster.strategy=[];
cluster.partition=[];
cluster.index.balance=[];
cluster.index.R=[];

function projection=initProjectionStruct

projection.method=[];
projection.parameters=[];
projection.coordinates=[];
