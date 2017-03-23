function Pointer(control)

global gBrowsePar
%flChange=0;

switch control
case 'mouse'
      
    whatbutton = get(gcf,'SelectionType');
    mousecoord = get(gca,'CurrentPoint');
    xmouse = mousecoord(1,1);
    curaxis = get(gcf,'CurrentAxes');
    if strcmp(whatbutton, 'extend')  
        %save pointer
        gBrowsePar.SavedPointer(end+1) = xmouse;
    end
    if ~isempty(gBrowsePar.pHandle)
        delete(gBrowsePar.pHandle);
    end
    children = get(gcf, 'Children')';
    for i=1:length(children)
        set(gcf, 'CurrentAxes', children(i));
        gBrowsePar.pHandle(i) = Lines(xmouse,[],'r');
    end
    set(gcf,'CurrentAxes',curaxis);
     gBrowsePar.pHandle(end+1) = text(mousecoord(1), mousecoord(2),num2str(xmouse));
case 'keyboard'
    % switch on 
    if ~strcmp(gBrowsePar.LastAction, 'pointer')
        gBrowsePar.LastAction = 'pointer';   
	% temporarily assign the function to the pointer, not MouseBrowse
        set(gcf,'WindowButtonDownFcn','Pointer(''mouse'')');
        set(gcf,'Pointer','crosshair');
        fprintf('Pointer ON\n');
    else % switch off
        set(gcf,'WindowButtonDownFcn','MouseBrowse');
        gBrowsePar.LastAction = '';
        set(gcf,'Pointer','left');
        fprintf('Pointer OFF\n');
        if ~isempty(gBrowsePar.pHandle)
            delete(gBrowsePar.pHandle);
        end
        % save pointer
        if ~isempty(gBrowsePar.SavedPointer)
            saveans = inputdlg({'Enter filename ?'},'Save Pointers',1,{'No'}); 
            if ~strcmp(saveans,'No')
                msave(saveans{1}, gBrowsePar.SavedPointer(:));
            end
        end
        
    end
end