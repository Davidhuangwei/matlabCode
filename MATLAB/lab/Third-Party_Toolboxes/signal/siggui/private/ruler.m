function varargout = ruler(varargin)
%RULER Ruler management function.
 
%   Copyright (c) 1988-98 by The MathWorks, Inc.
% $Revision: 1.1 $

% API - state of ruler is stored in a structure in the userdata
% of the figure in which it is installed - ud.ruler
%
%  field       description
%  -----       -----------
%  color       string (evals to color spec in base workspace), 
%                     defines color of ruler lines and labels
%  marker      string ('o','+',etc)
%  markersize  string ('5','4','m',etc - evaled in base workspace)
%  value       current value of rulers
%               x1, x2, y1, y2, dx, dy, dydx
%  type        'vertical' 'horizontal' 'track' or 'slope'
%  lines       [l1 l2 slopeline] handles of ruler lines
%  markers     [m1 m2] handles of ruler marker lines
%
%  ud.focusline  handle of current line being measured (for 'track' and 'slope')
%              (empty if no focus)

if nargin < 1
    action = 'init';
else
    action = varargin{1};
end

switch lower(action)

%-----------------------------------------------------------------
% curs = ruler('motion',fig)
%  returns 1 if currentpoint is over ruler 1, 2 if over ruler 2, 0 else
%
case 'motion'
    fig = varargin{2};
    ud = get(fig,'userdata');
    mainaxes = ud.mainaxes;
    p = get(mainaxes,'currentpoint');
    p = p(1,1:2);
    xlim = get(mainaxes,'xlim');
    ylim = get(mainaxes,'ylim');
    if ~pinrect(p,[xlim ylim])  % outside of main axes
        curs = 0;
    else
        if all(isnan([ud.ruler.value.x1 ud.ruler.value.x2 ...
                    ud.ruler.value.y1 ud.ruler.value.y2])) 
            curs = 0;
            varargout{1} = curs;
            return
        end
        mpos = get(mainaxes,'position'); % in pixels
        % alternate method (doesn't quite work)
        %fp = get(fig,'currentpoint');
        %fprintf(1,'x=%d, y=%d, ',fp(1),fp(2))
        %fprintf(1,' xlim(1)=%d, xlim(2)=%d  ',mpos(1),mpos(1)+mpos(3)-1)
        %x1 = ((ud.ruler.value.x1-xlim(1))*(mpos(3)-1)/diff(xlim)) ...
        %         + mpos(1) - 1;
        %fprintf(1,' x1=%4.3f',x1)
        %dist = abs(x1-fp(1));
        %fprintf(1,'  dist=%d\n',dist)
        
        if ud.ruler.type(1)=='h'  % horizontal
            if strcmp(get(mainaxes,'yscale'),'log')
              %  if (ylim(1) == 0), ylim(1) = eps*ylim(2); end
                ppd = mpos(4)/diff(log10(ylim)); % pixels per decade
                y1 = ud.ruler.value.y1;
                y2 = ud.ruler.value.y2;
                c1 = 10^(-3.5/ppd);
                c2 = 10^(2.5/ppd);
                if (p(2)>=c1*y1) & (p(2)<=c2*y1)
                    curs = 1;
                elseif (p(2)>=c1*y2) & (p(2)<=c2*y2)
                    curs = 2;
                else
                    curs = 0;
                end                 
            else 
                five_ypixels = 3.5*diff(ylim)/mpos(4);
            if abs(p(2)-ud.ruler.value.y1)<=five_ypixels
                curs = 1;
            elseif abs(p(2)-ud.ruler.value.y2)<=five_ypixels
                curs = 2;
            else
                curs = 0;
            end
            end
        else % vertical
            if strcmp(get(mainaxes,'xscale'),'log')
              %  if (xlim(1) == 0), xlim(1) = eps*xlim(2); end
                ppd = mpos(3)/diff(log10(xlim)); % pixels per decade
                x1 = ud.ruler.value.x1;
                x2 = ud.ruler.value.x2;
                c1 = 10^(-2.5/ppd);
                c2 = 10^(3.5/ppd);
                if (p(1)>=c1*x1) & (p(1)<=c2*x1)
                    curs = 1;
                elseif (p(1)>=c1*x2) & (p(1)<=c2*x2)
                    curs = 2;
                else
                    curs = 0;
                end                 
            else
                five_xpixels = 3.5*diff(xlim)/mpos(3);
                if abs(p(1)-ud.ruler.value.x1)<=five_xpixels
                    curs = 1;
                elseif abs(p(1)-ud.ruler.value.x2)<=five_xpixels
                    curs = 2;
                else
                    curs = 0;
                end
            end
        end
    end
    
    varargout{1} = curs;
    
%-----------------------------------------------------------------
% ruler
% ruler('init',fig)
% ruler('init',fig,rulerPopupStr,rulerPopupVal,popupCallback,allAxesList)
%  startup code; adds ruler and popup to choose focus line to gcf
% Inputs:
%   fig - figure of client (ie. filtview, sigbrowse, sepctview)
%   rulerPopupStr - names of all possible subplots
%   rulerPopupVal - value of popupmenu reflecting the currently
%                   selected plot
%   popupCallback - callback to ruler popupmenu
%   allAxesList   - list of possible handle values for ud.mainaxes, default
%                   is just ud.mainaxes
%
case 'init'
%    save_fig = gcf;
    fig = gcf;
    rulerPopupStr = {''};
    rulerPopupVal = 1;
    popupCallback = '';
    
    if nargin > 1
        fig = varargin{2};
    end
    if nargin > 2
        rulerPopupStr = varargin{3};
    end
    if nargin > 3
        rulerPopupVal = varargin{4};
    end
    if nargin > 4
        popupCallback = varargin{5};
    end
   
    % figure(fig)
    ud = get(fig,'userdata');
    
    if nargin > 5
        rul.allAxesList = varargin{6};
    else
        rul.allAxesList = ud.mainaxes;
    end
    
    rul.type = ud.prefs.ruler.type;

    rul.value.x1 = NaN;
    rul.value.y1 = NaN;
    rul.value.x2 = NaN;
    rul.value.y2 = NaN;
    rul.value.dx = NaN;
    rul.value.dy = NaN;
    rul.value.dydx = NaN;
    
    rul.varname = 'r';  % used in 'Save measurements' dialog box
    
    ud.ruler = rul;
    ud.prefs.tool.ruler = 1;

    uibgcolor = get(0,'defaultuicontrolbackgroundcolor');
    uifgcolor = get(0,'defaultuicontrolforegroundcolor');
    mainaxes = ud.mainaxes;

    % Define axes frame properties: (these axes act as frames)
    ax_props = {
         'parent',fig,...
         'units','pixels',...
         'box','on',...
         'xcolor','k',...
         'ycolor','k',...
         'color',uibgcolor,...
         'xtick',[],...
         'ytick',[],...
         'handlevisibility','callback'           };

    % Define Text Label properties:
    label_props = {
         'color',uifgcolor,...
         'fontname',get(0,'defaultuicontrolfontname'),...
         'fontsize',get(0,'defaultuicontrolfontsize'),...
         'fontweight',get(0,'defaultuicontrolfontweight'),...
         'handlevisibility','callback'    };

    ui_label_props = {
         'units','pixels',...          
         'parent',fig,...
         'style','text',...
         'horizontalalignment','right',...
         'handlevisibility','callback'    };

    line_props = {
         'parent',mainaxes,...
         'visible','off',...
         'erasemode','xor',...
         'xdata',0,'ydata',0,...
         'color',evalin('base',ud.prefs.ruler.color),...
         'handlevisibility','callback'           };
    markersize = evalin('base',ud.prefs.ruler.markersize);
    % create line 2 and marker 2 first, so buttondown callbacks will always
    % favor line 1.
    l2 = line(line_props{:},'tag','ruler2line','linestyle','--',...
         'linewidth', 1, ...
           'buttondownfcn','sbswitch(''ruldown'',2)');
    m2 = line(line_props{:},'tag','ruler2marker',...
              'buttondownfcn','sbswitch(''ruldown'',2)',...
              'linestyle','none','marker',ud.prefs.ruler.marker,...
              'markersize',markersize);
    l1 = line(line_props{:},'tag','ruler1line',...
         'buttondownfcn','sbswitch(''ruldown'',1)',...
         'linewidth', 1);
    slopeline = line(line_props{:},'tag','slopeline',...
         'linewidth',1,'linestyle','--');
    m1 = line(line_props{:},'tag','ruler1marker',...
              'buttondownfcn','sbswitch(''ruldown'',1)',...
              'linestyle','none','marker',ud.prefs.ruler.marker,...
              'markersize',markersize);
              
    peakline = line(line_props{:},'tag','peakline',...
              'buttondownfcn','sbswitch(''ruldown'',1)',...
              'linestyle','none','marker','^','visible','off');
    valleyline = line(line_props{:},'tag','valleyline',...
              'buttondownfcn','sbswitch(''ruldown'',1)',...
              'linestyle','none','marker','v','visible','off');

    ud.ruler.lines = [l1 l2 slopeline peakline valleyline];
    ud.ruler.markers = [m1 m2];

    % ====================================================================
    % Ruler axes - contains rulers
    ud.ruler.hand.ruleraxes = axes(ax_props{:}, 'tag','ruleraxes');

    % ====================================================================
    % Ruler label
    ud.ruler.hand.rulerlabel = text(label_props{:},...
         'parent',ud.ruler.hand.ruleraxes,...
         'horizontalalignment','center',...
         'tag','rulerlabel','string','Rulers');

    % ====================================================================
    % Ruler frame line
    line_frame_props = {
         'color','k',...
         'handlevisibility','callback'           };
    ud.ruler.hand.rulerframe = ...
      line(line_frame_props{:},'parent',ud.ruler.hand.ruleraxes,...
            'tag','rulerframe');

    % ====================================================================
    % Ruler - Labels for ruler values
    ud.ruler.hand.x1label = uicontrol(ui_label_props{:},...
           'tag','x1label','string','x1');
    ud.ruler.hand.y1label = uicontrol(ui_label_props{:},...
           'tag','y1label','string','y1');
    ud.ruler.hand.x2label = uicontrol(ui_label_props{:},...
           'tag','x2label','string','x2');
    ud.ruler.hand.y2label = uicontrol(ui_label_props{:},...
           'tag','y2label','string','y2');
    ud.ruler.hand.dxlabel = uicontrol(ui_label_props{:},...
           'tag','dxlabel','string','dx');
    ud.ruler.hand.dylabel = uicontrol(ui_label_props{:},...
           'tag','dylabel','string','dy');
    ud.ruler.hand.dydxlabel = uicontrol(ui_label_props{:},...
           'tag','dydxlabel','string','m');

    % ====================================================================
    % Ruler editboxes 1 and 2
    edit_props = {'units','pixels','style','edit','backgroundcolor','w','string','-',...
          'horizontalalignment','left','parent',fig};
    ud.ruler.hand.boxes(1) = uicontrol(edit_props{:},'tag','rulerbox1',...
              'callback','sbswitch(''ruler'',''rulerbox'',1)');
    ud.ruler.hand.boxes(2) = uicontrol(edit_props{:},'tag','rulerbox2',...
              'callback','sbswitch(''ruler'',''rulerbox'',2)');

    % ====================================================================
    % Text UIControls to display values of rulers
    text_props = {'style','text','backgroundcolor',uibgcolor,'parent',fig,...
          'foregroundcolor',uifgcolor,'horizontalalignment','left',...
          'string','-','units','pixels'};
    ud.ruler.hand.y1text = uicontrol(text_props{:},'tag','y1text');
    ud.ruler.hand.y2text = uicontrol(text_props{:},'tag','y2text');
    ud.ruler.hand.dxtext = uicontrol(text_props{:},'tag','dxtext');
    ud.ruler.hand.dytext = uicontrol(text_props{:},'tag','dytext');
    ud.ruler.hand.dydxtext = uicontrol(text_props{:},'tag','dydxtext');

    % ====================================================================
    % Ruler 1 button
    ud.ruler.hand.buttons(1) = uicontrol(...
        'units','pixels',...
        'parent',fig,...
        'style','pushbutton',...
        'string','1',...
        'callback','sbswitch(''ruler'',''rulerbutton'',1)',...
        'tag','ruler1button' );
    % ====================================================================
    % Ruler 2 button
    ud.ruler.hand.buttons(2) = uicontrol(...
        'units','pixels',...
        'parent',fig,...
        'style','pushbutton',...
        'string','2',...
        'callback','sbswitch(''ruler'',''rulerbutton'',2)',...
        'tag','ruler2button' );
        
    % ====================================================================
    % Save Ruler button
    ud.ruler.hand.saverulerbutton = uicontrol(...
        'units','pixels',...
        'parent',fig,...
        'style','pushbutton',...
        'string','Save Rulers...',...
        'callback','sbswitch(''ruler'',''save'')',...
        'tag','saverulerbutton' );

    %====================================================================
    % Popup to select the subplot the rulers will focus on
    if (length(rulerPopupStr) > 1)
        pop_props = {'units','pixels',...
	       'style','popup','horizontalalignment','left'};

        % Position is set in ruler('resize')
        ud.ruler.hand.rulerpopup = uicontrol(pop_props{:},...
	       'units','pixels',...
	       'parent',fig,...
	       'string',rulerPopupStr,...
	       'tag','rulerpopup',...
	       'callback', popupCallback,...
	       'value',rulerPopupVal);
    end
     
    % ====================================================================
    % toolbar for rulers
    % 'rulergroup' - includes Vertical, Horizontal, Track, Slope

    % common text properties:
    tp = [',''color'',''k'',''fontunits'',''pixels'',' ...
         '''horizontalalignment'',''center'',''fontsize'',9'];  

    s1 =['[line([.3 .3],[.4 .95],''color'',''k'') ' ...
         ' line([.7 .7],[.4 .95],''linestyle'',''--'',''color'',''k'') '...
         ' text(.5,.15,''Vertical''' tp ')]'];

    s2 =['[text(.5,.15,''Horizontal''' tp ')'...
         ' line([.1 .9],[.8 .8],''color'',''k'') ' ...
         ' line([.1 .9],[.5 .5],''linestyle'',''--'',''color'',''k'') ]'];

    s3 =['[text(.5,.15,''Track''' tp ')'...
         ' line([.3 .3],[.4 .95],''color'',''k'') ' ...
         ' line([.7 .7],[.4 .95],''linestyle'',''--'',''color'',''k'')' ...
         ' line([.3 .7],[.5 .8],''linestyle'',''none'',''marker'',''o'','...
         '''color'',''k'')  ]'];

    s4 =['[text(.5,.15,''Slope''' tp ')' ...
         ' line([.3 .3],[.4 .95],''color'',''k'') ' ...
         ' line([.7 .7],[.4 .95],''linestyle'',''--'',''color'',''k'')' ...
         ' line([.1 .9],[.35 .95],''linestyle'',''--'',''color'',''k'')' ...
         ' line([.3 .7],[.5 .8],''linestyle'',''none'',''marker'',''o'','...
         '''color'',''k'')  ]'];

    r_iconstr = str2mat(s1,s2,s3,s4);
    c1 = 'sbswitch(''ruler'',''newtype'',''vertical'')';
    c2 = 'sbswitch(''ruler'',''newtype'',''horizontal'')';
    c3 = 'sbswitch(''ruler'',''newtype'',''track'')';
    c4 = 'sbswitch(''ruler'',''newtype'',''slope'')';

    r_callbackstr = str2mat(c1,c2,c3,c4);
 
    % common btngroup param/value pairs:
    group_props = {'BevelWidth',.05, 'Orientation','horizontal',...
                   'Units','pixels'};

    id = ruler_btnid(ud.prefs.ruler.type);
    initialState = [0 0 0 0];
    initialState(id) = 1;
    ud.ruler.hand.rulergroup = btngroup(fig,'GroupID','rulergroup',...
        'IconFunctions',r_iconstr,...
        'ButtonID',str2mat('vertical','track','horizontal','slope'),...
        'Exclusive','yes',...
        'InitialState',initialState,...
        'Callbacks',r_callbackstr,...
        'GroupSize',[2 2],...
        group_props{:});
    setFontUnitsPixels(ud.ruler.hand.rulergroup)

    % ====================================================================
    % Peaks and Valleys toggle buttons

    s1 =['[text(.5,.15,''Peaks''' tp ')'...
         ' line([.1 .35 .5 .65 .9],[.4 .9 .65 .8 .4],''color'',''k'') ' ...
         ' line([.35 .65],[.9 .8],''linestyle'',''none'',''marker'',''o'','...
         '''color'',''k'')  ]'];

    s2 =['[text(.5,.15,''Valleys''' tp ')' ...
         ' line([.1 .35 .5 .65 .9],1.35-[.4 .9 .65 .8 .4],''color'',''k'') ' ...
         ' line([.35 .65],1.35-[.9 .8],''linestyle'',''none'',''marker'',''o'','...
         '''color'',''k'')  ]'];

    r_iconstr = str2mat(s1,s2);
    c1 = 'sbswitch(''ruler'',''peaks'')';
    c2 = 'sbswitch(''ruler'',''valleys'')';
    r_callbackstr = str2mat(c1,c2,c3,c4);
 
    ud.ruler.hand.peaksgroup = btngroup(fig,'GroupID','peaksgroup',...
        'IconFunctions',r_iconstr,...
        'ButtonID',str2mat('peaks','valleys'),...
        'InitialState',[0 0],...
        'Callbacks',r_callbackstr,...
        'GroupSize',[1 2],...
        group_props{:});
    setFontUnitsPixels(ud.ruler.hand.peaksgroup)

    ud.ruler.evenlySpaced = 1;  % default value; used in rulermo;
                                % needs to be set by ruler's caller whenever
                                % ud.focusline is set
                                
    ud.ruler.Track_and_Slope_Allowed = 'on';                              
    set(fig,'userdata',ud)

    set(fig,'resizefcn',appstr(get(fig,'resizefcn'),...
            'sbswitch(''ruler'',''resize'')'))

    ruler('resize',1,fig)
    showhide_ruler_labels(fig,ud.ruler.type,ud.ruler.hand)

    % figure(save_fig)

%-----------------------------------------------------------------
% ruler('close',fig)
%  shutdown code - removes ruler from browser
%   Inputs:
%     fig - figure handle of browser
%     handle - HG handle that needs to be removed along
%              with the rulers (ie rulerpopup uicontrol)
%
case 'close'   
    fig = varargin{2};
    ud = get(fig,'userdata');
    if find(strcmp('rulerpopup',fieldnames(ud.ruler.hand)));  % popup exists
       delete(ud.ruler.hand.rulerpopup);
    end
    ud.prefs.tool.ruler = 0;
    delete(ud.ruler.lines)
    delete(ud.ruler.markers)
    h = ud.ruler.hand;
    ud.ruler.lines = [];
    ud.ruler.markers = [];
    ud.ruler.hand = [];

    delete_list = [
      h.rulergroup
      h.peaksgroup
      h.ruleraxes
      h.x1label
      h.y1label
      h.x2label
      h.y2label
      h.dxlabel
      h.dylabel
      h.dydxlabel
      h.boxes(:)
      h.buttons(:)
      h.saverulerbutton
      h.y1text
      h.y2text
      h.dxtext
      h.dytext
      h.dydxtext
    ];
     
    delete(delete_list)

    set(fig,'resizefcn',remstr(get(fig,'resizefcn'),...
       'sbswitch(''ruler'',''resize'')'))    

    set(fig,'userdata',ud)

%-----------------------------------------------------------------
% minWidth = ruler('minWidth',sz)
%  returns height of ruler INCLUDING toolbar, in pixels
%  can be called before or after creation of rulers
%   sz - size structure
%
case 'minwidth'
    sz = varargin{2};
    toolbar_ht = sz.ih;
    varargout{1} = sz.fus+sz.lh+3*sz.rih+8*(sz.uh+sz.fus)+2*sz.fus + toolbar_ht;
    
%-----------------------------------------------------------------
% ruler('resize',create_flag,fig)
%  resize ruler object
%   create_flag == 1 for first time call (position ALL objects)
%               == 0 to position only those that move on resize
%   fig - figure handle of client, such as the signal browser, spectrum
%         viewer or filter viewer
%
case 'resize'
    if nargin >= 2
        create_flag = varargin{2};
    else
        create_flag = 0;
    end
    if nargin >= 3
        fig = varargin{3};
    else
        fig = gcbf;
    end

    ud = get(fig,'userdata');
    sz = ud.sz;
    fp = get(fig,'position');   % in pixels already
    toolbar_ht = sz.ih;

    popupExistFlag = isfield(ud.ruler.hand,'rulerpopup');
    if popupExistFlag
       n_ui = 9;      % number of uicontrols in ruler frame
       xtra_ui = 1;
    else
       n_ui = 8;
       xtra_ui = 0;
    end
    
    minRulerHeight = sz.fus+sz.lh+3*sz.rih+n_ui*(sz.uh+sz.fus)+2*sz.fus;
    if (fp(4)-toolbar_ht) < minRulerHeight
       % disp('    RULER: figure too short - resizing')
       w = fp(3);
       h = minRulerHeight+toolbar_ht;
       fp = [fp(1) fp(2)+fp(4)-h w h];
       set(fig,'position',fp)
       return
    end
    mainaxes = ud.mainaxes;
    mp = get(mainaxes,'position');
    hand = ud.ruler.hand;
    frame_top = fp(4)-(toolbar_ht+sz.ffs+sz.lh/2);
    sizes = {
      hand.ruleraxes  [fp(3)-sz.rw 1 sz.rw fp(4)-toolbar_ht]   
      hand.rulergroup [fp(3)-sz.rw/2-sz.riw ...
                       frame_top-(xtra_ui*(sz.uh+sz.fus)+sz.lh/2+2*sz.rih) ...
		       2*sz.riw 2*sz.rih] 
      hand.peaksgroup [fp(3)-sz.rw/2-sz.riw ...
                       frame_top-(sz.lh/2+3*sz.rih+(n_ui-1)*(sz.uh+sz.fus)+1) ...
                       2*sz.riw sz.rih] 
      hand.buttons(1) [mp(1)+mp(3)-2*sz.uh mp(2)+mp(4) sz.uh sz.uh]
      hand.buttons(2) [mp(1)+mp(3)-sz.uh mp(2)+mp(4) sz.uh sz.uh]
      hand.saverulerbutton [fp(3)-sz.rw/2-sz.riw ...
                      frame_top-(sz.lh/2+3*sz.rih+n_ui*(sz.uh+sz.fus)-3) ...
                      2*sz.riw sz.uh];
    };

    set([sizes{:,1}],{'position'},sizes(:,2))
    set(hand.ruleraxes,'xlim',[0 sz.rw],'ylim',[0 fp(4)-toolbar_ht])

    if popupExistFlag
       rulerGroupPos = sizes{2,2};
       set(ud.ruler.hand.rulerpopup,'position',...
	       [rulerGroupPos(1) frame_top-sz.uh-sz.lh/2+1 sz.riw*2-2 sz.uh]);
    end
  
    % 1-by-2 position vectors (for axes text)
    pos = {
    hand.rulerlabel    [sz.rw/2 frame_top]
    };

    set([pos{:,1}],{'position'},pos(:,2))

    pos_ruler_labels(fig,sz,ud.ruler.type,hand,xtra_ui);

    % --------------------------------------------------------------------
    % specify rectangles for frame borders (line objects)
    %   [left bottom right top]
    pos = {
    hand.rulerframe  [sz.ffs ...
                   frame_top-(sz.lh/2+2*sz.rih+9*sz.fus+n_ui*sz.uh+sz.rih) ...
                   sz.rw-sz.ffs frame_top]
    };
    % convert rectangles to xdata and ydata for frame borders (line objects)
    [xdata,ydata]=lfdata(pos(:,2), hand.rulerlabel, sz.lfs);

    set([pos{:,1}],{'xdata'},xdata,{'ydata'},ydata)
    
%-----------------------------------------------------------------
% ruler('resizebtns',fig)
%  move ruler buttons (1,2) to correct location
%   fig - figure handle of the client, such as signal browser, 
%         filter viewer, or spectrum viewer
%
case 'resizebtns'
    if nargin >= 2
        fig = varargin{2};
    else
        fig = gcf;
    end

    ud = get(fig,'userdata');
    sz = ud.sz;

    mainaxes = ud.mainaxes;
    mp = get(mainaxes,'position');

    set(ud.ruler.hand.buttons(1),...
        'position',[mp(1)+mp(3)-2*sz.uh mp(2)+mp(4) sz.uh sz.uh])
    set(ud.ruler.hand.buttons(2),...
        'position',[mp(1)+mp(3)-sz.uh mp(2)+mp(4) sz.uh sz.uh])

%------------------------------------------------------------------------
% ruler('setpopup',fig,str,val)
%  set the string and value of the ruler popupmenu
% Inputs:
%   fig - figure handle of the client
%   str - ruler popupmenu string
%   val - ruler popupmenu value
%
case 'setpopup'
    fig = varargin{2};
    str = varargin{3};
    val = varargin{4};

    ud = get(fig,'userdata');
    set(ud.ruler.hand.rulerpopup,'string',str);
    set(ud.ruler.hand.rulerpopup,'value',val);

%------------------------------------------------------------------------
% [str,val] = ruler('getpopup',fig)
%  get the string and value of the ruler popupmenu
% Inputs:
%   fig - figure handle of the client
% Outputs:
%   str - ruler popupmenu string
%   val - ruler popupmenu value
%
case 'getpopup'
    fig = varargin{2};
    ud = get(fig,'userdata');
    varargout{1} = get(ud.ruler.hand.rulerpopup,'string');
    varargout{2} = get(ud.ruler.hand.rulerpopup,'value');
    
%------------------------------------------------------------------------
%   ruler('allowTrack',on_off,fig)
%     Set allowTrack property of rulers; if set to 'off', then
%     user cannot switch to track or slope modes, and the peaks and
%     valleys buttons are forced off.
%     When switched off, the ruler is switched to Vertical mode if it
%     was previously in track or slope, and the peaks and valleys are
%     turned off.
%   Side effect: sets the userdata of the figure
%   Inputs:
%     on_off - 'on' or 'off'
%     fig - figure of rulers
%
case 'allowtrack'
    on_off = varargin{2};
    fig = varargin{3};
    ud = get(fig,'userdata');
    
    switch on_off
    case 'on'
        ud.ruler.Track_and_Slope_Allowed = 'on';
        set(fig,'userdata',ud);
    case 'off'
        ud.ruler.Track_and_Slope_Allowed = 'off';
        set(fig,'userdata',ud);
        switch ud.ruler.type
        case {'track', 'slope'}
            btndown(fig,'rulergroup',1)
            btnup(fig,'rulergroup',3)
            btnup(fig,'rulergroup',4)
            ruler('newtype','vertical',fig)
        end
        ud = get(fig,'userdata');
        % turn off peaks and/or valleys
        if btnstate(fig,'peaksgroup',1)  % peaks are on
            btnup(fig,'peaksgroup',1)
            ruler('peaks')
        end
        if btnstate(fig,'peaksgroup',2)  % valleys are on
            btnup(fig,'peaksgroup',2)
            ruler('valleys')
        end    
    otherwise
        error('allowTrack must be ''on'' or ''off''.')
    end
    
%------------------------------------------------------------------------
%   ruler('newtype',type,fig)
%  OR
%   ruler('newtype',type,[x1 x2])
%    type can be 'horizontal','vertical','track' or 'slope'.
%    positions rulers in center of mainaxes, or if given two values
%    as input uses those values.
%
case 'newtype'
    type = varargin{2};
    if nargin < 3
        fig = gcf;
    elseif length(varargin{3})==1
        fig = varargin{3};
        varargin{3} = [];
    end
    ud = get(fig,'userdata');
    
    old_type = ud.ruler.type;

    plotIndex = find(ud.mainaxes == ud.ruler.allAxesList);
    
    if ud.pointer == 2  % help mode
        if ~isequal(type,old_type)
            btnup(fig,'rulergroup',ruler_btnid(type))
            btndown(fig,'rulergroup',ruler_btnid(old_type))
        end
        spthelp('exit','ruler',type)
        return
    end
    
    if strcmp(ud.ruler.Track_and_Slope_Allowed,'off') & ...
       (strcmp(type,'track') | strcmp(type,'slope'))
        btndown(fig,'rulergroup',1+strcmp(old_type,'horizontal'))
        btnup(fig,'rulergroup',3)
        btnup(fig,'rulergroup',4)
        return
    end

    if isequal(type,old_type)  % do nothing if type hasn't changed
        return
    end

    mainaxes = ud.mainaxes;
    xlim = get(mainaxes,'xlim');
    ylim = get(mainaxes,'ylim');

    if ~strcmp(type,'horizontal')
        if ~strcmp(old_type,'horizontal')
            if nargin < 3 | isempty(varargin{3})
                % if both new and old ruler type are vertical,
                % retain any visible values.
                if (ud.ruler.value.x1 < xlim(1))|(ud.ruler.value.x1>xlim(2))
                    x1 = 2/3*xlim(1) + 1/3*xlim(2);
                else
                    x1 = ud.ruler.value.x1;
                end
                if (ud.ruler.value.x2 < xlim(1))|(ud.ruler.value.x2>xlim(2))
                    x2 = 1/3*xlim(1) + 2/3*xlim(2);
                else
                    x2 = ud.ruler.value.x2;
                end
            elseif ~isempty(varargin{3})
                x1 = varargin{3}(1);
                x2 = varargin{3}(2);
            end
        else  % coming from horizontal to one of the verticals
            if nargin < 3 | isempty(varargin{3})
                x1 = 2/3*xlim(1) + 1/3*xlim(2);
                x2 = 1/3*xlim(1) + 2/3*xlim(2);
            elseif ~isempty(varargin{3})
                x1 = varargin{3}(1);
                x2 = varargin{3}(2);
            end
        end
    end

    ud.ruler.type = type;
    
    popupExistFlag = isfield(ud.ruler.hand,'rulerpopup');
    if popupExistFlag
       xtra_ui = 1;
    else
       xtra_ui = 0;
    end
    showhide_ruler_labels(fig,ud.ruler.type,ud.ruler.hand)
    pos_ruler_labels(fig,ud.sz,ud.ruler.type,ud.ruler.hand,xtra_ui)

    if ~isempty(ud.focusline)
        yd = get(ud.focusline,'ydata');
    else
        yd = [];
    end
    
    if isempty(yd)  % nothing to look at
          ud.ruler.value.x1 = NaN;
          ud.ruler.value.y1 = NaN;
          ud.ruler.value.x2 = NaN;
          ud.ruler.value.y2 = NaN;
          ud.ruler.value.dx = NaN;
          ud.ruler.value.dy = NaN;
          ud.ruler.value.dydx = NaN;
          set(ud.ruler.hand.boxes,'string','-','userdata',NaN)
          set(ud.ruler.hand.y1text,'string','-')
          set(ud.ruler.hand.y2text,'string','-')
          set(ud.ruler.hand.dxtext,'string','-')
          set(ud.ruler.hand.dytext,'string','-')
          set(ud.ruler.hand.dydxtext,'string','-')
          set(ud.ruler.hand.buttons,'visible','off')
          set(ud.ruler.lines,'visible','off')
          set(ud.ruler.markers,'visible','off')
          set(fig,'userdata',ud)
          return
    end

    switch ud.ruler.type
    case 'vertical'
        y1 = NaN;
        y2 = NaN;
        dx = x2 - x1;
        dy = NaN;
        dydx = NaN;
        set(ud.ruler.hand.boxes(1),'string',num2str(x1),'userdata',x1)
        set(ud.ruler.hand.boxes(2),'string',num2str(x2),'userdata',x2)
        set(ud.ruler.hand.dxtext,'string',num2str(dx),'userdata',dx)
        set(ud.ruler.lines(1:2),'visible','on')
        set(ud.ruler.lines(1),'xdata',[x1 x1])
        setrulxdata(ud.ruler.lines(2),[x2 x2])
        set(ud.ruler.lines([1 2]),'ydata',ud.limits(plotIndex).ylim)
        set(ud.ruler.lines(3),'visible','off')
        set(ud.ruler.markers,'visible','off')
    case 'horizontal'
        x1 = NaN;
        x2 = NaN;
        if nargin < 3 | isempty(varargin{3})
            y1 = 2/3*ylim(1) + 1/3*ylim(2);
            y2 = 1/3*ylim(1) + 2/3*ylim(2);
        elseif ~isempty(varargin{3})
            y1 = varargin{3}(1);
            y2 = varargin{3}(2);
        end
        dx = NaN;
        dy = y2 - y1;
        dydx = NaN;
        set(ud.ruler.hand.boxes(1),'string',num2str(y1),'userdata',y1)
        set(ud.ruler.hand.boxes(2),'string',num2str(y2),'userdata',y2)
        set(ud.ruler.hand.dytext,'string',num2str(dy),'userdata',dy)
        set(ud.ruler.lines(1:2),'visible','on')
        set(ud.ruler.lines(1),'ydata',[y1 y1])
        set(ud.ruler.lines(2),'ydata',[y2 y2])        
        set(ud.ruler.lines([1 2]),'xdata',ud.limits(plotIndex).xlim)
        set(ud.ruler.lines(1),'linewidth',get(ud.ruler.lines(2),'linewidth'))
        set(ud.ruler.lines(3),'visible','off')
        set(ud.ruler.markers,'visible','off')
    case 'track'
        xd = get(ud.focusline,'xdata');
        if length(xd)==1
           x1 = 0;
           x2 = 0;
           dx = 0;
           y1 = yd;
           y2 = yd;
           dy = 0;
           dydx = NaN;
        else
           t0 = xd(1); Ts = xd(2)-xd(1);
           ind1 = round((x1 - t0)/Ts)+1;
           ind2 = round((x2 - t0)/Ts)+1;
           if ind1>length(xd), ind1 = length(xd); end
           if ind2>length(xd), ind2 = length(xd); end
           x1 = (ind1-1)*Ts + t0;
           x2 = (ind2-1)*Ts + t0;
           dx = x2 - x1;
           y1 = yd(ind1);
           y2 = yd(ind2);
           dy = y2 - y1;
           if dx ~= 0
               dydx = dy / dx;
           else
               dydx = NaN;
           end
        end
        set(ud.ruler.hand.boxes(1),'string',num2str(x1),'userdata',x1)
        set(ud.ruler.hand.boxes(2),'string',num2str(x2),'userdata',x2)
        set(ud.ruler.hand.y1text,'string',num2str(y1));
        set(ud.ruler.hand.y2text,'string',num2str(y2));
        set(ud.ruler.hand.dxtext,'string',num2str(dx),'userdata',dx)
        set(ud.ruler.hand.dytext,'string',num2str(dy));
        set(ud.ruler.hand.dydxtext,'string',num2str(dydx));

        set(ud.ruler.markers,'visible','on')
        set(ud.ruler.markers(1),'xdata',x1,'ydata',y1)
        set(ud.ruler.markers(2),'xdata',x2,'ydata',y2)

        set(ud.ruler.lines(1:2),'visible','on')
        set(ud.ruler.lines(1),'xdata',[x1 x1])
        setrulxdata(ud.ruler.lines(2),[x2 x2])
        set(ud.ruler.lines([1 2]),'ydata',ud.limits(plotIndex).ylim)
        set(ud.ruler.lines(3),'visible','off')
    case 'slope'
        xd = get(ud.focusline,'xdata');
        if length(xd)==1
           x1 = 0;
           x2 = 0;
           dx = 0;
           y1 = yd;
           y2 = yd;
           dy = 0;
           dydx = NaN;
           set(ud.ruler.lines(3),'visible','off')
        else
           t0 = xd(1); Ts = xd(2)-xd(1);
           ind1 = round((x1 - t0)/Ts)+1;
           ind2 = round((x2 - t0)/Ts)+1;
           if ind1>length(xd), ind1 = length(xd); end
           if ind2>length(xd), ind2 = length(xd); end
           x1 = (ind1-1)*Ts + t0;
           x2 = (ind2-1)*Ts + t0;
           dx = x2 - x1;
           y1 = yd(ind1);
           y2 = yd(ind2);
           dy = y2 - y1;

           if dx ~= 0
               [xd,yd,dydx] = setslopeline(ud.mainaxes,ud.limits,...
                   x1,x2,y1,y2,dx,dy,plotIndex);
               set(ud.ruler.lines(3),'xdata',xd,'ydata',yd,'visible','on')
           else
               dydx = NaN;
               set(ud.ruler.lines(3),'visible','off')
           end
        end
        set(ud.ruler.hand.boxes(1),'string',num2str(x1),'userdata',x1)
        set(ud.ruler.hand.boxes(2),'string',num2str(x2),'userdata',x2)
        set(ud.ruler.hand.y1text,'string',num2str(y1));
        set(ud.ruler.hand.y2text,'string',num2str(y2));
        set(ud.ruler.hand.dxtext,'string',num2str(dx),'userdata',dx)
        set(ud.ruler.hand.dytext,'string',num2str(dy));
        set(ud.ruler.hand.dydxtext,'string',num2str(dydx));

        set(ud.ruler.markers,'visible','on')
        set(ud.ruler.markers(1),'xdata',x1,'ydata',y1)
        set(ud.ruler.markers(2),'xdata',x2,'ydata',y2)

        set(ud.ruler.lines(1:2),'visible','on')
        set(ud.ruler.lines(1),'xdata',[x1 x1])
        setrulxdata(ud.ruler.lines(2),[x2 x2])
        set(ud.ruler.lines([1 2]),'ydata',ud.limits(plotIndex).ylim)

    end

    ud.ruler.value.x1 = x1;
    ud.ruler.value.x2 = x2;
    ud.ruler.value.y1 = y1;
    ud.ruler.value.y2 = y2;
    ud.ruler.value.dx = dx;
    ud.ruler.value.dy = dy;
    ud.ruler.value.dydx = dydx;

    set(fig,'userdata',ud)  % save new type and position labels and edit boxes

    if strcmp(type,'horizontal')
        if (y1<ylim(1))|(y1>ylim(2))
            set(ud.ruler.hand.buttons(1),'visible','on')
        else 
            set(ud.ruler.hand.buttons(1),'visible','off')
        end
        if (y2<ylim(1))|(y2>ylim(2))
            set(ud.ruler.hand.buttons(2),'visible','on')
        else 
            set(ud.ruler.hand.buttons(2),'visible','off')
        end
    else
        if (x1<xlim(1))|(x1>xlim(2))
            set(ud.ruler.hand.buttons(1),'visible','on')
        else 
            set(ud.ruler.hand.buttons(1),'visible','off')
        end
        if (x2<xlim(1))|(x2>xlim(2))
            set(ud.ruler.hand.buttons(2),'visible','on')
        else 
            set(ud.ruler.hand.buttons(2),'visible','off')
        end
    end


% --------------------------------------------------------------------
% ruler('newaxes',fig,plotIndex,newMainaxes)
%  move the rulers to new visible mainaxes of the client
%   fig - figure handle of the client
%   plotIndex - index into ud.limits(plotIndex).xlim and 
%              ud.limits(plotIndex).ylim
%   newMainaxes - new subplot that rulers should focus on
%
case 'newaxes'
    if nargin >= 4
        newMainaxes = varargin{4};
        plotIndex = varargin{3};
        fig = varargin{2};
    elseif nargin == 2
        fig = varargin{2};
        plotIndex = 1;
    else
        fig = gcf;
        plotIndex = 1;
    end
    
    % Set ruler lines and markers visible off and move rulers to the new
    % visible axes
    ud = get(fig,'userdata');
    set(ud.ruler.lines,'visible', 'off','parent',newMainaxes)
    set(ud.ruler.markers,'visible','off','parent',newMainaxes)
    
    ruler('newlimits',fig,plotIndex);
    ruler('newsig',fig,plotIndex);
    ruler('showlines',fig,ud.focusline);
    ruler('resizebtns',fig)
    
% --------------------------------------------------------------------
% ruler('newlimits',fig,plotIndex,focusline)
%  case in which the x or y limits
%  have changed, but the ydata and line pick have not necessarily changed
%   plotIndex - index into ud.limits(plotIndex).xlim and 
%              ud.limits(plotIndex).ylim
%
case 'newlimits'
     if nargin > 3
         focuslineFlag = ~isempty(varargin{4});
     else
         focuslineFlag = 1;
     end
     
     if nargin > 2
         plotIndex = varargin{3};
         fig = varargin{2};
     elseif nargin == 2
         fig = varargin{2};
         plotIndex = 1;
     else
         fig = gcf;
         plotIndex = 1;
     end
     ud = get(fig,'userdata');
    
     mainaxes = ud.mainaxes;

     if strcmp(ud.ruler.type,'horizontal')
         set(ud.ruler.lines([1 2]),'xdata',ud.limits(plotIndex).xlim)
         set(ud.ruler.lines(1),'linewidth',get(ud.ruler.lines(2),'linewidth'))
         ylim = get(mainaxes,'ylim');
         if focuslineFlag  % if focusline is set (not empty)
             if (ud.ruler.value.y1 > ylim(2)) | (ud.ruler.value.y1 < ylim(1)) 
                 set(ud.ruler.hand.buttons(1),'visible','on')
             else
                 set(ud.ruler.hand.buttons(1),'visible','off')
             end
             if (ud.ruler.value.y2 > ylim(2)) | (ud.ruler.value.y2 < ylim(1)) 
                 set(ud.ruler.hand.buttons(2),'visible','on')
             else
                 set(ud.ruler.hand.buttons(2),'visible','off')
             end
         end
      else
          set(ud.ruler.lines([1 2]),'ydata',ud.limits(plotIndex).ylim)
          xlim = get(mainaxes,'xlim');
          if focuslineFlag  % if focusline is set (not empty)
              if (ud.ruler.value.x1 > xlim(2)) | (ud.ruler.value.x1 < xlim(1)) 
                  set(ud.ruler.hand.buttons(1),'visible','on')
              else
                  set(ud.ruler.hand.buttons(1),'visible','off')
              end
              if (ud.ruler.value.x2 > xlim(2)) | (ud.ruler.value.x2 < xlim(1)) 
                  set(ud.ruler.hand.buttons(2),'visible','on')
              else
                  set(ud.ruler.hand.buttons(2),'visible','off')
              end
          end
      end
      if strcmp(ud.ruler.type,'slope')
          x1 = ud.ruler.value.x1;
          x2 = ud.ruler.value.x2;
          y1 = ud.ruler.value.y1;
          y2 = ud.ruler.value.y2;
          dx = ud.ruler.value.dx;
          dy = ud.ruler.value.dy;
          [xd,yd,dydx] = setslopeline(mainaxes,ud.limits,...
              x1,x2,y1,y2,dx,dy,plotIndex);
          if focuslineFlag  % if focusline is set (not empty)
              set(ud.ruler.lines(3),'xdata',xd,'ydata',yd,'visible','on')
          end
      end
      
% --------------------------------------------------------------------
% ruler('newsig',fig,plotIndex)
%  case in which a new line has been picked (i.e., ud.focusline
%  has changed, but type hasn't changed and  xlimits / ylimits have not
%  necessarily changed but may have)
%     plotIndex - index into ud.limits(plotIndex).xlim and 
%                 ud.limits(plotIndex).ylim
%
case 'newsig'
      if nargin >= 3
          fig = varargin{2};
          plotIndex = varargin{3};
      elseif nargin == 2
          fig = varargin{2};
          plotIndex = 1;
      else
          fig = gcf;
          plotIndex = 1;
      end
      ud = get(fig,'userdata');

      state = btnstate(fig,'peaksgroup');
      if ~isempty(ud.focusline)
          xd = get(ud.focusline,'xdata');
          yd = get(ud.focusline,'ydata');
      else
          xd = [];
          yd = [];
      end
      if isempty(xd)  % nothing to look at
          ud.ruler.value.x1 = NaN;
          ud.ruler.value.y1 = NaN;
          ud.ruler.value.x2 = NaN;
          ud.ruler.value.y2 = NaN;
          ud.ruler.value.dx = NaN;
          ud.ruler.value.dy = NaN;
          ud.ruler.value.dydx = NaN;
          set(ud.ruler.hand.boxes,'string','-','userdata',NaN)
          set(ud.ruler.hand.y1text,'string','-')
          set(ud.ruler.hand.y2text,'string','-')
          set(ud.ruler.hand.dxtext,'string','-')
          set(ud.ruler.hand.dytext,'string','-')
          set(ud.ruler.hand.dydxtext,'string','-')
          set(ud.ruler.hand.buttons,'visible','off')
          set(ud.ruler.lines,'visible','off')
          set(ud.ruler.markers,'visible','off')
          set(fig,'userdata',ud)
          return
      elseif isnan(ud.ruler.value.x1) & isnan(ud.ruler.value.y1)
          % coming from an 'unfocused' state 
          if strcmp(ud.ruler.type,'horizontal')
              ylim = get(ud.mainaxes,'ylim');
              val1 = 2/3*ylim(1) + 1/3*ylim(2);
              val2 = 1/3*ylim(1) + 2/3*ylim(2);
              set(ud.ruler.lines(1:2),'visible','on')
          else
              xlim = get(ud.mainaxes,'xlim');
              val1 = 2/3*xlim(1) + 1/3*xlim(2);
              val2 = 1/3*xlim(1) + 2/3*xlim(2);
            
              if strcmp(ud.ruler.type,'track')
                  set(ud.ruler.lines(1:2),'visible','on')
                  set(ud.ruler.markers,'visible','on')
              elseif strcmp(ud.ruler.type,'slope')
                  set(ud.ruler.lines(1:3),'visible','on')
                  set(ud.ruler.markers,'visible','on')
              else
                  set(ud.ruler.lines(1:2),'visible','on')
              end
          end

          ud = setrul(fig,ud,val1,1,0,0,plotIndex);
          ud = setrul(fig,ud,val2,2,0,0,plotIndex);

          if state(1)
              ind = findpeaks(yd);
              if isempty(ind)
                  btnup(fig,'peaksgroup',1)
                  ruler('peaks')
              else
                  set(ud.ruler.lines(4),'visible','on','xdata',xd(ind),...
                                                      'ydata',yd(ind))
              end
          end
          if state(2)
              ind = findpeaks(-yd);
              if isempty(ind)
                  btnup(fig,'peaksgroup',2)
                  ruler('valleys')
              else
                  set(ud.ruler.lines(5),'visible','on','xdata',xd(ind),...
                                                      'ydata',yd(ind))
              end
          end
          set(fig,'userdata',ud)
          return
      end
      
      if state(1)
          ind = findpeaks(yd);
          if isempty(ind)
              btnup(fig,'peaksgroup',1)
              ruler('peaks')
          else 
              set(ud.ruler.lines(4),'visible','on','xdata',xd(ind),...
                                                  'ydata',yd(ind))
          end
      end
      if state(2)
          ind = findpeaks(-yd);
          if isempty(ind)
              btnup(fig,'peaksgroup',2)
              ruler('valleys')
          else 
              set(ud.ruler.lines(5),'visible','on','xdata',xd(ind),...
                                                  'ydata',yd(ind))
          end
      end
      
      mainaxes = ud.mainaxes;
      xlim = get(mainaxes,'xlim');
      ylim = get(mainaxes,'ylim');

      % don't need to change anything if type is not 'track' or 'slope'
      switch ud.ruler.type
      case 'vertical'
          if (ud.ruler.value.x1 > xlim(2)) | (ud.ruler.value.x1 < xlim(1)) 
             set(ud.ruler.hand.buttons(1),'visible','on')
          else
              set(ud.ruler.hand.buttons(1),'visible','off')
          end
          if (ud.ruler.value.x2 > xlim(2)) | (ud.ruler.value.x2 < xlim(1)) 
             set(ud.ruler.hand.buttons(2),'visible','on')
          else
              set(ud.ruler.hand.buttons(2),'visible','off')
          end
          return
      case 'horizontal'
          if (ud.ruler.value.y1 > ylim(2)) | (ud.ruler.value.y1 < ylim(1)) 
             set(ud.ruler.hand.buttons(1),'visible','on')
          else
              set(ud.ruler.hand.buttons(1),'visible','off')
          end
          if (ud.ruler.value.y2 > ylim(2)) | (ud.ruler.value.y2 < ylim(1)) 
             set(ud.ruler.hand.buttons(2),'visible','on')
          else
              set(ud.ruler.hand.buttons(2),'visible','off')
          end
          return
      end

      [dum,ind1] = min(abs(ud.ruler.value.x1-xd));
      [dum,ind2] = min(abs(ud.ruler.value.x2-xd));
      
      set(ud.ruler.lines(1),'xdata',[xd(ind1) xd(ind1)]);
      ud.ruler.value.x1 = xd(ind1);
      set(ud.ruler.hand.boxes(1),'string',num2str(ud.ruler.value.x1),...
           'userdata',ud.ruler.value.x1);
      if (xd(ind1) > xlim(2)) | (xd(ind1) < xlim(1)) 
          set(ud.ruler.hand.buttons(1),'visible','on')
      else
          set(ud.ruler.hand.buttons(1),'visible','off')
      end
      setrulxdata(ud.ruler.lines(2),[xd(ind2) xd(ind2)])
      ud.ruler.value.x2 = xd(ind2);
      set(ud.ruler.hand.boxes(2),'string',num2str(ud.ruler.value.x2),...
           'userdata',ud.ruler.value.x2);
      if (xd(ind2) > xlim(2)) | (xd(ind2) < xlim(1)) 
          set(ud.ruler.hand.buttons(2),'visible','on')
      else
          set(ud.ruler.hand.buttons(2),'visible','off')
      end
      
      ud.ruler.value.y1 = yd(ind1);
      ud.ruler.value.y2 = yd(ind2);
      ud.ruler.value.dy = ud.ruler.value.y2 - ud.ruler.value.y1;
      if ud.ruler.value.dx ~= 0
          ud.ruler.value.dydx = ud.ruler.value.dy / ud.ruler.value.dx;
      else
          ud.ruler.value.dydx = NaN;
      end

      set(ud.ruler.hand.y1text,'string',num2str(ud.ruler.value.y1));
      set(ud.ruler.hand.y2text,'string',num2str(ud.ruler.value.y2));
      set(ud.ruler.hand.dytext,'string',num2str(ud.ruler.value.dy));
      set(ud.ruler.hand.dydxtext,'string',num2str(ud.ruler.value.dydx));

      set(ud.ruler.markers(1),'xdata',ud.ruler.value.x1)
      set(ud.ruler.markers(1),'ydata',ud.ruler.value.y1)
      set(ud.ruler.markers(2),'xdata',ud.ruler.value.x2)
      set(ud.ruler.markers(2),'ydata',ud.ruler.value.y2)

      if strcmp(ud.ruler.type,'slope')
          x1 = ud.ruler.value.x1;
          x2 = ud.ruler.value.x2;
          y1 = ud.ruler.value.y1;
          y2 = ud.ruler.value.y2;
          dx = ud.ruler.value.dx;
          dy = ud.ruler.value.dy;

          if ~isnan(ud.ruler.value.dydx) % <-- implies dx ~= 0
              [xd,yd,dydx] = setslopeline(ud.mainaxes,ud.limits,...
                  x1,x2,y1,y2,dx,dy,plotIndex);
              set(ud.ruler.lines(3),'xdata',xd,'ydata',yd,'visible','on')
          else
              set(ud.ruler.lines(3),'visible','off')
          end
      end

      set(fig,'userdata',ud)

%------------------------------------------------------------------------
% ruler('save')
%  put up dialog box asking for variable name, then save
%  ruler value struct as that name in base workspace.
%
case 'save'
      fig = gcf;
	   ud = get(fig,'userdata');
      prompt={sprintf(['Enter the variable name for the ruler\n' ...
                       'structure to save in the workspace.'])};
      def = {ud.ruler.varname};
      title = 'Save Measurements';
      lineNo = 1;
      varname = inputdlg(prompt,title,lineNo,def);
		if isempty(varname)
		    return
		end
		varstr = varname{:};
		if ~isvalidvar(varstr)
		    errstr = 'Sorry, that''s not a valid variable name.';
		    msgbox(errstr,'Error','error','modal')
		    return 
		end
		ud.ruler.varname = varstr;
		set(fig,'userdata',ud)
		
		val = ud.ruler.value;
		if strcmp(get(ud.ruler.lines(4),'visible'),'on')
		    val.peaks.x = get(ud.ruler.lines(4),'xdata');
		    val.peaks.y = get(ud.ruler.lines(4),'ydata');
		else
		    val.peaks.x = [];
		    val.peaks.y = [];
		end
		if strcmp(get(ud.ruler.lines(5),'visible'),'on')
		    val.valleys.x = get(ud.ruler.lines(5),'xdata');
		    val.valleys.y = get(ud.ruler.lines(5),'ydata');
		else
		    val.valleys.x = [];
		    val.valleys.y = [];
		end
		
		assignin('base',varstr,val)
		
% --------------------------------------------------------------------
% ruler('showlines',fig,focusline)
%  set the visible property of the correct lines
% Inputs:
%   fig - figure handle of the client
%   focusline - handle of the line currently focused by the rulers
%
case 'showlines'
      fig = varargin{2};
      if nargin > 2
          focuslineFlag = ~isempty(varargin{3});
      else 
          focuslineFlag = 1;
      end
      
      if focuslineFlag
          ud = get(fig,'userdata');
          set(ud.ruler.lines(1:2),'visible','on')
          if strcmp(ud.ruler.type,'track')
              set(ud.ruler.markers,'visible','on')
          elseif strcmp(ud.ruler.type,'slope')
              set(ud.ruler.markers,'visible','on')
              set(ud.ruler.lines(3),'visible','on')
          end
          state = btnstate(fig,'peaksgroup');
          if state(1)
              set(ud.ruler.lines(4),'visible','on')
          end    
          if state(2)
              set(ud.ruler.lines(5),'visible','on')
          end
      end

% --------------------------------------------------------------------
% ruler('hidelines',fig,allRulerObjects)
%  set the visible property to off of the correct lines.  In the case where
%  there's a third input argument which is the string 'all' then all ruler
%  lines and markers are set to invisible.
%
% Inputs:
%   fig - figure handle of the client which called ruler
%   allRulerObjects - is the string 'all' when you want to set all ruler
%                     lines and markers to invisible
%
case 'hidelines'  
    fig = varargin{2};
    ud = get(fig,'userdata');

    if (nargin > 2) & strcmp(varargin{3}, 'all')
        h = [ud.ruler.lines(:); ud.ruler.markers(:)];
        set(h,'visible','off')
    else
        if ~strcmp(ud.ruler.type,'track') & ~strcmp(ud.ruler.type,'slope')
            set(ud.ruler.markers,'visible','off')
        end
        if ~strcmp(ud.ruler.type,'slope')
            set(ud.ruler.lines(3),'visible','off')
        end
        state = btnstate(fig,'peaksgroup');
        if ~state(1)
            set(ud.ruler.lines(4),'visible','off')
        end    
        if ~state(2)
            set(ud.ruler.lines(5),'visible','off')
        end    
    end
    
%--------------------------------------------------------------------
% [RulerLinehandles] = ruler('getRulerlines',fig)
% Get the handles to the ruler lines
%
case 'getrulerlines'  
    fig = varargin{2};

    ud = get(fig,'userdata');
    varargout{1} = [ud.ruler.lines, ud.ruler.markers];
    
% --------------------------------------------------------------------
% ruler('peaks')
%   Turn peaks on or off
%
case 'peaks'
      fig = gcf;
      ud = get(fig,'userdata');
      
      if ud.pointer == 2  % help mode
          % restore state:
          if btnstate(fig,'peaksgroup',1)
              btnup(fig,'peaksgroup',1)
          else
              btndown(fig,'peaksgroup',1)
          end
          spthelp('exit','ruler','peaks')
          return
      end

      if btnstate(fig,'peaksgroup',1)
          if strcmp(ud.ruler.Track_and_Slope_Allowed,'off')
              btnup(fig,'peaksgroup',1)
              return
          end
         % button pushed in
         if isempty(ud.focusline)
             return
         end
         xd = get(ud.focusline,'xdata');
         yd = get(ud.focusline,'ydata');
         if isempty(xd)
             return
         end

         ind = findpeaks(yd);
         if isempty(ind)   
             % line is a vector of constants (no peaks); unselect peaks btn
             btnup(fig,'peaksgroup',1)
             return
         end

         set(ud.ruler.lines(4),'xdata',xd(ind),'ydata',yd(ind))
         set(ud.ruler.lines(4),'visible','on')
         
         if strcmp(ud.ruler.type,'track') | strcmp(ud.ruler.type,'slope')
         % snap rulers to peaks:
             ud = setrul(fig,ud,ud.ruler.value.x1,1);
             ud = setrul(fig,ud,ud.ruler.value.x2,2);
             set(fig,'userdata',ud)
         end
      else
         % button out
         if isempty(ud.focusline)
             return
         end
         xd = get(ud.focusline,'xdata');
         if isempty(xd)
             return
         end
         set(ud.ruler.lines(4),'visible','off')
         
         if btnstate(fig,'peaksgroup',2) 
             if  strcmp(ud.ruler.type,'track') | strcmp(ud.ruler.type,'slope')
             % snap rulers to valleys:
                ud = setrul(fig,ud,ud.ruler.value.x1,1);
                ud = setrul(fig,ud,ud.ruler.value.x2,2);
                set(fig,'userdata',ud)
             end
         end

      end
      

% --------------------------------------------------------------------
% ruler('valleys')
%  Turn valleys on or off
%
case 'valleys'  
      fig = gcf;
      ud = get(fig,'userdata');

      if ud.pointer == 2  % help mode
          % restore state:
          if btnstate(fig,'peaksgroup',2)
              btnup(fig,'peaksgroup',2)
          else
              btndown(fig,'peaksgroup',2)
          end
          spthelp('exit','ruler','valleys')
          return
      end

      if btnstate(fig,'peaksgroup',2)
         % button pushed in
         if strcmp(ud.ruler.Track_and_Slope_Allowed,'off')
             btnup(fig,'peaksgroup',2)
             return
         end
         if isempty(ud.focusline)
             return
         end
         xd = get(ud.focusline,'xdata');
         yd = get(ud.focusline,'ydata');
         if isempty(xd)
             return
         end
         
         ind = findpeaks(-yd);
         if isempty(ind)
             % line is a vector of constants (no valleys); unselect valleys
             btnup(fig,'peaksgroup',2)
             return
         end

         set(ud.ruler.lines(5),'xdata',xd(ind),'ydata',yd(ind))
         set(ud.ruler.lines(5),'visible','on')
         if strcmp(ud.ruler.type,'track') | strcmp(ud.ruler.type,'slope')
         % snap rulers to valleys:
             ud = setrul(fig,ud,ud.ruler.value.x1,1);
             ud = setrul(fig,ud,ud.ruler.value.x2,2);
             set(fig,'userdata',ud)
         end

     else
         % button out
         if isempty(ud.focusline)
             return
         end
         xd = get(ud.focusline,'xdata');
         if isempty(xd)
             return
         end
         set(ud.ruler.lines(5),'visible','off')
        
         if btnstate(fig,'peaksgroup',1) 
             if  strcmp(ud.ruler.type,'track') | strcmp(ud.ruler.type,'slope')
                % snap rulers to peaks:
                ud = setrul(fig,ud,ud.ruler.value.x1,1);
                ud = setrul(fig,ud,ud.ruler.value.x2,2);
                set(fig,'userdata',ud)
             end
         end

      end
      
% --------------------------------------------------------------------
% ruler('updatePeaksgroup',fig)
%
case 'updatepeaksgroup'

    fig = varargin{2};
    ud = get(fig,'userdata');
    set(ud.ruler.lines(4),'visible','off')
    set(ud.ruler.lines(5),'visible','off')
    
    if btnstate(fig,'peaksgroup',1)
        ruler('peaks')
    end
    if btnstate(fig,'peaksgroup',2)
        ruler('valleys')  
    end
      
% --------------------------------------------------------------------
% ruler('rulerbutton', ruler_num)
%  button has been pressed to bring ruler to center of display
%  2nd input is 1 or 2 for which ruler.
%
case 'rulerbutton'
      fig = gcf;
      ud = get(fig,'userdata');
      
      ruler_num = varargin{2};

      if strcmp(ud.ruler.type,'horizontal')
          ylim = get(ud.mainaxes,'ylim');
          if strcmp(get(ud.mainaxes,'yscale'),'linear')
              val = mean(ylim);
          else
              val = sqrt(prod(ylim));
          end
      else
          xlim = get(ud.mainaxes,'xlim');
          if strcmp(get(ud.mainaxes,'xscale'),'linear')
              val = mean(xlim);
          else
              val = sqrt(prod(xlim));
          end
      end

      ud = setrul(fig,ud,val,ruler_num);
      set(fig,'userdata',ud)


% --------------------------------------------------------------------
% ruler('rulerbox',ruler_num)
%  Callbacks for the ruler edit boxes
%  2nd input is 1 or 2 for which ruler.
%
case 'rulerbox'
      fig = gcf;
      ud = get(fig,'userdata');
      
      ruler_num = varargin{2};

      % parse and evaluate string input
      the_box = ud.ruler.hand.boxes(ruler_num);

      if isempty(ud.focusline)
          set(the_box,'string','-')
          return
      end

      str = get(the_box,'string');

      [val,err] = validarg(str,[-Inf Inf],[1 1],'ruler value');
      if err
         val = get(the_box,'userdata');
         set(the_box,'string',num2str(val));
         return 
      else
         set(the_box,'userdata',val);
      end

      % make sure input is in the valid range 
      if strcmp(ud.ruler.type,'horizontal')
          ylim = get(ud.mainaxes,'ylim');
          val = inbounds(val,ylim);
      else
          xlim = get(ud.mainaxes,'xlim');
          val = inbounds(val,xlim);
      end

      % now set the ruler values
      ud = setrul(fig,ud,val,ruler_num,0,1);

      set(fig,'userdata',ud)

% --------------------------------------------------------------------
% ruler('inbounds',fig,XorYlim,plotIndex)
% Adjust ruler positions according to new axes limits as the axes
% scaling, range, or units are changed.  Enforces that ruler values stay
% within the new axes limits.
%
% Inputs:
%   fig - figure handle of the client
%   XorYlim - a string indicating which limits to adjust, X or Y limits
%             (the choices are: 'xlim' or 'ylim')
%   plotIndex - index into the list of 6 possible subplots
% Outputs:
%   None
%
case 'inbounds'
    fig = varargin{2};
    ud = get(fig,'userdata');
    plotIndex = varargin{4};
    XorYlim = varargin{3};
    
    switch XorYlim
    case 'xlim'
        XorYscale = 'xscale';
        lim = ud.limits(plotIndex).xlim;
        rulerval1 = ud.ruler.value.x1;
        rulerval2 = ud.ruler.value.x2;
    case 'ylim'
        XorYscale = 'yscale';        
        lim = ud.limits(plotIndex).ylim;
        rulerval1 = ud.ruler.value.y1;
        rulerval2 = ud.ruler.value.y2;
    end
    
    if (strcmp(XorYlim,'ylim') & strcmp(ud.ruler.type,'horizontal')) | ...
            (strcmp(XorYlim,'xlim') & ~strcmp(ud.ruler.type,'horizontal'))
        lim1 = lim(1);
        lim2 = lim(2);
        if strcmp(get(ud.mainaxes,XorYscale),'linear')
            val = mean(lim);
        else
            val = sqrt(prod(lim));
        end
        if (rulerval1 <= lim1) | (rulerval1 > lim2)
            ud = setrul(fig,ud,val,1,0,0,plotIndex);
        end
        if (rulerval2 <= lim1) | (rulerval2 > lim2)
            ud = setrul(fig,ud,val,2,0,0,plotIndex);
        end
        set(fig,'userdata',ud)
    end
end

function pos_ruler_labels(fig,sz,type,h,xtra_ui)
% pos_ruler_labels   Position the ruler labels and edit boxes.
%   Inputs:
%      fig - figure containing the ruler
%      sz - sizes structure
%      type - string signifying the ruler mode
%      h - handles structure
%   Outputs:
%      None

    fp = get(fig,'position');   % in pixels already

    toolbar_ht = sz.ih;
    frame_top = fp(4)-(toolbar_ht+sz.ffs+sz.lh/2);
    top = frame_top-(sz.lh+xtra_ui*(sz.uh+sz.fus)+sz.fus+2*sz.rih);

    switch type

    case 'vertical'
        vpos = {
        h.x1label    top
        h.x2label    top - 1*(sz.uh+sz.fus)
        h.dxlabel    top - 2*(sz.uh+sz.fus)
        };
        bi = [1 2];  % box indices
        texthandles = h.dxtext;
        ti = 3;      % text indices
    case 'horizontal'
        vpos = {
        h.y1label    top
        h.y2label    top - 1*(sz.uh+sz.fus)
        h.dylabel    top - 2*(sz.uh+sz.fus)
        };
        bi = [1 2];  % indices of boxes
        texthandles = h.dytext;
        ti = 3;      % text indices
    case 'track'
        vpos = {
        h.x1label    top
        h.y1label    top - 1*(sz.uh+sz.fus)
        h.x2label    top - 2*(sz.uh+sz.fus)
        h.y2label    top - 3*(sz.uh+sz.fus)
        h.dxlabel    top - 4*(sz.uh+sz.fus)
        h.dylabel    top - 5*(sz.uh+sz.fus)
        };
        bi = [1 3];  % indices of boxes
        texthandles = [h.y1text h.y2text h.dxtext h.dytext]';
        ti = [2 4 5 6];      % text indices
    case 'slope'
        vpos = {
        h.x1label    top
        h.y1label    top - 1*(sz.uh+sz.fus)
        h.x2label    top - 2*(sz.uh+sz.fus)
        h.y2label    top - 3*(sz.uh+sz.fus)
        h.dxlabel    top - 4*(sz.uh+sz.fus)
        h.dylabel    top - 5*(sz.uh+sz.fus)
        h.dydxlabel  top - 6*(sz.uh+sz.fus)
        };
        bi = [1 3];  % indices of boxes
        texthandles = [h.y1text h.y2text h.dxtext h.dytext h.dydxtext]';
        ti = [2 4 5 6 7];      % text indices
    end

    [boxpos,labelpos] = panelpos([vpos{:,1}],sz.ffs+sz.fus,...
       sz.rw-(sz.ffs+sz.fus), sz.uh, sz.lbs, cat(1,vpos{:,2}));

    for i=1:length(boxpos)  % add x-offset to uicontrols
        boxpos{i}=boxpos{i}+[fp(3)-sz.rw -2 0 4];
    end
    for i=1:length(labelpos)  % add x-offset to uicontrols
        labelpos{i}=labelpos{i}+[fp(3)-sz.rw 0 0 0];
    end
    box_tags = {'rulerbox1' 'rulerbox2'}';
    set(h.boxes(1:2),{'position'},boxpos(bi))
    set(texthandles,{'position'},boxpos(ti))
    set([vpos{:,1}],{'position'},labelpos)


function showhide_ruler_labels(fig,type,h)
%showhide_ruler_labels    Set visible property of ruler's labels and text
%   Inputs:
%      fig - figure which contains the ruler
%      type - string which contains either 'vertical' 'horizontal'
%            'track' or 'slope'
%          h - handle structure
%   Outputs:
%      None

    switch type
    case 'vertical'
        vis =   [h.x1label h.x2label h.dxlabel ...
                 h.dxtext ]';
        invis = [h.y1label h.y2label h.dylabel h.dydxlabel ...
                 h.y1text h.y2text h.dytext h.dydxtext]';
    case 'horizontal'
        vis =   [h.y1label h.y2label h.dylabel ...
                 h.dytext ]';
        invis = [h.x1label h.x2label h.dxlabel h.dydxlabel ...
                 h.y1text h.y2text h.dxtext h.dydxtext]';
    case 'track'
        vis =   [h.x1label h.y1label h.x2label h.y2label h.dxlabel h.dylabel ...
                 h.y1text h.y2text h.dxtext h.dytext]';
        invis = [h.dydxlabel h.dydxtext]';
    case 'slope'
        vis =   [h.x1label h.y1label h.x2label h.y2label h.dxlabel h.dylabel ...
                 h.dydxlabel h.y1text h.y2text h.dxtext h.dytext h.dydxtext]';
        invis = [];
    end
    set(vis,'visible','on')
    set(invis,'visible','off')


function id = ruler_btnid(type)
%ruler_btnid - Button number for ruler button group type string
%    type        id
% ------------  -----
% 'vertical'      1
% 'horizontal'    2
% 'track'         3
% 'slope'         4
%  otherwise     -1

switch type
case 'vertical'
    id = 1;
case 'horizontal'
    id = 2;
case 'track'
    id = 3;
case 'slope'
    id = 4;
otherwise
    id = -1;
end

function [ind,peaks] = findpeaks(y)
% FINDPEAKS  Find peaks in real vector.
%  ind = findpeaks(y) finds the indices (ind) which are
%  local maxima in the sequence y.  
%
%  [ind,peaks] = findpeaks(y) returns the value of the peaks at 
%  these locations, i.e. peaks=y(ind);

y = y(:)';

switch length(y)
case 0
    ind = [];
case 1
    ind = 1;
otherwise
    dy = diff(y);
    not_plateau_ind = find(dy~=0);
    ind = find( ([dy(not_plateau_ind) 0]<0) & ([0 dy(not_plateau_ind)]>0) );
    ind = not_plateau_ind(ind);
    if y(1)>y(2)
        ind = [1 ind];
    end
    if y(end-1)<y(end)
        ind = [ind length(y)];
    end
end

if nargout > 1
    peaks = y(ind);
end

function [boxpos,labelpos] = panelpos(labelhandles,left,right,uh,lbs,vpos)
%PANELPOS  Finds positions of labels and edit boxes.
%   [boxpos,labelpos]=panelpos(labelhandles,left,right,uh,lbs,vpos)
%   Purpose: This function maximizes the horizontal spacing of the edit
%      boxes in a list, taking the text extent of the labels into account.
%      Assumes labels are right justified.
%
%       left                    right
%         |                       |
%         |        lbs            I
%         v       |<-->|          v
% vpos(1)->   [label 1]    [edit box 1]     | uh
% vpos(2)->   [label 2]    [edit box 2]
% vpos(3)->   [label 3]    [edit box 3]
% vpos(4)->   [label 4]    [edit box 4]
%
%       inputs:
%     labelhandles - length N vector of axes text objects or 
%                        text uicontrols (all the same type).
%     left - left most pixel position (scalar).
%     right - right most pixel position (scalar).
%     uh - height of editable uicontrols, in pixels (scalar).
%     lbs - label-to-box spacing, in pixels (scalar).
%     vpos - length N vector of vertical pixel positions (centers).
%   outputs:
%     boxpos - length N cell array of positions for edit boxes.
%     labelpos - length N cell array of positions for text boxes.
%
%   T. Krauss, 12/1/95
 
    N = length(labelhandles);
    boxpos = zeros(N,4);
    labelpos = zeros(N,2);

    ex = get(labelhandles(:),'extent');
    ex = cat(1,ex{:});
    widths = ex(:,3);
    max_width = max(widths);

    edit_left = left+max_width+lbs;
    edit_width = right - edit_left;
  
    if strcmp(get(labelhandles(1),'type'),'uicontrol')
        labelpos(:,1) = left;
        labelpos(:,2) = vpos - uh/2;
        labelpos(:,3) = max_width;
        labelpos(:,4) = uh;
    else
        labelpos(:,1) = left+max_width;
        labelpos(:,2) = vpos;
    end
    boxpos(:,1) = left+max_width+lbs;
    boxpos(:,2) = vpos-uh/2;
    boxpos(:,3) = edit_width;
    boxpos(:,4) = uh;
    
    labelpos = num2cell(labelpos,2);
    boxpos = num2cell(boxpos,2);

function setFontUnitsPixels(ax)
% Sets the fontunits of all axes text children of ax to 'pixels'
% and keeps their font sizes the same
    t = findobj(ax,'type','text');
    s = get(t,'fontsize');
    set(t,'fontunits','pixels')
    set(t,{'fontsize'},s)

