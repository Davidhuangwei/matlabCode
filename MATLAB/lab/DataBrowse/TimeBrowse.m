%function TimeBrowse([action,] [Data,] Width, Position, tRange )
function TimeBrowse(varargin)
global gBrowsePar
global gBrowseData
flDisplay = 0;
if isstr(varargin{1})
    action = varargin{1};
    if ~iscell(varargin{2})
        data = gcf;
        argsfrom = 2;
    else
        data =  varargin{2};
        flDisplay = 1;
        argsfrom = 3;
    end

else    
    action = 'init';
    if ~iscell(varargin{1})
        data = gcf;
        argsfrom = 1;
    else
        data =  varargin{1};
        flDisplay = 1;
        argsfrom = 2;
    end
end
[Width, Position, tRange ] = DefaultArgs(varargin(argsfrom:end),{[], [], []});    

% now go through actions
switch action
    
case 'init'
 % initialize the gBrowsePar and update        
    if ~isempty(tRange)
        gBrowsePar.MaxT = tRange(2);
        gBrowsePar.MinT = tRange(1);
    else % find time limits from data or axes
        if flDisplay
            gBrowsePar.MaxT = data{1}{1}(end);
            gBrowsePar.MinT = data{1}{1}(1);
            %error('not implemented yet. give tRange\n');
        else
           curxlim = get(gca,'XLim');
           gBrowsePar.MaxT = curxlim(2);
           gBrowsePar.MinT = curxlim(1);
        end
    end
    if ~isempty(Width)
        gBrowsePar.Width = Width;
    else
        gBrowsePar.Width = min(gBrowsePar.MaxT/20,100);
    end
    gBrowsePar.MinWidth = min(0.2,Width/10); %change to general!!!
    if ~isempty(Position)
        gBrowsePar.Center = Position;
    else
        gBrowsePar.Center = gBrowsePar.Width/2;
    end
    
    % set other params
    gBrowsePar.ZoomDir = 1;
    gBrowsePar.Step = gBrowsePar.Width/2;
    gBrowsePar.UndoLevel = 0;
    gBrowsePar.MouseBrowse = 1;
    gBrowsePar.SavedPointer=[];
    gBrowsePar.pHandle=[];
    %now set the function callbacks for this figure
    set(gcf,'Pointer','right');
    set(gcf,'WindowButtonDownFcn','MouseBrowse');
    set(gcf,'KeyPressFcn', 'KeyBrowse');
    set(gcf, 'Name', 'TimeBrowse');
    set(gcf, 'NumberTitle', 'off');
 
case 'update'
    % update the display
    if flDisplay % make a new display according to Data
        figure;
        DisplayData(data);
    else % just rescale the axis
        Seg = gBrowsePar.Center+gBrowsePar.Width/2*[-1 1];
        str = ['xlim([' num2str(Seg) '])'];
        ForAllSubplots(str);
       % gBrowsePar
    end
end
