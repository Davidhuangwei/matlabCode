% ReCluster(FileBase, ElecNo, CluNos, MinClusters, MaxClusters, KKArgs)
%
% reads in FileBase.fet.n and FileBase.clu.n,
% selects only those spikes belongs to clusters in CluNos
% and re-runs KlustaKwik on them.
% The old cluster is deleted, and new ones are assigned
% starting from the max cluster number in the file
%

function ReCluster(FileBase, ElecNo, CluNos, MinClusters, MaxClusters, Opts)

if nargin<4
	MinClusters = 2;
end
if nargin<5
	MaxClusters = MinClusters+10;
end
if nargin<6
    Opts = '';
end

Fet = LoadFet([FileBase '.fet.' num2str(ElecNo)]);
Clu = LoadClu([FileBase '.clu.' num2str(ElecNo)]);

MaxClu = max(Clu);

MySpikes = find(ismember(Clu, CluNos));

if length(MySpikes)==0
	error('No spikes in specified clusters!');
end

Tmp = tempname;

SaveFet([Tmp '.fet.1'], Fet(MySpikes,:));

Exec = '/home/ken/code/KlustaKwik/version-1.6/KlustaKwik';

Cmd = sprintf('!%s %s 1 -MinClusters %d -MaxClusters %d %s', ...
			Exec, Tmp, MinClusters, MaxClusters, Opts);

eval(Cmd);

r = input('Save it?', 's');

if r(1) == 'y'
	% save old clu file
	eval(['!cp ' FileBase '.clu.' num2str(ElecNo) ...
            ' ' FileBase '.clu.' num2str(ElecNo) '.save']);
	
	NuClu = LoadClu([Tmp '.clu.1']);
    Clu(MySpikes) = NuClu+MaxClu;
    SaveClu([FileBase '.clu.' num2str(ElecNo)], Clu);
end

% remove temp files
eval(['!rm ' Tmp '.*']);

