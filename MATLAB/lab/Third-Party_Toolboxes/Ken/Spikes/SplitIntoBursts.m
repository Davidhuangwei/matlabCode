% [Burst, BurstLen, SpkPos, OutOf] = SplitIntoBursts(Res, Thresh)
%
% splits a spike train (Res) into demarked events (bursts
% or single spikes), each of which is a series of spikes 
% seperated by ISIs of no more than Thresh.  Single spikes 
% are detected as  bursts of length 1.  Burst returns the 
% index within Res of the event (burst.  BurstLen returns 
% the length of the burst.  SpkPos returns a number for 
% each spike, giving the position within the burst of the 
% spike.  OutOf returns the length of the burst which a 
% given spike belongs to.
%
% Thresh defaults to 120 (6ms at 20kHz)

function [Burst, BurstLen, SpkPos, OutOf] = SplitIntoBursts(Res, Thresh);

if isempty(Res)
	warning('You ran SplitIntoBursts with no spikes!');
	Burst = [];
	BurstLen = [];
	SpkPos = [];	
	OutOf = [];
	return
end
	
if nargin<2, Thresh=120; end;

Res = Res(:);
ISI = diff(Res);
PrevISI = [inf; ISI];
NextISI = [ISI; inf];

Burst = find(PrevISI>Thresh);
BurstStop = find(NextISI>Thresh);
BurstLen = 1+BurstStop-Burst;

nBursts = length(Burst);
ToSum = ones(length(Res),1);
ToSum(Burst) = [1; 1-BurstLen(1:nBursts-1)];
SpkPos = cumsum(ToSum);

ToSum2 = zeros(length(Res),1);
ToSum2(Burst) = [BurstLen(1) ; diff(BurstLen)];
OutOf = cumsum(ToSum2);