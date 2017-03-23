% Out = SpikeRemove(In, thresh, CutSize)
%
% takes out spikes from an intracellular trace, leaving you with
% (hopefully) just the subthreshold membrane potential.
%
% Spikes are detected when the potential crosses above thresh,
% and CutSize samples are removed on either side and replaced
% by a linearly interpolated signal.

function Out = SpikeRemove(In, Thresh, CutSize)

nSamples = length(In);

Out = In;

Exceeds = find(In>Thresh);

CutOut = zeros(size(In));

% find ranges to cut out
for i=Exceeds
	if (i>CutSize & i<=(nSamples-CutSize))
		CutOut(i-CutSize:i+CutSize) = 1;
	end
end

CutOutDiff = diff(CutOut);

StartPoints = find(CutOutDiff == 1) + 1;
StopPoints = find(CutOutDiff == -1);

nRanges = length(StartPoints);
if length(StopPoints) ~= nRanges
	error('Spike Remove internal error - sorry.');
end


for i=1:nRanges
	StartPoint = StartPoints(i);
	StopPoint = StopPoints(i);
	StartVal = In(StartPoint);
	StopVal = In(StopPoint);
	Length = StopPoint - StartPoint;
	
	Out(StartPoint:StopPoint) = StartVal + (0:Length) * (StopVal-StartVal) / Length;
%	pause;
end

if (any(Out>Thresh))
	warning('Spike Remove didn''t work!');
end;

return


for i=Exceeds
	% go throuh the threshold exceeds one by one.
	% calculate the start and stop points to be
	% interpolated.
	
	% see how many samples the exceed lasts for
	j=i;
	while (In(j+1) > Thresh)
		j = j+1;
	end

		
	StartPoint = i-CutSize;
	StopPoint = j+CutSize;
	
	Length=StopPoint-StartPoint;
	
	StartVal = In(StartPoint);
	StopVal = In(StopPoint);
	
	Out(StartPoint:StopPoint) = StartVal + (0:Length) * (StopVal-StartVal) / Length;

%	if (i == 9836)
%		disp('pasue')
%		pause;
%	end
end

if (any(Out>Thresh))
	warning('Spike Remove didn''t work!  Try with a higher threshold');
end;