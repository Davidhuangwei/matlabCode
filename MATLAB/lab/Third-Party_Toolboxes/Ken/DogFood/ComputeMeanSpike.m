% [MeanSpike nSpikes] = ComputeMeanSpike(DatFileName, SampleRate, BeforeSamps, AfterSamps)
%
%  computes mean spike and number of spikes present using joint intra/extra data
%
%  will produce an array of 4 extracellular channes and 1 intracellular channel
%  from channels 1-4 and 5 of the 8 channel .dat file (counting from 0)
%
%  First array dimension : channel number
%  Second dimension: time within spike waveform
%
%  requires Darryl's intracellular spike info file with the 1st line chopped of
%  called 'IntraInfo'
%
%  Assumes input is centered on 2048.
%
%  SamplingRate should be in Hz
%
% BeforeSamps and AfterSamps give the number of sample points to store on either side of
% the trigger point.

function [MeanSpike, nSpikesActuallyThere] = ComputeMeanSpike(DatFileName, SampleRate, BeforeSamps, AfterSamps)

% Parameters: store 350 samples before spike start, 450 after

WaveSamps = BeforeSamps + AfterSamps + 1;
NChannels = 8;

% open info file
load IntraInfo;

nSpikes = size(IntraInfo, 1);

fp = fopen(DatFileName, 'r');


% set up array
TotWave = zeros(5, WaveSamps);
WaveData = zeros(8, WaveSamps);

% load up data

nSpikesActuallyThere = 0;
for i = 1:nSpikes

	% go to correct part of wave file

	StartSamp = round(IntraInfo(i, 2) * SampleRate - BeforeSamps);
	if (isfinite(StartSamp))
		status = fseek(fp, StartSamp*NChannels*2, 'bof');
		if (status~=0)
			fprintf('reading spike %d caused an error:', i);
			ferror(fp)
		else
			% Read in buffer
			WaveData = fread(fp, [8 WaveSamps], 'int16');
			if (ferror(fp)) break; end
			nSpikesActuallyThere = nSpikesActuallyThere+1;
			TotWave = TotWave + WaveData(2:6, :) - 2048;
		end
	end
end

% now compute mean

MeanSpike = TotWave ./ nSpikesActuallyThere;

