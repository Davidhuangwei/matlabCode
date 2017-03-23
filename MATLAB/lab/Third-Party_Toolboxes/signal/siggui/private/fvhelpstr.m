function str = fvhelpstr(tag,fig)
%FVHELPSTR  Help for Filter Viewer

%   Copyright (c) 1988-98 by The MathWorks, Inc.
% $Revision: 1.1 $

    str{1,1} = 'Filter Viewer';
    str{1,2} = {['No help for this object (' tag ')']};

% ****                       WARNING!                       ****
% ****                                                      ****
% ****  All help text between the SWITCH TAG and OTHERWISE  ****
% ****  statements is automatically generated.  To change   ****
% ****  the help text, edit FVHELP.H and use HWHELPER to    ****
% ****  insert the changes into this file.                  ****

switch tag
case 'help'
str{1,1} = 'FILTER VIEWER';
str{1,2} = {
' '
'This window is a Filter Viewer.  It allows you to view several characteristics of'
'a filter which can be loaded or designed via the SPTool. You can view any'
'combination of the magnitude and phase responses, the group delay, the pole-zero'
'plot, and the impulse and step responses of the filter. Through the Preferences'
'menu item, accessible from the File menu in SPTool, you can customize the layout'
'of the 6 subplots in the Filter Viewer.'
' '
'The Toolbar provides some information about the filter, such as the'
'variable name where the filter is stored (Filter) and the sampling'
'frequency (Fs).  The Toolbar has two zoom buttons that allow you to zoom'
'in and out of each subplot.  It contains a help button which enables you'
'to obtain help on the rest of the Filter Viewer.  It also contains a line'
'selection menu to choose, from the multiple selected filters of the SPTool,'
'which one filter has the ruler focus.  The selected filter''s line color and'
'style can also be changed from this line selection menu.'
' '
'To get help at any time, click once on the Help button.  The mouse pointer'
'becomes an arrow with a question mark symbol.  You can then click on'
'anything in the Filter Viewer, including the options under the menu items,'
'to find out what it is and how to use it.'
};

case 'closemenu'
str{1,1} = 'CLOSE MENU OPTION';
str{1,2} = {
' '
'Select this menu option to close the Filter Viewer.'
};

case 'mainframe'
str{1,1} = 'MAIN FRAME';
str{1,2} = {
' '
'In this region of the Filter Viewer, you can select which subplots to'
'display in the main window, set the scaling of various subplot axes, and'
'set the sampling frequency.'
};

case {'plotframe','plottext'}
str{1,1} = 'PLOTS FRAME';
str{1,2} = {
' '
'This frame indicates which subplots are currently displayed in the main'
'window to the right.  You can enable some or all of the plots.  Simply'
'check the corresponding box to enable a plot.  You can choose from:'
'magnitude response, phase response, group delay, pole-zero plot, impulse'
'response, and step response.'
};

case 'magcheck'
str{1,1} = 'MAGNITUDE';
str{1,2} = {
' '
'Check this box to enable the magnitude response subplot.  '
};

case {'maglist','magframe'}
str{1,1} = 'MAG SCALING';
str{1,2} = {
' '
'You can choose a scaling for the magnitude plot (linear, log, or decibels)'
'by choosing from the Magnitude popup menu.'
};

case 'phasecheck'
str{1,1} = 'PHASE';
str{1,2} = {
' '
'Check this box to enable the phase response subplot.'
};

case {'phaselist','phaseframe'}
str{1,1} = 'PHASE UNITS';
str{1,2} = {
' '
'You can choose the units for the phase (degrees or radians) by choosing'
'from the Phase popup menu.'
};

case 'groupdelay'
str{1,1} = 'GROUP DELAY';
str{1,2} = {
' '
'Check this box to enable the group delay subplot.  The group delay is'
'defined as the derivative of the phase response.'
};

case 'polezero'
str{1,1} = 'POLE-ZERO';
str{1,2} = {
' '
'Check this box to enable the pole-zero subplot.  This displays the poles'
'and zeros of the transfer function and their proximity to the unit circle.'
};

case 'impresp'
str{1,1} = 'IMPULSE RESP.';
str{1,2} = {
' '
'Check this box to enable the impulse response subplot.  This displays the'
'result of applying the filter to a discrete-time unit-height impulse at 0.'
};

case 'stepresp'
str{1,1} = 'STEP RESPONSE';
str{1,2} = {
' '
'Check this box to enable the step response subplot.  This displays the'
'result of applying the filter to a discrete-time unit-height step at 0.'
};

case {'freqframe','freqtext'}
str{1,1} = 'FREQUENCY AXIS';
str{1,2} = {
' '
'In this frame, you can set the scaling and range of the frequency axis.'
};

case {'freqsframe','freqscale','freqstext'}
str{1,1} = 'FREQ. SCALING';
str{1,2} = {
' '
'You can choose the scaling for the frequency axis (linear or log) by'
'selecting the appropriate option from this popup menu.'
};

case {'freqrframe','freqrange','freqrtext'}
str{1,1} = 'FREQ. RANGE';
str{1,2} = {
' '
'You can choose the range for the frequency axis by selecting an option from'
'this popup menu.  The options are [0, Fs/2], [0, Fs], and [-Fs/2, Fs/2],'
'where Fs in the sampling frequency displayed in the upper left-hand corner'
'of the Filter Viewer in the Toolbar.'
};

case 'toolbar'
str{1,1} = 'TOOLBAR';
str{1,2} = {
' '
'The Toolbar has four sections.  On the left it has two variables, Filter'
'and Fs, which provide filter information.  Following the two variables are'
'two zoom buttons.  On the right side of the Toolbar there is a help button'
'followed by a line selection menu to choose, from the multiple selected'
'filters of the SPTool, which one filter has the ruler focus.  The selected'
'filter''s line color and style can also be changed from this line selection'
'menu.'
' '
'The two variables, Filter and Fs, contain the filter name and its sampling'
'frequency, respectively, of the filter design currently selected. You can'
'change these using the edit menu of the SPTool.  When viewing multiple'
'filters which don''t all have the same sampling frequency the largest'
'sampling frequency will be used.  Also, when viewing multiple filters where'
'the names of all the selected filters do not fit in the allowed space the'
'number of filters selected will be displayed instead of the names of the'
'individual filters selected.'
};

case 'fvzoom:mousezoom'
str{1,1} = 'MOUSE ZOOM';
str{1,2} = {
' '
'Clicking this button puts you in "Mouse Zoom" mode. In this mode, the mouse'
'pointer becomes a cross when it is inside any of the six subplot areas.'
'You can click and drag a rectangle in a subplot, and the axes display will'
'zoom in to that region.  If you click with the left button at a point in a'
'subplot, the axes display will zoom in to that point for a more detailed'
'look at the data at that point.  Similarly, you can click with the right'
'mouse button (shift click on a Mac) at a point in a subplot to zoom out'
'from that point for a wider view of the data.'
' '
'To get out of the mouse zoom mode without zooming in or out, click on the'
'Mouse Zoom button again.'
' '
'ZOOM PERSISTENCE'
' '
'Normally you leave zoom mode as soon as you zoom in or out once.  In order'
'to zoom in or out again, the Mouse Zoom button must be clicked again.'
'However, the mouse zoom mode will remain enabled after a zoom if the box'
'labeled ''Stay in Zoom Mode after Zoom'' is checked in the Preferences for'
'SPTool window.  The Preferences for SPTool window can be opened by'
'selecting Preferences under the File menu in SPTool.'
};

case 'fvzoom:zoomout'
str{1,1} = 'FULL VIEW';
str{1,2} = {
' '
'Clicking this button restores the axes limits of all the subplots.'
};

case 'magaxes'
str{1,1} = 'MAGNITUDE';
str{1,2} = {
' '
'This axes displays the magnitude of the frequency response of the currently'
'selected filters.'
};

case 'phaseaxes'
str{1,1} = 'PHASE';
str{1,2} = {
' '
'This axes displays the phase of the frequency response of the currently'
'selected filters.'
};

case 'delayaxes'
str{1,1} = 'GROUP DELAY';
str{1,2} = {
' '
'This axes displays the group delay (defined as the derivative of the phase'
'of the frequency response) of the currently selected filters.'
};

case 'pzaxes'
str{1,1} = 'POLE-ZERO';
str{1,2} = {
' '
'This axes displays the poles and zeros of the transfer function of the'
'currently selected filters in relationship to the unit circle.'
};

case 'impaxes'
str{1,1} = 'IMPULSE RESPONSE';
str{1,2} = {
' '
'This axes displays the response of the currently selected filters to a'
'discrete-time unit-height impulse at 0.'
};

case 'stepaxes'
str{1,1} = 'STEP RESPONSE';
str{1,2} = {
' '
'This axes displays the response of the currently selected filters to a'
'discrete-time unit-height step function.'
};

case 'magline'
str{1,1} = 'MAGNITUDE RESP.';
str{1,2} = {
' '
'This line is the magnitude of the frequency response of one of the'
'currently selected filters.  When not in mouse zoom mode, you can click and'
'drag on the response to move it around this subplot.'
};

case 'phaseline'
str{1,1} = 'PHASE RESPONSE';
str{1,2} = {
' '
'This line is the phase of the frequency response of one of the currently'
'selected filters.  When not in mouse zoom mode, you can click and drag on'
'the response to move it around this subplot.'
};

case 'delayline'
str{1,1} = 'GROUP DELAY';
str{1,2} = {
' '
'This line is the group delay (defined as the derivative of the phase of the'
'frequency response) of the currently selected filters.  When not in mouse'
'zoom mode, you can click and drag on the line to move it around this'
'subplot.'
};

case {'implinedots','implinestem'}
str{1,1} = 'IMPULSE RESP.';
str{1,2} = {
' '
'This stem plot is the response of the currently selected filters to a'
'discrete-time unit-height impulse at 0.  When not in mouse zoom mode, you'
'can click and drag on the response to move it around this subplot.'
};

case {'steplinedots','steplinestem'}
str{1,1} = 'STEP RESPONSE';
str{1,2} = {
' '
'This stem plot is the response of the currently selected filters to a'
'discrete-time unit-height step function.  When not in mouse zoom mode, you'
'can click and drag on the response to move it around this subplot.'
};

case 'polesline'
str{1,1} = 'POLE';
str{1,2} = {
' '
'This ''x'' represents a pole of the transfer function of the current'
'filter.'
};

case 'zerosline'
str{1,1} = 'ZERO';
str{1,2} = {
' '
'This ''o'' represents a zero of the transfer function of one of the currently'
'selected filters.'
};

case 'unitcircle'
str{1,1} = 'UNIT CIRCLE';
str{1,2} = {
' '
'This dotted line is the unit circle.  Depending on the type of filter,'
'the proximity of the poles and zeros to the unit circle may yield'
'information about the frequency response.'
};

case 'ruler1line'
str{1,1} = 'RULER 1';
str{1,2} = {
' '
'You have clicked on Ruler 1.  Drag this indicator with the mouse to measure'
'features of your selected data.  The value of the ruler is shown textually'
'in the Ruler area on the right side of the Filter Viewer window.'
};

case 'ruler2line'
str{1,1} = 'RULER 2';
str{1,2} = {
' '
'You have clicked on Ruler 2.  Drag this indicator with the mouse to measure'
'features of your selected data.  The value of the ruler is shown textually'
'in the Ruler area on the right side of the Filter Viewer window.'
};

case 'slopeline'
str{1,1} = 'SLOPE';
str{1,2} = {
' '
'You have clicked on the Slope Line of the Rulers.  This line goes through'
'the points (x1,y1) and (x2,y2) defined by Ruler 1 and Ruler 2 respectively.'
'Its slope is labeled as ''m''.  As you drag either Ruler 1 or Ruler 2 left'
'and right, the Slope Line is updated.'
};

case 'peakline'
str{1,1} = 'PEAK';
str{1,2} = {
' '
'You have clicked on a peak of the currently selected filter.  To measure'
'this peak, move one of the rulers on top of it in "track" mode.'
};

case 'valleyline'
str{1,1} = 'VALLEY';
str{1,2} = {
' '
'You have clicked on a peak of the currently selected filter. To measure'
'this valley, move one of the rulers on top of it in "track" mode.'
};

case 'ruler1button'
str{1,1} = 'FIND RULER 1';
str{1,2} = {
' '
'Click on this button to bring Ruler 1 to the center of the main axes.  This'
'button is only visible when Ruler 1 is "off the screen", that is, when'
'Ruler 1 is not visible in the main axes.'
};

case 'ruler2button'
str{1,1} = 'FIND RULER 2';
str{1,2} = {
' '
'Click on this button to bring Ruler 2 to the center of the main axes.  This'
'button is only visible when Ruler 2 is "off the screen", that is, when'
'Ruler 2 is not visible in the main axes.'
};

case {'ruleraxes','rulerlabel','rulerframe'}
str{1,1} = 'RULERS';
str{1,2} = {
' '
'This area of the Filter Viewer allows you to read and control the values of'
'the rulers in the main axes.  Use the rulers to make measurements on'
'filters, such as distances between features, heights of peaks, and slope'
'information.'
};

case 'ruler:vertical'
str{1,1} = 'VERTICAL';
str{1,2} = {
' '
'Click this button to change the Rulers to Vertical mode.  In Vertical mode,'
'you can change the rulers'' x-values (i.e., horizontal position) by either'
'  - dragging them left and right with the mouse, or'
'  - entering their values in the x1 and x2 edit boxes.'
' '
'The difference x2-x1 is displayed as dx.'
};

case 'ruler:horizontal'
str{1,1} = 'HORIZONTAL';
str{1,2} = {
' '
'Click this button to change the Rulers to Horizontal mode.  In Horizontal'
'mode, you can change the rulers'' y-values (i.e., vertical position) by'
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
'Click this button to change the Rulers to Track mode.  This mode is just'
'like Vertical mode, in which you can change the rulers'' x-values (i.e.,'
'horizontal position) by either'
'  - dragging them left and right with the mouse, or'
'  - entering their values in the y1 and y2 edit boxes.'
' '
'In Track mode, the Rulers also "track" a filter''s response, so that you can'
'see the y-values of the filter''s response at the x-values of the Rulers.'
'The value dy is equal to y2-y1.  You can change which filter is tracked by'
'clicking on a filter in the main axes, or by setting the "Selection" on the'
'upper, right of the Filter Viewer.'
' '
'Track mode is not available in the pole-zero plot.'
};

case 'ruler:slope'
str{1,1} = 'SLOPE';
str{1,2} = {
' '
'Click this button to change the Rulers to Slope mode.  This mode is just'
'like Track mode, in which you can change the rulers'' x-values (i.e.,'
'horizontal position) by either'
'  - dragging them left and right with the mouse, or'
'  - entering their values in the y1 and y2 edit boxes.'
' '
'In Slope mode, the Rulers "track" a filter''s response, so that you can see'
'the y-values of the filter''s response at the x-values of the Rulers.  The'
'value dy is equal to y2-y1.  The line connecting (x1,y1) and (x2,y2) is'
'included in the main plot, so you can approximate derivatives and slopes of'
'the filter''s response.  The value ''m'' is equal to dy/dx.'
' '
'You can change which filter is tracked by clicking on a filter response in'
'any axes, or by setting the "Selection" in the upper right corner of the'
'Filter Viewer.'
' '
'Slope mode is not available in the pole-zero plot.'
};

case 'x1label'
str{1,1} = 'X1';
str{1,2} = {
' '
'This is the X value of Ruler 1.  Change this value by dragging Ruler 1 back'
'and forth with the mouse, or clicking in the box labeled x1 and typing in a'
'number.'
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
'When you drag Ruler 1 with the mouse, the value in this box changes'
'correspondingly.'
};

case {'y1label','y1text'}
str{1,1} = 'Y1';
str{1,2} = {
' '
'This is the Y value of Ruler 1.  '
' '
'In Track and Slope Ruler modes, y1 is the value of the filter response axes'
'that is being tracked by Ruler 1 (designated by Selection).'
' '
'In Horizontal Ruler mode, you can enter a value in the box labeled y1 to'
'change the position of the Ruler.'
};

case 'x2label'
str{1,1} = 'X2';
str{1,2} = {
' '
'This is the X value of Ruler 2.  Change this value by dragging Ruler 2 left'
'and right with the mouse, or clicking in the box labeled x2 and typing in a'
'number.'
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
'When you drag Ruler 2 with the mouse, the value in this box changes'
'correspondingly.'
};

case {'y2label','y2text'}
str{1,1} = 'Y2';
str{1,2} = {
' '
'This is the Y2 value of Ruler 2.  '
' '
'In Track and Slope Ruler modes, y2 is the value of the filter''s response in'
'the main axes that is being tracked by Ruler 2 (designated by Selection).'
' '
'In Horizontal Ruler mode, you can enter a value in the box labeled y2 to'
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
'Click on this button to see all the local maxima of the currently selected'
'filter response.  Change which filter is selected by clicking on any filter'
'response in any axes, or by choosing it in the Selection popup menu'
'directly above the rulers.'
' '
'In track and slope mode, the rulers are constrained to the peaks in this'
'mode.  In vertical mode, the peaks are only visual and do not affect the'
'behavior of the rulers.'
' '
'It is possible to display both the peaks and valleys at the same time.'
' '
'You can''t select peaks nor valleys in the pole-zero plot.'
};

case 'ruler:valleys'
str{1,1} = 'VALLEYS';
str{1,2} = {
' '
'Click on this button to see all the local minima of the currently selected'
'filter response.  Change which filter is selected by clicking on any filter'
'response in any axes, or by choosing it in the Selection popup menu'
'directly above the rulers.'
' '
'In track and slope mode, the rulers are constrained to the valleys in this'
'mode.  In vertical mode, the valleys are only visual and do not affect the'
'behavior of the rulers.'
' '
'It is possible to display both the peaks and valleys at the same time.'
' '
'You can''t select peaks nor valleys in the pole-zero plot.'
};

case 'saverulerbutton'
str{1,1} = 'SAVE RULERS';
str{1,2} = {
' '
'Clicking this button displays a dialogue box which allows you to enter a'
'variable name to save a structure in the MATLAB workspace with the fields'
'x1, y1, x2, y2, dx, dy, dydx, peaks, and valleys.'
' '
'Any undefined values will be set to NaN.'
};

case 'legendbutton'
str{1,1} = 'COLORS';
str{1,2} = {
' '
'Click on this button to change the Selected filter''s response line color'
'and/or line Style.'
};

case {'legendpopup','legendline','legendpatch','legendlabel'}
str{1,1} = 'SELECTION';
str{1,2} = {
' '
'Click on this menu to choose, from the multiple selected filters in the'
'SPTool, which one filter has the ruler focus.  The selected filter''s line'
'color and style are shown in the line segment just above this menu.  The'
'ruler measurements in track and slope mode, and peaks and valleys, apply to'
'the selected filter''s response.'
' '
'You can also change the selected filter by clicking on the desired filter'
'response in any of the subplots.'
};

case 'rulerpopup'
str{1,1} = 'RULERPOPUP';
str{1,2} = {
' '
'Click on this menu to choose which subplot, from the six possible subplots'
'containing filter responses, that you want the rulers to focus.  Selecting'
'a subplot that is not visible makes that subplot visible and moves the'
'rulers to that subplot.'
};


otherwise

str{1} = {
    'HELP for FILTVIEW'
    ' '
    'You have clicked on an object with tag'
    ['   ''' tag ''''] 
};

end

