PlotPoints(control)

global gBrowsePar
flChange=0;

switch control
case    'keyboard'
    
    if ~strcmp(gBrowsePar.LastAction, 'plot_points')
        % have no line plotted just before - for undo
        dlgans = questdlg('Where to load from?','Load points','From File', 'From Variable', 'From File');
        if strcmp(dlgans,'From File')
            saveans = inputdlg({'Enter filename ?'},'Load points',1,{'rem'});
            flChange = 1;
            children = get(gcf, 'Children')';
            for i=1:length(children) 
                set(gcf, 'CurrentAxes', children(i));
                Lines
            end;
            for i=1:
                gBrowsePar.lHandle =
            end
        else
            if ~isempty(gBrowsePar.lHandle)
                delete(gBrowsePar.lHandle);
            end
        end
    else
        
    end
case 'update'
      
end