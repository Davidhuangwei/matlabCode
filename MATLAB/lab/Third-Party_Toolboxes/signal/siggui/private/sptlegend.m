function varargout = sptlegend(varargin)
%SPTLEGEND  SPTool Legend facility for picking one of multiple items.
%
% sptlegend(fig,callback,newColorCallback)
%    initializes sptlegend (call after zoombar)
%    adds .legend field to userdata of figure with handle fig.
% Inputs:
%    fig - figure in which to install legend
%    callback - string; when a change occurs to the legend pick, sptlegend
%      will eval this string
%    newColorCallback - string; this function will be called when the line
%      style and/or line color have changed; calling sequence:
%          feval(newColorCallback,'newColor',lineColor,lineStyle)
%      Before calling this, this function will set the style and color of
%      ud.focusline

%   Copyright (c) 1988-98 by The MathWorks, Inc.
% $Revision: 1.2 $

if nargin == 0
    action = 'init';
    fig = gcf;
    callback = '';
elseif ~isstr(varargin{1})
    action = 'init';
    fig = varargin{1};
    if nargin >= 2
        callback = varargin{2};
    else
        callback = '';
    end
else
    action = varargin{1};
end
% "Globals" - defined each time function is called
pw = 90;  % popup width
bw = 65;  % button width
maxPopupEntries = 24;

switch action
case 'init'    
    ud = get(fig,'userdata');
    uifgcolor = get(0,'defaultuicontrolforegroundcolor');
    
    % ====================================================================
    % Create line frames: (these lines act as frames)
    line_props = {
         'parent',ud.toolbar.toolbar,...
         'color','k',...
         'handlevisibility','callback'};
         
    leg.legendpatch = patch('parent',ud.toolbar.toolbar,...
         'handlevisibility','callback','edgecolor','none','tag','legendpatch');
    leg.legendframe = line(line_props{:},'tag','legendframe');

    % Because of PCWIN limitation where you can't set linewidths of broken
    % linestyle lines, we must draw 3 lines to get thick lines.  To be
    % consistent and to avoid platform specific code we draw 3 lines.

    % The userdata of legendline contains the variable and column of the
    % current trace
    leg.legendline(1)=line(line_props{:},'tag','legendline','userdata',[1 1]);
    leg.legendline(2)=line(line_props{:},'tag','legendline','userdata',[1 1]);
    leg.legendline(3)=line(line_props{:},'tag','legendline','userdata',[1 1]);
  
    % ====================================================================
    % Create Text Labels:
    label_props = {
         'parent',ud.toolbar.toolbar,...
         'color',uifgcolor,...
         'horizontalalignment','left',...
         'fontname',get(0,'defaultuicontrolfontname'),...
         'fontsize',get(0,'defaultuicontrolfontsize'),...
         'fontweight',get(0,'defaultuicontrolfontweight'),...
         'handlevisibility','callback'    };

    leg.legendlabel = text(0,0,'Selection',label_props{:},'tag','legendlabel');
    
    leg.legendpopup = uicontrol('style','popup',...
         'units','pixels',...
         'string',{' '  ' '},'value',1,...
         'callback','sbswitch(''sptlegend'',''popup'')',...
         'tag','legendpopup');

    leg.legendbutton = uicontrol('style','pushbutton',...
         'string','Color...',...
         'units','pixels',...
         'tag','legendbutton', ...
         'callback','sbswitch(''sptlegend'',''button'')');
     
    leg.callback = callback;
    if nargin > 2
        leg.newColorCallback = varargin{3};
    else
        leg.newColorCallback = '';
    end
   
    ud.legend = leg;
    set(fig,'userdata',ud)
    
    sptlegend('resize',fig)
    set(fig,'resizefcn',appstr(get(fig,'resizefcn'),...
       'sbswitch(''sptlegend'',''resize'')'))

%--------------------------------------------------------------------
% sptlegend('resize')
%   position the label, frame line and legend  line 
case 'resize'
    if nargin > 1  
        fig = varargin{2};
    else
        fig = gcbf;
    end
    ud = get(fig,'userdata');
    hand = ud.legend;
    sz = ud.sz;
    fp = get(fig,'position');   % in pixels already
    ap = get(ud.toolbar.toolbar,'position');
        
    ll_pos = [fp(3)-3*sz.fus-sz.lbs-pw-bw+2*sz.fus ...
               2*sz.lbs+sz.lh/2+sz.uh+2];
    set(hand.legendlabel,'position',ll_pos)

    ex = get(hand.legendlabel,'extent');

    % position of labelframe in [left bottom right top] format:
    lf_pos = [fp(3)-sz.lbs-3*sz.fus-pw-bw sz.lbs ...
              fp(3)-sz.fus 2*sz.lbs+sz.lh/2+sz.uh+2];

    % pickframe line data
    xdata = [lf_pos(1) lf_pos(3) lf_pos(3) lf_pos(3)-sz.lbs NaN ...
                lf_pos(1)+sz.lbs lf_pos(1) lf_pos(1)];
    ydata = [lf_pos(2) lf_pos(2) lf_pos(4) lf_pos(4) NaN ...
                lf_pos(4) lf_pos(4) lf_pos(2)];
    set(hand.legendframe,'xdata',xdata,'ydata',ydata)

    % legendline line data
    xdata = [fp(3)-pw-bw-sz.lbs-3*sz.lbs+2*sz.lfs+ex(3) ...
            lf_pos(3)-sz.lbs-sz.lfs];
    ydata1 = lf_pos([4 4]);  % legend line
    
    ydata2 = ydata1-[1 1];   % line below
    ydata3 = ydata1+[1 1];   % line above
    set(hand.legendline(1),'xdata',xdata+[sz.lbs -sz.lbs],'ydata',ydata1)
    set(hand.legendline(2),'xdata',xdata+[sz.lbs -sz.lbs],'ydata',ydata2)
    set(hand.legendline(3),'xdata',xdata+[sz.lbs -sz.lbs],'ydata',ydata3)
    
    set(hand.legendpatch,'xdata',[xdata xdata([2 1])],...
        'ydata',[ydata1 ydata1]+[-4 -4 +3 +3])
    
    % Tweak position & size of uicontrols: [horz_pos ver_pos width height]
    switch computer
    case 'MAC2'
        popTweak = [-2 -1 0  0];
        btnTweak = [-1  3 0 -4];
    case 'PCWIN'
        popTweak = [-2 4 0 0];
        btnTweak = [-1 0 0 4];
    otherwise  % UNIX
        popTweak = [-2 1 0 2];
        btnTweak = [-1 1 0 2];
    end
 
    % 1-by-4 position vectors
    pos = {
    hand.legendpopup  [lf_pos(1)+sz.fus lf_pos(2)+sz.lbs+ap(2)...
                       pw sz.uh] + popTweak
    hand.legendbutton [fp(3)-2*sz.fus-bw lf_pos(2)+sz.lbs+ap(2)...
                       bw sz.uh] + btnTweak
    };

    set([pos{:,1}],{'position'},pos(:,2))
    
%--------------------------------------------------------------------
% sptlegend('width',fig)
%  return the width, in pixels, of the legend.  You can call this before
%  or after the legend has been created.
case 'width'
    fig = varargin{2};
    ud = get(fig,'userdata');
    varargout{1} = ud.sz.lbs+pw+bw+3*ud.sz.fus;

%--------------------------------------------------------------------
% sptlegend('popup')
%  Callback of popupmenu. 
case 'popup'
    fig = gcf;
    ud = get(fig,'userdata');
    legendList = get(ud.legend.legendpopup,'userdata');
    popupStr = get(ud.legend.legendpopup,'string');
    val = get(ud.legend.legendpopup,'value');
    columns = get(ud.legend.legendbutton,'userdata');
    if ~isempty(legendList)
        if ( val == length(popupStr) )
            line_ud = get(ud.legend.legendline(1),'userdata');
            i = line_ud(1);
            j = line_ud(2);
            ind = 0;
            for ii=1:i-1
                ind = ind+length(columns{ii});
            end
            ind = ind + find(columns{i}==j);
            %  User selected "More..." so put up listdlg
            [val,ok] = listdlg('Name','Select a trace:',...
               'SelectionMode','Single',...
               'ListString',legendList,...
               'OKString','OK',...
               'InitialValue',ind);
            if ~ok
                % restore old value
                sptlegend('setvalue',ud.legend.legendline(1),i,j,fig)
                return
            end
        else
            val = val + get(ud.legend.legendpopup,'min') - 1;
        end
    else
        legendList = popupStr;
    end
    
    newLegendString(ud.legend.legendpopup,legendList,val,...
                        maxPopupEntries);
    searchVal = 0;
    i=0;
    j=0;
    while searchVal < val
        i=i+1;
        searchVal = searchVal + length(columns{i});
    end
    j = length(columns{i}) - searchVal + val;
    if isequal(get(ud.legend.legendline(1),'userdata'),[i j])
        return
    end

    set(ud.legend.legendline,'userdata',[i j])

    evalin('base',ud.legend.callback)
    
%--------------------------------------------------------------------
% [i,j] = sptlegend('value',fig)
%   return which matrix and column is currently selected
%   fig is optional - defaults to gcf
case 'value'
    if nargin > 1
        fig = varargin{2};
    else
        fig = gcf;
    end
    ud = get(fig,'userdata');
    line_ud = get(ud.legend.legendline(1),'userdata');
    i = line_ud(1);
    j = line_ud(2);

    varargout{1} = i;
    if nargout > 1
        varargout{2} = j;
    end
    
%--------------------------------------------------------------------
% sptlegend('setvalue',lineHandle,i,j,fig)
%   set which matrix and column is currently selected
%   also set color and linestyle of legendline to that of lineHandle
%   j is optional and defaults to 1
%   fig is optional and defaults to gcf
case 'setvalue'
    lineHandle = varargin{2};
    i = varargin{3};
    if nargin < 4
        j = 1;
    else
        j = varargin{4};
    end
    if nargin < 5
        fig = gcf;
    else
        fig = varargin{5};
    end
    
    ud = get(fig,'userdata');
    
    columns = get(ud.legend.legendbutton,'userdata');
    
    if ~isempty(lineHandle)
        legendList = get(ud.legend.legendpopup,'userdata');
        if isempty(legendList)
            legendList = get(ud.legend.legendpopup,'string');
        end
        ind = 0;
        for ii=1:i-1
            ind = ind+length(columns{ii});
        end
        ind = ind + find(columns{i}==j);
        newLegendString(ud.legend.legendpopup,legendList,ind,...
                            maxPopupEntries);
        
        set(ud.legend.legendline,'userdata',[i j]);
        if ~isequal(ud.legend.legendline(1),lineHandle)
            set(ud.legend.legendline,'color',get(lineHandle,'color'),...
               'linestyle',get(lineHandle,'linestyle'));
            set(ud.legend.legendpatch,'facecolor',...
            get(get(lineHandle,'parent'),'color'));
        end
    else
        set(ud.legend.legendline,'visible','off')
        set(ud.legend.legendpatch,'visible','off')
    end

%--------------------------------------------------------------------
% sptlegend('setstring',labels,columns,fig,retainValueFlag)
%   set the popup choices of the legendPopup
%   labels - cell array of labels
%   columns - cell array of index vectors - optional, defaults to
%       1 for each entry of labels.  If this is an empty cell array,
%       then assume 1 for each label.
%   fig is optional and defaults to gcf
%   retainValueFlag - optional - defaults to 0, determines if the
%      popupmenu's value should be changed
%       == 1 ==> don't change value
%       == 0 ==> set value to 1
case 'setstring'
   labels = varargin{2};
   N = length(labels);
   if (nargin >= 3)
       columns = varargin{3};
       if length(columns)==0
           columns = cell(N,1);
           for i=1:N
               columns{i} = 1;
           end
       end
   else
       columns = cell(N,1);
       for i=1:N
           columns{i} = 1;
       end
   end
   if nargin < 4
       fig = gcf;
   else
       fig = varargin{4};
   end
   if nargin < 5
       retainValueFlag = 0;
   else
       retainValueFlag = varargin{5};
   end
   legendStr = {};    
   for i=1:length(labels)
        N = length(columns{i});
        for j=1:N
            if N>1
                str = [labels{i} '(:,' num2str(columns{i}(j)) ')'];    
            else
                str = labels{i};
            end
            legendStr = {legendStr{:} str};
        end
   end

   ud = get(fig,'userdata');
   if retainValueFlag
       [i,j] = sptlegend('value',fig);
   end
   if length(legendStr) == 0
       set(ud.legend.legendpopup,'value',1,'string',{'<none>'},...
           'enable','off','userdata',[])
       set(ud.legend.legendbutton,'userdata',columns)
       set(ud.legend.legendbutton,'enable','off')
       set(ud.legend.legendline,'visible','off')
       set(ud.legend.legendpatch,'visible','off')
   else
       newLegendString(ud.legend.legendpopup,legendStr,1,maxPopupEntries);
       set(ud.legend.legendpopup,'enable','on')
       set(ud.legend.legendbutton,'userdata',columns) 
       set(ud.legend.legendbutton,'enable','on')
       set(ud.legend.legendline,'visible','on')
       set(ud.legend.legendpatch,'visible','on')
   end
   if retainValueFlag
       sptlegend('setvalue',ud.legend.legendline(1),i,j,fig)
   end
   
%--------------------------------------------------------------------
% sptlegend('button')
%   Edit line colors
%   Assumptions: current figure has ud struct containing
%    valid .focusline (line handle) and .colororder (cell array of
%    colorspecs) and .mainaxes
case 'button'
    fig = gcf;
    ud = get(fig,'userdata');
    val = get(ud.legend.legendpopup,'value');
    str = get(ud.legend.legendpopup,'string');
    label = str{val};
    
    [lineColor,lineStyle,ok] = speditline(ud.legend.legendline(1),label, ...
        ud.colororder,'white'); 
    if ok
        set(ud.legend.legendline,'color',lineColor,'linestyle',lineStyle)
        if ~isempty(ud.focusline)
            if ~strcmp(get(ud.focusline,'linestyle'),'none')
                % Don't change line style markers.
                set(ud.focusline,'linestyle',lineStyle)
            end
            set(ud.focusline,'color',lineColor)
            set(ud.legend.legendpatch,'facecolor',...
                get(get(ud.focusline,'parent'),'color'));
        end
        % also update .lineinfo struct in given structure
        if ~isempty(ud.legend.newColorCallback)
            feval(ud.legend.newColorCallback,'newColor',lineColor,lineStyle)
        end
    end
    
end

function newLegendString(legendPopup,labelList,ind,M)
%newLegendString
%  Sets popup string to the given labelList
%  Inputs:
%     legendPopup - handle to popupmenu
%     labelList - cell array of strings
%     ind - desired value of popup, index into labelList
%     M - maximum number of entries in a popupmenu
%  On output:
%   if N<=maxPopupEntries:
%     legendPopup string:  {label1 label2 ... labelN} 
%     legendPopup value:  ind
%     legendPopup userdata: []
%   else
%     legendPopup string:  {labelList{i1:i2} 'More...'} 
%     legendPopup value:  some value between 1 and M-1
%     legendPopup userdata: labelList

N = length(labelList);
if N>M
    if rem(M,2)==0   % M is even
        i1 = max(1,ind-(M/2-1));
    else
        i1 = max(1,ind-(M/2-1/2));
    end
    i2 = i1+M-2;
    if i2>N
        i1 = i1-(i2-N);
        i2 = N;
    end
    set(legendPopup,'string',{labelList{i1:i2} 'More...'},...
        'value',ind-i1+1,...
        'min',i1,...
        'max',i2,...
        'userdata',labelList)
else
    set(legendPopup,'string',labelList,...
        'value',ind,...
        'min',1,...
        'max',length(labelList),...
        'userdata',[])
end
