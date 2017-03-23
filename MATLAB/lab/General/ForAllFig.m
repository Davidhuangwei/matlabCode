% ForAllFigures(Command)
%
% Selects every figure
% and executes Command.

function ForAllFig(Command,arg);
tit=arg;
for a=get(0, 'Children')';
	set(0, 'CurrentFigure', a);
	eval(Command);
end;