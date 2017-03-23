function cztdemo(action,s);
%CZTDEMO Demonstrates the FFT and CZT in the Signal Processing Toolbox.

%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/05/19 19:43:49 $

% Possible actions:
% initialize
% Fs
% Wmin
% Wmax
% points
% radius1
% radius2
% design

% button callbacks:
% radio
% info
% close


if nargin<1,
    action='initialize';
end;

if strcmp(action,'design'), % evaluate fft or czt
    set(gcf,'Pointer','watch');
    hndlList=get(gcf,'Userdata');
    zplaneHndl = hndlList(1);
    responseHndl = hndlList(2);
    FsHndl = hndlList(3); Fs = get(FsHndl,'UserData');
    WminHndl = hndlList(4); Wmin = get(WminHndl,'UserData');
    WmaxHndl = hndlList(5); Wmax = get(WmaxHndl,'UserData');
    pointsHndl = hndlList(6); Npoints = get(pointsHndl,'UserData');
    radius1Hndl = hndlList(7); R1 = get(radius1Hndl,'UserData');
    radius2Hndl = hndlList(8); R2 = get(radius2Hndl,'UserData');
    btn1Hndl = hndlList(9);
    btn2Hndl = hndlList(10); iir = get(btn2Hndl,'UserData');
    b = iir(1,:);  a = iir(2,:);
    closeHndl = hndlList(12);  domainHndl = get(closeHndl,'UserData');

    set(gcf,'nextplot','add')
    if (get(btn1Hndl,'UserData')==1), % FFT button checked?
       n = (ceil(Npoints*Fs / max(Wmax-Wmin,eps)));
       if n>2048, n = 2^nextpow2(n); end
       w = (0:n-1)'/n*2*pi;
       ww = (0:min(n,400)-1)'/min(n,400)*2*pi;
       axes(zplaneHndl)
       if ~isempty(domainHndl)
           set(domainHndl(1),'xdata',cos(ww),'ydata',sin(ww));
           set(domainHndl(2),'xdata',[0 cos(Wmin*2*pi/Fs)],...
                             'ydata',[0 sin(Wmin*2*pi/Fs)]);
           set(domainHndl(3),'xdata',[0 cos(Wmax*2*pi/Fs)],...
                             'ydata',[0 sin(Wmax*2*pi/Fs)]);
       else
           [domainHndl,h2,h3] = zplane(exp(j*ww),[],zplaneHndl);
           if length(h3)>1, delete(h3(2:length(h3))), end
           rcolor = get(gcf,'defaultaxescolororder');
           rcolor = rcolor(min(2,size(rcolor,1)),:);
           domainHndl(2) = line('xdata',[0 cos(Wmin*2*pi/Fs)],...
             'color',rcolor,'ydata',[0 sin(Wmin*2*pi/Fs)]);
           domainHndl(3) = line('xdata',[0 cos(Wmax*2*pi/Fs)],...
             'color',rcolor,'ydata',[0 sin(Wmax*2*pi/Fs)]);
           set(closeHndl,'UserData',domainHndl)
       end
       title('Domain of FFT')
       axes(responseHndl)
       F = fft(b,n)./fft(a,n);
       plot(w*Fs/2/pi,20*log10(abs(F)),'.')
       if (Wmin == 0)&(Wmax>=Fs*(1-1/n))
           title(sprintf('%g point FFT of elliptic bandpass filter',n));
       else
       title(sprintf('Close-up of %g point FFT of elliptic bandpass filter',n));
       end
    else % CZT button checked.
       M = Npoints; 
       A = R1*exp(j*Wmin*2*pi/Fs);
       W = ( R2/R1 )^(-1/(M-1)) * exp(-j*(Wmax-Wmin)*2*pi/Fs/(M-1)) ;
       axes(zplaneHndl)
       z = A*W.^(-(0:M-1)');
       if ~isempty(domainHndl)
           set(domainHndl,'xdata',real(z),'ydata',imag(z));
           set(domainHndl(2),'xdata',[0 R1*cos(Wmin*2*pi/Fs)],...
                             'ydata',[0 R1*sin(Wmin*2*pi/Fs)]);
           set(domainHndl(3),'xdata',[0 R2*cos(Wmax*2*pi/Fs)],...
                             'ydata',[0 R2*sin(Wmax*2*pi/Fs)]);
       else
           [domainHndl,h2,h3] = zplane(z,[],zplaneHndl);
           if length(h3)>1, delete(h3(2:length(h3))), end
           rcolor = get(gcf,'defaultaxescolororder');
           rcolor = rcolor(min(2,size(rcolor,1)),:);
           domainHndl(2) = line('xdata',[0 R1*cos(Wmin*2*pi/Fs)],...
             'color',rcolor,'ydata',[0 R1*sin(Wmin*2*pi/Fs)]);
           domainHndl(3) = line('xdata',[0 R2*cos(Wmax*2*pi/Fs)],...
             'color',rcolor,'ydata',[0 R2*sin(Wmax*2*pi/Fs)]);
           set(closeHndl,'UserData',domainHndl)
       end
       title('Domain of CZT')
       axes(responseHndl)
       w = unwrap(angle(z));
       w = linspace(Wmin,Wmax,M)*2*pi/Fs;
       
       Ga = czt(a,M,W,A);
       Gb = czt(b,M,W,A);       
       % If any elements of Ga or Gb are zero set to eps
       zeroIndxs_a=find(Ga==0);
       zeroIndxs_b=find(Gb==0);
       Ga(zeroIndxs_a)=eps; 
       Gb(zeroIndxs_b)=eps;        
       F = Gb./Ga;
       
       cla
       hold on           
       plot(w*Fs/2/pi,20*log10(abs(F)),'.')
       hold off
       title(sprintf('%g point CZT of elliptic bandpass filter',M));
    end
    xlabel('Frequency')
    ylabel('Magnitude of Transform (dB)')
    set(gca,'xlim',[Wmin Wmax])
    ylim = get(gca,'ylim');
    set(gca,'ylim',[max(-350,ylim(1)) ylim(2)])
    set(gcf,'Pointer','arrow');
    return

elseif strcmp(action,'initialize'),
    shh = get(0,'showhiddenhandles');
    set(0,'showhiddenhandles','on')
    figNumber=figure( ...
        'Name','CZT and FFT Demo', ...
        'handlevisibility','callback',...
        'integerhandle','off',...
        'NumberTitle','off');

    %[b,a]=ellip(9,3,50,[.4 .7]);   % design filter - store in btn2 userdata
    % inline filter coeffs for speed:
    b = [ 1.036215553331465e-02
     2.103525287321029e-02
     4.618180706244246e-02
     6.626949942636884e-02
     1.047645705817928e-01
     1.135461439917620e-01
     1.182161372812089e-01
     9.184711304310156e-02
     5.839803125783760e-02
    -5.115907697472721e-13
    -5.839803125883236e-02
    -9.184711304391158e-02
    -1.182161372818484e-01
    -1.135461439921812e-01
    -1.047645705820628e-01
    -6.626949942649851e-02
    -4.618180706250907e-02
    -2.103525287323005e-02
    -1.036215553332198e-02]';
    a = [ 1.000000000000000e+00
     2.616784951166920e+00
     9.010794557412463e+00
     1.664491445555174e+01
     3.429175523852171e+01
     4.935300363227517e+01
     7.526259700870287e+01
     8.775364685258239e+01
     1.063920847920586e+02
     1.018212388254725e+02
     1.008239318769620e+02
     7.874570918388088e+01
     6.397972011971305e+01
     3.962383394162555e+01
     2.603920255580061e+01
     1.187892654523706e+01
     6.065579909513929e+00
     1.633745653505110e+00
     5.883332413893858e-01]';

    %==================================
    % Set up the image axes
    axes( ...
        'Units','normalized', ...
        'Position',[0.10 0.35 0.60 0.6], ...
        'XTick',[],'YTick',[], ...
        'Box','on');
    set(figNumber,'defaultaxesposition',[0.10 0.1 0.60 0.80])
    zplaneHndl = subplot(2,1,1);
    set(gca, ...
        'Units','normalized', ...
        'XTick',[],'YTick',[], ...
        'Box','on');
    responseHndl = subplot(2,1,2);
    set(gca, ...
        'Units','normalized', ...
        'XTick',[],'YTick',[], ...
        'Box','on');

    %====================================
    % Information for all buttons (and menus)
    labelColor=[0.8 0.8 0.8];
    yInitPos=0.90;
    menutop=0.95;
    btnTop = 0.6;
    top=0.75;
    left=0.785;
    btnWid=0.175;
    btnHt=0.06;
    textHeight = 0.05;
    textWidth = 0.07;

    % Spacing between the button and the next command's label
    spacing=0.019;
    
    %====================================
    % The CONSOLE frame
    frmBorder=0.019; frmBottom=0.04; 
    frmHeight = 0.92; frmWidth = btnWid;
    yPos=frmBottom-frmBorder;
    frmPos=[left-frmBorder yPos frmWidth+2*frmBorder frmHeight+2*frmBorder];
    h=uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
	'BackgroundColor',[0.5 0.5 0.5]);

    %====================================
    % fft radio button
    btnTop = menutop-spacing;
    btnNumber=1;
    yPos=btnTop-(btnNumber-1)*(btnHt+spacing);
    labelStr='FFT';
    callbackStr='cztdemo(''radio'',1);';

    % Generic button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    btn1Hndl=uicontrol( ...
        'Style','radiobutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'value',0,'Userdata',2, ...
        'Callback',callbackStr);

    %====================================
    % czt radio button
    btnTop = menutop-spacing;
    btnNumber=2;
    yPos=btnTop-(btnNumber-1)*(btnHt+spacing);
    labelStr='CZT';
    callbackStr='cztdemo(''radio'',2);';

    % Generic button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    btn2Hndl=uicontrol( ...
        'Style','radiobutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'value',1, ...
        'UserData',[b;a], ...    % store filter coefficients here
        'Callback',callbackStr);

    yPos = yPos - spacing;

    %===================================
    % Sampling Frequency
    top = yPos - btnHt - spacing;
    labelWidth = frmWidth-textWidth-.01;
    labelBottom=top-textHeight;
	labelLeft = left;
    labelRight = left+btnWid;
    labelPos = [labelLeft labelBottom labelWidth textHeight];
    h = uicontrol( ...
		'Style','text', ...
        'Units','normalized', ...
		'Position',labelPos, ...
        'Horiz','left', ...
        'String','Fs', ...
        'Interruptible','off', ...
		'BackgroundColor',[0.5 0.5 0.5], ...
        'ForegroundColor','white');
	% Text field
    textPos = [labelRight-textWidth labelBottom textWidth textHeight];
    callbackStr = 'cztdemo(''Fs'')';
    FsHndl = uicontrol( ...
		'Style','edit', ...
        'Units','normalized', ...
		'Position',textPos, ...
		'Horiz','right', ...
		'Background','white', ...
        'Foreground','black', ...
		'String','1000','Userdata',1000, ...
        'callback',callbackStr);

    %===================================
    % Wmin frequency (1) label and text field
    labelBottom=top-2*textHeight-spacing;
	labelLeft = left;
    labelPos = [labelLeft labelBottom labelWidth textHeight];
    h = uicontrol( ...
		'Style','text', ...
        'Units','normalized', ...
		'Position',labelPos, ...
        'String','Fmin', ...
        'Horiz','left', ...
        'Interruptible','off', ...
		'Background',[0.5 0.5 0.5], ...
        'Foreground','white');
	% Text field
    textPos = [labelRight-textWidth labelBottom textWidth textHeight];
    callbackStr = 'cztdemo(''Wmin'')';
    WminHndl = uicontrol( ...
		'Style','edit', ...
        'Units','normalized', ...
		'Position',textPos, ...
		'Horiz','center', ...
		'Background','white', ...
        'Foreground','black', ...
		'String','200','Userdata',200, ...
        'Callback',callbackStr);

    %===================================
    % Wmax frequency label and text field
    labelBottom=top-3*textHeight-2*spacing;
	labelLeft = left;
    labelPos = [labelLeft labelBottom labelWidth textHeight];
    h = uicontrol( ...
		'Style','text', ...
        'Units','normalized', ...
		'Position',labelPos, ...
        'String','Fmax', ...
        'Horiz','left', ...
        'Interruptible','off', ...
		'Background',[0.5 0.5 0.5], ...
        'Foreground','white');
	% Text field
    textPos = [labelRight-textWidth labelBottom textWidth textHeight];
    callbackStr = 'cztdemo(''Wmax'')';
    WmaxHndl = uicontrol( ...
		'Style','edit', ...
        'Units','normalized', ...
		'Position',textPos, ...
		'Horiz','center', ...
		'Background','white', ...
        'Foreground','black', ...
		'String','350','Userdata',350, ...
        'Callback',callbackStr);

    %===================================
    % Number of points label and text field
    labelBottom=top-4*textHeight-3*spacing;
	labelLeft = left;
    labelPos = [labelLeft labelBottom labelWidth textHeight];
    h = uicontrol( ...
		'Style','text', ...
        'Units','normalized', ...
		'Position',labelPos, ...
        'String','Npoints', ...
        'Horiz','left', ...
        'Interruptible','off', ...
		'Background',[0.5 0.5 0.5], ...
        'Foreground','white');
	% Text field
    textPos = [labelRight-textWidth labelBottom textWidth textHeight];
    callbackStr = 'cztdemo(''points'')';
    pointsHndl = uicontrol( ...
		'Style','edit', ...
        'Units','normalized', ...
		'Position',textPos, ...
		'Horiz','center', ...
		'Background','white', ...
        'Foreground','black', ...
		'String','300','Userdata',300, ...
        'Callback',callbackStr);

    %===================================
    % Radius (1) label and text field
    labelBottom=top-5*textHeight-4*spacing;
	labelLeft = left;
    labelPos = [labelLeft labelBottom labelWidth textHeight];
    h = uicontrol( ...
		'Style','text', ...
        'Units','normalized', ...
		'Position',labelPos, ...
        'String','R1', ...
        'Horiz','left', ...
        'Interruptible','off', ...
		'Background',[0.5 0.5 0.5], ...
        'Foreground','white');
	% Text field
    textPos = [labelRight-textWidth labelBottom textWidth textHeight];
    callbackStr = 'cztdemo(''radius1'')';
    radius1Hndl = uicontrol( ...
		'Style','edit', ...
        'Units','normalized', ...
		'Position',textPos, ...
		'Horiz','center', ...
		'Background','white', ...
        'Foreground','black', ...
		'String','1','Userdata',1, ...
        'Callback',callbackStr);

    %===================================
    % Radius (2) label and text field
    labelBottom=top-6*textHeight-5*spacing;
	labelLeft = left;
    labelPos = [labelLeft labelBottom labelWidth textHeight];
    h = uicontrol( ...
		'Style','text', ...
        'Units','normalized', ...
		'Position',labelPos, ...
        'String','R2', ...
        'Horiz','left', ...
        'Interruptible','off', ...
		'Background',[0.5 0.5 0.5], ...
        'Foreground','white');
	% Text field
    textPos = [labelRight-textWidth labelBottom textWidth textHeight];
    callbackStr = 'cztdemo(''radius2'')';
    radius2Hndl = uicontrol( ...
		'Style','edit', ...
        'Units','normalized', ...
		'Position',textPos, ...
		'Horiz','center', ...
		'Background','white', ...
        'Foreground','black', ...
		'String','1','Userdata',1, ...
        'Callback',callbackStr);

    %====================================
    % The INFO button
    labelStr='Info';
    callbackStr='cztdemo(''info'')';
    helpHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',[left frmBottom+btnHt+spacing btnWid btnHt], ...
        'String',labelStr, ...
        'Callback',callbackStr);

    %====================================
    % The CLOSE button
    labelStr='Close';
    callbackStr='close(gcf)';
    closeHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',[left frmBottom btnWid btnHt], ...
        'String',labelStr, ...
        'Callback',callbackStr);

    hndlList=[zplaneHndl responseHndl FsHndl WminHndl WmaxHndl pointsHndl ...
              radius1Hndl radius2Hndl btn1Hndl btn2Hndl helpHndl closeHndl];
    set(figNumber, ...
	'Visible','on', ...
	'UserData',hndlList);

    cztdemo('design')
    set(0,'showhiddenhandles',shh)
    return

elseif strcmp(action,'Fs'),
    hndlList = get(gcf,'UserData');
    Wmax = get(hndlList(5),'UserData');
    v = get(gco,'Userdata');
    s = get(gco,'String');
    vv = eval(s,num2str(v));
    if vv<Wmax*2, vv = v; end
    vv = round(vv*100)/100;
    set(gco,'Userdata',vv,'String',num2str(vv))
    cztdemo('design')
    return

elseif strcmp(action,'Wmin'),
    hndlList = get(gcf,'UserData');
    Fs = get(hndlList(3),'UserData');
    Wmax = get(hndlList(5),'UserData');
    v = get(gco,'Userdata');
    s = get(gco,'String');
    vv = eval(s,num2str(v));
    if vv>=Wmax, vv = v; end
    vv = round(vv*100)/100;
    set(gco,'Userdata',vv,'String',num2str(vv))
    cztdemo('design')
    return

elseif strcmp(action,'Wmax'),
    hndlList = get(gcf,'UserData');
    Fs = get(hndlList(3),'UserData');
    Wmin = get(hndlList(4),'UserData');
    v = get(gco,'Userdata');
    s = get(gco,'String');
    vv = eval(s,num2str(v));
    if vv<=Wmin, vv = v; end
    vv = round(vv*100)/100;
    set(gco,'Userdata',vv,'String',num2str(vv))
    cztdemo('design')
    return

elseif strcmp(action,'points'),
    v = get(gco,'Userdata');
    s = get(gco,'String');
    vv = eval(s,num2str(v));
    hndlList=get(gcf,'Userdata');  
    if vv<length(get(hndlList(10),'UserData')), vv = v; end
    vv = round(vv*100)/100;
    set(gco,'Userdata',vv,'String',num2str(vv))
    cztdemo('design')
    return

elseif strcmp(action,'radius1'),
    v = get(gco,'Userdata');
    s = get(gco,'String');
    vv = eval(s,num2str(v));
    if vv<=0 | vv>10, vv = v; end
    vv = round(vv*1000)/1000;
    set(gco,'Userdata',vv,'String',num2str(vv))
    cztdemo('design')
    return

elseif strcmp(action,'radius2'),
    v = get(gco,'Userdata');
    s = get(gco,'String');
    vv = eval(s,num2str(v));
    if vv<=0 | vv > 10, vv = v; end
    vv = round(vv*1000)/1000;
    set(gco,'Userdata',vv,'String',num2str(vv))
    cztdemo('design')
    return

elseif strcmp(action,'radio'),
    axHndl=gca;
    hndlList=get(gcf,'Userdata');
    for i=9:10,
      set(hndlList(i),'value',0) % Disable all the buttons
    end
    set(hndlList(s+8),'value',1) % Enable selected button
    set(hndlList(9),'Userdata',s) % Remember selected button
    cztdemo('design')
    return

elseif strcmp(action,'info'),
    set(gcf,'pointer','arrow')
	ttlStr = get(gcf,'Name');
	hlpStr1= [...
         ' This demo lets you explore two different Z-tran-'
         ' sform algorithms.  They are                     '
         '    FFT - the Fast Fourier Transform             '
         '    CZT - the Chirp-Z Transform                  '
         '                                                 '
         ' The upper plot shows the transform domain, and  '
         ' the lower plot shows the transform of a band-   '
         ' pass elliptic digital filter on the points with-'
         ' in the wedge show on the upper plot. The filter '
         ' has a passband from .4 to .7 of the Nyquist     '
         ' frequency (Nyquist = Fs/2).                     '
         '                                                 '
         ' The FFT computes the Z-transform on equally     '
         ' spaced points around the unit circle.           '
         '                                                 '
         ' The CZT computes the Z-transform on a spiral    '
         ' or "chirp" contour.  The contour is defined by  '
         ' initial frequency Fmin and radius R1, and final '
         ' frequency Fmax and radius R2.                   '];
	hlpStr2 = [...
         ' Fs is the sampling frequency.                   '
         '                                                 '
         ' Fmin and Fmax define a "wedge" of the unit      '
         ' circle.                                         '
         '                                                 '
         ' Npoints is the number of Z-transform points     '
         ' computed on the unit circle in the wedge        '
         ' defined by Fmin and Fmax.                       '
         '                                                 '  
         ' With FFT, the length of the transform is        '
         ' Npoints*Fs/(Fmax-Fmin), which computes          '
         ' Npoints points in the range Fmin to Fmax.       '
         ' If you are interested in a small frequency      '
         ' range, the CZT is much more efficient           '
         ' because it can "zoom-in" on the range you       '
         ' are interested in.                              '
         '                                                 '  
         ' Filename: cztdemo.m                             '];

    myFig = gcf;
    helpfun(ttlStr,hlpStr1,hlpStr2);
    return  % avoid fancy, self-modifying code which
    % is killing the callback to this window's close button
    % if you press the info button more than once.
    % Also, a bug on Windows MATLAB is killing the 
    % callback if you hit the info button even once!

    % Protect against gcf changing -- Change close button behind
    % helpfun's back
    ch = get(gcf,'ch');
    for i=1:length(ch),
      if strcmp(get(ch(i),'type'),'uicontrol'),
        if strcmp(lower(get(ch(i),'String')),'close'),
          callbackStr = [get(ch(i),'callback') ...
            '; cztdemo(''closehelp'',' num2str(myFig) ')'];
          set(ch(i),'callback',callbackStr)
          return
        end
      end
    end
    return

elseif strcmp(action,'closehelp'),
    % Restore close button help behind helpfun's back
    ch = get(gcf,'ch');
    for i=1:length(ch),
      if strcmp(get(ch(i),'type'),'uicontrol'),
        if strcmp(lower(get(ch(i),'String')),'close'),
          callbackStr = get(ch(i),'callback');
          k = findstr('; cztdemo(',callbackStr);
          callbackStr = callbackStr(1:k-1);
          set(ch(i),'callback',callbackStr)
          break;
        end
      end
    end
    ch = get(0,'ch');
    if ~isempty(find(ch==s)), figure(s), end % Make sure figure exists

end    % if strcmp(action, ...lose all
