function out = Summary(FileBase,varargin)

Par = LoadPar([FileBase]);

[dummy ElHpc] = GetChannels(FileBase,'h');
[dummy ElCx] = GetChannels(FileBase,'c');

CluLoc = load([FileBase '.cluloc']);

out.nClusters(1) = sum(ismember(CluLoc(:,1),ElCx));
out.nClusters(2) = sum(ismember(CluLoc(:,1),ElHpc));
out.FileBase = FileBase;
out.Labels = {'cx','hpc'};