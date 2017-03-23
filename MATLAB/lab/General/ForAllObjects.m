% ForAllObjects(PropName, PropValue)
%
% Selects every object of the current axes
% and sets the PropName to PropValue.

function Out = ForAllObjects(PropName, PropValue)

children = get(gca, 'Children')';
for i=1:length(children)
	%set(gcf, 'CurrentAxes', children(i));
    %clear o;
  %  eval(Command);
    %if exist('o')
    %	Out{i} = o;
    %end
    set(children(i),PropName, PropValue);
end;