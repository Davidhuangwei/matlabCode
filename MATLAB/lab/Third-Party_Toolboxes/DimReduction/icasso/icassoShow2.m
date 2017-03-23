function [centrotype,clusterquality]=icassoShow(sR, varargin)
%function icassoShow(sR, varargin)
%
%PURPOSE
%
%To generate explorative visualizations for Icasso.
%
%EXAMPLES OF BASIC USAGE
%
%load sf12
%sR=icassoEst('randinit',sf12,10);
%sR=icassoExp(sR);
%
%icassoShow(sR);
%
%icassoShow(sR,'level',20,'limit',0.1,'dense',0.8)
%
%sR Icasso result struct
%
% ['identifier1',value1, 'identifier2',value2,...] 
% default: {'graph','on','graphscale','normal',
%           'level','auto','limit',0.25,'dense',0.9,
%           'source','on','rank','mean'};
%
% 'graph'  'on' (default) | 'off'
%   whether to show the similarity graph or not; in mode 'off' only
%   the cluster hulls are shown
% 'graphscale' 'linear' (default) | 'equalized' 
%   sets the limits (similarity) for the three gray shades in use
%   'equalized' sets equal number of lines for each shade, 'linear'
%    sets linear scale for the shades. 
% 'level' integer | 'datadim' (default)  
%   sets the number of clusters (interger) 'datadim' sets the
%   number of clusters to original data dimension
% 'limit' scalar in [0,1] default 0.25
%   similarities below this limit are completely suppressed from
%   the similarity graph (see also reducesim)
% 'dense' scalar in [0,1] default 0.9 
%   if the average/minimum intra-cluster similarity is above this limit,
%   the cluster hull is shaded light/clear red instead of drawing the
%   similarity graph
% 'source' 'on' (default) | 'off' 
%   whether to show the centrotype of the source estimates
%   associated to each cluster or not 
%
%%DETAILS 
%
%The function creates three figures (figures number 1,2,3) 
%
% Figure 1: Icasso: Clusters & Correlation graph 
%Shows the similarity graph and clusters. Estimates are presented
%with dark red points. Estimates belonging to the same cluster are
%bounded by a red convex hull. If the average similarity in a cluster
%is above a specified limit 'dense', (input argument pair
%'dense', 0.8 in our example) the graph lines inside the cluster are replaced by
%light red fill color. If the _minimum_ intra-cluster similarity is
%above the same limit, the cluster fill color is clear red. The
%graph lines can be suppressed below a certain value T of similarity
%by giving input argument pair 'limit', ('limit',0.1) in our
%example. You can suppress the similarity graph completely by
%giving input argument pair 'graph','off'. 
%
%Cluster labels are the same as in Figures 2 and 3.
%
%If you click on a cluster hull or a cluster label (number) the
%cluster label is stored in workspace variable CLUSTER
%and indices for the corresponding estimates are in
%workspace variable INDEX. (The variables are created if
%necessary). You can retirieve the estimates
%from the Icasso result struct with function icassoGet.
%For example, icassoGet(sR,'source',INDEX) would retrieve the
%estimated independent components in our example, and
%icassoSourceplot(sR,INDEX) would plot them. 
%
%Note that the function will automatically to change this threshold
%to keep the number of lines reasonable if more than 5000 are
%produced.
%
% Figure 2: Icasso: Cluster quality
%Shows cluster ranking. Left panel shows the value of the cluster
%raniking index (x-axis) for each cluster (label on y-axis) the
%right panel shows some statistics: the avergage intra- and
%extra-cluster similarity, the minimum intra-cluster similarity and
%the maximum extra-cluster similarity for each clsuter. The
%intra-cluster similarities for cluster C means the mutual
%similarities between the estimates in C, and the extra-cluster
%similarities for C are the similarities between the estimates in C and
%the estimates not in C. The default way of computing the index is
%to subtract the average extra-cluster similarity from the average
%intra-cluster similarity. ('rank','mean'), you can also specify a
%more conservative but less robust criteria ('rank','minmax') where
%the maximum extra-cluster similarity is subtracted from the
%minimum intra cluster-similarity. (see icassoClusterRank)
%
% Figure 3: Icasso: Centrotype estimates
%Shows centrotype estimate (independent component) for each
%cluster (labels are the same as in figures 1 and 2. You can
%suppress this window by giving input argument pair 'source','off'.
%
%SEE ALSO
% icassoGet
% icassoSourceplot
%
if nargin<1|isempty(sR),
  error('At least one input argument expected');
end

if isempty(sR.projection.coordinates) | isempty(sR.cluster.partition) | ...
      isempty(sR.cluster.index) | isempty(sR.cluster.similarity), 
  error('Missing similarity/projection/cluster information.');
end

% Define some colors
BASICedge=[0.85 0 0];
%ISOLATEDedge=[1 0 0];

BASICface=[NaN NaN NaN]; % invisible!
DENSEface=[1 .7 .7];
VERYDENSEface=[1 0 0];
% initiate some boolean vectors
isDense=[];  
isVeryDense=[];
isIsolated=[];
% initiate graphic handles
h_graph=[];   % graph lines
graphText=[]; % label texts for graph lines
h_fill=[];    % solid patches: (fill of cluster hulls)
h_edge=[];    % open patches: edges of cluster hulls

% initiate output args.
centrotype=[]; clusterquality=[];
autolevel=size(sR.signal,1);

%% Set defaults and process optional imput
default={'graph','on','graphscale','normal',...
	 'source','on','level',autolevel,...
	 'limit',0.25,'dense',0.9,...
	 'rank','mean'};

varargin=processvarargin(varargin,default);
num_of_args=length(varargin);

for i=1:2:num_of_args,
  id=varargin{i}; value=varargin{i+1};
  switch lower(id)
   case 'graph'
    switch lower(value)
     case 'on'
      graph=1;
     case 'off'
      graph=0; 
     otherwise
      error('GRAPH must be either ON or OFF.');
    end
   case 'source'
    switch lower(value)
     case 'on'
      source=1;
     case 'off'
      source=0; 
     otherwise
      error('SOURCE must be either ON or OFF.');
    end
   case 'level'
    if isnumeric(value);
      level=value;
    else
      switch lower(value)
       case 'datadim'
	level=autolevel;
       otherwise
	error(['Unknown value for identifier ' varargin{i}']);
      end
    end
   case 'limit'
    lowlimit=value; 
   case 'dense'
    denseLim=value;
   case 'graphscale'
    switch lower(value);
     case 'normal'
      graphmode='sqrt';
     case 'equalized'
      graphmode='equalized'
     otherwise
      error(['Unknown value for identifier ' varargin{i}']);
    end
   case 'rank'
    switch lower(value)
     case {'mean','minmax'}
      rank=lower(value);
     otherwise
      error(['Unknown value for identifier ' varargin{i}']);
    end
   otherwise
    error(['Doesn''t recognize icassoShow option ''' varargin{i} '''.']);
  end
end

p=sR.projection.coordinates; 
c=sR.cluster.similarity;

% Initiate figure 1, clear, and hold on
figure(1);
clf; hold on; 

% Check if cluster level is valid
maxCluster=size(sR.cluster.partition,1);
if level<=0 | level>maxCluster,
  error('Cluster level out of range or not specified.');
end

% Take the partition for level
partition=sR.cluster.partition(level,:);
Ncluster=max(partition);
  
% Compute statistics
s=clusterstat(c,partition);
  
% Reduce similarities 
% If partitioning is computed, limit not only by lowlimit but also
% by denseLim: ignore lines inside cluster hulls if average internal
% similarities are over denseLim (dense clusters)
c=reducesim(c,lowlimit,partition,s.internal.avg,denseLim);

% set flag for dense clusters
isDense=s.internal.avg(:)>=denseLim; Ndense=sum(isDense);

% set flag for very dense clusters
isVeryDense=s.internal.min(:)>=denseLim; NveryDense=sum(isVeryDense);
  
% set flag for isolated clusters
%isIsolated=s.external.max(:)<isolatedLim; Nisolated=sum(isIsolated);
  
% set colors
edgeColorMatrix=repmat(BASICedge,Ncluster,1);
%edgeColorMatrix(isIsolated,:)=repmat(ISOLATEDedge,Nisolated,1);
faceColorMatrix=repmat(BASICface,Ncluster,1);
faceColorMatrix(isDense,:)=repmat(DENSEface,Ndense,1);
faceColorMatrix(isVeryDense,:)=repmat(VERYDENSEface,NveryDense,1);
  
% draw faces for dense & isolated clusters; they have to be in
% bottom; otherwise they shade everything else

h_fill=clusterhull('fill',p,partition,faceColorMatrix);
  
% Next step: draw similarity graph and/or vertices if set
if graph,
  % graph is set: draw lines, graphmode sets gray scaling
  [tmp,h_graph,graphText]=similaritygraph(p,c,graphmode);
  ax=axis;
  xwidth=ax(2)-ax(1);
else
  % Only vertices
  similaritygraph(p);
  ax=axis;
  xwidth=ax(2)-ax(1);
end

% Last thing is to set hull edges

[h_edge,txtcoord]=clusterhull('edge',p,partition,edgeColorMatrix); 

% ..and cluster labels 

txt=num2str([1:Ncluster]'); 
h_text=text(txtcoord(:,1)-xwidth/100,txtcoord(:,2),cellstr(txt));
for i=1:Ncluster,
  set(h_text(i),'horiz','right','color','k','fontsize',18);
end

% Set ButtonDown functions for lauching customized visualizations
for cluster=1:level,
  index=partition==cluster;
  set(h_edge(cluster,1),'userdata',[cluster find(index)], ...
		    'buttondownfcn',icassoShowButtonDownF);
  set(h_text(cluster,1),'userdata',[cluster find(index)],'buttondownfcn',icassoShowButtonDownF);
end

% Legend
%setlegend(h_graph,graphText,h_fill,h_edge,isDense,isVeryDense, ...
%		  isIsolated,denseLim,isolatedLim)
setlegend(h_graph,graphText,h_fill,h_edge,isDense,isVeryDense,denseLim)

% Set figure name
set(1,'numbertitle','off','name','Icasso: Clusters & Correlation graph');

% Initiate custom visualization
icassoCustom(sR);

figure(2); clf;
subplot(1,2,1);
clusterquality=icassoClusterRank(sR,'simple',level,rank);
subplot(1,2,2);
icassoClusterRank(sR,'detailed',level,rank);
set(2,'numbertitle','off','name','Icasso: Cluster quality');

ax=axis;
hold on; 
plot([denseLim denseLim],ax(3:4),'k-'); 
text(denseLim, ax(3),'dense');
%plot([-isolatedLim -isolatedLim],ax(3:4),'k-'); 
%text(-isolatedLim, ax(3),'limit');

[tmp,i]=sort(-clusterquality);
centrotypes=icassoCentrotype(sR,'partition',partition);
  
% Launch optionally also plot of source estimates corresponding to cluster centroids
if source,
  figure(3); clf;
  set(3,'numbertitle','off','name','Icasso: centrotype estimates');
  icassoSourceplot(sR,centrotypes(i)); 
  axis on; set(gca,'ytick',1:level,'yticklabel',i,'xtick',[]); 
  grid off; axis([-.46 .46 0.5 level+.5]);
end

function setlegend(h_graph,graphText,h_fill,h_edge,isDense,isVeryDense,dense)
%function setlegend(h_graph,graphText,h_fill,h_edge,isDense,isVeryDense,isIsolated,dense,isolated)

%h_isolated=findobj(h_edge(isIsolated&isfinite(h_edge)),'type','patch');
%h_notisolated=findobj(h_edge(~isIsolated&isfinite(h_edge)),'type','patch');
%h_edge=findobj(h_edge);
h_dense=findobj(h_fill(isDense&~isVeryDense&isfinite(h_fill)),'type','patch');
h_verydense=findobj(h_fill(isVeryDense&isfinite(h_fill)),'type','patch');

%if ~isempty(h_isolated),
%  h_graph(end+1)=h_isolated(1);
%  graphText{end+1}=['max S_{ext}<' sprintf('%0.2f',isolated)];
%end

%if ~isempty(h_notisolated),
%  h_graph(end+1)=h_notisolated(1);
%  graphText{end+1}=['max S_{ex}\geq ' sprintf('%0.2f',isolated)];
%end

%if ~isempty(h_edge),
%  h_graph(end+1)=h_edge(1);
%  graphText{end+1}=['max S_{ex}\geq ' sprintf('%0.2f',isolated)];
%end

if ~isempty(h_dense),
  h_graph(end+1)=h_dense(1);
  graphText{end+1}=['mean S_{in}\geq ' sprintf('%0.2f',dense)];
end

if ~isempty(h_verydense),
  h_graph(end+1)=h_verydense(1);
  graphText{end+1}=['min S_{in}\geq ' sprintf('%0.2f',dense)];;
end


legend(h_graph,graphText);