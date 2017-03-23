% OK=WithinEpochs(Res, Epochs, InThese, NotInThese)
%
% Inputs: Res - spike times
% Epochs: Epochs struct as returned by ForCells
% InThese, NotInThese: string or cell array of strings listing epoch type names
%
% returns 1 for those lines of Res which are in all of the Epochs in InThese
% but not in any of those in NotInThese, 0 for all others
%
% e.g. WithinEpochs(Res, Epochs, 'NonTheta', {'Sleep', 'Ripple'})

function OK=WithinEpochs(Res, Epochs, InThese, NotInThese)

if nargin<4
	NotInThese = {};
end

% turn strings into single element cell arrays
if isstr(InThese)
	InThese = {InThese};
end

if isstr(NotInThese)
	NotInThese = {NotInThese};
end

InOK = [];
for i=1:length(InThese)
	MyEpochs = find(strcmp(Epochs.Type, InThese{i}));
	InOK(:,i) = WithinRanges(Res, [Epochs.Start(MyEpochs), Epochs.End(MyEpochs)]);
end

NotInOK = [];
for i=1:length(NotInThese)
	MyEpochs = find(strcmp(Epochs.Type, NotInThese{i}));
	NotInOK(:,i) = ~WithinRanges(Res, [Epochs.Start(MyEpochs), Epochs.End(MyEpochs)]);
end

if isempty(InOK) & isempty(NotInOK)
    OK = ones(length(Res),1);
else
    OK = all([InOK, NotInOK], 2);
end