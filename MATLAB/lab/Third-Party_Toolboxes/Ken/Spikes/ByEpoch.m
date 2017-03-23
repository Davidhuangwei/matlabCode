% Function to see which epochs a given spike belongs to
% Takes a File structure and Res file, returns count which gives number 
% of epochs each specified type a given spike lands in
%
% Usage : [Count, EpochTypes, EpochTime] = ByEpoch(F, Res)
%
% returns:
% Count: nSpikes x nEpochTypes array, containing 1 if the
%		spike happens during the specified epoch type
% if you have overlapping epochs of the same type, Count will
% give the number of epochs that overlap over a given spike.
%
% EpochTypes: names of epoch types
% EpochTime: total time in each epoch (s)
%
% Use EpochCombo to find the spikes that belong in certain
% epoch combinations.

function [Count, EpochTypes, EpochTime] = ByEpoch(F, Res)

Epochs = F.Epochs;

nEpochs = length(Epochs);
nSpikes = length(Res);

EpochTypes = unique({Epochs.Type});
nEpochTypes = length(EpochTypes);
Count = zeros(nSpikes,nEpochTypes);

MultFac = 1e6/F.Par.SampleTime; % converts seconds to samples


% collect start and end points of all epochs
Ranges = zeros(nEpochs, 2);
Ranges(:,1) = [Epochs.Start]';
Ranges(:,2) = [Epochs.End]';

% make array of (integer) range labels
RangeLabels = zeros(nEpochs, 1);
EpochTime = zeros(nEpochTypes,1);
for eType = 1:nEpochTypes
	% find those of the correct type
	MyEpochs = find(strcmp({Epochs.Type}, EpochTypes(eType))); 
	RangeLabels(MyEpochs) = eType;
	% compute total time in this epoch
	EpochTime(eType) = sum(Ranges(MyEpochs,2) - Ranges(MyEpochs,1));
end

% run WithinRanges

Count = WithinRanges(Res, Ranges*MultFac, RangeLabels);


return

% OLD SLOW CODE BELOW

% collect start and end points of all epochs of a given type 
% into cell arrays eStart and eEnd
for eType = 1:nEpochTypes
	MyEpochs = find(strcmp({Epochs.Type}, EpochTypes(eType))); % find those of the correct type
	eStart{eType} = [Epochs(MyEpochs).Start]; % collect start times
	eEnd{eType} = [Epochs(MyEpochs).End]; % collect end times
	EpochTime(eType) = sum(eEnd{eType} - eStart{eType});
end

% Now find out what epochs each spike belongs to
% because the epochs for each type are sorted, we can go through them
% in order

for EpochTypeNo = 1:nEpochTypes
	EpochType = EpochTypes(EpochTypeNo);
	MyEpochs = find(strcmp({Epochs.Type}, EpochType));
	c= zeros(length(Res),1);	% temporary coutn vector
	for EpochNo = MyEpochs
		e = Epochs(EpochNo);
		Spikes = find(Res>= e.Start*MultFac & Res<=e.End*MultFac);
		c(Spikes) = c(Spikes)+1;
	end
	Count(:, EpochTypeNo) = c;
end

return

% QUICKER METHOD - NOT!  It would be quicker in C....




% eCurrent is an array giving for each epoch type the 
% current or next epoch of this type.  So t<eEnd{Type}(eCurrent) always.
% it is zero if we have finished the last epoch
eCurrent = ones(nEpochTypes,1);

bFlag = 0;								
for s=1:nSpikes
	if (mod(s,10000)==0), s, end;
	t = Res(s) / MultFac; % time of this spike in samples
	for eType = 1:nEpochTypes % go through each epoch type
		% check we have not finished with this type
		if eCurrent(eType) ~=0 
		
			% advance through epochs until we are before the end of eCurrent
			while(eEnd{eType}(eCurrent(eType)) < t)
				eCurrent(eType) = eCurrent(eType) + 1;
				% check that it wasn't the last one
				if eCurrent(eType) > length(eStart{eType})
					eCurrent(eType) = 0
					bFlag = 1; % Get out of two layers of loops.
					break		% THIS IS WHEN I WANT TO USE GOTO!
				end
			end
			
			if bFlag
				bFlag = 0;
				break;
			end
				
			% if we are after the start of eCurrent, set count
			if t>=eStart{eType}(eCurrent(eType))
				Count(s,eType) = 1;
			end
					
		end
	end
end










return

