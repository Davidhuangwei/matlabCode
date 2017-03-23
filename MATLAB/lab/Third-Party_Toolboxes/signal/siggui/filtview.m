function varargout = filtview(varargin)
%FILTVIEW Filter Viewer.
%   This graphical tool allows you to examine the magnitude and phase
%   responses, group delay, zeros and poles, and impulse and step responses
%   of a digital filter.
%
%   Type 'sptool' to start the Signal Processing GUI Tool and access
%   the Filter Viewer.
%
%   See also SPTOOL, SIGBROWSE, FILTDES, SPECTVIEW.

%   Copyright (c) 1988-98 by The MathWorks, Inc.
%       $Revision: 1.1 $

% NOTE: ud.limits is set to the current X- Y-limits of the plot.  This is
% necessary because ruler.m uses ud.limits, and to avoid the rulers from
% dictating the XY limits of the plot we must keep the rulers inside the
% axes. ud.limits does not contain the largest X- Y-limits possible for
% that plot, as it might be the case in other clients that use ud.limits.

if nargin == 0,
    if isempty(findobj(0,'tag','sptool'))
        disp('Type ''sptool'' to start the Signal GUI.')
    else
        disp('To use the Filter Viewer, click on a filter in the ''Filters''')
        disp('column in the ''SPTool'', and then click on the ''View'' button.')
    end
    return
elseif ~isstr(varargin{1})
    fvinit(varargin{:})
    drawnow
    shh = get(0,'showhiddenhandles');
    set(0,'showhiddenhandles','on')
    ud = get(gcf,'userdata');

    set(ud.toolbar.zoomgroup,'visible','on')
    set(ud.toolbar.helpgroup,'visible','on')
    set(0,'showhiddenhandles',shh)
    return
end

action = varargin{1};

switch action
% ----------------------------------------------------------------------
% plotTitles = filtview('plotTitles',realFilterFlag)
%   
% Inputs:
%     realFilterFlag - flag indicating that filter being viewed is real
% Outputs:
%     plotTitles - list of plots available to focus on by rulers
%
case 'plotTitles'

    realFilterFlag = varargin{2};
    if realFilterFlag
        plotTitles ={'Magnitude','Phase','Group Delay',...
	        'Zeros and Poles','Impulse Response','Step Response',};
    else % Complex filter
        plotTitles ={'Magnitude','Phase','Group Delay',...
                'Zeros and Poles','Impulse (Real)',...
                'Impulse (Imag)','Step (Real)','Step (Imag)'};
    end
    varargout{1} = plotTitles;

%----------------------------------------------------------------------
% [FsStr filtLabelStr] = filtview('filtFsLabelStrs',ud.prefs,ud.ht,ud.filt)
%   Call local function to determine the correct strings for Fs and filter
%   label (the label which lists the names of the filters currently being
%   viewed).
%
case 'filtFsLabelStrs'

    [FsStr filtLabelStr] = ...
        filtFsLabelStrs(varargin{2},varargin{3},varargin{4});
    varargout{1} = FsStr;
    varargout{2} = filtLabelStr;

%----------------------------------------------------------------------
% [ud.lines] = filtview('emptyLinesStruct')
%  fvinit.m uses this case to access the local function emptyLineStruct.
%
case 'emptyLinesStruct'

    initializedLines = emptyLinesStruct;
    varargout{1} = initializedLines;
    
%----------------------------------------------------------------------
% [xlim1,xlim2,ylim1,ylim2] = filtview('zeropolePlotLims',ud.filt)
%   Call local function to alculate the limits for the zero-pole plot
%   (must keep the aspect ratio correct)
%
case 'zeropolePlotLims'

    filtStruct = varargin{2};
    [xlim1,xlim2,ylim1,ylim2] = zeropolePlotLims(filtStruct);
    
    varargout{1} = xlim1;
    varargout{2} = xlim2;
    varargout{3} = ylim1;
    varargout{4} = ylim2;

%----------------------------------------------------------------------
% filtview('cb',checkboxnum)
%   callback of checkbox to turn plots on/off
%
case 'cb'
    cbnum = varargin{2};
    fig = gcf;
    ud = get(fig,'userdata');
    ud.prefs.plots(cbnum) = 1-ud.prefs.plots(cbnum);
    set(fig,'userdata',ud)
    fvresize(1,fig)  % Add or remove axes and resize all other axes

    if ud.prefs.plots(cbnum)
        pflag = [0 0 0 0 0 0]';
        pflag(cbnum) = 1;
        filtview('plots',pflag)

        % Update the ud.limits of new plots as they're made visible
        ud = get(fig,'userdata');
        new_ud = filtview('setudlimits',ud,ud.ht.a,cbnum);
        set(fig,'userdata',new_ud)
        ud = get(fig,'userdata');
        
        if ud.prefs.tool.ruler  &  sum(ud.prefs.plots) == 1
            % Coming from a "no visible plots" state; make one plot visible
            ud.mainaxes = ud.ht.a(cbnum);
            ud.focusIndex = sptlegend('value',fig);
            [rulerPopupStr, rulerPopupVal] = ruler('getpopup',fig);

            % Account for the case where the filter was cleared
            % while viewing it in the filter viewer
            if isfield(ud,'filt.tf.num') 
                realFilterFlag = (isreal(ud.filt(ud.focusIndex).tf.num) &...
                    isreal(ud.filt(ud.focusIndex).tf.den));
            else
                realFilterFlag = 1;
            end
            
            if rulerPopupVal == 1  % Selection made via check box
                realDataFlag = 1;
            else                   % Selection made via ruler popup
                realDataFlag = (realFilterFlag | ~rem(rulerPopupVal,2));
            end
            ud.focusline = setFocusLine(ud.mainaxes,ud.lines,...
                cbnum,ud.focusIndex,realDataFlag);
            set(fig,'userdata',ud)
            rulerPopupVal = cbnum + (~realFilterFlag & (cbnum == 6));
            ruler('setpopup',fig,ud.prefs.plottitles,rulerPopupVal)
            ruler('newaxes',fig,cbnum,ud.mainaxes);    
            noTrackZeroPole(fig,ud)
        elseif ud.prefs.tool.ruler
            % Either, an invisible plot was selected via the ruler popup
            % OR, mainaxes limits changed because new plots were added
            plotIndex = find(ud.mainaxes == ud.ht.a);
            ruler('newlimits',fig,plotIndex,ud.focusline)
        end
    else     % If we're turning off a plot, zoom out of that plot
        fvzoom('zoomout',[zeros(1,cbnum-1) 1 zeros(1,6-cbnum)],fig)
        if ud.prefs.tool.ruler 
            if strcmp(get(ud.mainaxes,'visible'), 'off')
                if any(strcmp(get(ud.ht.a,'visible'),'on'))
                    % If other plots exist move rulers to the next plot.
                    [ud.mainaxes,ud.focusline,plotIndex,visPlots] = ...
                        setMainaxes(ud.mainaxes,ud.ht.a,ud.lines,1);
                    ud = filtview('setudlimits',ud,ud.ht.a,plotIndex);
                    set(fig,'userdata',ud)
                    ruler('newaxes',fig,plotIndex,ud.mainaxes)
                    noTrackZeroPole(fig,ud)
                else    % no visible plots
                    ud.focusline = [];
                    ud.focusIndex = [];
                    set(fig,'userdata',ud)
                    ruler('hidelines',fig,'all')
                    ruler('newsig',fig)          % sets the ruler values
                end
                ud = get(fig,'userdata');

                % Account for the case where the filter was cleared
                % while viewing it in the filter viewer
                if isfield(ud,'filt.tf.num')
                    realFilterFlag=(isreal(ud.filt(ud.focusIndex).tf.num)...
                        & isreal(ud.filt(ud.focusIndex).tf.den));
                else
                    realFilterFlag = 1;
                end
                
                updateRulrPopupList(fig,ud.prefs.plottitles,ud.ht.a,...
                    ud.mainaxes,realFilterFlag)
            else
                % Set ruler XY limits because subplots have been resized.
                plotIndex = find(ud.mainaxes == ud.ht.a);
                ud = filtview('setudlimits',ud,ud.ht.a,plotIndex);
                set(fig,'userdata',ud)
                ruler('newlimits',fig,plotIndex,ud.focusline)
            end
        end
    end

    % Disable and enable Magnitude and Phase popupmenus as appropriate
    if get(ud.ht.cb(1),'value') == 0
        set(ud.ht.magpop,'enable','off')
    else
        set(ud.ht.magpop,'enable','on')       
    end
    
    if get(ud.ht.cb(2),'value') == 0
        set(ud.ht.phasepop,'enable','off')
    else
        set(ud.ht.phasepop,'enable','on')       
    end
    
% ----------------------------------------------------------------------
% filtview('magpop')
%   callback of magnitude linear/log popup
%
case 'magpop'
    fig = gcf;
    ud = get(fig,'userdata');
    oldmode = ud.prefs.magmode;
    popupval = get(ud.ht.magpop,'value');
    popupstr = get(ud.ht.magpop,'string');
    if strcmp(oldmode,popupstr{popupval})
        return
    end

    switch popupval
    case 1
        ud.prefs.magmode = 'linear';
        set(ud.ht.a(1),'yscale','linear')
    case 2
        ud.prefs.magmode = 'log';
        set(ud.ht.a(1),'yscale','log')
     case 3
        ud.prefs.magmode = 'decibels';
        set(ud.ht.a(1),'yscale','linear')
    end
    set(fig,'userdata',ud)

    if ud.prefs.plots(1)
       filtview('plots',[1 0 0 0 0 0])
       fvzoom('zoomout',[1 0 0 0 0 0],fig)  % sets userdata
       ud = get(fig,'userdata');
       
       if ud.prefs.tool.ruler & (ud.ht.a(1) == ud.mainaxes)
           ruler('newsig',fig,1)           
           ruler('inbounds',fig,'ylim',1)  % make sure ruler limits are 
                                           % within the new axes limits
       end
    end
    
    p = sptool('getprefs','filtview1');
    p.magscale = popupval;
    sptool('setprefs','filtview1',p)
    
% ----------------------------------------------------------------------
% filtview('phasepop')
%   callback of phase degrees/radians popup
%
case 'phasepop'
    fig = gcf;
    ud = get(fig,'userdata');
    oldmode = ud.prefs.phasemode;
    popupval = get(ud.ht.phasepop,'value');
    popupstr = get(ud.ht.phasepop,'string');
    if strcmp(oldmode,popupstr{popupval})
        return
    end

    switch popupval
    case 1
        ud.prefs.phasemode = 'degrees';
        set(get(ud.ht.a(2),'title'),'string',ud.titles{2}{1})
    case 2
        ud.prefs.phasemode = 'radians';
        set(get(ud.ht.a(2),'title'),'string',ud.titles{2}{2})
    end
    set(fig,'userdata',ud)

    if ud.prefs.plots(2)
        filtview('plots',[0 1 0 0 0 0])
        fvzoom('zoomout',[0 1 0 0 0 0],fig) % sets userdata
        ud = get(fig,'userdata');
        
        if ud.prefs.tool.ruler & (ud.ht.a(2) == ud.mainaxes)
            ud = filtview('setudlimits',ud,ud.ht.a,2);
            set(fig,'userdata',ud)
            ruler('newlimits',fig,2,ud.focusline)
            ruler('newsig',fig,2)
            ud = get(fig,'userdata');
            ruler('inbounds',fig,'ylim',2) % make sure ruler limits are 
                                           % within the new axes limits
        end
    end

    p = sptool('getprefs','filtview1');
    p.phaseunits = popupval;
    sptool('setprefs','filtview1',p)

% ----------------------------------------------------------------------
% filtview('fscalepop')
%   callback of frequency scale linear/log popup
%    
case 'fscalepop'
    fig = gcf;
    ud = get(fig,'userdata');
    oldmode = ud.prefs.freqscale;    
    popupval = get(ud.ht.fscalepop,'value');
    popupstr = get(ud.ht.fscalepop,'string');
    if strcmp(oldmode,popupstr{popupval})
        return
    end
    
    switch popupval
    case 1
        ud.prefs.freqscale = 'linear';
        set(fig,'userdata',ud)
        set(ud.ht.a([1 2 3]),'xscale','linear')
        fvzoom('zoomout',[1 1 1 0 0 0],fig)

    case 2
        ud.prefs.freqscale = 'log';
        set(fig,'userdata',ud)

        if ud.prefs.freqrange == 3  % can't have negative frequencies
                                 % in logarithmic scale - change to [0..Fs/2]
            % so... change range!
            msgbox({'Sorry, you can''t have the Frequency Axis Scaling set'...
                'to logarithmic when the range includes negative frequencies.'...
                'Changing the range to positive frequencies only.'},...
                'Logarithmic Scaling Conflict','warn','modal')

            set(ud.ht.frangepop,'value',1)
            filtview('frangepop',fig)
            ud = get(fig,'userdata');
        end
        Fs = evalin('base',ud.prefs.Fs,'1');
        switch ud.prefs.freqrange
        case 1    % [0 Fs/2]
            flim = [Fs/ud.prefs.nfft Fs/2];
        case 2    % [0 Fs]
            flim = [Fs/ud.prefs.nfft Fs];
        end
        set(ud.ht.a([1 2 3]),'xscale','log','xlim',flim)
    end

    if ud.prefs.tool.ruler & any(ud.ht.a(1:3) == ud.mainaxes)
        plotIndex = find(ud.mainaxes == ud.ht.a);

        % Make sure that ud.limits matches new axes limits 
        ud = filtview('setudlimits',ud,ud.ht.a,plotIndex);
        set(fig,'userdata',ud)
        
        % Make sure that ruler values stay within the new axes limits
        ruler('inbounds',fig,'xlim',plotIndex)
        ud = get(fig,'userdata');
        
        ruler('newlimits',fig,plotIndex,ud.focusline)
        ruler('newsig',fig,plotIndex)
    end

    p = sptool('getprefs','filtview1');
    p.freqscale = get(ud.ht.fscalepop,'value');
    sptool('setprefs','filtview1',p)

% ----------------------------------------------------------------------
% filtview('frangepop',fig)
%   callback of frequency range popup
%
case 'frangepop'
    if nargin > 1
        fig = varargin{2};
    else
        fig = gcf;
    end

    ud = get(fig,'userdata');
    oldmode = ud.prefs.freqrange;
    popupval = get(ud.ht.frangepop,'value');
    popupstr = get(ud.ht.frangepop,'string');
    if (oldmode == popupval)
        return
    end
    switch popupval
    case 1
        ud.prefs.freqrange = 1;
    case 2
        ud.prefs.freqrange = 2;
    case 3
        % if in log scaling, don't allow display of negative frequencies
        if strcmp(ud.prefs.freqscale,'log')
            % so don't change range!
            msgbox({'Sorry, you can''t set the range to include negative' ...
                'frequencies when the Frequency Axis Scaling is logarithmic.'},...
                'Logarithmic Scaling Conflict','warn','modal')
            set(ud.ht.frangepop,'value',ud.prefs.freqrange)
            return
        end
        ud.prefs.freqrange = 3;
    end
    set(fig,'userdata',ud)
    
    filtview('plots',[ud.prefs.plots(1:3); 0; 0; 0],fig)
    fvzoom('zoomout',[ud.prefs.plots(1:3)' 0 0 0],fig) % sets userdata
    ud = get(fig,'userdata'); 
        
    % Make sure that rulers appear within the new axes limits
    if ud.prefs.tool.ruler & any(ud.ht.a(1:3) == ud.mainaxes)
        plotIndex = find(ud.mainaxes == ud.ht.a);
        ruler('inbounds',fig,'xlim',plotIndex) % make sure ruler limits are 
                                               % within the new axes limits
        if (ud.prefs.freqrange ~= oldmode)
            ruler('updatepeaksgroup',fig)
        end
    end

    p = sptool('getprefs','filtview1');
    p.freqrange = get(ud.ht.frangepop,'value');
    sptool('setprefs','filtview1',p)

% ----------------------------------------------------------------------
% filtview('Fs',fig)
%   callback of sampling frequency edit box 
%   (or you can use this to set the sampling frequency if you
%   set the string of ud.ht.Fsedit first)
%
case 'Fs'
    if nargin < 2
        fig = gcf;
    else
        fig = varargin{2};
    end

    ud = get(fig,'userdata');

    str = get(ud.ht.Fsedit,'string');

    if isequal(str,ud.prefs.Fs)
        return
    end

    [Fs,err] = validarg(str,[0 Inf],[1 1],'sampling frequency');
    if err
        set(ud.ht.Fsedit,'string',ud.prefs.Fs)
        return
    else
        ud.prefs.Fs = str;
        set(fig,'userdata',ud)
        if ~isempty(ud.tabfig)    % update settings figure
            data = get(ud.tabfig,'userdata');
            % this panel has been created since it is the first 1
            fvprefhand('populate',ud.tabfig,1,ud.prefs)
        end
        fvzoom('zoomout',ud.prefs.plots,fig)
        filtview('plots',ud.prefs.plots,fig)
    end
 
% ----------------------------------------------------------------------
% filtview('plots',plots,fig,need_update)
%   updates the plots indicated with a '1' in the plots vector
%   
case 'plots'
    if nargin < 3
        fig = gcf;
    else
        fig = varargin{3};
    end

    ud = get(fig,'userdata');

    if nargin < 4
        need_update = 1:length(ud.filt);   % everything needs updating
    else
        need_update = varargin{4};
    end
    
    plots = varargin{2};
    if all(plots==0)
        return
    end

    if isempty(ud.filt)
        % uninitialized tool - no filter
        % set axes limits to default value [0 1]
        for i=1:3
            if plots(i)
                set(ud.ht.a(i),'xlim',[0 1])
            end
        end
        return
    end
    
    maxFs = evalin('base',ud.prefs.Fs,'1');
    nfft = ud.prefs.nfft;
    
    if strcmp(ud.prefs.freqscale,'log')
        xlim1 = maxFs/ud.prefs.nfft;
    else
        xlim1 = 0;
    end
    switch ud.prefs.freqrange
    case 1    % [0 Fs/2]     
        flim = [xlim1 maxFs/2];
    case 2    % [0 Fs]      
        flim = [xlim1 maxFs];
    case 3    % [-Fs/2 Fs/2]
        flim = [-maxFs/2 maxFs/2];
    end

    % Loop through selected filters that need updating        
    for i = need_update
        Fs = ud.filt(i).Fs;
        switch ud.prefs.freqrange
        case 1    % [0 Fs/2]
            ud.filt(i).f = 0:Fs/nfft:(Fs/2 - Fs/(2*nfft));
        case 2    % [0 Fs]
            ud.filt(i).f = 0:Fs/nfft:(Fs - Fs/nfft);
        case 3    % [-Fs/2 Fs/2]
            ud.filt(i).f = fftshift(0:Fs/nfft:(Fs - Fs/nfft));
            ind = find(ud.filt(i).f>=Fs/2);
            ud.filt(i).f(ind) = ud.filt(i).f(ind)-Fs;
        end
    
        if any(plots([1 2 3]))
            ud.filt(i).H = fft(ud.filt(i).tf.num,nfft);
            warnsave = warning; 
            warning('off')   % prevent possible divide by 0 message
            ud.filt(i).H = ud.filt(i).H./fft(ud.filt(i).tf.den,nfft);
            warning(warnsave)
            switch ud.prefs.freqrange
            case 1    % [0 Fs/2]
                ud.filt(i).H = ud.filt(i).H(1:nfft/2);
            case 3    % [-Fs/2 Fs/2]
                ud.filt(i).H = fftshift(ud.filt(i).H);
            end
        end
        
        if isempty(ud.filt(i).lineinfo)
            lineColor = ud.colororder{1};
            lineStyle = ud.linestyleorder{1};
        else
            lineColor = ud.filt(i).lineinfo.color;
            lineStyle = ud.filt(i).lineinfo.linestyle;
        end
        
        if plots(1)
            if isempty(ud.lines(i).mag)
                ud.lines(i).mag = line(1,1,'tag','magline',...
                    'parent',ud.ht.a(1), ...
                    'buttondownfcn','filtview(''mdown'')');
            end
            set(ud.lines(i).mag,'color',lineColor,'linestyle',lineStyle)
            if strcmp(ud.prefs.magmode,'decibels')
                absH = abs(ud.filt(i).H);
                ind = find(absH>0);
                dbH = -Inf; dbH = dbH(ones(size(absH)));
                dbH(ind) = 20*log10(absH(ind));
                set(ud.lines(i).mag,'xdata',ud.filt(i).f,...
                    'ydata',dbH,'visible','on')
            else
                set(ud.lines(i).mag,'xdata',ud.filt(i).f,...
                    'ydata',abs(ud.filt(i).H),'visible','on')
            end        
        end
        
        if plots(2)
            if isempty(ud.lines(i).phase)
                ud.lines(i).phase = line(1,1,'tag','phaseline',...
                    'parent',ud.ht.a(2), ...
                    'buttondownfcn','filtview(''mdown'')');
            end
            set(ud.lines(i).phase,'color',lineColor,'linestyle',lineStyle)
            if ud.prefs.freqrange < 3
                pha = unwrap(angle(ud.filt(i).H));
            else
                pha_neg = unwrap(angle(ud.filt(i).H(nfft/2:-1:1)));
                pha_neg = pha_neg(end:-1:1);
                pha_pos = unwrap(angle(ud.filt(i).H((nfft/2+1):end)));
                pha = [pha_neg(:); pha_pos(:);];
            end

            switch ud.prefs.phasemode
            case 'degrees'
                set(ud.lines(i).phase,'xdata',ud.filt(i).f,...
                    'ydata',pha*180/pi,'visible','on')
            case 'radians'
                set(ud.lines(i).phase,'xdata',ud.filt(i).f,...
                    'ydata',pha,'visible','on')
            end
        end
        
        if plots(3)
            warnsave = warning; 
            warning('off');  % turn off divide by zero warning
            ud.filt(i).G = grpdelay(ud.filt(i).tf.num,ud.filt(i).tf.den,...
                           ud.filt(i).f,Fs);
            warning(warnsave);  
            if isempty(ud.lines(i).grpdelay)
                ud.lines(i).grpdelay = line(1,1,'tag','delayline',...
                    'parent',ud.ht.a(3), ... 
                    'buttondownfcn','filtview(''mdown'')');
            end
            set(ud.lines(i).grpdelay,'color',lineColor,'linestyle',lineStyle)
            set(ud.lines(i).grpdelay,'xdata',ud.filt(i).f,...
                'ydata',ud.filt(i).G,'visible','on')
        end
     
        if plots(4)
            if isempty(ud.lines(i).z)               
                ud.lines(i).z = line(NaN,NaN,'tag','zerosline',...
                    'linestyle','none','marker','o',...
                    'parent',ud.ht.a(4),...
                    'buttondownfcn','filtview(''mdown'')');
            end
            set(ud.lines(i).z,'color',lineColor)
            if isempty(ud.lines(i).p)
                ud.lines(i).p = line(NaN,NaN,'tag','polesline',...
                    'linestyle','none','marker','x',...
                    'parent',ud.ht.a(4),...
                    'buttondownfcn','filtview(''mdown'')');
            end
            set(ud.lines(i).p,'color',lineColor)
            if isempty(ud.filt(i).zpk)
                if ~isempty(ud.filt(i).ss)
                    [z,p,k] = ss2zp(ud.filt(i).ss.a,ud.filt(i).ss.b,...
                        ud.filt(i).ss.c,ud.filt(i).ss.d,1);
                elseif ~isempty(ud.filt(i).sos)
                    [z,p,k] = sos2zp(ud.filt(i).sos);
                else
                    if length(ud.filt(i).tf.den)<length(ud.filt(i).tf.num)
                        den = ud.filt(i).tf.den;
                        den(length(ud.filt(i).tf.num)) = 0;   % zero pad
                        [z,p,k] = tf2zp(ud.filt(i).tf.num,den);
                    else
                        [z,p,k] = tf2zp(ud.filt(i).tf.num,ud.filt(i).tf.den);
                    end
                end
                ud.filt(i).zpk.z = z;
                ud.filt(i).zpk.p = p; 
                ud.filt(i).zpk.k = k;
            end
            set(ud.lines(i).z,'xdata',real(ud.filt(i).zpk.z),...
                'ydata',imag(ud.filt(i).zpk.z),'visible','on')
            set(ud.lines(i).p,'xdata',real(ud.filt(i).zpk.p),...
                'ydata',imag(ud.filt(i).zpk.p),'visible','on')
            set(ud.ht.a(4),'ylimmode','auto','xlimmode','auto')
            apos = get(ud.ht.a(4),'Position');
            set(ud.ht.a(4),'DataAspectRatio',[1 1 1],...
                'PlotBoxAspectRatio',apos([3 4 4]))
        end
        if any(plots([5 6]))
            [ud.filt(i).imp,ud.filt(i).t] = ...
                impz(ud.filt(i).tf.num,ud.filt(i).tf.den,ud.prefs.nimp,Fs);
        end
        if plots(5)
            if isempty(ud.lines(i).imp)
                ud.lines(i).imp = line(nan,nan,'tag','implinedots',...
                    'linestyle','none','marker','o',...
                    'parent',ud.ht.a(5),...
                    'buttondownfcn','filtview(''mdown'')');
            end
            set(ud.lines(i).imp,'color',lineColor,'markerfacecolor',lineColor)
            if isempty(ud.lines(i).impstem)
                ud.lines(i).impstem = line(nan,nan,'color',lineColor,...
                    'linestyle','-',...
                    'tag','implinestem',...
                    'parent',ud.ht.a(5),...
                    'buttondownfcn','filtview(''mdown'')');
            end
            set(ud.lines(i).impstem,'color',lineColor,'linestyle',lineStyle)
            if isempty(ud.lines(i).impc)
                ud.lines(i).impc = line(nan,nan,'tag','implinedotsc',...
                    'linestyle','none','marker','*',...
                    'parent',ud.ht.a(5),...
                    'buttondownfcn','filtview(''mdown'')');
            end
            set(ud.lines(i).impc,'color',lineColor,'markerfacecolor',lineColor)
            if isempty(ud.lines(i).impstemc)
                ud.lines(i).impstemc = line(nan,nan,'tag','implinestemc',...
                    'linestyle','-',...
                    'parent',ud.ht.a(5),...
                    'buttondownfcn','filtview(''mdown'')');
            end
            set(ud.lines(i).impstemc,'color',lineColor,'linestyle',lineStyle)
            setstem([ud.lines(i).imp ud.lines(i).impstem],ud.filt(i).t,...
                    real(ud.filt(i).imp))
            if sum(imag(ud.filt(i).imp).^2) > 1e-10*sum(real(ud.filt(i).imp).^2)
                setstem([ud.lines(i).impc ud.lines(i).impstemc],ud.filt(i).t,...
                        imag(ud.filt(i).imp))
                set([ud.lines(i).impc ud.lines(i).impstemc],'visible','on')
            else
                set([ud.lines(i).impc ud.lines(i).impstemc],'visible','off')
            end
            set([ud.lines(i).imp ud.lines(i).impstem],'visible','on')
        end
        
        if plots(6)
            if isempty(ud.lines(i).step)
                ud.lines(i).step = line(nan,nan,'tag','steplinedots',...
                    'linestyle','none','marker','o',...
                    'parent',ud.ht.a(6),...
                    'buttondownfcn','filtview(''mdown'')');
            end
            set(ud.lines(i).step,'color',lineColor,'markerfacecolor',lineColor)
            if isempty(ud.lines(i).stepstem)
                ud.lines(i).stepstem = line(nan,nan,'tag','steplinestem',...
                    'linestyle','-',...
                    'parent',ud.ht.a(6),...
                    'buttondownfcn','filtview(''mdown'')');
            end  
            set(ud.lines(i).stepstem,'color',lineColor,'linestyle',lineStyle)
            if isempty(ud.lines(i).stepc)
                ud.lines(i).stepc = line(nan,nan,'tag','steplinedotsc',...
                    'linestyle','none','marker','*',...
                    'parent',ud.ht.a(6),...
                    'buttondownfcn','filtview(''mdown'')');
            end
            set(ud.lines(i).stepc,'color',lineColor,'markerfacecolor',lineColor)
            if isempty(ud.lines(i).stepstemc)
                ud.lines(i).stepstemc = line(nan,nan,'tag','steplinestemc',...
                    'linestyle','-',...
                    'parent',ud.ht.a(6),...
                    'buttondownfcn','filtview(''mdown'')');
            end 
            set(ud.lines(i).stepstemc,'color',lineColor,'linestyle',lineStyle)
            ud.filt(i).step = filter(ud.filt(i).tf.num,ud.filt(i).tf.den,...
                ones(1,length(ud.filt(i).t)));
            setstem([ud.lines(i).step ud.lines(i).stepstem],ud.filt(i).t,...
                real(ud.filt(i).step))
            if sum(imag(ud.filt(i).step).^2) > 1e-10*sum(real(ud.filt(i).step).^2)
                setstem([ud.lines(i).stepc ...
                        ud.lines(i).stepstemc],ud.filt(i).t,...
                        imag(ud.filt(i).step))
                set([ud.lines(i).stepc ud.lines(i).stepstemc],'visible','on')
            else
                set([ud.lines(i).stepc ud.lines(i).stepstemc],'visible','off')
            end
            set([ud.lines(i).step ud.lines(i).stepstem],'visible','on')
            set(ud.ht.a(6),'ylimmode','auto',...
                'xlim',[ud.filt(i).t(1)-1/Fs  ud.filt(i).t(end)+1/Fs])
            
        end
         
        set(fig,'userdata',ud)
        sptool('import',ud.filt(i))
    end % looping trough selected filters
    
    % set all axes properties only once:
    if plots(1)
        % Make sure that proper scale is used for magnitude axis
        if get(ud.ht.magpop,'value') == 2
            set(ud.ht.a(1),'yscale','log')
        else
            set(ud.ht.a(1),'yscale','linear')        
        end
        set(ud.ht.a(1),'ylimmode','auto','xlim',flim)
    end
    
    if plots(2), set(ud.ht.a(2),'ylimmode','auto','xlim',flim), end
    if plots(3)  % set ylims of group delay plot
        gd_ylim = filtview('gd_ylim',ud.filt);
        set(ud.ht.a(3),'ylim',gd_ylim)
        set(ud.ht.a(3),'xlim',flim)
    end
    %if plots(3), set(ud.ht.a(3),'ylimmode','auto','xlim',flim), end

    if any(plots(1:3))  % Make sure that proper scale is used for freq axis
        if get(ud.ht.fscalepop,'value') == 2
            set(ud.ht.a(find(plots(1:3))),'xscale','log')
        else
            set(ud.ht.a(find(plots(1:3))),'xscale','linear')        
        end
    end
    
    if plots(4)
        [xlim1,xlim2,ylim1,ylim2] = zeropolePlotLims(ud.filt);
        set(get(ud.ht.a(4),'xlabel'),'userdata',[xlim1 xlim2 ylim1 ylim2]);
    end

    if any(plots([5 6]))
        tmax = -inf;
        for i = 1:length(ud.filt)
            tmax = max([tmax; ud.filt(i).t(end)]);
        end
        
        xlim = [-1/maxFs tmax+1/maxFs];
        if plots(5),set(ud.ht.a(5),'ylimmode','auto','xlim',xlim), end
        if plots(6),set(ud.ht.a(6),'ylimmode','auto','xlim',xlim), end
    end

%------------------------------------------------------------------------
%   gd_ylim = filtview('gd_ylim',filt)
%      compute ylimits for group delay plot
%      assumes .H and .G fields of filt struct are set correctly
case 'gd_ylim' 
    filt = varargin{2};
    if length(filt)==0
        gd_ylim = [0 1];
    else
        gd_ylim = [Inf -Inf];
    end
    for i=1:length(filt)
        ind = find( abs(filt(i).H) > (max(abs(filt(i).H))*1e-10) );
        gd_ylim = [min(gd_ylim(1),min(filt(i).G(ind))-1) ...
                 max(gd_ylim(2),max(filt(i).G(ind))+1)]; 
    end
    varargout{1} = gd_ylim;
    
%------------------------------------------------------------------------
% filtview('changefocus')
%  callback of sptlegend
%
case 'changefocus'
    
    newfocusIndex = sptlegend('value');
    fig = gcbf;
    ud = get(fig,'userdata');
    plotIndex = find(ud.mainaxes == ud.ht.a);

    realFilterFlag = (isreal(ud.filt(newfocusIndex).tf.num) &...
        isreal(ud.filt(newfocusIndex).tf.den));

    % Make sure that ruler popup is updated correctly when changing from a
    % real filter to a complex filter and vice versa.
    if ud.prefs.tool.ruler & ~isempty(ud.filt)
        currentPopupVal = get(ud.ruler.hand.rulerpopup,'value');   
        newPlottitles = filtview('plotTitles',realFilterFlag);
        newPopupVal = cmplxFiltPopupVal(currentPopupVal,newPlottitles,...
                                                       ud.prefs.plottitles);
        ud.prefs.plottitles = newPlottitles;
        set(fig,'userdata',ud)
        updateRulrPopupList(fig,newPlottitles,ud.ht.a,...
                                      ud.mainaxes,realFilterFlag)
        str = ruler('getpopup',fig);
        ruler('setpopup',fig,str,newPopupVal)
    end
        
    if isempty(ud.focusIndex) 
        h = [];
    else
        hstepc = ud.lines(ud.focusIndex).stepc;
        himpc = ud.lines(ud.focusIndex).impc;
        h = [hstepc himpc];
    end
    if  isempty(ud.focusline) | isempty(h) | realFilterFlag | ...
            all(ud.focusline~=h)
        realDataFlag = 1;   % data is real
    else    
        realDataFlag = 0;   % data is complex
    end

    ud.focusline = setFocusLine(ud.mainaxes,ud.lines,...
                                plotIndex,newfocusIndex,realDataFlag);
    ud.focusIndex = newfocusIndex;
    set(fig,'userdata',ud)
    
    if ud.prefs.tool.ruler
        ruler('newsig',fig,plotIndex)
    end
    if isempty(find(ud.prefs.plots)) & ~isempty(ud.filt)
        sptlegend('setvalue',ud.legend.legendline,...
            ud.focusIndex,1,fig)
        set(ud.legend.legendline,'color',...
            ud.filt(ud.focusIndex).lineinfo.color)
    else
        sptlegend('setvalue',ud.focusline,ud.focusIndex,1,fig)
    end
    set(ud.legend.legendline,'linestyle', ...
                               ud.filt(ud.focusIndex).lineinfo.linestyle)
    bringToFront(fig,ud.focusIndex)
    
%------------------------------------------------------------------------
% filtview('newColor',lineColor,lineStyle)
%  newColorCallback of sptlegend
%  color and linestyle of ud.focusline have already been updated
%
case 'newColor'
    lineColor = varargin{2};
    lineStyle = varargin{3};
    
    fig = gcf;
    ud = get(fig,'userdata');
    
    indx = ud.focusIndex;
    if isempty(indx)
        indx = get(ud.legend.legendpopup,'value');
    end
    ud.filt(indx).lineinfo.color = lineColor;
    ud.filt(indx).lineinfo.linestyle = lineStyle;
 
    set(fig,'userdata',ud)
    
    % poke back into SPTool
    sptool('import',ud.filt(indx))

    % Only change the line style of lines, not markers; in other words
    % don't change the line style of circles, dots or asterisks.
    flds = {'mag'
            'phase'
            'grpdelay'
            'impstem'
            'impstemc'
            'stepstem'
            'stepstemc'};

    for i = 1:length(flds)
        lineHandle = eval(['ud.lines(', num2str(indx),  ').', flds{i}]);
        if ishandle(lineHandle)
            set(lineHandle,'linestyle',lineStyle)
        end
    end

    h = [ud.lines(indx).imp ud.lines(indx).imp  ud.lines(indx).step ...
            ud.lines(indx).stepc];
    set(h,'markerfacecolor',lineColor)
    handleCell = struct2cell(ud.lines(indx));
    h = [handleCell{:}];
    set(h,'color',lineColor)
    
%------------------------------------------------------------------------
% filtview('rulerpopup')
%   callback of the ruler popupmenu
%
case 'rulerpopup'
    fig = gcf;
    ud = get(fig,'userdata');
    [rulerPopupStr,rulerPopupVal] = ruler('getpopup',fig);
    realFilterFlag = length(rulerPopupStr) <= 7;
    none_indx = strcmp(rulerPopupStr{1},'<none>');

    if none_indx & (rulerPopupVal == 1)
        return
    end

    plotIndex = rulerPopupVal - none_indx;
    plotIndex = plotIndex - (~realFilterFlag &  ((plotIndex==6) | ...
        (plotIndex==7))) - 2*(~realFilterFlag & plotIndex>=8);
        
    if plotIndex == find(ud.mainaxes == ud.ht.a) & ...
            strcmp(get(ud.mainaxes,'visible'),'on')
        realDataFlag = (realFilterFlag | rem(rulerPopupVal-none_indx,2));
        focusline = setFocusLine(ud.mainaxes,ud.lines,...
            plotIndex,ud.focusIndex,realDataFlag);
        if isequal(ud.focusline,focusline)
            return
        end
    end
        
    if ~ud.prefs.plots(plotIndex)               % plot is not selected
        set(ud.ht.cb(plotIndex),'value',1);     % select checkbox
        filtview('cb',plotIndex)                % display plot 
        if ~realFilterFlag & any((rulerPopupVal-none_indx)==[6 8])
            if none_indx, rulerPopupStr = rulerPopupStr(2:end); end
            ruler('setpopup',fig,rulerPopupStr,rulerPopupVal-none_indx)
        end
        ud = get(fig,'userdata');
    end
    
    complxFlag = ~realFilterFlag & (any((rulerPopupVal-none_indx)==[6 8]));
    ud.mainaxes = ud.ht.a(plotIndex);
    ud.focusline = setFocusLine(ud.mainaxes,ud.lines,plotIndex,...
        ud.focusIndex,~complxFlag);
        
    ud = filtview('setudlimits',ud,ud.ht.a,plotIndex);
    set(fig,'userdata',ud)
    ruler('newaxes',fig,plotIndex,ud.mainaxes)
    noTrackZeroPole(fig,ud)                

%------------------------------------------------------------------------
% ud = filtview('setudlimits',ud,axesList,axesIndexes)
% Inputs:
%   ud - structure containing client's userdata
%   axesList - list of handles of the axes of all subplots
%   axesIndexes - indicies of the handles of all visible subplots
% Ouputs:
%   ud - structure containing client's modified userdata (new xlim and
%        ylim)
%
case 'setudlimits'

    ud = varargin{2};
    axesList = varargin{3};
    axesIndexes = varargin{4};

    for i = 1:length(axesIndexes)
        ud.limits(axesIndexes(i)).xlim=get(axesList(axesIndexes(i)),'xlim');
        ud.limits(axesIndexes(i)).ylim=get(axesList(axesIndexes(i)),'ylim');
    end
    
    varargout{1} = ud;

%------------------------------------------------------------------------
% filtview('settab')
%  open settings tabbed dialog box
%
case 'settab'
    fig = gcf;
    ud = get(fig,'userdata');

    if ud.pointer == 2  % help mode
        fvhelp('settab')
        return
    end

    if isempty(ud.tabfig)
        setptr(fig,'watch');
        ud.pointer = -1; 
        set(fig,'userdata',ud)
        tabfig1 = tabfig(0,'fvprefhand',ud.sz);
        ud.tabfig = tabfig1;
        ud.pointer = 0; 
        set(fig,'userdata',ud);
        fvmotion(ud.toolnum)
    else
        set(ud.tabfig,'visible','on')
        figure(ud.tabfig)
    end
    
%------------------------------------------------------------------------
% filtview('mdown')
%  mouse down event on one of the lines
%
case 'mdown'
    [l,fig] = gcbo;
    ud = get(fig,'userdata');
    oldFocusIndx = ud.focusIndex;
    
    if ud.pointer == 2  % help mode
        fvhelp('line')
        return
    end
    
    if ~justzoom(fig)
        ax = get(l,'parent');
        if ax==ud.ht.a(5) | ax==ud.ht.a(6)
            erasemode = 'xor';
        else
            erasemode = 'background';
        end
        
        xlim = get(ax,'xlim');
        ylim = get(ax,'ylim');
    
        % Determine which line from which filter was selected
        for i = 1:length(ud.lines)
            allLines = struct2cell(ud.lines(i));
            allLines = [allLines{:}];
            if any(allLines==l)
                ud.focusIndex = i;
                break
            end
        end
        set(fig,'userdata',ud)
        
        % Setting XY limits here causes redrawing of the plot when you
        % click on the line - try to avoid this in the future
        set(ax,'ylimmode','auto','xlimmode','auto')
        bounds.xlim = get(ax,'xlim');
        bounds.ylim = get(ax,'ylim');
        set(ax,'ylim',ylim,'xlim',xlim)
            
        if ud.prefs.tool.ruler & (ax == ud.mainaxes)
            invis = [ud.ruler.lines ud.ruler.markers];
        else
            invis = [];
        end

        limchange = panfcn('erasemode',erasemode,'bounds',bounds,...
            'invisible',invis,'immediate',0);

        plotIndex = find(ax == ud.ht.a);
        if limchange
            ud = filtview('setudlimits',ud,ud.ht.a,plotIndex);
            set(fig,'userdata',ud);
        end

        if ud.prefs.tool.ruler & (ax == ud.mainaxes) & ...
                (oldFocusIndx==ud.focusIndex) & flisequal(fig,ud.focusline,l)
            % just dragging the line (where rulers are focused) around
            ruler('newlimits',fig,plotIndex)
            ruler('showlines',fig)
        elseif ud.prefs.tool.ruler % Move rulers to new line
            % Line chosen in new axes, hence, make new axes the mainaxes
            if (ax ~= ud.mainaxes)  
                ud.mainaxes = ax;
                set(fig,'userdata',ud)
            end
            ud = get(fig,'userdata');

            realFilterFlag = (isreal(ud.filt(ud.focusIndex).tf.num) &...
                              isreal(ud.filt(ud.focusIndex).tf.den));
            rulerPopVal = plotIndex;

            % Make sure that ruler popup is updated correctly when changing
            % from a real filter to a complex filter and vice versa.
            realDataFlag = realdataFlag(l,ud.lines,ud.focusIndex);
            if ~realFilterFlag
                if realDataFlag        % the real part was chosen
                    if (plotIndex == 6)   
                        rulerPopVal = plotIndex + 1;
                    end
                else                   % the imaginary part was chosen
                    switch plotIndex
                    case 5, rulerPopVal = 6;
                    case 6, rulerPopVal = 8;
                    end
                end
            end

            % Don't set the string of the ruler popup if it hasn't changed;
            % in case we're viewing only real or complex filters
            oldRealFilterFlag = (isreal(ud.filt(oldFocusIndx).tf.num) &...
                              isreal(ud.filt(oldFocusIndx).tf.den));
            if (oldRealFilterFlag ~= realFilterFlag)
                newPlottitles = filtview('plotTitles',realFilterFlag);
                updateRulrPopupList(fig,newPlottitles,ud.ht.a,...
                    ud.mainaxes,realFilterFlag)
            end
            str = ruler('getpopup',fig);
            ruler('setpopup',fig,str,rulerPopVal)

            
            ud.focusline = setFocusLine(ud.mainaxes,ud.lines,...
                                   plotIndex,ud.focusIndex,realDataFlag);
            set(fig,'userdata',ud)
            ud = get(fig,'userdata');
            ud = filtview('setudlimits',ud,ud.ht.a,plotIndex);
            set(fig,'userdata',ud)
            ruler('newaxes',fig,plotIndex,ud.mainaxes)
            noTrackZeroPole(fig,ud)
        else        
            realDataFlag = realdataFlag(l,ud.lines,ud.focusIndex);
            plotIndex = find(ax == ud.ht.a);
            ud.focusline = setFocusLine(ud.mainaxes,ud.lines,...
                plotIndex,ud.focusIndex,realDataFlag);
            set(fig,'userdata',ud)
        end
        if ax == ud.ht.a(4) & limchange
            xlim = get(ud.ht.a(4),'xlim');
            ylim = get(ud.ht.a(4),'ylim');
            set(get(ud.ht.a(4),'xlabel'),'userdata',[xlim ylim]);
        end
    end
    ud = get(fig,'userdata');
    bringToFront(fig,ud.focusIndex)
    sptlegend('setvalue',ud.focusline,ud.focusIndex,1,fig)
    set(ud.legend.legendline,'linestyle', ...
        ud.filt(ud.focusIndex).lineinfo.linestyle)
    
%------------------------------------------------------------------------
% enable = filtview('selection',action,msg,SPTfig)
%  respond to selection change in SPTool
% possible actions are
%    'view'
%  Button is enabled when
%     a) there is a filter selected
%
case 'selection'
    msg = varargin{3};
    SPTfig = varargin{4};
    fig = findobj('type','figure','tag','filtview');
    
    % get all filters (f) and the indexes (ind) of the selected filters
    [f,ind] = sptool('Filters',1,SPTfig);

    if isempty(f(ind))
        varargout{1} = 'off';
    else
        varargout{1} = 'on';
    end

    if ~isempty(fig)  % update filter viewer
        ud = get(fig,'userdata');
        switch msg
        case 'label'
            if ~isempty(ud.filt)
                oldFiltLabels = {ud.filt.label};
                newFiltLabels = {f(ind).label};
                % make sure FILTER (not signal or spectrum) has changed
                % its label
                if ~isequal(oldFiltLabels,newFiltLabels)
                    sptlegend('setstring',newFiltLabels,{},fig,1)
                    for i=1:length(ud.filt)
                        ud.filt(i).label = f(ind(i)).label;
                    end
                    set(fig,'userdata',ud)
                    [FsStr filtLabelStr] = filtFsLabelStrs(ud.prefs,ud.ht,ud.filt);
                    set(ud.ht.filterLabel,'string',filtLabelStr)
                end
            end
            return 
        case 'Fs'
            if any([ud.filt.Fs] ~= [f(ind).Fs])   % Filter's Fs has changed
                filtIndx = find([ud.filt.Fs] ~= [f(ind).Fs]);
                oldFs = ud.filt(filtIndx).Fs;
                newFs = f(ind(filtIndx)).Fs;
                ud.filt(filtIndx).Fs = newFs;
                ud.filt(filtIndx).f = ud.filt(filtIndx).f*(newFs/oldFs); 
                ud.filt(filtIndx).t = ud.filt(filtIndx).t/(newFs/oldFs);
               
                oldMaxFs = ud.prefs.Fs;
                newMaxFs = sprintf('%.9g',max([f(ind).Fs]));
             
                if ~strcmp(newMaxFs, oldMaxFs)  
                    ud.prefs.Fs = newMaxFs;
                    [FsStr filtLabelStr]=filtFsLabelStrs(ud.prefs,ud.ht,ud.filt);
                    set(ud.ht.Fsedit,'string',FsStr)

                    axesScale = str2double(newMaxFs)/str2double(oldMaxFs);
                    for i = 1:3
                        oldXlim = get(ud.ht.a(i),'xlim');
                        set(ud.ht.a(i),'xlim',oldXlim*axesScale)
                    end
                    for i = 5:6
                        oldXlim = get(ud.ht.a(i),'xlim');
                        set(ud.ht.a(i),'xlim',oldXlim/axesScale)
                    end
                end
                set(fig,'userdata',ud)
                
                h = struct2cell(ud.lines(filtIndx)); % Handles to lines
                h = [h{:}];
                for i = 1:3
                    hi = findobj(h,'parent',ud.ht.a(i));
                    for j = 1:length(hi)
                        set(hi(j),'xdata',get(hi(j),'xdata')*newFs/oldFs)
                    end
                end
                for i = 5:6
                    hi = findobj(h,'parent',ud.ht.a(i));
                    for j = 1:length(hi)
                        set(hi(j),'xdata',get(hi(j),'xdata')*oldFs/newFs)
                    end
                end
               
                if (filtIndx == ud.focusIndex) | ~strcmp(newMaxFs,oldMaxFs)  
                    % If on mainaxes fix ruler position
                    plotIndex = find(ud.mainaxes == ud.ht.a);
                    ruler('newlimits',fig,plotIndex)
                    ruler('newsig',fig,plotIndex)
                end
                return
            end    % Filter's Fs has changed
        end

        if ~isequal(f(ind),ud.filt)
            need_update = 1:length(ind);
            if isempty(ind)     % No filters in SPTool
                set(ud.ht.Fsedit,'string','')
                set(ud.ht.filterLabel,'string',['Filter: <none>'])
                ud.filt = [];
                for n = 1:length(ud.lines)
                    h = struct2cell(ud.lines(n));
                    h = [h{:}];
                    delete(h)
                end
                ud.lines = [];
                
                if ud.prefs.tool.ruler
                    ud.focusline = [];
                    ud.focusIndex = [];
                    set(fig,'userdata',ud)
                    ruler('newsig',fig)      % sets the ruler values
                    ud = get(fig,'userdata');
                end
            else  % New filter selected/created
                if ~isempty(ud.filt) 
                    % Find filters which need freq. response computed
                    % (don't include filters that were previously selected
                    % whose freq. response haven't changed)
                    newFiltSelection = f(ind);
                    [need_update,ud.lines,ud.focusIndex] = ...
                        redundantFilters(newFiltSelection,ud.filt,...
                        ud.lines,ud.focusIndex);
                else 
                    % Selecting a filter after un-selecting all filters
                    ud.lines = emptyLinesStruct;
                    ud.lines(length(f(ind))) = ud.lines(1);
                    ud.focusIndex = 1;
                end
                ud.filt = f(ind);
                plotIndex = find(ud.mainaxes == ud.ht.a);
                
                ud.prefs.Fs = sprintf('%.9g',max([f(ind).Fs]));
                [FsStr filtLabelStr] = filtFsLabelStrs(ud.prefs,ud.ht,ud.filt);
                set(ud.ht.filterLabel,'string',filtLabelStr)
                set(ud.ht.Fsedit,'string',FsStr) 
                
                for i=1:length(ud.filt) % Loop through the selected filters
                    % delete complex imp/step lines if filter is real, in case
                    % we are changing from a complex to a real filter
                    realFilterFlag = (isreal(ud.filt(i).tf.num) & ...
                        isreal(ud.filt(i).tf.den));
                    if realFilterFlag 
                        if ~isempty(ud.lines(i).impc)
                            delete([ud.lines(i).impc ud.lines(i).impstemc])
                            ud.lines(i).impc = [];
                            ud.lines(i).impstemc = [];
                        end
                        if ~isempty(ud.lines(i).stepc)
                            delete([ud.lines(i).stepc ud.lines(i).stepstemc])
                            ud.lines(i).stepc = [];
                            ud.lines(i).stepstemc = [];
                        end
                    end
                end  % looping through selected filters
            
            end      % new filter(s) selected/created
            set(fig,'userdata',ud)

            % Make sure that ruler popup is updated correctly when changing
            % from a real filter to a complex filter and vice versa.
            if ud.prefs.tool.ruler & ~isempty(ud.filt(ud.focusIndex)) 
                realFilterFlag = (isreal(ud.filt(ud.focusIndex).tf.num) &...
                              isreal(ud.filt(ud.focusIndex).tf.den));
                currentPopupVal = get(ud.ruler.hand.rulerpopup,'value');
                newPlottitles = filtview('plotTitles',realFilterFlag);
                newPopupVal = cmplxFiltPopupVal(currentPopupVal, ...
                                          newPlottitles, ud.prefs.plottitles);
                ud.prefs.plottitles = newPlottitles;
                set(fig,'userdata',ud)
                updateRulrPopupList(fig,newPlottitles,ud.ht.a,...
                                    ud.mainaxes,realFilterFlag)
                str = ruler('getpopup',fig);
                ruler('setpopup',fig,str,newPopupVal)
            end
            
            % Set line color and style for each new filter selected
            ud = get(fig,'userdata');
            for i = 1:length(ud.filt)     % loop through selected filters
                if isempty(ud.filt(i).lineinfo)
                    % assign next available line color and style
                    [ud.filt(i).lineinfo,ud.colorCount] = ...
                        nextcolor(ud.colororder,ud.linestyleorder, ...
                        ud.colorCount);
                    % poke back into SPTool
                    if nargin > 3
                        sptool('import',ud.filt(i),0,varargin{4})
                    else
                        sptool('import',ud.filt(i))
                    end
                
                end   % if-empty lineinfo
            end   % loop through selected filters
            set(fig,'userdata',ud);
            
            % Don't allow rulers to affect maximum axes limits computations
            if ud.prefs.tool.ruler, ruler('hidelines',fig,'all'), end
            filtview('plots',ud.prefs.plots,fig,need_update)
            
            ud = get(fig,'userdata');
            bringToFront(fig,ud.focusIndex)

            % New filter. Set the focusline correctly so that the rulers
            % will be set on appropriate subplot and focus on
            % correct line - if rulers were on imaginary line of complex
            % filter and new filter is also complex, focus rulers on the 
            % imaginary line of new filter.
            if ~isempty(f(ind)) 
                plotIndex = find(ud.mainaxes==ud.ht.a);
                ud = filtview('setudlimits',ud,ud.ht.a,plotIndex);
                realFilterFlag = (isreal(ud.filt(ud.focusIndex).tf.num) &...
                    isreal(ud.filt(ud.focusIndex).tf.den));

                if isempty(ud.focusIndex) 
                    h = [];
                else
                    hstepc = ud.lines(ud.focusIndex).stepc;
                    himpc = ud.lines(ud.focusIndex).impc;
                    h = [hstepc himpc];
                end
                if isempty(ud.focusline) | isempty(h) | realFilterFlag | ...
                        all(ud.focusline~=h)
                    realDataFlag = 1;   % data is real
                else    
                    realDataFlag = 0;   % data is complex
                end
                
                ud.focusline = setFocusLine(ud.mainaxes,ud.lines,...
                    plotIndex, ud.focusIndex,realDataFlag);
                set(fig,'userdata',ud)
                if ud.prefs.tool.ruler
                    ruler('newlimits',fig,plotIndex)
                    ruler('newsig',fig,plotIndex)
                    ruler('showlines',fig,ud.focusline)
                end
            end

            ud = get(fig,'userdata');
            
            if isempty(ind)     % No filters in SPTool
                sptlegend('setstring',{ },{},fig,0)
            else
                sptlegend('setstring',{ud.filt.label},{},fig,0)
                if isempty(find(ud.prefs.plots)) & ~isempty(ud.filt)
                    sptlegend('setvalue',ud.legend.legendline,...
                        ud.focusIndex,1,fig)
                    set(ud.legend.legendline,'color',...
                        ud.filt(ud.focusIndex).lineinfo.color)
                else
                    sptlegend('setvalue',ud.focusline,ud.focusIndex,1,fig)
                end
                set(ud.legend.legendline,'linestyle',...
                    ud.filt(ud.focusIndex).lineinfo.linestyle)
            end
            
        end   % newly selected filter(s) (f(ind)) doesn't equal ud.filt
    end   % filter viewer exists - fig is not empty
    
%------------------------------------------------------------------------
% enable = filtview('action',verb.action)
%  respond to button push in SPTool
% possible actions are
%    'view'
%
case 'action'
    SPTfig = gcf;
    fig = findobj('type','figure','tag','filtview');
    
    % get all filters (f) and the indexes (ind) of the selected filters
    [f,ind] = sptool('Filters',1,SPTfig);

    if isempty(fig)  % create the filter viewer
        filtview(f(ind))
    else             % set filter viewer's visibility 'ON'
        set(fig,'visible','on')
        figure(fig)
        ud = get(fig,'userdata');
        if ~isequal(f(ind),ud.filt)
            ud.filt = f(ind);
            ud.prefs.Fs = sprintf('%.9g',max([f(ind).Fs]));
            set(ud.ht.Fsedit,'string',ud.prefs.Fs)
            set(fig,'userdata',ud)
            filtview('plots',ud.prefs.plots,fig)

            ud.prefs.Fs = sprintf('%.9g',max([f(ind).Fs]));
            [FsStr filtLabelStr] = filtFsLabelStrs(ud.prefs,ud.ht,ud.filt);
            set(ud.ht.filterLabel,'string',filtLabelStr)
            set(ud.ht.Fsedit,'string',FsStr) 
            set(fig,'userdata',ud)
        end
    end

%------------------------------------------------------------------------
% filtview('SPTclose',verb.action)
%  respond to SPTool closing
% possible actions are
%    'view'
%
case 'SPTclose'
    fig = findobj('type','figure','tag','filtview');
    if ~isempty(fig)  % destroy the filtview tool
        ud = get(fig,'userdata');
        delete(fig)
    end
%------------------------------------------------------------------------
% filtview('print')
%  print contents of filtview (assumed in gcf)
%
case 'print'
    

%------------------------------------------------------------------------
% filtview('help')
% Callback of help button in toolbar
%
case 'help'
    fig = gcf;
    ud = get(fig,'userdata');
    if ud.pointer ~= 2   % if not in help mode
        % enter help mode
        saveEnableControls = [ud.legend.legendpopup
                              ud.legend.legendbutton
                              ud.ht.magpop
                              ud.ht.phasepop];
        ax = [ud.ht.a ud.toolbar.toolbar];
        titleStr = 'Filter Viewer Help';
        helpFcn = 'fvhelpstr';
        spthelp('enter',fig,saveEnableControls,ax,titleStr,helpFcn)
    else
        spthelp('exit')
    end
    
%------------------------------------------------------------------------
% errstr = filtview('setprefs',panelName,p)
% Set preferences for the panel with name panelName
%
% Inputs:
%   panelName - string; must be either 'ruler','color', 'filtview1', 
%               or 'filtview2'
%              (see sptprefreg for definitions)
%   p - preference structure for this panel
%
case 'setprefs'
    errstr = '';
    panelName = varargin{2};
    p = varargin{3};
    % first do error checking
    switch panelName        
    case 'filtview1'
        arbitrary_obj = {'arb' 'obj'};
        nfft = evalin('base',p.nfft,'arbitrary_obj');
        if isequal(nfft,arbitrary_obj)
            errstr = 'Sorry, the FFT Length you entered could not be evaluated';
        elseif isempty(nfft) | (round(nfft)~=nfft | nfft<=0 | ~isreal(nfft))
            errstr = ['The FFT Length must be a positive integer.'];
        end
        if isempty(errstr)
            nimp = evalin('base',p.nimp,'arbitrary_obj');
            if isequal(nimp,arbitrary_obj)
                errstr = 'Sorry, the Time Response Length you entered could not be evaluated';
            elseif ~isempty(nimp) & (round(nimp)~=nimp | nimp<=0 | ~isreal(nimp))
                errstr = ['The Time Response Length must be a positive integer' ...
                          ' or the empty matrix ''[]'' (to get the default value).'];
            end
        end
        if isempty(errstr) & (p.freqscale == 2 & p.freqrange == 3)
            errstr = ['You can''t have frequency log scaling with a negative ' ...
                      'frequency range.'];
        end
    case 'filtview2'  % tiling
    end
    
    varargout{1} = errstr;
    if ~isempty(errstr)
        return
    end
        
    % now set preferences
    fig = findobj('type','figure','tag','filtview');
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
        case 'filtview1'
            newprefs.tool.zoompersist = p.zoomFlag;
            newprefs.tool.ruler = p.rulerEnable;
            newprefs.nfft = evalin('base',p.nfft);
            newprefs.nimp = evalin('base',p.nimp);
            
            set(ud.ht.magpop,'value',p.magscale)
            set(ud.ht.phasepop,'value',p.phaseunits)
            set(ud.ht.fscalepop,'value',p.freqscale)
            set(ud.ht.frangepop,'value',p.freqrange)
                        
            newprefs.magmode = {'linear' 'log' 'decibels'};
            newprefs.magmode = newprefs.magmode{p.magscale};
            newprefs.phasemode = {'degrees' 'radians'};
            newprefs.phasemode = newprefs.phasemode{p.phaseunits};
            newprefs.freqscale = {'linear' 'log'};
            newprefs.freqscale = newprefs.freqscale{p.freqscale};
            newprefs.freqrange = p.freqrange;

            % enable / disable ruler
            if ud.prefs.tool.ruler ~= newprefs.tool.ruler
                if newprefs.tool.ruler
                    % Enable ruler and ruler popupmenu 
                    rulerPrefs = sptool('getprefs','ruler');
                    typeStr = {'vertical','horizontal','track','slope'};
                    ud.prefs.ruler.type = typeStr{rulerPrefs.initialType};
                    set(fig,'userdata',ud)

                    % Account for the case where the filter was cleared
                    % while viewing it in the filter viewer
                    if isfield(ud,'filt.tf.den')
                        realFilterFlag = (isreal(ud.filt(ud.focusIndex).tf.num)...
                            & isreal(ud.filt(ud.focusIndex).tf.den));
                    else
                        realFilterFlag = 1;
                    end

                    % Find mainaxes to focus rulers                    
                    [ud.mainaxes,ud.focusline,plotIndex,visPlots] = ...
                        setMainaxes(ud.mainaxes,ud.ht.a,ud.lines,realFilterFlag);
                    set(fig,'userdata',ud)

                    % Update rulerpopup; display (initialize) ruler panel
                    % and focus ruler on appropriate subplot
                    rulerPopStr = filtview('plotTitles',realFilterFlag);
                    rulerPopVal = min(plotIndex,length(rulerPopStr));
                    popupCallback = 'filtview(''rulerpopup'')';	
                    ruler('init',fig,rulerPopStr,rulerPopVal,...
                        popupCallback,ud.ht.a)
                    ud = get(fig,'userdata');
                    new_ud = filtview('setudlimits',ud,ud.ht.a,plotIndex);
                    set(fig,'userdata',new_ud)
                    ruler('newlimits',fig,plotIndex)
                    ruler('newsig',fig,plotIndex)
                    noTrackZeroPole(fig,new_ud)
                else
                    ruler('close',fig)
                end
                ud = get(fig,'userdata');
            end

        case 'filtview2'
            if p.mode1
                newprefs.tilemode = [2 3];
            elseif p.mode2
                newprefs.tilemode = [3 2];
            elseif p.mode3
                newprefs.tilemode = [6 1];
            elseif p.mode4
                newprefs.tilemode = [1 6];
            end
        end
        ud.prefs = newprefs;
        set(fig,'userdata',ud)

        fvresize(1,fig)
        if newprefs.tool.ruler
            ruler('resizebtns',fig)
        end
        fvzoom('zoomout',ud.prefs.plots,fig)
        filtview('plots',ud.prefs.plots,fig)

        % Update ruler's XY limits; limits might have changed due to
        % preferences changes
        if ud.prefs.tool.ruler & newprefs.tool.ruler
            ud = get(fig,'userdata');
            plotIndex = find(ud.mainaxes==ud.ht.a);
            new_ud = filtview('setudlimits',ud,ud.ht.a,plotIndex);
            set(fig,'userdata',new_ud)
            ruler('newlimits',fig,plotIndex)
            ruler('newsig',fig,plotIndex)
        end
    end
    
end  % of switch statement

function setstem(h,x,y)
%SETSTEM Set xdata and ydata of two handles for stem plots

    set(h(1),'xdata',x,'ydata',y)
    x = x(:);  % make it a column
    xx = x(:,[1 1 1])';
    xx = xx(:);
    n = nan;
    y = [zeros(size(x)) y(:) n(ones(length(x),1),:)]';
    set(h(2),'xdata',xx,'ydata',y(:));

function [mainaxes,focusline,plotIndex,visPlots] = ...
        setMainaxes(oldMainaxes,axesList,lineList,realDataFlag)
%SETMAINAXES Set a new axes (if mainaxes was set invisible), from 
%       the list of visible axes, to be the new mainaxes (where rulers
%       will be focused).  Otherwise, use the input OldMainaxes as the
%       new mainaxes.
% Inputs:
%   oldMainaxes - handle to previous mainaxes
%   axesList - list of axes handles of all possible subplots
%   lineList - structure containing the handles to each line
%              of all subplots
%   realDataFlag - flag indicating that line which rulers are focused on is
%                  real
% Outputs:
%   mainaxes - handle to the newly selected subplot axes
%   focusline - handle to the newly selected line
%   plotIndex - index into the list of the handles of all subplots
%   visPlots - indices of visible plots of vector containing
%              all subplots
%
    visPlots = find(strcmp(get(axesList,'visible'),'on'));
       
    if strcmp(get(oldMainaxes,'visible'),'off')
        oldMainaxes_indx = find(oldMainaxes == axesList);
        
        if ~isempty(visPlots)
            [dum,visPlotIndx] = min(mod(visPlots-oldMainaxes_indx,6));
            plotIndex  = visPlots(visPlotIndx);
            mainaxes = axesList(plotIndex);
            fig = get(mainaxes,'parent');
            focusIndex = sptlegend('value',fig);
            focusline = setFocusLine(mainaxes,lineList,plotIndex,...
                focusIndex,realDataFlag);
        else
            plotIndex  = 1;
            mainaxes = oldMainaxes;
            focusline = [];
        end
    else
        mainaxes = oldMainaxes;
        plotIndex = find(mainaxes == axesList);
        focusIndex = 1;
        focusline = setFocusLine(mainaxes,lineList,plotIndex,...
            focusIndex,realDataFlag);
    end					   

function updateRulrPopupList(fig,rulerPopStr,axesList,mainaxes,realFilterFlag)
% UPDATERULRPOPUPLIST Update the list of the ruler popupmenu and when
%	appropriate add '<none>' to the first element of the popup
%       string.
% Inputs:
%   fig - handle to the filtviewer
%   rulerPopStr - the string value of the ruler popupmenu
%   axesList - list of axes handles of all possible subplots
%   mainaxes - axes where rulers are currently focused
%   realFilterFlag - flag indicating if filter being viewed is real
%
    visPlots = find(strcmp(get(axesList,'visible'),'on'));
    if ~isempty(visPlots)
        plotIndex = find(mainaxes == axesList);
        rulerPopVal = plotIndex + (~realFilterFlag & plotIndex == 6);
    else    
        rulerPopStr = {'<none>',rulerPopStr{:}};
        rulerPopVal = 1;    
    end
    ruler('setpopup',fig,rulerPopStr,rulerPopVal)
           
function focusLine = setFocusLine(mainaxes,lineList,plotIndex,...
                                                 focusIndex,realDataFlag)
% SETFOCUSLINE Sets the focus line
% Inputs:
%   mainaxes - axes where rulers are currently focused
%   lineList - structure containing the handles to each line
%              of all subplots
%   plotInde - index indicating which subplot is selected
%   focusIndex - index indicating which filter is being viewed
%   realDataFlag - flag indicating that line where rulers are focused is
%                  real
% Outputs:
%   focusLine - the new line which the rulers are focused on
%

    % The following is necessary in case where there are 2 plots
    % being viewed; all filters are cleared (in SPTool) and then the
    % mainaxes plot (where the rulers were focused) is deselected .  This
    % means that mainaxes was 'on' but all the lines were empty, hence,
    % focusline should be set to [].
    allLinesEmpty = 1;
    if ~isempty(lineList)
        h = struct2cell(lineList(focusIndex));
        h = [h{:}];
        if ~isempty(h), allLinesEmpty = 0; end
    end

    if strcmp(get(mainaxes,'visible'),'off') | allLinesEmpty
        focusLine = [];
    else 
        switch plotIndex
        case 1
            focusLine = lineList(focusIndex).mag;
        case 2
            focusLine = lineList(focusIndex).phase;
        case 3
            focusLine = lineList(focusIndex).grpdelay;
        case 4           
            if ~isempty(get(lineList(focusIndex).z,'xdata'))
                focusLine = lineList(focusIndex).z;
            else
                focusLine = lineList(focusIndex).p;
            end
        case 5
            if realDataFlag
                focusLine = lineList(focusIndex).imp;
            else
                focusLine = lineList(focusIndex).impc;
            end
        case 6
            if realDataFlag
                focusLine = lineList(focusIndex).step;    
            else
                focusLine = lineList(focusIndex).stepc;
            end
        end
    end
    
function realdataFlag = realdataFlag(selectedLine,allLines,focusIndex)
% REALDATAFLAG Determines if the line chosen for the rulers to focus on is
% the real or imaginary part of the impulse or step response.
% Inputs:
%   allLines - list of all possible line objects in all subplots
%   focusIndex - index into list of filters
% Ouputs:
%   realdataFlag - flag indicating if the data is real (1 = real)
%
    l = selectedLine;
    imagLines = {'impc' 'impstemc' 'stepc' 'stepstemc'};
    realdataFlag = 1;
    for i = 1:length(imagLines)
        if ~isempty(getfield(allLines(focusIndex),imagLines{i}))...
                & (l == getfield(allLines(focusIndex),imagLines{i}))
            realdataFlag = 0;
            break
        end
    end
    
function noTrackZeroPole(fig,ud)
% NOTRACKZEROPOLE If in zero-pole plot don't allow slope and track rulers.
% Inputs:
%   fig - figure handle of client, filter viewer
%   ud - userdata of the client, filter viewer
%
    if (ud.mainaxes == ud.ht.a(4))
        ruler('allowTrack','off',fig)
    else
        ruler('allowTrack','on',fig)
    end

function bool = flisequal(fig,focusline,l)
% FLISEQUAL - FOCUS LINE IS EQUAL
%  True if focusline and l are "virtually" equivalent
%  Usually this is only true if l is actually equal to focusline
%  but when focusline is any of lines.imp, impc, stem, stemc, or z (for
%  zero-pole plot) l is considered "equal" if it is impstem, impstemc,
%  stepstem, stepstemc or p respectively.
% Inputs:
%   fig - figure handle of client (filter viewer)
%   focusline - handle of line focused on by rulers
%   l - handle of line clicked on by the mouse pointer
%   selected filters
%
     if isequal(focusline,l)
         bool = 1;
     else
         ud = get(fig,'userdata');
         tagSets = {
                    {'impline' 'implinestem'} 
                    {'implinec' 'implinestemc' 'implinedotsc'}
                    {'stepline' 'steplinestem'}
                    {'steplinec' 'steplinestemc' 'steplinedotsc'}
                    {'zerosline' 'polesline' 'unitcircle'}
                   };
         lineTag = get(l,'tag');
         flineTag = get(focusline,'tag');
         bool = 0;
         for i = 1:length(tagSets)
             if ~isempty(find(strcmp(lineTag, tagSets{i})))
                 bool = 1;
                 break
             end
         end
     end

function [lines] = emptyLinesStruct
% EMPTYLINESSTRUCT Create scalar lines structure and initialize to []
    
    lines.mag = [];   
    lines.phase = [];   
    lines.grpdelay = [];   
    lines.z = [];   
    lines.p = [];   
    lines.imp = [];   
    lines.impstem = [];   
    lines.impc = [];   
    lines.impstemc = [];   
    lines.step = [];   
    lines.stepstem = [];   
    lines.stepc = [];   
    lines.stepstemc = [];   

function [need_update,lines,focusIndex] = ...
          redundantFilters(newFilts,oldFiltSelection,oldLines,oldFocusIndex)
% REDUNDANTFILTERS - Determines if the new selection of filters contains
%        filters that were previously selected.  If so, and the filter
%        response has not changed, then it does not calculate the filter
%        response of that filter again.  Also, this functions uses lines of
%        old filters for the newly selected filters - this avoids deleting
%        and then re-creating lines.
% Inputs:
%   newFilts - new selection of filters
%   oldFiltSelection - old selection of filters (ud.filt)
%   oldLines - old lines (ud.lines)
%   oldFocusIndex - old focus index (ud.focusIndex)
% Ouputs:
%   lines - new ud.lines with possibly some recycled lines
%   focusIndex - new focus index
%
    % Find overlapping filters between new selection and old selection
    [c,ia,ib] = intersect(char({oldFiltSelection.label}),...
                          char({newFilts.label}),'rows');

    if isempty(oldFocusIndex) | isempty(ia)
        focusIndex = 1;     % arbitrarily select 1st item
    else
        if any(oldFocusIndex==ia)
            focusIndex = ib(find(oldFocusIndex == ia));
        else
            if oldFocusIndex > length(newFilts) 
                % Last filter in SPTool list was unselected; select the first
                focusIndex = 1;
            else
                focusIndex = min(find(ia > oldFocusIndex));
            end
        end
    end
    
    for i=length(ia):-1:1
        if ~isequal(oldFiltSelection(ia(i)),newFilts(ib(i)))
            ia(i) = [];
            ib(i) = [];
        end
    end
    
    % at this point, don't need to update ud.filt(ib)
    [ib,ib_sort_ind] = sort(ib);
    ia = ia(ib_sort_ind);
    need_update = 1:length(newFilts);
    need_update(ib) = [];

    % initialize empty line struct array
    lines = [];
    lines = emptyLinesStruct; % re-create lines
    lines(length(newFilts)) = lines(1);
    
    if ~isempty(ia)
        lines(ib) = oldLines(ia);
    end
    oldLines(ia) = [];
    
    % Delete any oldLines that we can't use. Won't enter loop unless we
    % have a surplus of oldLines to delete
    for j = (length(need_update)+1):length(oldLines)         
        h = struct2cell(oldLines(j));
        h = [h{:}];
        delete(h)
    end        
    
    % Use any oldLines that we can by copying them to ud.lines:
    for i = 1:min(length(oldLines),length(need_update))
        lines(need_update(i)) = oldLines(i);
    end

function [xlim1,xlim2,ylim1,ylim2] = zeropolePlotLims(filtStruct)
% ZEROPOLEPLOTLIMS Set the XY limits to the largest values of the plots
%        currently being viewed

    xlim1 = inf; xlim2 = -inf;
    ylim1 = inf; ylim2 = -inf;

    for i = 1:length(filtStruct)
        if ~isempty(filtStruct(i).zpk)
            xlim1 = min(real([xlim1; filtStruct(i).zpk.z(:); filtStruct(i).zpk.p(:)]));
            xlim2 = max(real([xlim2; filtStruct(i).zpk.z(:); filtStruct(i).zpk.p(:)]));
            ylim1 = min(imag([ylim1; filtStruct(i).zpk.z(:); filtStruct(i).zpk.p(:)]));
            ylim2 = max(imag([ylim2; filtStruct(i).zpk.z(:); filtStruct(i).zpk.p(:)]));
        end 
    end

    if isempty(xlim1)
        xlim1 = -1.5;
    end
    if isempty(xlim2)
        xlim2 = 1.5;
    end
    if isempty(ylim1)
        ylim1 = -1.5;
    end
    if isempty(ylim2)
        ylim2 = 1.5;
    end
    if xlim1 == xlim2
        xlim1 = xlim1-1;
        xlim2 = xlim2+1;
    end
    if ylim1 == ylim2
        ylim1 = ylim1-1;
        ylim2 = ylim2+1;
    end
    
function [FsStr,filtLabelStr] = filtFsLabelStrs(prefsStruct,uiHandles,...
                                                                filtsStruct)
% FILTFSLABELSTRS - Determine the string to be used for the sampling
%       frequency and the currently selected filter names.
% Inputs:
%   prefsStruct - userdata structure containing filter viewer preferences
%                (ud.prefs)
%   uiHandles - filter viewers uicontrol handles (ud.ht)
%   filtsStruct - the array of selected filter structures (ud.filt)
% Outputs:
%   FsStr - the string "Fs=" (for single filter) or "Maximum Fs =" (for
%           multiple filters)
%   filtLabelStr - the names of the filters currently selected, if they fit
%                  in the allowed space, or the string "n filters
%                  selected", where n is the number of filters selected.
%
    labelpos = get(uiHandles.filterLabel,'position');
    numFilts = length(filtsStruct);
    
    if (numFilts == 1) 
        FsStr = ['Fs = ' prefsStruct.Fs];
        filtLabelStr = ['Filter: ' filtsStruct(1).label];
    else
        if isequal([filtsStruct.Fs], ...  % All Fs is equal
                filtsStruct(1).Fs*ones(1,length(filtsStruct)))
            FsStr = ['Fs = ' prefsStruct.Fs];
        else
            FsStr = ['Maximum Fs = ' prefsStruct.Fs];
        end

        filtsStr = '';
        for i = 1:numFilts  % Loop through the selected filters
            if numFilts > 1
                if (i ~= 1), filtsStr = [filtsStr ', ']; end
                filtsStr = [filtsStr filtsStruct(i).label];
                filtLabelStr = ['Filters: ' filtsStr];           
            end
        end     % Looping through the selected filters
        
        % Determine if all the filter names will fit in space allowed
        tempstr = get(uiHandles.filterLabel,'string');
        set(uiHandles.filterLabel,'string',filtLabelStr)
        labelext = get(uiHandles.filterLabel,'extent');
        set(uiHandles.filterLabel,'string',tempstr)
        if labelext(3) > labelpos(3)+5
            filtLabelStr = [sprintf('%d', numFilts),' filters selected'];
        end
    end

function newPopupVal = cmplxFiltPopupVal(currentPopupVal, newPlottitles, ...
                                                          currentPlotTitles)
% CMPLXFILTPOPUPVAL - determine what the ruler popup value should be in the
%        cases were user switches from a complex to a real filter or vice
%        versa.
%

    newPopupVal = currentPopupVal;
    if length(newPlottitles) == length(currentPlotTitles)
        % going from complex-filter --> complex-filter   OR
        % going from real-filter    --> real-filter
        % newPopupVal does not change...
    elseif length(newPlottitles) > length(currentPlotTitles)
        % going from real-filter    --> complex-filter
        if currentPopupVal == 6
            newPopupVal = currentPopupVal + 1;
        end
    else % going from complex-filter --> real-filter
        switch currentPopupVal
        case 6,     newPopupVal = 5;
        case {7,8}, newPopupVal = 6;
        end
    end

function bringToFront(fig,focusIndx)
%bringToFront
%  reorders children of parent axis of h so that 
%   the objects with handles in h are just above all the objects
%   except for the ruler lines

   ud = get(fig,'userdata');

   for nAxis = 1:length(ud.ht.a)
       ax = ud.ht.a(nAxis);
       ch = get(ax,'children');
   
       rulerHndls = [];
       if ud.prefs.tool.ruler & (ud.mainaxes == ax)
           % make sure ruler lines are on top of stacking order
           rulerHndls = [ud.ruler.lines(:); ud.ruler.markers(:)];
       end
   
       h = [];
       for i = 1:length(ud.lines)
           if  (i==focusIndx)        % Create a vector of handles which will
               switch(nAxis)         % follow the rulers' handles in the 
               case 1                % stacking order of the children
                   h = [h;ud.lines(i).mag];
               case 2
                   h = [h;ud.lines(i).phase];
               case 3 
                   h = [h;ud.lines(i).grpdelay];
               case 4
                   h = [h;ud.lines(i).z; ud.lines(i).p];
               case 5
                   h = [h;ud.lines(i).imp; ud.lines(i).impc; ...
                   ud.lines(i).impstem; ud.lines(i).impstemc;h];
               case 6 
                   h = [h;ud.lines(i).step; ud.lines(i).stepc; ...
                       ud.lines(i).stepstem; ud.lines(i).stepstemc];
               end
           end 
       end

       orig_ch = ch;       
       for i=1:length(h)
           ch(find(ch==h(i))) = []; % Remove handles to lines of focused filter
       end
       ch = [h;ch];                % Prepend handles to lines of focused filter
       ch1 = ch;
       
       for i=1:length(rulerHndls)
           ch1(find(ch1==rulerHndls(i))) = []; % Remove handles of rulers
       end
       ch1 = [rulerHndls; ch1(:)]; % Prepend handles of ruler lines/markers*
       if ~isequal(ch1,orig_ch)  
           % avoid redraw if child order hasn't changed
           set(ax,'children',ch1)
       end
   end

