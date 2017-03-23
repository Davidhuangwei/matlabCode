function KeyBrowse()

global gBrowsePar
flChange = 0;
%check what key was pressed in figure 
whatkey = get(gcf,'CurrentCharacter');

if isletter(whatkey)
    switch whatkey
        
    case 'u' % undo for several levels
        %         if gBrowsePar.UndoLevel>0
        %             gBrowsePar = gBrowsePar.OldPar{end};
        %         end
        %         
    case 'z' %  zoom  IN
        gBrowsePar.ZoomDir = 1;
        newWidth = gBrowsePar.Width * 2^(-gBrowsePar.ZoomDir); 
        if newWidth > gBrowsePar.MinWidth & newWidth<gBrowsePar.MaxT
            gBrowsePar.Width = newWidth;
            flChange = 1;
        end
        
    case 'x'  % zoom OUT
        gBrowsePar.ZoomDir = -1;
        newWidth = gBrowsePar.Width * 2^(-gBrowsePar.ZoomDir); 
        if newWidth > gBrowsePar.MinWidth & newWidth<gBrowsePar.MaxT
            gBrowsePar.Width = newWidth;
            flChange = 1;
        end
        
    case 'f' % move forward
        if gBrowsePar.Center < gBrowsePar.MaxT - gBrowsePar.Step - gBrowsePar.Width/2
            gBrowsePar.Center = gBrowsePar.Center + gBrowsePar.Step; 
            flChange=1;
        else
            fprintf('No more to the right, change step\n');
        end  
        
    case 'b' % move backward
        if gBrowsePar.Center > gBrowsePar.Step + gBrowsePar.Width/2
            gBrowsePar.Center = gBrowsePar.Center - gBrowsePar.Step;
            flChange=1;
        else
            fprintf('No more to the left, change step\n');
        end
        
    case 'm' % switch mouse regime
        gBrowsePar.MouseBrowse = ~gBrowsePar.MouseBrowse;
        if gBrowsePar.MouseBrowse
            set(gcf,'WindowButtonDownFcn','MouseBrowse')
            fprintf('Mouse Browse ON\n');
            set(gcf,'Pointer','right');
        else
            set(gcf,'WindowButtonDownFcn','')
            fprintf('Mouse Browse OFF\n');
            set(gcf,'Pointer','arrow');
        end
    case 'q' % quit
        set(gcf,'WindowButtonDownFcn','');
        set(gcf,'KeyPressFcn', '');
    case 's' % save
        % save pointer
        if ~isempty(gBrowsePar.SavedPointer)
            saveans = inputdlg({'Enter filename ?'},'Save Pointers',1,{'No'}); 
            if ~strcmp(saveans,'No')
                msave(saveans{1}, gBrowsePar.SavedPointer(:));
            end
        end
    case 'p' % put pointer
        Pointer('keyboard');
    case 't' %put point process lines
        if ~strcmp(gBrowsePar.LastAction, 'line_points')
            dlgans = questdlg('Where to load from?','Load points','From File', 'From Variable', 'From File');
            if strcmp(dlgans,'From File')
                saveans = inputdlg({'Enter filename ?'},'Load points',1,{'rem'});
%                 for i=1:
%                 gBrowsePar.lHandle = 
            else
                if ~isempty(gBrowsePar.lHandle)
                    delete(gBrowsePar.lHandle);
                end
            end
        else
            
        end
        
    otherwise 
        fprintf('inexisting key functionality\n');
    end    
else % update step according to polynomial(or exp) scheme
    stepind = str2num(whatkey);
    if ~isempty(stepind)
        gBrowsePar.Step = 2^(stepind-2)*gBrowsePar.Width;
        flChange =1;
    end
end

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


