function printcomp(varargin) 
%PRINTCOMP Create and display a print preview of SPTool GUI components.

% Copyright (c) 1988-98 by The MathWorks, Inc.
% $Date: 1998/06/02 14:02:11 $ $Revision: 1.2 $

switch varargin{1}

case {'prev', 'prnt', 'pgepos'}, % Selection from component's 'File' menu
   % Get specific information from the given component 
   compInfoStruct = getcompinfo(gcbf);
   
   % Generate preview figure
   [hFigPrev, prevInfoStruct] = preview(compInfoStruct); 
   
   % Store the preview information in UserData of preview figure
   set(hFigPrev,'UserData',prevInfoStruct); 
   
   % Set units to normalized so axes resize correctly
   setaxesnorm(hFigPrev);
   
   if strcmp(varargin{1}, 'prev'),
      set(hFigPrev,'Visible','on');         % Preview selected
   elseif strcmp(varargin{1}, 'prnt')       % Print selected, don't show preview
      prnt_prev_fig(hFigPrev,'prnt');
   else 
      prnt_prev_fig(hFigPrev,'pgepos');     % Page Position selected
   end
   
case 'prevprnt',                            % "Print" ui selected in preview figure
   % Print preview figure
   prnt_prev_fig(gcbf,'prevprnt');
   
case 'resizemenubar',
   % Resize menubar if preview window is resized
   prevInfoStruct = get(gcbf,'UserData');
   resizemenubar(prevInfoStruct.menubarhndls);
end 

%%%%%%%%%%%%%%%%%%%%%%%%
%   Subfunctions       %
%%%%%%%%%%%%%%%%%%%%%%%%


function compInfoStruct = getcompinfo(hFigPrev);
%GETCOMPINFO  Build a structure of information for one (at a time) of 
%             sptool's components for printing.  The handle of the 
%             component is the input argument.

showhid = get(0,'ShowHiddenHandles');
set(0,'ShowHiddenHandles','on');

% Get information common to all components
ud = get(gcf,'UserData'); 
compInfoStruct.name = get(gcbf,'Name');
compInfoStruct.tag = get(gcbf,'Tag');
compInfoStruct.pos = get(gcbf,'Position'); 
compInfoStruct.prefs = ud.prefs; 
set(0,'ShowHiddenHandles',showhid); % Turn HiddenHandles back

% For all components but Filter Designer
if ~strcmp(compInfoStruct.name, 'filtdes'),  
   compInfoStruct.opts(1).name = 'mainaxes'; % compInfoStruct.opts is an array of structures  
   compInfoStruct.opts(1).value =  ud.mainaxes;
   if ud.prefs.tool.ruler, 
      compInfoStruct.opts(end+1).name = 'ruler';  
      compInfoStruct.opts(end).value = ud.ruler; 
   end  
end

switch compInfoStruct.tag
   
% Get information specific to each component
case 'sigbrowse',
   if ud.prefs.tool.panner,
     compInfoStruct.opts(end+1).name = 'panner'; 
     compInfoStruct.opts(end).value = ud.panner; 
  end
  
case 'filtview',
% Filter Viewer
  
case 'filtdes',
% Filter Designer
  
case 'spectview',
   compInfoStruct.opts(end+1).name = 'spect';    
   compInfoStruct.opts(end).value = ud.spect;
   compInfoStruct.opts(end+1).name = 'methods';    
   compInfoStruct.opts(end).value = ud.methods;
   compInfoStruct.opts(end+1).name = 'lines';    
   compInfoStruct.opts(end).value = ud.lines; 
end 

% end of getcompinfo
% ---------------------------------------------------------------------------------


function [hFigPrev, prevInfoStruct] = preview(compInfoStruct)
%PREVIEW  Generate a print preview for a component of sptool.

% Necessary because of bug in pagedlg
stale_hFigPrev = findobj('Tag','PrntPrev');
if ishandle(stale_hFigPrev),
   close(stale_hFigPrev);
end

% Create figure for preview
hFigPrev = figure('Position',compInfoStruct.pos, ...
                'Name',[compInfoStruct.name ' Print Preview'],...
                'NumberTitle','off',...
                'ResizeFcn','printcomp(''resizemenubar'')',...
                'Tag','PrntPrev',...
                'PaperPositionMode','auto',... 
                'IntegerHandle','off',...
                'MenuBar','none',...
                'HandleVisibility','on',...
                'Visible','off');
             
% Axes to place Box around entire preview figure
axes('Units','Norm','Position',[0 0 1 1],...
     'XTick',[],'YTick',[],'Box','on','Color','none');
             
for i =1:length(compInfoStruct.opts),
   
   switch compInfoStruct.opts(i).name
      
   case 'mainaxes',          
      set(hFigPrev,'Position',compInfoStruct.pos); % Set preview position to component position
      % Copy mainaxes to preview figure
      hmaxes = copyobj(compInfoStruct.opts(i).value, hFigPrev); 
      set(hmaxes,'Units','Pixels','HandleVisibility','on'); 
      
      % Clear 'ButtonDownFcn' for children of main axes (ruler lines)
      hchildMax = get(hmaxes,'Children');
      set(hchildMax,'ButtonDownFcn','');
      
      % Build a structure of preview information
      prevInfoStruct.prevItem(i).name = 'mainaxes';
      prevInfoStruct.prevItem(i).axhandle = hmaxes;
      prevInfoStruct.prevItem(i).pos = get(hmaxes,'Position');  
           
   case 'ruler',
      % Get Ruler Values       
      [rulervals, rulerlbls] = getrulervals(compInfoStruct.opts(i).value); 
      
      % Create frame (by making an axes) to display ruler values
      hraxes = axes('Ytick',[],'Xtick',[],'Visible','off',...  
                    'Box','on','Color','none','Tag','ruler',...
                    'Units','Pixels');
      hrxlabel = xlabel('Ruler Values'); 
      
      % Create text to display ruler values and labels.
      hrvalstxt = createrulervalstxt(hraxes, rulervals, rulerlbls);
      
      prevInfoStruct.prevItem(i).name = 'ruler'; 
      prevInfoStruct.prevItem(i).axhandle = hraxes;
      prevInfoStruct.prevItem(i).pos = get(hraxes,'Position'); 

      % Ruler specific information
      prevInfoStruct.rulerinfo.rulervals = rulervals;
      prevInfoStruct.rulerinfo.rulerlbls = rulerlbls;
      prevInfoStruct.rulerinfo.hrvalstxt = hrvalstxt;      
      
   case 'panner',
      % Copy panaxes to preview figure
      hpaxes = copyobj(compInfoStruct.opts(i).value.panaxes, hFigPrev); 
      set(hpaxes,'Units','Pixels');
      % Change color of panner xlabel because when copied to preview
      % it becomes white. See private/panner.m  
      hxlbl = get(hpaxes,'Xlabel');
      set(hxlbl,'Color',[0 0 0]);      
      
      prevInfoStruct.prevItem(i).name = 'panaxes';
      prevInfoStruct.prevItem(i).axhandle = hpaxes; 
      prevInfoStruct.prevItem(i).pos = get(hpaxes,'Position');
      
   case 'spect',
      [hspecs, specStrs] = getSpecInfo(compInfoStruct.opts(:));
      
      prevInfoStruct.specinfo.hspecs = hspecs;
      prevInfoStruct.specinfo.specStrs = specStrs;
   end
end

% Set position of preview information being printed
setpos(hFigPrev, prevInfoStruct);

% Turn on the "Print" and "Close" uicontrols in the preview figure
prevInfoStruct.menubarhndls = menubar_on(hFigPrev);

% end of preview
% ---------------------------------------------------------------------------------


function resizemenubar(menubar_hndls)
%RESIZEMENUBAR  Resizes the preview menubar when window is resized. 

% Get specific information from the preview figure
hFigPrev = gcbf;
old_units = get(hFigPrev,'Units');
set(hFigPrev,'Units','pixels');
figpos = get(hFigPrev,'Position');

% Set the new positions of the uicontrols
uibarpos = [2, figpos(4)-20, figpos(3)-3, 20];
set(menubar_hndls.huibar ,'Position',uibarpos);

uiprntpos = [uibarpos(1)+10, figpos(4)-20, 50, 20];
set(menubar_hndls.huiprnt,'Position',uiprntpos);

uiclsepos = [uiprntpos(1)+uiprntpos(3)+10, figpos(4)-20, 50, 20];
set(menubar_hndls.huiclse,'Position',uiclsepos);

set(hFigPrev,'Units', old_units);

% end of resizemenubar
% ---------------------------------------------------------------------------------


function h = menubar_on(hFigPrev)
%MENUBAR_ON  Uicontrols for print and close in the preview figure.


h.huibar = uicontrol(hFigPrev,...
                           'Style','text',...
                           'Tag','pprevbarui');

h.huiprnt = uicontrol(hFigPrev,...
                            'Style','Push',...
                            'String','Print...',...
                            'Tag','pprevui',...
                            'CallBack','printcomp(''prevprnt'')');
                         
h.huiclse = uicontrol(hFigPrev,...
                            'Style','Push',...
                            'String','Close',...
                            'Tag','ppcloseui',...
                            'CallBack','closereq;');

resizemenubar(h);

% end of menubar_on
% ---------------------------------------------------------------------------------


function [rulervals, rulerlbls] = getrulervals(rulerstruct)
%GETRULERVALS  Get ruler values to display.

field_name = fieldnames(rulerstruct.value);
rulervals = []; % Initialize ruler value 
rulerlbls = {}; % and label cell arrays

for i = 1:length(field_name),
   if ~isnan(getfield(rulerstruct.value,field_name{i})), % Get all non-NaN values
      rulervals(end+1) = getfield(rulerstruct.value,field_name{i}); 
      rulerlbls{end+1} = field_name{i}; 
   end
end

% Need to check if 'type' is track and not display last value and label.
% There's a bug in Sigbrowse that doesn't set the slope value to NaN when not
% in slope mode.
if strcmp(rulerstruct.type, 'track') & length(field_name)==length(rulervals),
      rulervals = rulervals(1:end-1); % All but the last (for the dydx case)
      rulerlbls = rulerlbls(1:end-1); %  "   "  last label
end

% Need to check if 'type' is slope and display the last label as "m" and not "dydx."
if strcmp(rulerstruct.type, 'slope') 
   rulerlbls{end} = 'm'; 
end


% end of getrulervals
% ---------------------------------------------------------------------------------


function hrvalstxt = createrulervalstxt(hraxes, rulervals, rulerlbls)
%CREATERULERVALSTXT Creates the text objects to display the Ruler values.

for k = 1:length(rulervals),
   hrvalstxt(k) = text(10*k, 20, [rulerlbls{k} ': 'num2str(rulervals(k),4)]);
   set(hrvalstxt(k),'Visible','off','Units','Pixels');
end

% end of createrulervalstxt
% ---------------------------------------------------------------------------------


function prnt_prev_fig(hndl_prev, prnt_option)
%PRNT_PREV_FIG Prints the preview figure.

% Need to turn visiblity off for uicontrols (or else the figure is displayed)
prevInfoStruct = get(hndl_prev,'UserData');
menubar_off(prevInfoStruct.menubarhndls);

if strcmp(prnt_option,'pgepos'),
   dlg = pagesetupdlg(hndl_prev);  
   % Don't close the figure because of a bug in pagedlg
else
   printdlg(hndl_prev);
   close(hndl_prev);
end

% end of prnt_prev_fig
% ---------------------------------------------------------------------------------


function menubar_off(menubar_hndls)
%MENUBAR_OFF  Turn off visibility of the "Print" and "Close" uicontrols. 
%            
set(menubar_hndls.huibar,'Visible','off');
set(menubar_hndls.huiprnt,'Visible','off');
set(menubar_hndls.huiclse,'Visible','off');

% end of menubar_off
% ---------------------------------------------------------------------------------


function  setaxesnorm(hndl_prev);
%SETAXESNORM Set units to normalized so axes resize correctly

set(hndl_prev,'Units','Norm');

prevInfoStruct = get(hndl_prev,'UserData');
set([prevInfoStruct.prevItem(:).axhandle], 'Units','Norm'); % Mainaxes, panaxes, and ruler

if isfield(prevInfoStruct,'rulerinfo'),
   set([prevInfoStruct.rulerinfo.hrvalstxt], 'Units','Norm');
end

% end of setaxesnorm
% ---------------------------------------------------------------------------------


function setpos(hFigPrev, previnfo)
%SETPOS  Sets the position of the different information being printed.

% These positions will be set later depending on whether or not these items 
% will be printed; Please do not change these values.
ruler_ax_pos = [0 0 0 0];
panner_ax_pos = [0 0 0 0];
space_between_ax = 20;  % Vertical spacing between axes

% Get component position 
figpos = get(hFigPrev,'Position');

% Set dimensions for items
main_ax_left_edge = 57; 
main_ax_bottom_edge = 28;
main_ax_wdth = figpos(3)-100; 
main_ax_hght = 325; 
main_ax_pos = [main_ax_left_edge main_ax_bottom_edge main_ax_wdth main_ax_hght]; 

% Determining what items exist and their respective widths and heights
for indx = 1:length(previnfo.prevItem),
   switch previnfo.prevItem(indx).name
      
   case 'mainaxes',
      hmainaxes = (previnfo.prevItem(indx).axhandle);
      
   case 'ruler',
      ruler_ax_pos(4) = 25; % Need height (arbitrary) to determine how much to move up others
      hruleraxes = (previnfo.prevItem(indx).axhandle);
              
   case 'panaxes',
      pos = previnfo.prevItem(indx).pos; 
      panner_ax_pos(4) = pos(4);
      hpanner = (previnfo.prevItem(indx).axhandle);
      
   end
end
% Vertical space multiplier
vspace_multi = sum(([main_ax_pos(2) ruler_ax_pos(4) panner_ax_pos(4)]~=0))-1;

% Set the positions of items that exist

% Offset for mainaxes Y position and height relative to the other items
offset = main_ax_pos(2)+ruler_ax_pos(4)+panner_ax_pos(4)+(vspace_multi*space_between_ax);
main_ax_pos = [main_ax_left_edge main_ax_bottom_edge+offset main_ax_wdth main_ax_hght-offset];
set(hmainaxes,'Position', main_ax_pos);
      
if exist('hruleraxes'), % If rulers are selected
   set(hruleraxes,'Position',[main_ax_left_edge main_ax_bottom_edge main_ax_wdth ruler_ax_pos(4)],...
       'Visible','on');
    
    % Set the positions for the text of ruler values based on the ruler axes
    ruler_pos = get(hruleraxes,'Position');    
    horzspace = (ruler_pos(3)-20)/length(previnfo.rulerinfo.rulervals); % Subtract 20 from Ruler axes
    ypos = ruler_pos(4)/2;                                              % width to make sure values appear 
    for k = 1:length(previnfo.rulerinfo.rulervals),                     % within axes
       xpos(k) = 7 + (k-1)*horzspace;
       set(previnfo.rulerinfo.hrvalstxt(k),'Position',[xpos(k) ypos],'Visible','on');
    end    
 end

if exist('hpanner'), % If panner is selected
   panner_bottom_edge = main_ax_bottom_edge + ruler_ax_pos(4) + (vspace_multi-1)*space_between_ax;
   set(hpanner,'Position',[main_ax_left_edge panner_bottom_edge main_ax_wdth panner_ax_pos(4)]);
end

% Spectrum Viewer: Need to put legend on axes after the main axes position is set
if isfield(previnfo, 'specinfo'),
   prevFont = get(hmainaxes,'FontName'); % Change FontName so that strings in legend
   set(hmainaxes,'FontName','Courier');  % line up properly.   
   % Call legend here instead of in the "preview" so that legend is positioned correctly
   legend(hmainaxes, previnfo.specinfo.hspecs, previnfo.specinfo.specStrs);  
   set(hmainaxes,'FontName',prevFont);
end


% end of setpos
% ---------------------------------------------------------------------------------


function [hspecs, specStrs] = getSpecInfo(spectrumStruct)
%GETSPECINFO    Get the spectrum legend information.

% Index for "spect", "lines", and "methods" 
indxs = strmatch('spect',{spectrumStruct(:).name});
indxl = strmatch('lines',{spectrumStruct(:).name});
indxm = strmatch('methods',{spectrumStruct(:).name});

% Get spectra handles, labels(i.e. spect1, spect2, ...) and method name
for h = 1:length(spectrumStruct(indxs).value),
   hspecs(h) = spectrumStruct(indxl).value(h).h;
   Lbl{h} = spectrumStruct(indxs).value(h).label;
   methodName(h) = spectrumStruct(indxs).value(h).specs.methodName(spectrumStruct(indxs).value(h).specs.methodNum);
   
   % Get index for current "Method Name" from ud.methods(:).methodName 
   indxmethNam = strmatch(methodName{h}, {spectrumStruct(indxm).value(:).methodName});
   
   % Find index for "Nfft" label from ud.methods(:).label
   % Check if "methodName" is "Welch" or "MUSIC" and set the Index for the Nfft Label 
   % manually.  There is a bug (geck # 40830) with the ud.methods structure which 
   % doesn't allow strmatch to find "Nfft" for these two cases.
   if strcmp(methodName{h}, 'Welch'),
      indxNfftLbl = 1;                % First parameter down from "Method"
   elseif strcmp(methodName{h}, 'MUSIC')
      indxNfftLbl = 3;                % third   "         "    "    "
   else
      indxNfftLbl = strmatch('Nfft', spectrumStruct(indxm).value(indxmethNam).label);
   end
   
   % Actual Nfft value
   numfft{h} = spectrumStruct(indxs).value(h).specs.valueArrays{spectrumStruct(indxs).value(h).specs.methodNum}{indxNfftLbl};
end

% Pad strings with spaces so they line up correctly in the legend
Lbl = str2mat(Lbl);
methodName = str2mat(methodName);
numfft = str2mat(numfft); 

[M, N] = size(Lbl); % M (number of rows in legend)
for k = 1:M,
   specStrs{k} = [Lbl(k,:) ': 'methodName(k,:) ': Nfft = 'num2str(numfft(k,:))]; 
end

% end of getSpecInfo
% ---------------------------------------------------------------------------------
