function [CovMat, XCov] = GetXCov(DatFile, ResFile, nChannels, PCs, SamplesToLoad, Channels2Use)
% Makes a Covariance matrix for multichannel noise passed through a PCA
%
% [CovMat, XCov] = GetXCov(DatFile, ResFile, nChannels, PCs, SamplesToLoad, Channels2Use)
%
% PCs are specified by PCs.  If PCs is a 3D array, the third dim corresponds to
% channel number.  If not, it assumes all channels go through the same set of PCs
%
% Will ignore 32 samples around each spike marked in ResFile
% and won't go beyond SamplesToLoad
%
% nChannels is number of channels in the file
% Channels2Use is which to actually use - defaults to all of them
% At the moment you use 4 channels.
%
% assumes the file is short int.
%
% returns a 12x12 matrix CovMat


%preliminary stuff

nPCs = size(PCs,2);
PCSize = size(PCs,1);
if size(PCs,3) == 1
	AllChannelsSamePCs = 1;
elseif size(PCs, 3) ~= nChannels
	error('Size of PCs third dimension must be equal to number of channels or 1');
else
	AllChannelsSamePCs = 0;
end;

if (nargin < 5) SamplesToLoad = inf; end;
if (nargin < 6) Channels2Use = 1:nChannels; end;

% load .res file
if (isempty(ResFile))
	Res = [];
else
	Res = load(ResFile);
end;

% Set up arrays to store cross-covariance and normalisation factor
XCov = zeros(2*PCSize-1, 16);
CovNorm = zeros(2*PCSize-1, 1);

% Go through .dat file, one chunk at a time
LastSpikeTime = 0;
for NextSpikeTime = Res(:)'
	if (NextSpikeTime > SamplesToLoad) break; end;
	ChunkSize = NextSpikeTime - LastSpikeTime - 64;
	if (ChunkSize >= 100)
		dat = bload(DatFile, [nChannels, ChunkSize], (LastSpikeTime+32)*nChannels*2);
		dat = dat(Channels2Use,:);
		XCov = XCov + xcov(dat',PCSize-1);
		CovNorm = CovNorm + ChunkSize - abs((1:2*PCSize-1)' - (PCSize));
	end;
	LastSpikeTime = NextSpikeTime;
end;

% Now load in last chunk
if (NextSpikeTime < SamplesToLoad)
	dat = bload(DatFile, [nChannels, inf], (LastSpikeTime+32)*nChannels*2);
	dat = dat(Channels2Use,:);
	ChunkSize = size(dat, 2);
	if (ChunkSize >= 100)
		XCov = XCov + xcov(dat',PCSize-1);
		CovNorm = CovNorm + ChunkSize - abs((1:2*PCSize-1)' - (PCSize));
	end;
end;
	
% Normalize covariance
XCov = XCov ./ repmat(CovNorm, 1, 16);

% set up answer matrix

CovMat = zeros(12, 12);

% go through each pair of electrodes

for e1=1:4
	for e2=1:4
		TimeCovMat = toeplitz(XCov(PCSize:2*PCSize-1,(e1-1)*4+e2), ...
							  XCov(PCSize:-1:1,(e1-1)*4+e2)...
		);
		if AllChannelsSamePCs
			CovMat((e1-1)*3+1:e1*3, (e2-1)*3+1:e2*3) = PCs'*TimeCovMat*PCs;
		else
			CovMat((e1-1)*3+1:e1*3, (e2-1)*3+1:e2*3) = PCs(:,:,e1)'*TimeCovMat*PCs(:,:,e2);
		end;
	end;
end;