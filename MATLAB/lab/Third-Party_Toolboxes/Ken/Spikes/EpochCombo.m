% Spikes = EpochCombo(Count, EpochTypes, InThese, NotInThese);
%
% run this program after you have run ByEpoch, to determine those
% spikes that lie in a given combination of epoch types.
%
% Inputs:
% 	Count, EpochTypes - as returned by ByEpoch
%	InThese - a cell array listing the names of epoch types
%	          you require your spikes to be in -if empty, defaults to all.
% 	NotInThese - a cell array listing the names of epoch types
% 		      you require your spikes not to be in
%
% Output: Spikes gives the spike numbers satisfying these criteria

function Spikes = EpochCombo(Count, EpochTypes, InThese, NotInThese);

if nargin<3 | isempty(InThese)
	InThese = EpochTypes;
end

if nargin<4
	NotInThese = {};
end

nTypes = length(EpochTypes);

if size(Count,2) ~= nTypes
	error('2nd dim of Count must equal length of EpochTypes!');
end

% find places in EpochTypes that InThese and NotInThese correspond to
nIn = length(InThese);
InPos = [];
for i=1:nIn	
	InPos = [InPos ; find(strcmp(EpochTypes, InThese{i}))];
end

nNotIn = length(NotInThese);
NotInPos = [];
for i=1:nNotIn	
	NotInPos = [NotInPos ; find(strcmp(EpochTypes, NotInThese{i}))];
end

% now compute which spikes fit the bill
if isempty(InPos)
	Spikes = [];
elseif isempty(NotInPos)
	Spikes = find(all(Count(:,InPos),2));
else
	Spikes = find(all(Count(:,InPos),2) & ~any(Count(:,NotInPos),2));
end
