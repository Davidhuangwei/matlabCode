% ForAllSubplots(Command)
%
% Selects every subplot of the current figure
% and executes Command.

function Out = ForAllSubplots(Command);

children = get(gcf, 'Children')';
for i=1:length(children)
	set(gcf, 'CurrentAxes', children(i));
    clear o;
    o = eval(Command);
    if exist('o')
    	Out{i} = o;
    end
end;