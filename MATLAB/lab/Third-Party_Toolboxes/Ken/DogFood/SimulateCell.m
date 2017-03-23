function FiringTimes = SimulateCell(f, T, Refrac, BurstProb, BurstISI, ISIsd)
% Simulates a spike train from a refractory cell
% FiringTimes = SimulateCell(f, T, Refrac, BurstProb, BurstISI, ISIsd)
%
% It works by generating a uniform random sequence in 0...T
% with frequency f
%
% Then generating bursts by taking spikes with prob BurstProb
% and making a 3 spike burst with ISIs normal with mean BurstISI
% and sd ISI sd.
%
% It then will remove any spikes coming within
% Refrac of the last one.
%
% NB so the final firing frequency will be only approximately f.

nSpikes = round(T*f);
FiringTimes = T*rand(nSpikes, 1);

FiringTimes = sort(FiringTimes);

if (BurstProb>0)
	Bursters = find(rand(nSpikes, 1) < BurstProb);
	nBursts = length(Bursters);
	Burst2nds = FiringTimes(Bursters) + BurstISI + randn(nBursts, 1)*ISIsd;
	Burst3rds = Burst2nds + BurstISI + randn(nBursts, 1)*ISIsd;

	FiringTimes = union(union(FiringTimes, Burst2nds), Burst3rds);
end;

% delete refractory spikes
while 1
	nSpikes = length(FiringTimes);
	Refractors = find((FiringTimes(2:nSpikes) - FiringTimes(1:nSpikes-1)) ...
					 < Refrac);
	if isempty(Refractors) break; end;
	
	FiringTimes(Refractors) = [];
%	length(FiringTimes)
	
end;
					


