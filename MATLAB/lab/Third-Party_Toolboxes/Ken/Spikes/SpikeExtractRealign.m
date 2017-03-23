% Spikes = SpikeExtractRealign(DatFileName, IntraInfoFileName, NumChannels,
%			SampleRate, ExtraChannels, IntraChannel, BeforeSamps, AfterSamps)
%
%  Extracts spikes using joint intra/extra data
%
%  will produce an array of 4 extracellular
%  channels and 1 intracellular channel
%  from the specified .dat fie
%
%  First output array dimension : channel number
%  Second dimension: time within spike waveform
%  Third dimension: spike number
%
%  requires Darryl's intracellular spike info file
%  with the 1st line chopped off (IntraInfo file)
%
%  Assumes input is centered on 2048.
%
%  SamplingRate should be in Hz
%
% NB the spikes are resampled and realigned on the peak of the intracellular channel
% if you don't want this use SpikeExtract
%
% BeforeSamps and AfterSamps give the number of samples to store on either side of the spike
% (default values = 100)

function RealignedSpikes = SpikeExtract(DatFileName, IntraFileName, NChannels, SampleRate, ExtraChannels, IntraChannel, BeforeSampsR, AfterSampsR)


% Parameters for resampled, realigned spikes
if (nargin<7) BeforeSampsR = 100; end;
if (nargin<8) AfterSampsR = 100; end;
WaveSampsR = BeforeSampsR + AfterSampsR + 1;

% Parameters: store number of samples before and after
BeforeSamps = BeforeSampsR + 50;
AfterSamps = AfterSampsR + 50;
WaveSamps = BeforeSamps + AfterSamps + 1;

% range to look for peaks in
MaxRange = BeforeSamps-5:BeforeSamps+5;

% open info file
IntraInfo = load(IntraFileName);

nSpikes = size(IntraInfo, 1);

fp = fopen(DatFileName, 'r');

% set up array
Spikes = zeros(5, WaveSamps, nSpikes);

% load up data

fprintf('Loading data...\n');

nSpikesActuallyThere = 0;
for i = 1:nSpikes

	% go to correct part of wave file

	StartSamp = round(IntraInfo(i, 3) * SampleRate - BeforeSamps);
	if (isfinite(StartSamp))
		status = fseek(fp, StartSamp*NChannels*2, 'bof');
		
		% if error, stop loading spikes
		if (status~=0)
			ferror(fp)
			break;
		end
		
	
		nSpikesActuallyThere = nSpikesActuallyThere+1;
		% Read in buffer
		WaveData = fread(fp, [NChannels WaveSamps], 'int16');

		% Extract the channels we want, and lose DC offset
		Spikes(1:4, :, nSpikesActuallyThere) = WaveData(ExtraChannels, :) - 2048;
		Spikes(5,:,nSpikesActuallyThere) =WaveData(IntraChannel, :) - 2048;
	end
end

% cut down the size of the Spikes array to those that really exist
% if (nSpikesActuallyThere<nSpikes)
%	Spikes(:, : , nSpikesActuallyThere+1:nSpikes) = [];
% end
	
% now do resampling

% due to memory constraints, do the resampling in blocks of size BlockSize
BlockSize = 50;

RealignedSpikes = zeros(5, WaveSampsR, nSpikes);

for i=1:BlockSize:nSpikes
	% progress indicator
	fprintf('Resampling .... at spike %d\n', i);
	
	% check for last block
	if (nSpikes-i<BlockSize)
		RealignedSpikes(:,:, i:end) = ResampleRealignSpikes(Spikes(:,:, i:end), 10, BeforeSampsR, AfterSampsR, MaxRange);
	else
		RealignedSpikes(:,:, i:i+BlockSize) = ResampleRealignSpikes(Spikes(:,:, i:i+BlockSize),  10, BeforeSampsR, AfterSampsR, MaxRange);
	end;
end;

% last block
% RealignedSpikes(:,:, i:end) = ResampleRealignSpikes(Spikes(:,:, i:end), BeforeSampsR, AfterSampsR, 45:55);