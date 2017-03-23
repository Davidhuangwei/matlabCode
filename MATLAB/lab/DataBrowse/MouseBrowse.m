function MouseBrowse()

global gBrowsePar
flChange=0;
tmpPar = gBrowsePar; % for undo


whatbutton = get(gcf,'SelectionType');
mousecoord = get(gca,'CurrentPoint');
xmouse = mousecoord(1,1);

switch whatbutton
case 'normal'  % left - move left
           flChange =  BrowseMove('left', gBrowsePar.Step);
case 'extend'  % middle - recenter
    %fprintf('recenter\n');
    if xmouse > gBrowsePar.Width/2 & xmouse < gBrowsePar.MaxT - gBrowsePar.Width/2
        gBrowsePar.Center = xmouse;
        flChange=1;
    end
case 'alt'      % right - move right
     flChange =  BrowseMove('right', gBrowsePar.Step);
case 'open'     %double click 
    %fprintf('fast move');
    switch gBrowsePar.LastAction
    case 'right'
       flChange =  BrowseMove('right', gBrowsePar.Step*2);
    case 'left'
       flChange =  BrowseMove('left', gBrowsePar.Step*2);
    end
    
end

%check if current step should be adjusted (at borders)

%update
if flChange
    % store old par for undo functionality
    %     gBrowsePar.UndoLevel = gBrowsePar.UndoLevel +1;
    %     gBrowsePar.OldPar{gBrowsePar.UndoLevel} = tmpPar;
        
    set(gcf,'Pointer','watch');
    
    % call data display update
    TimeBrowse('update',gcf);
    
    set(gcf,'Pointer','right');
end