function sbinit
%SBINIT Initialize signal browser.
 
%   Copyright (c) 1988-98 by The MathWorks, Inc.
% $Revision: 1.3 $

    save_shh = get(0,'showhiddenhandles');
    set(0,'showhiddenhandles','on')

    figname = prepender('Signal Browser');

    % ====================================================================
    % set defaults and initialize userdata structure

    rulerPrefs = sptool('getprefs','ruler');
    colorPrefs = sptool('getprefs','color');
    sigbrowsePrefs = sptool('getprefs','sigbrowse');

    ud.prefs.tool.ruler = sigbrowsePrefs.rulerEnable;    % rulers enabled
    ud.prefs.tool.panner = sigbrowsePrefs.pannerEnable;  % panner enabled
    ud.prefs.tool.zoompersist = sigbrowsePrefs.zoomFlag; % is zoom mode persistant or
       % does it go away when you zoom once?

    ud.prefs.colororder = colorPrefs.colorOrder;
    ud.prefs.linestyleorder = colorPrefs.linestyleOrder;

    ud.prefs.minsize = [150 150 60]; 
      % minsize(1)   - minimum width of main axes in pixels
      % minsize(2)   - minimum height of main axes in pixels
      % minsize(3)   - minimum height of workspace listbox in pixels

    ud.prefs.xaxis.label = sigbrowsePrefs.xlabel;
    ud.prefs.xaxis.grid = 1;
    ud.prefs.yaxis.label = sigbrowsePrefs.ylabel;
    ud.prefs.yaxis.grid = 1;
    
    ud.prefs.title.mode = 'auto';  % can be 'auto' or 'manual'
    ud.prefs.title.manualstring = '';  % title string in case mode is manual
   
    markerStr = { '+' 'o' '*' '.' 'x' ...
         'square' 'diamond' 'v' '^' '>' '<' 'pentagram' 'hexagram' }';
    typeStr = {'vertical' 'horizontal' 'track' 'slope'}';
    
    ud.prefs.ruler.color = rulerPrefs.rulerColor;
    ud.prefs.ruler.marker = markerStr{rulerPrefs.rulerMarker};
    ud.prefs.ruler.markersize = rulerPrefs.markerSize;
    ud.prefs.ruler.type = typeStr{rulerPrefs.initialType};

    ud.prefs.panner.erasemode = 'background';
    ud.prefs.panner.dynamicdrag = 1;

    ud.prefs.hidedialogs = 1;  % hide or destroy flag; 1 == hide
                               %  0 = destroy.

    ud.sz = sptsizes;

    ud.sigs = [];
    
    ud.linecache.h = [];  % no line objects defined yet
    if ud.prefs.tool.panner
        ud.linecache.ph = [];  
    end

    ud.lines = [];
    ud.SPToolIndices = [];
    ud.focusIndex = [];
    ud.colorCount = 0;  % number of colors allocated thus far
    ud.colororder = num2cell(evalin('base',ud.prefs.colororder),2);
    ud.linestyleorder = num2cell(evalin('base',ud.prefs.linestyleorder),2);

    ud.pointer = 0;  % == -1 watch, 0 arrow/drag indicators, 1 zoom,
                     %     2 help
    ud.t0 = 0;
    
    ud.tabfig = [];  % handle to settings dialog box figure

    ud.limits.xlim = [0 1];
    ud.limits.ylim = [0 1];

    ud.justzoom = [ 0 0 ] ;

    sz = ud.sz;

    screensize = get(0,'screensize');
    fp = get(0,'defaultfigureposition');
    fw = fp(3)+sz.rw; % figure width
    fw = min(fw,screensize(3)-30);
    fh = ruler('minWidth',sz);
    fp = [fp(1)-(fw-fp(3))/2 fp(2)+fp(4)-fh fw fh];
    
    % CREATE FIGURE
    fig = figure('createfcn','',...
            'closerequestfcn','sbswitch(''sigbrowse'',''SPTclose'')',...
            'tag','sigbrowse',...
            'numbertitle','off',...
            'integerhandle','off',...
            'handlevisibility','callback',...
            'userdata',ud,...
            'units','pixels',...
            'position',fp,...
            'menubar','none',...
            'name',figname,...
            'inverthardcopy','off',...
            'paperpositionmode','auto',...
            'visible','off',...
            'resizefcn','sbswitch(''resizedispatch'')%');
    figure(fig)
    uibgcolor = get(0,'defaultuicontrolbackgroundcolor');
    uifgcolor = get(0,'defaultuicontrolforegroundcolor');

    % ====================================================================
    % MENUs
    %  create cell array with {menu label, callback, tag}

 %  MENU LABEL                          CALLBACK                    TAG
mc={ 'File'                              ' '                     'filemenu'
     '>Pa&ge Setup...'                   'printcomp(''pgepos'')' 'pagepos'
     '>Print Pre&view...'                'printcomp(''prev'')'   'printprev'
     '>&Print...'                        'printcomp(''prnt'')'   'prnt'
     '>---'                              ' '                     ' '
     '>&Close^w'                         'close'                 'closemenu'
     '&Options'                          ' '                     'optionsmenu'
     '>&Play^p'                          'sigbrowse(''play'')'   'playmenu'
     '&Window'                            winmenu('callback')    'winmenu'};

    menu_handles = makemenu(fig, char(mc(:,1)), ...
                            char(mc(:,2)), char(mc(:,3)));
    winmenu(fig)
        
    set(menu_handles,'handlevisibility','callback')

    % ====================================================================
    % Create Main axes
    mainaxes = axes('units','pixels',...
         'box','on',...
         'handlevisibility','callback', ...
         'tag','mainaxes');
    % create a copy that will be underneath the main axes, and
    % will be used as a border during panning operations to prevent
    % background erasemode from clobbering the main axes plot box.
    temp = copyobj(mainaxes,fig);
    mainaxes_border = mainaxes;
    mainaxes = temp;

    set(mainaxes_border,'xtick',[],'ytick',[],'visible','off',...
          'tag','mainaxes_border')

    set(get(mainaxes,'title'),'FontAngle',  get(mainaxes, 'FontAngle'), ...
        'FontName',   get(mainaxes, 'FontName'), ...
        'FontSize',   get(mainaxes, 'FontSize'), ...
        'FontWeight', get(mainaxes, 'FontWeight'), ...
        'color',get(mainaxes,'xcolor'),...
        'tag','mainaxestitle',...
        'interpreter','none')
    set(get(mainaxes,'xlabel'),'string',ud.prefs.xaxis.label,...
         'tag','mainaxesxlabel')
    set(get(mainaxes,'ylabel'),'string',ud.prefs.yaxis.label,...
         'tag','mainaxesylabel')

    % ====================================================================
    % Complex Display Popup
    %   userdata stores last value
    ud.hand.complexpopup = uicontrol(...
        'style','popupmenu',...
        'units','pixels',...
        'tag','complexpopup',...
        'string','Real|Imaginary|Magnitude|Angle',...
        'value',1,'userdata',1,...
        'callback','sbswitch(''sbcmplx'')');

    % ====================================================================
    % Array Signals button
    %   userdata stores last value
    ud.hand.arraybutton = uicontrol(...
        'style','pushbutton',...
        'units','pixels',...
        'tag','arraybutton',...
        'string','Array Signals...',...
        'callback','sbswitch(''sigbrowse'',''array'')');

    ud.mainaxes = mainaxes;
    ud.mainaxes_border = mainaxes_border;

    set(fig,'userdata',ud)
    
    % ====================================================================
    % now add toolbar for signal browser
    btnlist = {'mousezoom' 'zoomout' 'zoominy' 'zoomouty' 'zoominx' ...
               'zoomoutx'  'help'}';
    tb_callbackstr = {
       'sbswitch(''sbzoom'',''mousezoom'')'
       'sbswitch(''sbzoom'',''zoomout'')'
       'sbswitch(''sbzoom'',''zoominy'')'
       'sbswitch(''sbzoom'',''zoomouty'')'
       'sbswitch(''sbzoom'',''zoominx'')'
       'sbswitch(''sbzoom'',''zoomoutx'')'
       'sbswitch(''sigbrowse'',''help'')' };
    zoombar('fig',fig,'btnlist',btnlist,'callbacks',tb_callbackstr,...
            'left_width',2*ud.sz.fus + ud.sz.bw,...
            'right_width',sptlegend('width',fig)+2*ud.sz.lbs); 

    % create legend - changes userdata
    sptlegend(fig,'sigbrowse(''changefocus'')','sigbrowse')
    
    % ====================================================================
    % position objects:
    sbresize(1,fig)

    set(fig,'resizefcn',appstr(get(fig,'resizefcn'),'sbswitch(''sbresize'')'))
    set(fig,'windowbuttonmotionfcn','sbswitch(''sbmotion'')')

    if ud.prefs.tool.ruler
       ruler
    end

    if ud.prefs.tool.panner
       panner
    end

    set(0,'showhiddenhandles',save_shh)
    % set(fig,'visible','on')  - do this later (in calling function)
