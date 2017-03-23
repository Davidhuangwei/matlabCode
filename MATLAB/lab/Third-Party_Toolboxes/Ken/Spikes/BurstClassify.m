% Label = BurstClassify(Res, Clu, SelectedCell, TimeWin);
%
% goes through the spikes and produces a set of labels:
%
% 1: other cell, not within burst period
% 2: other cell, within burst period of selected cell's spikes
% 3: this cell, first spike of burst
% 4: this cell, later on in burst
%
% TimeWin argument is how long after the previous spike it has to be to count
% default is 20*10. (i.e. 10ms for a 20kHz file)

function Label = BurstClassify(Res, Clu, SelectedCell, TimeWin);

if (nargin<4) TimeWin = 200; end;

nSpikes = length(Res);
MySpikes = find(Clu==SelectedCell);

ISIs = [diff(Res(:))];

Burst2nds = 1+intersect(MySpikes, find(ISIs<TimeWin)); % spikes within window _after_ selected cell fires 

Label = ones(nSpikes, 1);

Label(Burst2nds) = 2;
Label(MySpikes) = 3;
Label(intersect(Burst2nds, MySpikes)) = 4;