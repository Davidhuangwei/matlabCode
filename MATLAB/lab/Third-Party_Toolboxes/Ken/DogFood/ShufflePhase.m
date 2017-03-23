% SpkPh = ShufflePhase(SpkPh, Clu, ShuffleClus, nRands)
%
% randomizes phases within theta cycles for a spike train.
% what this does is leave each spike in its original theta
% cycle, but permutes the phases of all spikes.  So the
% overall phase preference of the cell will be the same,
% as will the place field - but the phase-firing rate
% correlation will be destroyed, as will the phase
% relationship between cells.
%
% if you provide only one input, it shuffles them all.
% if you provide two arguments, it shuffles within
% clusters but not between
% if you provide three arguments, it will only shuffle
% the clusters specified by the third argument.
% fourth argument allows for many shufflings: will return
% a 2d array with row giving spike # and column rand number

function Out = ShufflePhase(SpkPh, Clu, ShuffleClus, nRands)

SpkPh = SpkPh(:);
Clu = Clu(:);
n = length(SpkPh);

if nargin<2 | isempty(Clu)
	Clu = ones(size(SpkPh));
end

if nargin<3 | isempty(ShuffleClus)
	ShuffleClus = unique(Clu);
end

if nargin<4 | isempty(nRands)
	nRands = 1;
end

PhMod = mod(SpkPh,2*pi);
CycNo = SpkPh-PhMod;

PermMat = repmat((1:n)',1,nRands);

for c=ShuffleClus(:)'
	Mine = find(Clu==c);
    [dummy, Perm] = sort(rand(length(Mine), nRands),1); %randperm
    PermMat(Mine,:) = Mine(Perm);
end

Out = repmat(CycNo,1,nRands) + PhMod(PermMat);
