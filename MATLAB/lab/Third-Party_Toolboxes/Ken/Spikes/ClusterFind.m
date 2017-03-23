function [FileNo, SubCluster] = ClusterFind(FileBase, ClusterNo)
% gives the cluster number in the original .clu.n file for a
% specified cluster in the .clu file
%
% [FileNo SubCluster] = ClusterFind(FileBase, ClusterNo)
%
% FileBase is the full path of the files
% e.g. /u3/hajime/data/l9/S3/l9-10/l9-10
%
% ClusterNo is the cluster number in the .clu file
%
% FileNo returns n for which .clu.n the appropriate cluster is in
%
% SubCluster returns which cluster it is within this file.


% first see what cluster files are there and get the number of cluster
% in each one

n = 1;
while (1)
	CluFileName = strcat(FileBase, '.clu.', num2str(n));
	fp = fopen(CluFileName, 'r');
	if (fp == -1) break; end;
	
	nc = fscanf(fp, '%d', 1);
	if isempty(nc) break; end;
	
	NumClusters(n) = nc;
		
	fclose(fp);
	
	n = n+1;
end;

nClusterFiles = n-1;

% now get rid of noise clusters

NumClusters = NumClusters -1;
ClusterNo = ClusterNo - 1;

CumSum = 0;
for FileNo=1:nClusterFiles
	if (ClusterNo <= CumSum + NumClusters(FileNo)) break; end;
	CumSum = CumSum + NumClusters(FileNo);
end;

SubCluster = 1 + ClusterNo - CumSum;