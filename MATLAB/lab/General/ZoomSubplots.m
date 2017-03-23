% ZoomSubplots(action,dimension)
%
% Selects every subplot of the current figure
% and executes Command.

function Out = ZoomSubplots(action,varargin);

switch action
    case 'init'
        [dimension] = DefaultArgs(varargin,{'x'});
         set(hFrom, 'WindowButtonDownFcn', 'copyax(''mouse'')''');
         set(hFrom,'DeleteFcn','clear(''gcopyax'',''global'')');
         MyPointer('eye');
         set(hFrom,'Pointer','arrow');
         set(hFrom,'Name',' ZoomSubplot');
         
        
    case 'update'
        
        
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


end