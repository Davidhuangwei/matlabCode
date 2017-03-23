% [Res Clu Spk Dat] = LoadData(FileBase, ElecNum, nChannelsTot, ElecChannels, nSpikesMax)
%
%  Loads in:	.res file
%                  	.clu file
%                  	.spk file
%                  	the portions of the .dat file corresponding to spike times
%
%  Res is an array of spike times (in samples) - straight from the file
%  Clu is an array of cluster assignments - again straight from the file
%  Spk is the spike waveforms, straight from the .spk file
%  Dat is a 3d array of unfiltered spikes extracted from the .dat file
%  	First array dimension : channel number
%  	Second dimension: time within spike waveform
%  	Third dimension: spike number (for cross-referencing to Res, Clu, and Spk]
%
%  ElecChannels is which channels of the dat file correspond to this electrode.
%  - also used to determine sizes for spike file
%
%  If ElecNum is 0, will read FileBase.res etc. -- otherwise will read
%  FileBase.res.ElecNum
%
% Will not load more than nSpikesMax.  If this is absent or zero, will load everything.


function [Res, Clu, Spk, Dat] = LoadData(FileBase, ElecNum, nChannelsTot, ElecChannels, nSpikesMax)

% Parameters: store number of samples before and after
BeforeSamps = 50;
AfterSamps = 50;
DatSamps = BeforeSamps + AfterSamps + 1;

% sizes for .spk file
SpkSamps = 32;
nChannels = max(size(ElecChannels));

% Make Filenames
if (ElecNum == 0)
	ResFileName = sprintf('%s.res', FileBase);
	CluFileName = sprintf('%s.clu', FileBase);
	SpkFileName = sprintf('%s.spk', FileBase);
	DatFileName = sprintf('%s.dat', FileBase);
else
	ResFileName = sprintf('%s.res.%d', FileBase, ElecNum);
	CluFileName = sprintf('%s.clu.%d', FileBase, ElecNum);
	SpkFileName = sprintf('%s.spk.%d', FileBase, ElecNum);
	DatFileName = sprintf('%s.dat', FileBase);
end;

% Load in Res file

fp = fopen(ResFileName, 'r');
Res = fscanf(fp, '%d', nSpikesMax);
fclose(fp);

% Load in Clu file
fp = fopen(CluFileName, 'r');
% Get number of clusters
nClusters = fscanf(fp, '%d', 1);
% Get rest of file
Clu = fscanf(fp, '%d', nSpikesMax);
fclose(fp);

% Get number of spikes and check Res and Clu files are the same size
nSpikes = size(Res,1);
if (size(Clu, 1) ~= nSpikes)
	warning('Clu file size not equal to Res file size');
end;

% check is nSpikesMax is exceeded
if (nargin >= 4 & nSpikes>nSpikesMax)
	nSpikes = nSpikesMax;
end;


% load spike data
fprintf('Loading spk file...\n');
Spk = bload(SpkFileName, [nChannels, nSpikes*SpkSamps]);
Spk = reshape(Spk, [nChannels, SpkSamps, nSpikes]);

% set up array for Dat
Dat = zeros(nChannels, DatSamps, nSpikes);

% load dat data	
fprintf('Loading dat file...\n');
fp = fopen(DatFileName, 'r');

for i=1:nSpikes	

	% go to correct part of wave file

	StartSamp = Res(i) - BeforeSamps;
		status = fseek(fp, StartSamp*nChannelsTot*2, 'bof');
		
		% if error, stop loading spikes
		if (status~=0)
			ferror(fp)
			break;
		end
		
		% Read in buffer
		WaveData = fread(fp, [nChannelsTot DatSamps], 'int16');

		% Extract the channels we want, and lose DC offset
		Dat(:, :, i) = WaveData(ElecChannels, :);
end
