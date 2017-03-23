% ForAllFigures(Command)
%
% Selects every figure
% and executes Command.

function ForAllFigures(Command);

for a=get(0, 'Children')';
	set(0, 'CurrentFigure', a);
	eval(Command);
end;