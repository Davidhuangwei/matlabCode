function varargout = sigbrowse(varargin)
%SIGBROWSE  Signal Browser.
%   This graphical tool allows you to display, measure, filter, hear
%   and analyze digital signals.
%
%   Type 'sptool' to start the Signal Processing GUI Tool and access
%   the Signal Browser.
% 
%   See also SPTOOL, FILTDES, FILTVIEW, SPECTVIEW.

%   Copyright (c) 1988-98 by The MathWorks, Inc.
% $Revision: 1.1 $

if nargin<1 
    if isempty(findobj(0,'tag','sptool'))
        disp('Type ''sptool'' to start the Signal GUI.')
    else
        disp('To use the Signal Browser, import a signal into the SPTool,')
        disp('and then click on the ''View'' button under ''Signals''.')
    end
    return
end

if ~isstr(varargin{1})
    sbinit
    
    save_shh = get(0,'showhiddenhandles');
    set(0,'showhiddenhandles','on')
    set(gcf,'visible','on')
    set(0,'showhiddenhandles',save_shh)
    drawnow
    return
end
%------------------------------------------------------------------------
switch varargin{1}
%------------------------------------------------------------------------
%sigbrowse('update',fig)
%sigbrowse('update',fig,s,ind)
%sigbrowse('update',fig,s,ind,sptoolfig)
%sigbrowse('update',fig,s,ind,sptoolfig,msg)
% Callback for when selected signals have changed
% Inputs:
%   fig - figure handle of signal browser
%   s - structure array of signals 
%   ind - index of selected signals   
%     s,ind together are optional - if omitted, they are obtained from SPTool
%   sptoolfig - figure handle of SPTool (optional)
%   msg - message as passed from SPTool
%    can be 'new', 'value', 'label', 'Fs', 'dup', 'clear'
%    The only real distinction here is between 'new' and the rest;
%      'new' means start from scratch as you cannot count on objects
%      being the same just because they are at the same index position in ind.
%      So 'new' will allocate new lines while anything else will retain any
%      lines that are at the same index location.
case 'update'
    fig = varargin{2};
    ud = get(fig,'userdata');
    
    if nargin > 2
        s = varargin{3};
        ind = varargin{4};
    else
        [s,ind] = sptool('Signals');
    end
    
    if nargin > 5
        msg = varargin{6};
    else
        msg = 'new';  % new starts from scratch
    end
    fromScratch = strcmp(msg,'new');
    
    arrayFlag = 0;
    
    for i = 1:length(s(ind))
        if isempty(s(ind(i)).lineinfo)
            % assign next available line color and style
           [s(ind(i)).lineinfo,ud.colorCount] = ...
               nextcolor(ud.colororder,ud.linestyleorder,ud.colorCount);
            s(ind(i)).lineinfo.columns = 1;
            % poke back into SPTool
            if nargin > 4
                sptool('import',s(ind(i)),0,varargin{5})
            else
                sptool('import',s(ind(i)))
            end
        end
        if strcmp(s(ind(i)).type,'array')
            arrayFlag = 1;
        end
    end

    if arrayFlag
        set(ud.hand.arraybutton,'enable','on')
    else
        set(ud.hand.arraybutton,'enable','off')
    end

    oldLines = ud.lines;
    % de-allocate any lines that are no longer visible (save in cache):
    for i=1:length(ud.lines)
        if ~any(ud.SPToolIndices(i)==ind) | fromScratch
            % a quick command line test reveals that destroying and creating
            % 100 lines is about twice as slow as setting the visible, tag, 
            % xdata, and ydata of 100 lines.
            ud.linecache.h = [ud.linecache.h; ud.lines(i).h];
            ud.linecache.ph = [ud.linecache.ph; ud.lines(i).ph];
        end
    end
 
    % reset line cache:
    set(ud.linecache.h,'visible','off','tag','','xdata',0,'ydata',0)
    if ud.prefs.tool.panner
        set(ud.linecache.ph,'visible','off','tag','','xdata',0,'ydata',0)
    end
        
    N = length(ind);
    if length(ud.lines)>N
        ud.lines(N+1:end) = [];
    end

    complex_flag = 0;
    for i=1:length(s(ind))
        if ~isreal(s(ind(i)).data)
            complex_flag = 1;
        end
    end
    cv = get(ud.hand.complexpopup,'value');
    if complex_flag
        set(ud.hand.complexpopup,'enable','on')
    else
        set(ud.hand.complexpopup,'enable','off')
    end

    for i=1:N
        if ~isempty(ud.SPToolIndices) & ~fromScratch
            j = find(ind(i)==ud.SPToolIndices);
        else
            j = [];
        end
        if isempty(j) | ~isequal(s(ind(i)),ud.sigs(j))
            %assign lines, set xdata and ydata
            [ud.lines(i).h,ud.linecache.h] = assignline(ud.linecache.h,...
                 length(s(ind(i)).lineinfo.columns),ud.mainaxes,...
                 'color',s(ind(i)).lineinfo.color,...
                 'linestyle',s(ind(i)).lineinfo.linestyle,...
                 'visible','on',...
                 'tag',s(ind(i)).label);
            % set up fields for panning:
            ud.lines(i).data = s(ind(i)).data;
            ud.lines(i).columns = s(ind(i)).lineinfo.columns;
            ud.lines(i).Fs = s(ind(i)).Fs;
            ud.lines(i).t0 = 0;  % starting time: 0 by definition
            ud.lines(i).xdata = [];  % initialize field to empty
            if ud.prefs.tool.panner
                [ud.lines(i).ph,ud.linecache.ph] = assignline(...
                           ud.linecache.ph,...
                           length(s(ind(i)).lineinfo.columns),...
                           ud.panner.panaxes,...
                           'color',s(ind(i)).lineinfo.color,...
                           'linestyle',s(ind(i)).lineinfo.linestyle,...
                           'buttondownfcn','sbswitch(''pandown'',1)',...
                           'visible','on',...
                           'tag',s(ind(i)).label);
            end
            for k=1:length(s(ind(i)).lineinfo.columns)
                xd = (0:size(s(ind(i)).data,1)-1)/s(ind(i)).Fs;
                if ~isempty(xd)
                    yd = s(ind(i)).data(:,s(ind(i)).lineinfo.columns(k));
                    yd = sbcomplexfcn(yd,cv,complex_flag);
                else
                    yd = [];
                end
                set(ud.lines(i).h(k),'xdata',xd,'ydata',yd,'visible','on');
                if ud.prefs.tool.panner
                    set(ud.lines(i).ph(k),'xdata',xd,'ydata',yd,'visible','on');
                end
                set(ud.lines(i).h(k),...
                         'buttondownfcn',['sbswitch(''pickfcn'',' ...
                            num2str(i) ',' num2str(k) ')'])
            end
        else
        % use old lines (no need to set x and ydata)
            ud.lines(i) = oldLines(j);
            for k=1:length(s(ind(i)).lineinfo.columns)
                set(ud.lines(i).h(k),...
                     'buttondownfcn',['sbswitch(''pickfcn'',' ...
                                         num2str(i) ',' num2str(k) ')'])
            end
        end
    end  % for i=1:N

    if ~fromScratch
        common = intersect(ud.SPToolIndices,ind);
    else
        common = [];
    end
    ud.SPToolIndices = ind;
    ud.sigs = s(ind);
        
    ud.focusIndex = 1;
    % save the focusline handle in the userdata struct:
    if ~isempty(ud.sigs)
        focusLineInfo = ud.sigs(ud.focusIndex).lineinfo;
        ud.focusline = ud.lines(ud.focusIndex).h(1);
    else
        ud.focusline = [];
    end
    
    sbzoomout(ud,isempty(common),0)  % saves userdata
    ud = get(fig,'userdata');
        
    sptlegend('setstring',{ud.sigs.label},{ud.lines.columns},fig)
    
    set(get(ud.mainaxes,'title'),'string',sbtitle(fig,ud.sigs,'auto',''))
    
    pickfcn('noMouse',ud.focusIndex,1,fig)
      
%------------------------------------------------------------------------
% sigbrowse('changefocus')
%  callback of sptlegend
case 'changefocus'
    [i,j] = sptlegend('value');
    pickfcn('noMouse',i,j)
    
%------------------------------------------------------------------------
% sigbrowse('newColor',lineColor,lineStyle)
%  newColorCallback of sptlegend
%  color and linestyle of ud.focusline have already been updated
case 'newColor'
    lineColor = varargin{2};
    lineStyle = varargin{3};
    
    fig = gcf;
    ud = get(fig,'userdata');
    
    ind = ud.focusIndex;
    ud.sigs(ind).lineinfo.color = lineColor;
    ud.sigs(ind).lineinfo.linestyle = lineStyle;

    set(fig,'userdata',ud)
    
    % poke back into SPTool
    sptool('import',ud.sigs(ind))
    
    % set in case of array signals:
    set(ud.lines(ind).h,'color',lineColor,'linestyle',lineStyle)
    if ud.prefs.tool.panner
        set(ud.lines(ind).ph,'color',lineColor,'linestyle',lineStyle)
    end
    
%------------------------------------------------------------------------
% sigbrowse('array')
%  put up array signals dialog box
case 'array'
    fig = gcf;
    ud = get(fig,'userdata');
    
    % find out which signals are array signals:
    sigTypes = {ud.sigs.type};
    ind = findcstr(sigTypes,'array');
    
    [jkl,columns] = sbarray(ud.sigs(ind));
    if ~isempty(jkl)
        i = ind(jkl);
        % now set the number of columns for ud.sigs(i)
        % disp(sprintf('displaying new columns for signal %g',i))
        if ~isequal(ud.sigs(i).lineinfo.columns,columns)
            ud.sigs(i).lineinfo.columns = columns;
            xd = get(ud.lines(i).h(1),'xdata');
            ud.linecache.h = [ud.linecache.h; ud.lines(i).h];
            if ud.prefs.tool.panner
                ud.linecache.ph = [ud.linecache.ph; ud.lines(i).ph];
            end
            % reset line cache:
            set(ud.linecache.h,'visible','off','tag','','xdata',0,'ydata',0)
            if ud.prefs.tool.panner
                set(ud.linecache.ph,'visible','off','tag','','xdata',0,'ydata',0)
            end
       
            M = length(columns);
            %assign lines, set xdata and ydata
            [ud.lines(i).h,ud.linecache.h] = assignline(ud.linecache.h,...
                  M,ud.mainaxes,...
                  'color',ud.sigs(i).lineinfo.color,...
                  'linestyle',ud.sigs(i).lineinfo.linestyle,...
                  'visible','on',...
                  'tag',ud.sigs(i).label);
            % set up fields for panning:
            ud.lines(i).data = ud.sigs(i).data(:,columns);
            ud.lines(i).columns = columns;
            if ud.prefs.tool.panner
                [ud.lines(i).ph,ud.linecache.ph] = assignline(...
                       ud.linecache.ph,M,...
                       ud.panner.panaxes,...
                       'color',ud.sigs(i).lineinfo.color,...
                       'linestyle',ud.sigs(i).lineinfo.linestyle,...
                       'buttondownfcn','sbswitch(''pandown'',1)',...
                       'visible','on',...
                       'tag',ud.sigs(i).label);
            end
        
            complex_flag = ~isreal(ud.sigs(i).data);
            cv = get(ud.hand.complexpopup,'value');
           
            for k=1:M
                yd = ud.sigs(i).data(:,columns(k));
                yd = sbcomplexfcn(yd,cv,complex_flag);
                set([ud.lines(i).h(k) ud.lines(i).ph(k)],...
                           'xdata',xd,'ydata',yd);
                set(ud.lines(i).h(k),...
                     'buttondownfcn',['sbswitch(''pickfcn'',' ...
                                    num2str(i) ',' num2str(columns(k)) ')'])
            end
            
            sbzoomout(ud,0,0)  % zooms out and saves userdata 
            
            % poke back into SPTool:
            sptool('import',ud.sigs(i))
            sptlegend('setstring',{ud.sigs.label},{ud.lines.columns},fig)
            
            pickfcn('noMouse',i,1,fig)
        end
    else
        % disp('cancelled')
    end
    
    return
    
%------------------------------------------------------------------------
% sigbrowse('print')
%  print contents of sigbrowse (assumed in gcf)
case 'print'

%------------------------------------------------------------------------
% sigbrowse('play')
%  play signal
case 'play'
    ud = get(gcf,'userdata');
    if isempty(ud.focusIndex)
        return
    end
    setptr(gcf,'watch');
    ud.pointer = -1; 
    set(gcf,'userdata',ud)
    
    y = ud.sigs(ud.focusIndex).data(:,ud.focusColumn);
    Fs = ud.sigs(ud.focusIndex).Fs;
        
    if ~isreal(y)
    % for complex signals, play real / imag in separate channels
        y = [real(y(:)) imag(y(:))];
    end

    if Fs < 25   % sampling rate too low - use platform default
        soundStr = 'soundsc(y)';
    else
        soundStr = 'soundsc(y,Fs)';
    end
    eval(soundStr,'')  % catch errors in case of no sound capabilities

    ud.pointer = 0; 
    set(gcf,'userdata',ud)
    sbmotion(gcf)
        
%------------------------------------------------------------------------
% enable = sigbrowse('selection',action,msg,SPTfig)
%  respond to selection change in SPTool
% possible actions are
%    'view'
%  msg - either 'value', 'label', or 'Fs'
%         'value' - only the listbox value has changed
%         'label' - one of the selected objects has changed it's name
%         'Fs' - one of the selected objects's .Fs field has changed
%         'dup' - a selected object was duplicated
%         'clear' - a selected object was cleared
%  Button is enabled when there is at least one signal selected
case 'selection'
    msg = varargin{3};
    sptoolfig = varargin{4};
    [s,ind] = sptool('Signals',1,sptoolfig);
    if isempty(ind)
        enable = 'off';
    else
        enable = 'on';
    end
    fig = findobj('type','figure','tag','sigbrowse');
    if ~isempty(fig)
        ud = get(fig,'userdata');
        switch msg
        case {'new','value','dup'}
            if ~isequal(ud.sigs,s(ind))
                sigbrowse('update',fig,s,ind,sptoolfig,msg)
            end
        case 'label'
            for i=1:length(ind)
                if ~isequal(ud.sigs(i).label,s(ind(i)).label)
                    % change label of ud.sigs(i)
                    ud.sigs(i).label = s(ind(i)).label;
                    set(fig,'userdata',ud)
                    sptlegend('setstring',{ud.sigs.label},{ud.lines.columns},fig,1)
                    set(get(ud.mainaxes,'title'),'string',sbtitle(fig,ud.sigs,'auto',''))
                    break
                end
            end
        case 'Fs'
            for i=1:length(ind)
                if ~isequal(ud.sigs(i).Fs,s(ind(i)).Fs)
                    % change Fs of ud.sigs(i)
                    newFs = s(ind(i)).Fs;
                    oldFs = ud.sigs(i).Fs;
                    xd = (0:length(s(ind(i)).data)-1)/newFs;
                    ud.sigs(i).Fs = newFs;
                    ud.lines(i).Fs = newFs;
                    set(ud.lines(i).h,'xdata',xd)
                    if ud.prefs.tool.panner
                        set(ud.lines(i).ph,'xdata',xd)
                    end
                    sbzoomout(ud,0,1)
                    set(get(ud.mainaxes,'title'),'string',sbtitle(fig,ud.sigs,'auto',''))
                    break
                end
            end
        case 'clear'
            deletedStruc = sptool('changedStruc',sptoolfig);
            if ~strcmp(deletedStruc.SPTIdentifier.type,'Signal')
                % do nothing
            elseif isempty(ind)
                sigbrowse('update',fig,s,ind,sptoolfig,msg)
            else
                % first find out which one was deleted
                rmInd = length(ud.sigs);
                for i = 1:length(ind)
                    if ~strcmp(s(ind(i)).label,ud.sigs(i).label)
                        rmInd = i;
                        break  % found it
                    end
                end
                delete(ud.lines(rmInd).h)
                if ud.prefs.tool.panner
                    delete(ud.lines(rmInd).ph)
                end
                
                ud.sigs(rmInd) = [];
                ud.lines(rmInd) = [];
                
                ud.SPToolIndices = ind;
            
                set(fig,'userdata',ud)
                sptlegend('setstring',{ud.sigs.label},{ud.lines.columns},fig,1)
                
                if ud.focusIndex == rmInd
                  % shift focus to first signal
                    ud.focusIndex = 1;
                    % save the focusline handle in the userdata struct:
                    focusLineInfo = ud.sigs(ud.focusIndex).lineinfo;
                    ud.focusline = ud.lines(ud.focusIndex).h(focusLineInfo.columns(1));
                    sbzoomout(ud,0,0)  % saves userdata
                    ud = get(fig,'userdata');
                    pickfcn('noMouse',ud.focusIndex,1,fig)
                else
                    if ud.focusIndex > rmInd
                        ud.focusIndex = ud.focusIndex - 1;
                    end
                    sbzoomout(ud,0,0)  % saves userdata
                    if ud.prefs.tool.ruler
                        ruler('showlines',fig)
                    end
                    ud = get(fig,'userdata');
                end    
            
            end  % if isempty(ind)
        end  % switch msg
    end  % if ~isempty(fig)
    
    varargout{1} = enable;
    
%------------------------------------------------------------------------
% enable = sigbrowse('action',action,selection)
%  respond to button push in SPTool
% possible actions are
%    'view'
case 'action'
    sptoolfig = gcf;
    fig = findobj('type','figure','tag','sigbrowse');
    if isempty(fig)
        sigbrowse(sptoolfig)
        fig = gcf;
    else
        figure(fig)
    end
    ud = get(fig,'userdata');
    [s,ind] = sptool('Signals',1,sptoolfig);
    if ~isequal(ud.sigs,s(ind))
        sigbrowse('update',fig,s,ind,sptoolfig,'new')
    end

%------------------------------------------------------------------------
% sigbrowse('SPTclose',action)
% Signal Browser close request function
%   This function is called when a browser window is closed.
%  action will be:  'view'
case 'SPTclose'
    fig = findobj('type','figure','tag','sigbrowse');
    if ~isempty(fig)
        ud = get(fig,'userdata');
        if ~isempty(ud.tabfig)
            delete(ud.tabfig)
        end
        delete(fig)
    end
    
%------------------------------------------------------------------------
% errstr = sigbrowse('setprefs',panelName,p)
% Set preferences for the panel with name panelName
% Inputs:
%   panelName - string; must be either 'ruler','color', or 'sigbrowse'
%              (see sptprefreg for definitions)
%   p - preference structure for this panel
case 'setprefs'
    errstr = '';
    panelName = varargin{2};
    p = varargin{3};
    switch panelName
    case 'ruler'
        rc = evalin('base',p.rulerColor,'-1');
        if rc == -1
            errstr = 'The Ruler Color you entered cannot be evaluated.';
        elseif ~iscolor(rc)
            errstr = 'The Ruler Color you entered is not a valid color.';
        end
        if isempty(errstr)
            ms = evalin('base',p.markerSize,'-1');
            if ms == -1
                errstr = 'The Marker Size you entered cannot be evaluated.';
            elseif all(size(ms)~=1) | ms<=0 
                errstr = 'The Marker Size you entered must be a real scalar.';     
            end
        end
    case 'color'
        co = evalin('base',p.colorOrder,'-1');
        if co == -1
            errstr = 'The Color Order that you entered cannot be evaluated.';
        else
            if ~iscell(co)
                co = num2cell(co,[3 2]);  % convert to cell array
            end
            for i = 1:length(co)
                if ~iscolor(co{i})
                    errstr = 'The Color Order that you entered is invalid.';
                    break
                end
            end
        end
    
        if isempty(errstr)
            lso = evalin('base',p.linestyleOrder,'-1');
            if lso == -1
                errstr = 'The Line Style Order that you entered cannot be evaluated.';
            else
                if ~iscell(lso)
                    lso = num2cell(lso,[3 2]);  % convert to cell array
                end
                for i = 1:length(lso)
                    if isempty(findcstr({'-' '--' ':' '-.'},lso{i}))
                        errstr = 'The Line Style Order that you entered is invalid.';
                        break
                    end
                end
            end
        end
        
    case 'sigbrowse'
    end
    varargout{1} = errstr;
    if ~isempty(errstr)
        return
    end
    
    fig = findobj('type','figure','tag','sigbrowse');
    if ~isempty(fig)
        ud = get(fig,'userdata');
        newprefs = ud.prefs;
        switch panelName
        case 'ruler'
            markerStr = { '+' 'o' '*' '.' 'x' ...
               'square' 'diamond' 'v' '^' '>' '<' 'pentagram' 'hexagram'}';
            newprefs.ruler.color = p.rulerColor;
            newprefs.ruler.marker = markerStr{p.rulerMarker};
            newprefs.ruler.markersize = p.markerSize;
            
            if ud.prefs.tool.ruler
                rc = evalin('base',newprefs.ruler.color);
                set(ud.ruler.lines,'color',rc);
                set(ud.ruler.markers,'color',rc,'marker',newprefs.ruler.marker,...
                   'markersize',evalin('base',newprefs.ruler.markersize))
            end
        case 'color'
            newprefs.colororder = p.colorOrder;
            newprefs.linestyleorder = p.linestyleOrder;
            ud.colororder = num2cell(evalin('base',newprefs.colororder),2);
            ud.linestyleorder = num2cell(evalin('base',newprefs.linestyleorder),2);
        case 'sigbrowse'
            newprefs.xaxis.label = p.xlabel;
            newprefs.yaxis.label = p.ylabel;
            newprefs.tool.ruler = p.rulerEnable;
            newprefs.tool.panner = p.pannerEnable;
            newprefs.tool.zoompersist = p.zoomFlag;
            set(get(ud.mainaxes,'xlabel'),'string',p.xlabel)
            set(get(ud.mainaxes,'ylabel'),'string',p.ylabel)
            
            % resize flags
            rbrowse = 0; 
            rpanner = 0;
        
            % enable / disable ruler
            if ud.prefs.tool.ruler~=newprefs.tool.ruler
                if newprefs.tool.ruler
                    % turn ruler on
                    rulerPrefs = sptool('getprefs','ruler');
                    typeStr = {'vertical','horizontal','track','slope'};
                    ud.prefs.ruler.type = typeStr{rulerPrefs.initialType};
                    set(fig,'userdata',ud)
                    ruler('init',fig)
                    ruler('showlines',fig)
                    ruler('newlimits',fig)
                    ruler('newsig',fig)
                else
                    ruler('close',fig)
                end
                ud = get(fig,'userdata');
                rbrowse = 1;
                if newprefs.tool.panner, rpanner = 1; end
            end
        
            % enable / disable panner
            if ud.prefs.tool.panner~=newprefs.tool.panner
                if newprefs.tool.panner
                    panner('init',fig)
                    ud = get(fig,'userdata');
                    for i=1:length(ud.lines)
                        ud.lines.ph = copyobj(ud.lines.h,ud.panner.panaxes);
                        set(ud.lines.ph,'buttondownfcn','sbswitch(''pandown'',1)')
                    end
                else
                    panner('close',fig)
                    ud = get(fig,'userdata');
                end
                rbrowse = 1;
            end
        
            % resize objects if necessary:
            if rbrowse, 
                sbresize(0,fig)
                if newprefs.tool.ruler
                    ruler('resizebtns',fig)
                end
             end
            if rpanner, panner('resize',0,fig), end
        end
        ud.prefs = newprefs;
        set(fig,'userdata',ud)
            
    end

%------------------------------------------------------------------------
% sigbrowse('help')
% Callback of help button in toolbar
case 'help'
    fig = gcf;
    ud = get(fig,'userdata');
    if ud.pointer ~= 2   % if not in help mode
        % enter help mode
        saveEnableControls = [ ud.hand.arraybutton 
                               ud.hand.complexpopup 
                               ud.legend.legendpopup 
                               ud.legend.legendbutton];
        ax = [ud.mainaxes ud.toolbar.toolbar];
        if ud.prefs.tool.ruler
            ax = [ax ud.ruler.hand.ruleraxes];
        end
        if ud.prefs.tool.panner
            ax = [ax ud.panner.panaxes];
        end
        
        titleStr = 'Signal Browser Help';
        helpFcn = 'sbhelpstr';
        spthelp('enter',fig,saveEnableControls,ax,titleStr,helpFcn)
    else
        spthelp('exit')
    end
    
%------------------------------------------------------------------------
% default
otherwise
    if isstr(varargin{1})
        disp(sprintf('Sigbrowse: action ''%s'' not recognized',varargin{1}))
    else
        disp(sprintf('Sigbrowse: takes no arguments',varargin{1}))
    end
end


function sbzoomout(ud,xflag,rulerFlag)
% reset limits of mainaxes, and set Full View limits (ud.limits field)
% Inputs:
%   ud - userdata struct
%   xflag - 1 ==> zoom out in x
%           0 ==> keep xlimits the same
%   rulerFlag (optional) - 1 ==> update rulers (default)
%                          0 ==> don't update rulers
% CAUTION: Sets figure userdata !!!!!

    if nargin < 3
        rulerFlag = 1;
    end
    
    fig = get(ud.mainaxes,'parent');
    
    % turn off rulers for limits calculation:
    if ud.prefs.tool.ruler
        h = [ud.ruler.lines(:); ud.ruler.markers(:)];
        set(h,'visible','off')
    end
        
    % zoom out
    set(ud.mainaxes,'ylimmode','auto')
    if isempty(ud.sigs)
        xlim = get(ud.mainaxes,'xlim');
        ylim = get(ud.mainaxes,'ylim');
    elseif xflag   % FULL VIEW
        x2 = 0;
        for i=1:length(ud.sigs)
            x2 = max(x2,(size(ud.sigs(i).data,1)-1)/ud.sigs(i).Fs);
        end
        if x2 <= 0
            x2 = max(1./[ud.sigs.Fs]);
        end
        xlim = [0 x2];
        ud.limits.xlim = xlim;
        set(ud.mainaxes,'xlim',xlim)
        ylim = get(ud.mainaxes,'ylim');
        ud.limits.ylim = ylim;
    else   % only zoom out Y, but update ud.limits to FULL VIEW
        xlim = get(ud.mainaxes,'xlim');
        x2 = 0;
        for i=1:length(ud.sigs)
            x2 = max(x2,(size(ud.sigs(i).data,1)-1)/ud.sigs(i).Fs);
        end
        if x2 <= 0
            x2 = max(1./[ud.sigs.Fs]);
        end
        ud.limits.xlim = [0 x2];
        set(ud.mainaxes,'xlim',ud.limits.xlim)
        ud.limits.ylim = get(ud.mainaxes,'ylim');
        set(ud.mainaxes,'xlim',xlim)
        ylim = get(ud.mainaxes,'ylim');
    end
    xlim = inbounds(xlim,ud.limits.xlim);
    set(ud.mainaxes,'xlim',xlim,'ylim',ylim)

    set(fig,'userdata',ud)
    
    if ud.prefs.tool.panner
        set(ud.panner.panaxes,'xlim',ud.limits.xlim,'ylim',ud.limits.ylim)
        panner('update',fig)
    end

    if ud.prefs.tool.ruler & rulerFlag
        ruler('showlines',fig)
        ruler('newlimits',fig)
        ruler('newsig',fig)
    end

function data = sbcomplexfcn(data,cv,cf)
%SBCOMPLEXFCN Signal Browser complex number conversion function.
%   Inputs:
%      data - matrix to be converted
%      cv - complex value (1=real,2=imag,3=mag,4=angle)
%      cf - complex flag (0 = no, 1 = yes)
%   Outputs:
%      data - converted input data

    if cf
        switch cv
        case 1    % real
            data = real(data);
        case 2    % imaginary
            data = imag(data);
        case 3    % magnitude
            data = abs(data);
        case 4    % angle
            data = angle(data);
        end
    end
