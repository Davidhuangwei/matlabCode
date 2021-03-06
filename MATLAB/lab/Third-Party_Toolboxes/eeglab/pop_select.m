% pop_select() - remove trials and channels from a dataset
%
% Usage:
%   >> OUTEEG = pop_select(INEEG, 'key1', value1, 'key2', value2 ...);
%
% Inputs:
%   INEEG         - input dataset
%
% Optional inputs
%   'time'        - time range to include [min max] in milliseconds 
%   'notime'      - time range to exclude [min max] in milliseconds.
%                   It is not possible however to create a "gap" in the
%                   the middle of data trials.
%   'point'       - frame vector to include in points,
%                   the time range is recalculated automatically.
%   'nopoint'     - frame vector to exclude in points. If points and
%                   time is set, only the point vector is taken into
%                   account.
%   'trial'       - array of trial numbers to include
%   'notrial'     - array of trial numbers to exclude
%   'channel'     - array of channels to include
%   'nochannel'   - array of channels to exclude
%   'newname'     - new dataset name
%
% Outputs:
%   OUTEEG        - output dataset
%
% Note: the program perform a conjunction (AND) of all optional inputs.
%       However because negative counterparts of all options are 
%       present, you can theorically perform any logical operation.
% 
% Author: Arnaud Delorme, CNL / Salk Institute, 2001 
% 
% see also: eeglab()

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

% $Log: pop_select.m,v $
% Revision 1.19  2002/10/11 01:22:37  arno
% debugging min time when time select
%
% Revision 1.18  2002/08/21 01:57:57  arno
% undo changes
%
% Revision 1.17  2002/08/21 01:57:16  arno
% nothing
%
% Revision 1.16  2002/08/13 00:08:12  arno
% button problem
%
% Revision 1.15  2002/08/08 02:04:28  arno
% changing message order
%
% Revision 1.14  2002/08/08 01:47:00  arno
% editing text
%
% Revision 1.13  2002/07/29 18:01:41  arno
% changing message
%
% Revision 1.12  2002/07/08 21:42:41  arno
% correcting icawinv channel selection bug
%
% Revision 1.11  2002/06/25 01:55:02  arno
% adding parameter check
%
% Revision 1.10  2002/05/01 01:58:50  arno
% removing extra gui parameters
%
% Revision 1.9  2002/04/30 18:27:11  arno
% adding scroll button
%
% Revision 1.8  2002/04/22 23:43:44  arno
% debugging for no latency event structure
%
% Revision 1.7  2002/04/18 19:16:19  arno
% modifying gui
%
% Revision 1.6  2002/04/11 02:06:24  arno
% adding event consistency check
%
% Revision 1.5  2002/04/09 03:03:26  arno
% removing debug message
%
% Revision 1.4  2002/04/09 01:31:41  arno
% debuging event latency recalculation
%
% Revision 1.3  2002/04/05 23:50:44  arno
% typo
%
% Revision 1.2  2002/04/05 23:28:22  arno
% typo corection
%
% Revision 1.1  2002/04/05 17:32:13  jorn
% Initial revision
%

% 01-25-02 reformated help & license -ad 
% 01-26-02 changed the format for events and trial conditions -ad
% 02-04-02 changed display format and allow for negation of inputs -ad 
% 02-17-02 removed the event removal -ad 
% 03-17-02 added channel info subsets selection -ad 
% 03-21-02 added event latency recalculation -ad 

function [EEG, com] = pop_select( EEG, varargin);

com = '';
if nargin < 1
    help pop_select;
    return;
end;
if isempty(EEG.data)
    disp('Pop_select error: cannot process empty dataset'); return;
end;    
    
if nargin < 2
   geometry = { [1 1 1] [1 1 0.25 0.2 0.51] [1 1 0.25 0.2 0.51] [1 1 0.25 0.2 0.51] ...
           [1 1 0.25 0.2 0.51] [1] [1 1 1]};
   uilist = { ...
         { 'Style', 'text', 'string', 'Select data in:', 'fontweight', 'bold'  }, ...
         { 'Style', 'text', 'string', 'Input desired range', 'fontweight', 'bold'  }, ...
         { 'Style', 'text', 'string', 'on->remove these', 'fontweight', 'bold'  }, ...
         { 'Style', 'text', 'string', 'Time range [min max] (ms)' }, ...
         { 'Style', 'edit', 'string', '' }, ...
         { }, { 'Style', 'checkbox', 'string', '    ' },{ }, ...
         ...
         { 'Style', 'text', 'string', 'Frame range (ex: 1:10)' }, ...
         { 'Style', 'edit', 'string', '' }, ...
         { }, { 'Style', 'checkbox', 'string', '    ' },{ }, ...
         ...
         { 'Style', 'text', 'string', 'Epoch range (ex: 3:2:10)' }, ...
         { 'Style', 'edit', 'string', '' }, ...
         { }, { 'Style', 'checkbox', 'string', '    ' },{ }, ...
         ...
         { 'Style', 'text', 'string', 'Channel range' }, ...
         { 'Style', 'edit', 'string', '' }, ...
         { }, { 'Style', 'checkbox', 'string', '    ' },{ }, ...
         ...
		 {} ...
	   { }, { 'Style', 'pushbutton', 'string', 'Scroll dataset', 'callback', ...
			  'eegplot(EEG.data, ''winlength'', 5, ''position'', [100 300 800 500], ''xgrid'', ''off'', ''eloc_file'', EEG.chanlocs);' } {}};
   results = inputgui( geometry, uilist, 'pophelp(''pop_select'');', 'Select data -- pop_select()' );
   if length(results) == 0, return; end;
   
   % decode inputs
   % -------------
   args = {};
   if ~isempty( results{1} )
       if ~results{2}, args = { args{:}, 'time', eval( [ '[' results{1} ']' ] ) };
       else            args = { args{:}, 'notime', eval( [ '[' results{1} ']' ] ) }; end;
   end;
   
   if ~isempty( results{3} )
       if ~results{4}, args = { args{:}, 'point', eval( [ '[' results{3} ']' ] ) };
       else            args = { args{:}, 'nopoint', eval( [ '[' results{3} ']' ] ) }; end;
   end;

   if ~isempty( results{5} )
       if ~results{6}, args = { args{:}, 'trial', eval( [ '[' results{5} ']' ] ) };
       else            args = { args{:}, 'notrial', eval( [ '[' results{5} ']' ] ) }; end;
   end;

   if ~isempty( results{7} )
       if ~results{8}, args = { args{:}, 'channel', eval( [ '[' results{7} ']' ] ) };
       else            args = { args{:}, 'nochannel', eval( [ '[' results{7} ']' ] ) }; end;
   end;

else
	args = varargin;
end;
% create structure
if ~isempty(args)
   try, g = struct(args{:});
   catch, error('Wrong syntax in function arguments'); end;
else
    g = [];
end;

try, g.time; 	 catch, g.time = []; end;
try, g.notime; 	 catch, g.notime = []; end;
try, g.trial; 	 catch, g.trial = [1:EEG.trials]; end;
try, g.notrial;	 catch, g.notrial = []; end;
try, g.point; 	 catch, g.point = []; end; % will be set up later
try, g.nopoint;	 catch, g.nopoint = []; end;
try, g.channel;	 catch, g.channel = [1:EEG.nbchan]; end;
try, g.nochannel;	 catch, g.nochannel = []; end;
try, g.trialcond;	 catch, g.trialcond = []; end;
try, g.notrialcond;	 catch, g.notrialcond = []; end;

allfields = fieldnames(g);
for index = 1:length(allfields)
	switch allfields{index}
	 case { 'time' 'notime' 'trial' 'notrial' 'point' 'nopoint' 'channel' 'nochannel' 'trialcond' 'notrialcond' };
	 otherwise disp('pop_select error: unrecognized option'); beep; return;
	end;
end;

if isempty( g.point ) &  isempty( g.nopoint )
    if ~isempty( g.time )
        g.point = round((g.time(1)/1000-EEG.xmin)*EEG.srate+1):round((g.time(2)/1000-EEG.xmin)*EEG.srate);
    end;
    if ~isempty( g.notime )
        if g.notime(2) == EEG.xmax
            g.point = round((g.notime(1)/1000-EEG.xmin)*EEG.srate+1):EEG.pnts;
        else      
            if g.notime(1) == EEG.xmin
                g.point = 1:round((g.notime(2)/1000-EEG.xmin)*EEG.srate);
            else error('Wrong notime range. Remember that it is not possible to remove a slice of time.');
            end;    
        end;
    end;
end;
if isempty( g.point )
    g.point = [1:EEG.pnts];
end;
g.point   = setdiff( g.point, g.nopoint );
g.trial   = setdiff( g.trial, g.notrial );
g.channel = setdiff( g.channel, g.nochannel );

if ~isempty(g.time) & (g.time(1) < EEG.xmin*1000) & (g.time(2) > EEG.xmax*1000)
   error('Wrong time range');
end;
if (min(g.point) < 1) | (max( g.point ) > EEG.pnts)  
   error('Wrong point range');
end;
if min(g.trial) < 1 | max( g.trial ) > EEG.trials  
   error('Wrong trial range');
end;
if min(g.channel) < 1 | max( g.channel ) > EEG.nbchan  
   error('Wrong channel range');
end;

% select trial values
%--------------------
if ~isempty(g.trialcond)
   try, tt = struct( g.trialcond{:} ); catch
      error('Trial conditions format error');
   end;
   ttfields = fieldnames (tt);
   for index = 1:length(ttfields)
        if ~isfield( EEG.epoch, ttfields{index} )
            error([ ttfields{index} 'is not a field of EEG.epoch' ]);
        end;    
	    eval( [ 'Itriallow  = find( cell2mat({ EEG.epoch(:).' ttfields{index} ' }) >= tt.' ttfields{index} '(1) );' ] );
	    eval( [ 'Itrialhigh = find( cell2mat({ EEG.epoch(:).' ttfields{index} ' }) <= tt.' ttfields{index} '(end) );' ] );
	    Itrialtmp = intersect(Itriallow, Itrialhigh);
	    g.trial = intersect( g.trial(:)', Itrialtmp(:)');
   end;	   
end;

if isempty(g.trial)
   error('Empty dataset, no trials');
end;
if length(g.trial) ~= EEG.trials
	fprintf('Removing %d trials...\n', EEG.trials - length(g.trial));
end;
if length(g.channel) ~= EEG.nbchan
	fprintf('Removing %d channels...\n', EEG.nbchan - length(g.channel));
end;
if length(g.point) ~= EEG.pnts
	fprintf('Selecting data points...\n');
end;

% recompute latency and epoch number for events
% ---------------------------------------------
if length(g.trial) ~= EEG.trials & ~isempty(EEG.event)
    if ~isfield(EEG.event, 'epoch')
        disp('Pop_epoch warning: bad event format with epoch dataset, removing events');
        EEG.event = [];
    else
		if isfield(EEG.event, 'epoch')
			keepevent = [];
			for indexevent = 1:length(EEG.event)
				newindex = find( EEG.event(indexevent).epoch == g.trial );
				if ~isempty(newindex)
					keepevent = [keepevent indexevent];
					if isfield(EEG.event, 'latency')
						EEG.event(indexevent).latency = EEG.event(indexevent).latency - (EEG.event(indexevent).epoch-1)*EEG.pnts + (newindex-1)*EEG.pnts;
					end;
					EEG.event(indexevent).epoch = newindex;
				end;                
			end;
			diffevent = setdiff([1:length(EEG.event)], keepevent);
			if ~isempty(diffevent)
				disp(['Pop_select: removing ' int2str(length(diffevent)) ' unreferenced events']);
				EEG.event(diffevent) = [];
			end;    
		end;
    end;        
end;

% performing removal
% ------------------
EEG.data      = EEG.data(g.channel, g.point, g.trial);
EEG.xmin      = eeg_point2lat(g.point(1), 1, EEG.srate, [EEG.xmin EEG.xmax]);
EEG.trials    = length(g.trial);
EEG.pnts      = length(g.point);
EEG.nbchan    = length(g.channel);
if ~isempty(EEG.chanlocs)
    EEG.chanlocs = EEG.chanlocs(g.channel);
end;    
if ~isempty(EEG.epoch)
   EEG.epoch = EEG.epoch( g.trial );
end;
if ~isempty(EEG.specdata)
	if length(g.point) == EEG.pnts
   		EEG.specdata = EEG.specdata(g.channel, :, g.trial);
   	else
   		printf('Warning: spectral data removed because of the change in the numner of points\n');
   		EEG.specdata = [];
   	end;		
end;

% ica specific
% ------------
if ~isempty(EEG.icasphere)
   EEG.icasphere = EEG.icasphere(:,g.channel);
end;
if ~isempty(EEG.icawinv)
   EEG.icawinv = EEG.icawinv(g.channel,:);
end;
if ~isempty(EEG.icaact)
	if length(g.channel) == size( EEG.icaact,1)
   		EEG.icaact = EEG.icaact(:, g.point, g.trial);
		if ~isempty(EEG.specicaact)
			if length(g.point) == EEG.pnts
   				EEG.specicaact = EEG.specicaact(:, :, g.trial);
   			else
		   		printf('Warning: spectral ica data removed because of the change in the numner of points\n');
   				EEG.specicaact = [];
   			end;	
	   	end;
   	else
   		fprintf('Warning: ica data removed because of the change in the numner of channel\n');
   		EEG.icaact = [];
   		EEG.specicaact = [];
   	end;		
end;

EEG = rmfield( EEG, 'reject');
EEG.reject.rejmanual = [];

% for stats, can adapt remove the selected trials and electrodes
% in the future to gain time -----------------------------------  
EEG = rmfield( EEG, 'stats');
EEG.stats.jp = [];
EEG = eeg_checkset(EEG, 'eventconsistency');

% generate command
% ----------------
com = sprintf('EEG = pop_select( %s', inputname(1));
for i=1:2:length(args);
    if iscell(args{i+1})
        com = sprintf('%s, ''%s'', { {', com, args{i} );
        tmpcell = args{i+1};
        tmpcell = tmpcell{1};
        for j=1:2:length(tmpcell);
            com = sprintf('%s ''%s'', [%s],', com, tmpcell{j}, num2str(tmpcell{j+1}) );
        end;
        com = sprintf('%s } } ', com(1:end-1));     
    else
        com = sprintf('%s, ''%s'', [%s]', com, args{i}, num2str(args{i+1}) );
    end;       
end;
com = [com ');'];

return;

% ********* OLD, do not remove any event any more
% ********* in the future maybe do a pack event to remove events not in the time range of any epoch

if ~isempty(EEG.event)
    % go to array format if necessary
    if isstruct(EEG.event), format = 'struct';
    else                     format = 'array';
    end;
    switch format, case 'struct', EEG = eventsformat(EEG, 'array'); end;
    
    % keep only events related to the selected trials
    Indexes = [];
    Ievent  = [];
    for index = 1:length( g.trial )
        currentevents = find( EEG.event(:,2) == g.trial(index));
        Indexes = [ Indexes ones(1, length(currentevents))*index ];
        Ievent  = union( Ievent, currentevents );
    end;
    EEG.event = EEG.event( Ievent,: );
    EEG.event(:,2) = Indexes(:);
    
    switch format, case 'struct', EEG = eventsformat(EEG, 'struct'); end;
end;

