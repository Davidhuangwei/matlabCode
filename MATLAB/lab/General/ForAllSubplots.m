% ForAllSubplots(Command)
%
% Selects every subplot of the current figure
% and executes Command.

function Out = ForAllSubplots(Command);

children = get(gcf, 'Children')';
for i=1:length(children) %-- wierd bug - number of Children more than number of supblots...
    if strcmp(get(children(i),'Type'),'axes')
    set(gcf, 'CurrentAxes', children(i));
    %clear o;
    eval(Command);
    end
    %if exist('o')
    %	Out{i} = o;
    %end
end;