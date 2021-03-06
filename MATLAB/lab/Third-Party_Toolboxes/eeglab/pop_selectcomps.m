% pop_selectcomps() - Display components with button to vizualize their
%                  properties and label them for rejection.
% Usage:
%       >> OUTEEG = pop_selectcomps( INEEG, compnum );
%
% Inputs:
%   INEEG    - Input dataset
%   compnum  - vector of component numbers
%
% Output:
%   OUTEEG - Output dataset with updated rejected components
%
% Note:
%   if the function POP_REJCOMP is ran prior to this function, some 
%   fields of the EEG datasets will be present and the current function 
%   will have some more button active to tune up the automatic rejection.   
%
% Author: Arnaud Delorme, CNL / Salk Institute, 2001
%
% See also: pop_prop(), eeglab()

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) 2001 Arnaud Delorme, Salk Institute, arno@salk.edu
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

% $Log: pop_selectcomps.m,v $
% Revision 1.14  2002/09/04 23:31:22  arno
% spetial abording plot feature
%
% Revision 1.13  2002/09/04 23:25:40  arno
% debugging last
%
% Revision 1.12  2002/09/04 23:24:34  arno
% updating pop_compprop -> pop_prop
%
% Revision 1.11  2002/08/19 22:05:37  arno
% removing comment
%
% Revision 1.10  2002/08/12 18:35:09  arno
% questdlg2
%
% Revision 1.9  2002/08/12 14:59:30  arno
% button color
%
% Revision 1.8  2002/08/12 01:42:46  arno
% colors
%
% Revision 1.7  2002/08/11 22:19:37  arno
% *** empty log message ***
%
% Revision 1.6  2002/07/26 23:57:37  arno
% same
%
% Revision 1.5  2002/07/26 23:56:27  arno
% window location
%
% Revision 1.4  2002/07/26 14:35:27  arno
% debugging: if nb comps~=nb chans
%
% Revision 1.3  2002/04/26 21:21:08  arno
% updating eeg_store call
%
% Revision 1.2  2002/04/18 18:40:01  arno
% retrIeve
%
% Revision 1.1  2002/04/05 17:32:13  jorn
% Initial revision
%

% 01-25-02 reformated help & license -ad 

function [EEG, com] = pop_selectcomps( EEG, compnum, fig );

COLREJ = '[1 0.6 0.6]';
COLACC = '[0.75 1 0.75]';
PLOTPERFIG = 35;

com = '';
if nargin < 1
	help pop_selectcomps;
	return;
end;	
if exist('compnum') ~= 1
    compnum = [1:size(EEG.icaweights,1)];
end;    
fprintf('Drawing figure...\n');
currentfigtag = ['selcomp' num2str(rand)]; % generate a random figure tag

if length(compnum) > PLOTPERFIG
 	ButtonName=questdlg2(strvcat(['More than ' int2str(PLOTPERFIG) ' channels so'],'this function will pop-up several windows'), ...
	     'Confirmation', 'Cancel', 'OK','OK');
	if ~isempty( strmatch(lower(ButtonName), 'cancel')), return; end;

    for index = 1:PLOTPERFIG:length(compnum)
        pop_selectcomps(EEG, compnum([index:min(length(compnum),index+PLOTPERFIG-1)]));
    end;

	if length(compnum) == size(EEG.icaweights,1)
	    com = [ 'pop_selectcomps(' inputname(1) ',[1:' int2str(size(EEG.icaweights,1)) ']);' ];
	else
	    com = [ 'pop_selectcomps(' inputname(1) ',[' int2str(compnum) ']);' ];
	end;
	return;
end;

if isempty(EEG.reject.gcompreject)
	EEG.reject.gcompreject = zeros( size(EEG.icawinv,2));
end;
try, icadefs; 
catch, 
	BACKCOLOR = [0.8 0.8 0.8];
	GUIBUTTONCOLOR   = [0.8 0.8 0.8]; 
end;

% set up the figure
% -----------------
if ~exist('fig')
	figure('name', 'Reject components by map - pop_selectcomps()', 'tag', currentfigtag, ...
		   'numbertitle', 'off', 'color', BACKCOLOR);
	set(gcf,'MenuBar', 'none');
	pos = get(gcf,'Position');
	set(gcf,'Position', [pos(1) 20 800 800]);
	pos = get(gca,'position'); % plot relative to current axes
	hh = gca;
	q = [pos(1) pos(2) 0 0];
	s = [pos(3) pos(4) pos(3) pos(4)]./100;
	axis off;
end;

% figure rows and columns
% -----------------------  
column =ceil(sqrt( length(compnum) ))+1;
rows = ceil(length(compnum)/column);
count = 1;
for ri = compnum
	if exist('fig')
		button = findobj('parent', fig, 'tag', ['comp' num2str(ri)]);
		if isempty(button) 
			error( 'pop_selectcomps, figure does not contain the component button');
		end;	
	else
		button = [];
	end;		
		 
	if isempty( button )
		% compute coordinates
		% -------------------
		X = mod(count-1, column)/column * 120-13;  
		Y = (rows-floor((count-1)/column))/rows * 110-20;  

		% plot the head
		% -------------
		if ~strcmp(get(gcf, 'tag'), currentfigtag);
			disp('Abording plot');
			return;
		end;
		ha = axes('Units','Normalized', 'Position',[X Y 15 15].*s+q);
		topoplot( EEG.icawinv(:,ri), EEG.chanlocs, 'style' , 'fill');
		axis square;

		% plot the button
		% ---------------
		button = uicontrol(gcf, 'Style', 'pushbutton', 'Units','Normalized', 'Position',[X+2 Y+15 11 4].*s+q, 'tag', ['comp' num2str(ri)]);
		command = sprintf('pop_prop( %s, 0, %d, %3.15f);', inputname(1), ri, button);
		set( button, 'callback', command );
	end;
	set( button, 'backgroundcolor', eval(fastif(EEG.reject.gcompreject(ri), COLREJ,COLACC)), 'string', int2str(ri)); 	
	drawnow;
	count = count +1;
end;

% draw the bottom button
% ----------------------
if ~exist('fig')
	hh = uicontrol(gcf, 'Style', 'pushbutton', 'string', 'Cancel', 'Units','Normalized', 'backgroundcolor', GUIBUTTONCOLOR, ...
			'Position',[-10 -10 15 4].*s+q, 'callback', 'close(gcf); fprintf(''Operation cancelled\n'')' );
	hh = uicontrol(gcf, 'Style', 'pushbutton', 'string', 'Set threhsolds', 'Units','Normalized', 'backgroundcolor', GUIBUTTONCOLOR, ...
			'Position',[10 -10 15 4].*s+q, 'callback', 'pop_icathresh(EEG); pop_selectcomps( EEG, gcbf);' );
	if isempty( EEG.stats.compenta	), set(hh, 'enable', 'off'); end;	
	hh = uicontrol(gcf, 'Style', 'pushbutton', 'string', 'See comp. stats', 'Units','Normalized', 'backgroundcolor', GUIBUTTONCOLOR, ...
			'Position',[30 -10 15 4].*s+q, 'callback',  ' ' );
	if isempty( EEG.stats.compenta	), set(hh, 'enable', 'off'); end;	
	hh = uicontrol(gcf, 'Style', 'pushbutton', 'string', 'See projection', 'Units','Normalized', 'backgroundcolor', GUIBUTTONCOLOR, ...
			'Position',[50 -10 15 4].*s+q, 'callback', ' ', 'enable', 'off'  );
	hh = uicontrol(gcf, 'Style', 'pushbutton', 'string', 'Help', 'Units','Normalized', 'backgroundcolor', GUIBUTTONCOLOR, ...
			'Position',[70 -10 15 4].*s+q, 'callback', 'hthelp(''pop_selectcomps'');' );
	command = '[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET); h(''[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);''); close(gcf)';
	hh = uicontrol(gcf, 'Style', 'pushbutton', 'string', 'OK', 'Units','Normalized', 'backgroundcolor', GUIBUTTONCOLOR, ...
			'Position',[90 -10 15 4].*s+q, 'callback',  command);
			% sprintf(['eeg_global; if %d pop_rejepoch(%d, %d, find(EEG.reject.sigreject > 0), EEG.reject.elecreject, 0, 1);' ...
		    %		' end; pop_compproj(%d,%d,1); close(gcf); eeg_retrieve(%d); eeg_updatemenu; '], rejtrials, set_in, set_out, fastif(rejtrials, set_out, set_in), set_out, set_in));
end;

if length(compnum) == size(EEG.icaweights,1)
    com = [ 'pop_selectcomps(' inputname(1) ',[1:' int2str(size(EEG.icaweights,1)) ']);' ];
else
    com = [ 'pop_selectcomps(' inputname(1) ',[' int2str(compnum) ']);' ];
end;
return;		
