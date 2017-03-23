% SpikeDetect(FileBase)
%
% This script reads FileBase.fil and FileBase.par.  It
% detects spikes, and writes FileBase.res.1 (eventually
% will deal with multi-tetrode recordings).

function SpikeDetect(FileBase)

Par = LoadPar(strcat(FileBase, '.par'));

% PARAMETERS
BufferSize = 1000000; % samples to process at once
Threshold = 3; % times standard deviation
RealignSize = round(1000/Par.SampleTime); % it will look this far on each side to realign the spike (1 ms)
SmearHalfSize =round(100/Par.SampleTime); % Smears signal over this length when doing spike detection (0.1 ms)

SmearFilter = [1:SmearHalfSize, 1+SmearHalfSize, SmearHalfSize:-1:1]';

FilFp = fopen(strcat(FileBase, '.fil'), 'r');
ResFp = fopen(strcat(FileBase, '.res.1'), 'w');
DeCovFp = fopen('decov.fil', 'w');

BufferStart = 0;
Std = 0;

while 1
	[Buffer, nRead] = fread(FilFp, [Par.nChannels, BufferSize], 'short');
	Buffer = Buffer - mean(Buffer(:));
	
	% Calculate covariance matrix if none exists
%	if (CovMat == 0)
%		CovMat = cov(Buffer');
%	end;

	% Calculate decorrelated signal	
	%DeCov =(CovMat^-0.5)*Buffer;
	%fwrite(DeCovFp, 100*DeCov, 'short');
	
	% calculate sum of all channels
	RawChannelSum = sum(Buffer, 1);
	RawChannelSum = RawChannelSum(:);
	
	% now smear it
	Smeared = filter(SmearFilter,1,[RawChannelSum;zeros(SmearHalfSize,1)]);
	% needs to be realigned
	ChannelSum = Smeared(1+SmearHalfSize:end);	
	
	% calculate threshold according to first block only
	if (Std == 0)
		Std = std(ChannelSum);
	end;
	
	% find threshold crossings on any channel
	ThresholdCrossings = find(ChannelSum<-Threshold*Std);
	%DeCov(find(DeCov<0)) = 0;
	%ThresholdCrossings = find(sum(DeCov.*DeCov,1)>Threshold);
	%ThresholdCrossings = ThresholdCrossings(:);
	
	% This produces a 1D array that indexes DeCov(:).
	% To get sample times we need to integer divide by the number of channels
	% and take unique() because it may cross on more than 1 channel
	%ThresholdCrossings = 1+unique(floor((AllThresholdCrossings-1)/Par.nChannels));
	
	
	% We want to realign the spikes.  Do this by looking for a local minimum
	% in the sum of all 4 channels in the vicinity of each threshold crossing

	if (~isempty(ThresholdCrossings))
	
		% Make array of extracted segments
		Index = ThresholdCrossings(:,ones(1+2*RealignSize,1)) ...
			+ repmat(-RealignSize:RealignSize,length(ThresholdCrossings), 1);
			
		Index = clip(Index, 1, length(ChannelSum));
			
		[MinVal MinPos] = min(ChannelSum(Index), [], 2);
		NotStartOrEnd = find(MinPos>1 & MinPos<=2*RealignSize);	
		SpikeTimes = unique( ...
						ThresholdCrossings(NotStartOrEnd) ...
						+ MinPos(NotStartOrEnd) ...
						- (RealignSize+1) ...
					);

		% Write to .res file
		fprintf(ResFp, '%d\n', BufferStart+SpikeTimes);
	end	
	if (nRead<BufferSize*Par.nChannels) break; end;
	BufferStart = BufferStart + BufferSize
end;

fclose(FilFp);
fclose(ResFp);
fclose(DeCovFp);

% this bit to make missed.clu file
%!/u5/b/ken/bin/MakeIntraCluFile MakeIntraCluFile -TimeWindowBefore -10 -TimeWindowAfter 30

%Index = load('IntraSpikes.index');
%IntraRes = load('IntraSpikes.res');
%Missed = ~ismember(1:length(IntraRes), Index(:,1));
%SaveClu('missed.clu', Missed+1);
