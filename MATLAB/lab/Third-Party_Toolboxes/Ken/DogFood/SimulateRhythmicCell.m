% Simulates a spike train from a refractory cell
% FiringTimes = SimulateRhythmicCell(dt, T, jitter, MeanSpikesPerCycle)
%
% Produces an almost rhythmic spike train with frequency 1/dt in the range 0...T
%
% Times between cycles are distributed as dt plus a random error between -jitter and jitter.
% The number of spikes per cycle is a poisson distribution with mean MeanSpikesPerCycle
% The spikes times within each cycle are normaly distributed with std dev jitter.
% - so jitter serves 2 purposes. (cycle length + spike time within cycle)

function FiringTimes = SimulateRhythmicCell(dt, T, jitter, MeanSpikesPerCycle)

MoreThanEnough = round(T/(dt-jitter));

ISIs = dt + jitter*(2*rand(MoreThanEnough, 1) - 1);

CycleTimes = cumsum(ISIs);

SpikesPerCycle = poissrnd(MeanSpikesPerCycle, MoreThanEnough, 1);

Times = zeros(sum(SpikesPerCycle), 1);

pos = 1;
for Cycle = 1:MoreThanEnough
	if (SpikesPerCycle(Cycle))
		ns = SpikesPerCycle(Cycle);
		Times(pos:pos+ns-1) = CycleTimes(Cycle) + randn(ns,1)*jitter;
		pos = pos+ns;
	end
end;

FiringTimes = Times(find(Times<T));
