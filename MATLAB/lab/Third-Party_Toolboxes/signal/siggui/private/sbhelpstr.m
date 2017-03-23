function str = sbhelpstr(tag,fig)
%SBHELPSTR  Display Help for Signal Browser

%   Copyright (c) 1988-98 by The MathWorks, Inc.
% $Revision: 1.1 $

    str{1,1} = 'Signal Browser';
    str{1,2} = {['No help for this object (' tag ')']};

% ****                       WARNING!                       ****
% ****                                                      ****
% ****  All help text between the SWITCH TAG and OTHERWISE  ****
% ****  statements is automatically generated.  To change   ****
% ****  the help text, edit SBHELP.H and use HWHELPER to    ****
% ****  insert the changes into this file.                  ****

switch tag
case 'toolbar'
str{1,1} = 'TOOLBAR';
str{1,2} = {
' '
'You have clicked in the "Toolbar" of the Signal Browser.'
' '
'ARRAY SIGNALS'
' '
'This button is enabled any time you have selected an array signal in the'
'SPTool.  Click it to bring up a window which allows you to enter a column'
'index vector for one of the currently selected array signals.  Valid index'
'vectors are of the form ''1'' or ''1:3'' or ''[1 3 5]''.  All array signals start'
'out with only the first column displayed.'
' '
'OTHER ITEMS'
'To get help on any of the other items in the toolbar, click once on the '
'"Help" button, then click on the thing for which you want help.'
};

case 'sbzoom:mousezoom'
str{1,1} = 'MOUSE ZOOM';
str{1,2} = {
' '
'Clicking this button puts you in "Mouse Zoom" mode. In this mode, the '
'mouse pointer becomes a cross when it is inside the main axes area.  You '
'can click and drag a rectangle in the main axes, and the main axes display '
'will zoom in to that region.  If you click with the left button at a point '
'in the main axes, the main axes display will zoom in to that point for a '
'more detailed look at the data at that point.  Similarly, you can click '
'with the right mouse button (shift click on the Mac) at a point in the '
'main axes to zoom out from that point for a wider view of the data.  In '
'each case, the panner is updated to highlight the region of data displayed '
'in the main axes.'
' '
'To get out of mouse zoom mode without zooming in or out, click on the '
'Mouse Zoom button again.'
};

case 'sbzoom:zoomout'
str{1,1} = 'FULL VIEW';
str{1,2} = {
' '
'Clicking this button restores the axes limits of the plot so that all '
'signals displayed are fully viewed. '
};

case 'sbzoom:zoominy'
str{1,1} = 'ZOOM IN Y';
str{1,2} = {
' '
'Clicking this button zooms in on the signals, cutting the vertical range '
'of the main axes in half.  The x-limits (horizontal scaling) of the main '
'axes are not changed.'
};

case 'sbzoom:zoomouty'
str{1,1} = 'ZOOM OUT Y';
str{1,2} = {
' '
'Clicking this button zooms out from the signals, expanding the vertical '
'range of the main axes by a factor of two.  The x-limits (horizontal '
'scaling) of the main axes are not changed.'
};

case 'sbzoom:zoominx'
str{1,1} = 'ZOOM IN X';
str{1,2} = {
' '
'Clicking this button zooms in on the signals, cutting the horizontal range '
'of the main axes in half.  The y-limits (vertical scaling) of the main '
'axes are not changed.'
};

case 'sbzoom:zoomoutx'
str{1,1} = 'ZOOM OUT X';
str{1,2} = {
' '
'Clicking this button zooms out from the signals, expanding the horizontal '
'range of the main axes by a factor of two.  The y-limits (vertical '
'scaling) of the main axes are not changed.'
};

case 'help'
str{1,1} = 'SIGNAL BROWSER';
str{1,2} = {
' '
'This window is a Signal Browser.  It provides a graphical view of the '
'Signal objects currently selected in the SPTool.  To view a signal, just '
'click on it in the SPTool, and it is displayed here.'
' '
'The Signal Browser consists of three essential tools:'
'  1) zoom controls for getting a closer look at signal'
'     features.'
'  2) a "Panner" for seeing what part of the signal is'
'     currently being displayed, and quickly moving the'
'     view to other signal features.'
'  3) "Rulers" for making signal measurements and'
'     comparisons.'
};

str{2,1} = 'GETTING HELP';
str{2,2} = {
'To get help at any time, click once on the ''Help'' button.  The mouse '
'pointer becomes an arrow with a question mark symbol.  You can then click '
'on anything in the Signal Browser, including the options under the menu '
'items, to find out what it is and how to use it.'
};

case {'complexlabel','complexframe','complexpopup'}
str{1,1} = 'COMPLEX DISPLAY';
str{1,2} = {
' '
'The Signal Browser plots either the real, imaginary, magnitude, or angle '
'of complex signals.  When any of the variables selected in the SPTool is '
'complex, this popup menu becomes enabled. The Complex Display mode affects '
'ALL of the variables in the current selection - even those that are just '
'real.'
};

case 'mainaxes'
str{1,1} = 'MAIN AXES';
str{1,2} = {
' '
'You have clicked in the main axes of the Signal Browser.  This area '
'displays all of the signals currently selected in the SPTool.'
};

case 'mainaxesylabel'
str{1,1} = 'Y-LABEL';
str{1,2} = {
' '
'You can change the Y-Label in the Preferences for SPTool window, by '
'choosing Preferences under the File menu in SPTool and then selecting '
'Signal Browser.'
};

case 'mainaxesxlabel'
str{1,1} = 'X-LABEL';
str{1,2} = {
' '
'You can change X-Label in the Preferences for SPTool window, by choosing '
'Preferences under the File menu in SPTool and then selecting Signal '
'Browser.'
};

case 'ruler1line'
str{1,1} = 'RULER 1';
str{1,2} = {
' '
'You have clicked on Ruler 1.  Drag this indicator with the mouse to '
'measure features of your selected data.  The value of the ruler is shown '
'textually in the Ruler area on the right side of the Signal Browser window.'
};

case 'ruler2line'
str{1,1} = 'RULER 2';
str{1,2} = {
' '
'You have clicked on Ruler 2.  Drag this indicator with the mouse to '
'measure features of your selected data.  The value of the ruler is shown '
'textually in the Ruler area on the right side of the Signal Browser window.'
};

case 'slopeline'
str{1,1} = 'SLOPE';
str{1,2} = {
' '
'You have clicked on the Slope Line of the Rulers.  This line goes through '
'the points (x1,y1) and (x2,y2) defined by Ruler 1 and Ruler 2 '
'respectively.  Its slope is labeled as ''m''.  As you drag either Ruler 1 or '
'Ruler 2 left and right, the Slope Line is updated.'
};

case 'peakline'
str{1,1} = 'PEAK';
str{1,2} = {
' '
'You have clicked on a peak of the currently selected signal.  To measure '
'this peak, move one of the rulers on top of it in "track" mode.'
};

case 'valleyline'
str{1,1} = 'VALLEY';
str{1,2} = {
' '
'You have clicked on a peak of the currently selected signal. To measure '
'this valley, move one of the rulers on top of it in "track" mode. '
};

case 'ruler1button'
str{1,1} = 'FIND RULER 1';
str{1,2} = {
' '
'Click on this button to bring Ruler 1 to the center of the main axes.  '
'This button is only visible when Ruler 1 is "off the screen", that is, '
'when Ruler 1 is not visible in the main axes.'
};

case 'ruler2button'
str{1,1} = 'FIND RULER 2';
str{1,2} = {
' '
'Click on this button to bring Ruler 2 to the center of the main axes.  '
'This button is only visible when Ruler 2 is "off the screen", that is, '
'when Ruler 2 is not visible in the main axes.'
};

case {'ruleraxes','rulerlabel','rulerframe'}
str{1,1} = 'RULERS';
str{1,2} = {
' '
'This area of the Signal Browser allows you to read and control the values '
'of the rulers in the main axes.  Use the rulers to make measurements on '
'signals, such as distances between features, heights of peaks, and slope '
'information.'
};

case 'ruler:vertical'
str{1,1} = 'VERTICAL';
str{1,2} = {
' '
'Click this button to change the Rulers to Vertical mode.  In Vertical '
'mode, you can change the rulers'' x-values (i.e., horizontal position) by '
'either'
'  - dragging them left and right with the mouse, or'
'  - entering their values in the x1 and x2 edit boxes.'
' '
'The difference x2-x1 is displayed as dx.'
};

case 'ruler:horizontal'
str{1,1} = 'HORIZONTAL';
str{1,2} = {
' '
'Click this button to change the Rulers to Horizontal mode.  In Horizontal '
'mode, you can change the rulers'' y-values (i.e., vertical position) by '
'either'
'  - dragging them up and down with the mouse, or'
'  - entering their values in the y1 and y2 edit boxes.'
' '
'The difference y2-y1 is displayed as dy.'
};

case 'ruler:track'
str{1,1} = 'TRACK';
str{1,2} = {
' '
'Click this button to change the Rulers to Track mode.  This mode is just '
'like Vertical mode, in which you can change the rulers'' x-values (i.e., '
'horizontal position) by either'
'  - dragging them left and right with the mouse, or'
'  - entering their values in the y1 and y2 edit boxes.'
' '
'In Track mode, the Rulers also "track" a signal, so that you can see the '
'y-values of the signal at the x-values of the Rulers.  The value dy is '
'equal to y2-y1.  You can change which signal is tracked by clicking on a '
'signal in the main axes, or by setting the (line) "Selection" on the upper,'
'right corner of the Signal Browser.'
};

case 'ruler:slope'
str{1,1} = 'SLOPE';
str{1,2} = {
' '
'Click this button to change the Rulers to Slope mode.  This mode is just '
'like Track mode, in which you can change the rulers'' x-values (i.e., '
'horizontal position) by either'
'  - dragging them left and right with the mouse, or'
'  - entering their values in the y1 and y2 edit boxes.'
' '
'In Slope mode, the Rulers "track" a signal, so that you can see the '
'y-values of the signal at the x-values of the Rulers.  The value dy is '
'equal to y2-y1.  The line connecting (x1,y1) and (x2,y2) is included in '
'the main plot, so you can approximate derivatives and slopes of the '
'signal.  The value ''m'' is equal to dy/dx.'
' '
'You can change which signal is tracked by clicking on a signal in the main '
'axes, or by setting the (line) "Selection" in the upper right corner of the '
'Signal Browser.'
};

case 'x1label'
str{1,1} = 'X1';
str{1,2} = {
' '
'This is the X value of Ruler 1.  Change this value by dragging Ruler 1 '
'back and forth with the mouse, or clicking in the box labeled x1 and '
'typing in a number.'
};

case 'rulerbox1'
str{1,1} = 'RULER 1';
str{1,2} = {
' '
'For Vertical, Track and Slope modes:'
'  Change the value in this box to set the x-location of Ruler 1.'
' '
'For Horizontal mode:'
'  Change the value in this box to set the y-location of Ruler 1.'
' '
'When you drag Ruler 1 with the mouse, the value in this box changes '
'correspondingly.'
};

case {'y1label','y1text'}
str{1,1} = 'Y1';
str{1,2} = {
' '
'This is the Y value of Ruler 1.  '
' '
'In Track and Slope Ruler modes, y1 is the value of the signal in the main '
'axes that is being tracked by Ruler 1 (designated by (line) "Selection").'
' '
'In Horizontal Ruler mode, you can enter a value in the box labeled y1 to '
'change the position of the Ruler.'
};

case 'x2label'
str{1,1} = 'X2';
str{1,2} = {
' '
'This is the X value of Ruler 2.  Change this value by dragging Ruler 2 '
'left and right with the mouse, or clicking in the box labeled x2 and '
'typing in a number.'
};

case 'rulerbox2'
str{1,1} = 'RULER 2';
str{1,2} = {
' '
'For Vertical, Track and Slope modes:'
'  Change the value in this box to set the x-location of Ruler 2.'
' '
'For Horizontal mode:'
'  Change the value in this box to set the y-location of Ruler 2.'
' '
'When you drag Ruler 2 with the mouse, the value in this box changes '
'correspondingly.'
};

case {'y2label','y2text'}
str{1,1} = 'Y2';
str{1,2} = {
' '
'This is the Y2 value of Ruler 2.  '
' '
'In Track and Slope Ruler modes, y2 is the value of the signal in the main '
'axes that is being tracked by Ruler 2 (designated by (line) "Selection").'
' '
'In Horizontal Ruler mode, you can enter a value in the box labeled y2 to '
'change the position of the Ruler.'
};

case {'dxlabel','dxtext'}
str{1,1} = 'DX';
str{1,2} = {
' '
'Delta X value.  This is the value of x2 - x1.'
};

case {'dylabel','dytext'}
str{1,1} = 'DY';
str{1,2} = {
' '
'Delta Y value.  This is the value of y2 - y1.'
};

case {'dydxtext','dydxlabel'}
str{1,1} = 'DYDX';
str{1,2} = {
' '
'Delta Y / Delta X value.  This is the value of dy / dx.'
};

case 'ruler:peaks'
str{1,1} = 'PEAKS';
str{1,2} = {
' '
'Click on this button to see all the local maxima of the currently selected '
'signal.  Change which signal is selected by clicking on its waveform in '
'the main axes, or by choosing it in the (line) "Selection" popup menu'
'directly above the rulers.'
' '
'In track and slope mode, the rulers are constrained to the peaks in this '
'mode.  In vertical mode, the peaks are only visual and do not affect the '
'behavior of the rulers.'
' '
'It is possible to display both the peaks and valleys at the same time.'
};

case 'ruler:valleys'
str{1,1} = 'VALLEYS';
str{1,2} = {
' '
'Click on this button to see all the local minima of the currently selected '
'signal.  Change which signal is selected by clicking on its waveform in '
'the main axes, or by choosing it in the (line) "Selection" popup menu'
'directly above the rulers.'
' '
'In track and slope mode, the rulers are constrained to the valleys in this '
'mode.  In vertical mode, the valleys are only visual and do not affect the '
'behavior of the rulers.'
' '
'It is possible to display both the peaks and valleys at the same time.'
};

case 'saverulerbutton'
str{1,1} = 'SAVE RULERS';
str{1,2} = {
' '
'Clicking this button displays a dialogue box which allows you to enter a '
'variable name to save a structure in the MATLAB workspace with the fields '
'x1, y1, x2, y2, dx, dy, dydx, peaks, and valleys.'
' '
'Any undefined values will be set to NaN.'
};

case {'panaxes','pannerxlabel','pandown:0'}
str{1,1} = 'PANNER';
str{1,2} = {
' '
'This small, skinny axes is used to give a panoramic view of the signals '
'displayed in the main axes above it.  When you zoom in on the main axes, '
'the patch in the Panner highlights the section of the plot that is '
'currently in view in the main axes.  You can then drag this patch with the '
'mouse to pan across your signal data dynamically.'
};

case 'closemenu'
str{1,1} = 'CLOSE';
str{1,2} = {
' '
'Select this menu item to close the Signal Browser.  All signal selections '
'and ruler information will be lost.  Any settings you changed and saved '
'with the Preferences for SPTool window will be retained the next time you '
'open a Signal Browser.'
};

case 'playmenu'
str{1,1} = 'PLAY SOUND';
str{1,2} = {
' '
'Select this menu to play the current line Selection in its entirety '
'through your computer''s speakers (provided you have sound output '
'capabilities).  The Sample Interval of the Signal Browser is obeyed, as '
'long as it is no less than 50 Hz.  If it is less than 50 Hz, the platform '
'default is used to play the sound.'
};

case 'legendbutton'
str{1,1} = 'COLORS';
str{1,2} = {
' '
'Click on this button to change the Selected signal''s line color and / or '
'line Style.'
};

case {'legendpopup','legendline','legendpatch','legendlabel'}
str{1,1} = 'SELECTION';
str{1,2} = {
' '
'Click on this menu to choose, from the multiple selected signals of the '
'SPTool, which one signal has the ruler focus.  The selected signal''s line '
'color and style are shown in the line segment just above this menu.  The '
'ruler measurements in track and slope mode, and peaks and valleys, apply '
'to the selected signal.'
' '
'Array signals are listed in this menu as well allowing you to specify '
'which column of the array signal is the current one.  '
' '
'You can also change the selected signal by clicking on its waveform in the '
'main axes.'
};


otherwise
    %  this is a line object with tag corresponding to the
    %  variable in the workspace that it is plotting, or appended
    %  with _panner.
if ~isempty(findstr(tag,'_panner'))
tag = tag(1:end-7);
str{1,1} = 'LINE IN PANNER';
str{1,2} = {
    'You have clicked on a line in the panner.  The line you clicked'
    'corresponds to the SPTool signal'
    ['   ''' tag ''''] 
    '(or one if its columns if it is an array signal). '
    ' '
};
else
str{1,1} = 'LINE IN MAIN AXES';
str{1,2} = {
    'You have clicked on a line in the main axes.  The line you clicked'
    'corresponds to the SPTool signal'
    ['  ''' tag '''']
    '(or one if its columns if it is an array signal).'
    ' '
    'CLICK-AND-DRAG PANNING'
    ' '
    'If you click on a line in the main axes and hold down the button, you'
    'can pan around the main axes display using the clicked point as a center'
    'simply by dragging the mouse.  Note that this feature is not enabled in'
    'mouse zoom mode.'
};
end

end


