% pop_mergeset() - Merge two datasets. If only one argument is given,
%                  a window pops up to ask for other arguments.
%
% Usage:
%   >> OUTEEG = pop_mergeset( INEEG1, INEEG2, keepall);
%   >> OUTEEG = pop_mergeset( ALLEEG ); % pop_up window
%   >> OUTEEG = pop_mergeset( ALLEEG, indices, keepall);
%
% Inputs:
%  INEEG1  - first input dataset
%  INEEG2  - second input dataset
%  ALLEEG  - array of dataset structure
%  indices - indices of dataset to merge. 
%  keepall - [0|1] 0 -> remove or 1 -> preserve ICA activations 
%            of the first dataset and recompute the activations 
%            of the merged data.
%
% Outputs:
%  OUTEEG  - merged dataset
%
% Author: Arnaud Delorme, CNL / Salk Institute, 2001
%
% See also: eeglab()

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

% $Log: pop_mergeset.m,v $
% Revision 1.10  2002/09/04 22:17:19  luca
% improving epoch merge checking -arno
%
% Revision 1.9  2002/08/13 23:58:35  arno
% update error message
%
% Revision 1.8  2002/08/12 02:37:13  arno
% inputdlg2
%
% Revision 1.7  2002/06/25 02:20:29  arno
% preserving epoch information
%
% Revision 1.6  2002/06/25 00:52:27  arno
% debuging ICA info copy
%
% Revision 1.5  2002/04/23 20:08:39  arno
% full reprogramming of the function for standalone
%
% Revision 1.4  2002/04/21 01:09:24  scott
% edited help msg -sm
%
% Revision 1.3  2002/04/18 20:03:45  arno
% retrIeve
%
% Revision 1.2  2002/04/10 21:32:26  arno
% debuging event concatenation
%
% Revision 1.1  2002/04/05 17:32:13  jorn
% Initial revision
%

% 01-25-02 reformated help & license -ad 
% 01-26-02 change format for events and trial conditions -ad

function [INEEG1, com] = pop_mergeset( INEEG1, INEEG2, keepall);

com = '';
if nargin < 1
	help pop_mergeset;
	return;
end;
if isempty(INEEG1)
	error('Pop_merge: need at least 2 datasets');
end;
if nargin < 2 & length(INEEG1) == 1
	error('Pop_merge: need at least 2 datasets');
end;

if nargin == 1
	promptstr    = { 'Enter dataset numbers to merge', ...
					 'Preserve ICA of the first dataset ?' };
	inistr       = { '1', 'no' };
	result       = inputdlg2( promptstr, 'Merge datasets -- pop_mergeset()', 1,  inistr, 'pop_mergeset');
	size_result  = size( result );
	if size_result(1) == 0 return; end;
   
    INEEG2  = eval( [ '[' result{1} ']' ] );
    switch lower(result{2})
    	case 'yes', keepall = 1;
    	otherwise, keepall = 0;
    end;
else
	if nargin < 3
		keepall = 0;
	end;	
end;

fprintf('Merging datasets...\n');		
if ~isstruct(INEEG2)
	indices = INEEG2;
	if length(indices) < 2
		error('Pop_merge: need at least 2 datasets');
	end;
	%NEWEEG = eeg_retrieve(INEEG1, indices(1));
	NEWEEG = INEEG1(indices(1));
	for index = indices(2:end)
		%INEEG2 = eeg_retrieve(INEEG1, indices(2));
		INEEG2 = INEEG1(index);
		NEWEEG = pop_mergeset(NEWEEG, INEEG2, keepall);
	end;
	INEEG1 = NEWEEG;
else 
	% check consistency
	% -----------------
	if INEEG1.nbchan ~= INEEG2.nbchan
		error('The two datasets must have the same number of channels');
	end;	
	if INEEG1.srate ~= INEEG2.srate
		error('The two datasets must have the same sampling rate');
	end;	
	if INEEG1.trials > 1 | INEEG2.trials > 1
		if INEEG1.pnts ~= INEEG2.pnts
			error('The two epoched datasets must have the same number of points');
		end;
		if INEEG1.xmin ~= INEEG2.xmin
			fprintf('Warning: the two epoched datasets do not have the same time onset, adjusted');
		end;
		if INEEG1.xmax ~= INEEG2.xmax
			fprintf('Warning: the two epoched datasets do not have the same time offset, adjusted');
		end;
	end;	

	INEEG1.data    = [ INEEG1.data(:,:) INEEG2.data(:,:) ];
	INEEG1.setname	= 'Merge datasets';

	% concatenate events
	% ------------------
	if ~isempty(INEEG2.event)
		if isfield( INEEG1.event, 'epoch')
			for index = 1:length(INEEG2.event(:))
				INEEG2.event(index).epoch = INEEG2.event(index).epoch + INEEG1.trials;
			end;    
		end;
		if isfield( INEEG1.event, 'latency')
			for index = 1:length(INEEG2.event(:))
				INEEG2.event(index).latency = INEEG2.event(index).latency + INEEG1.trials*INEEG1.pnts;
			end;    
		end;
		
		INEEG1.event(end+1:end+length(INEEG2.event)) = INEEG2.event(:);			
	end;

	if isfield(INEEG1, 'epoch') & isfield(INEEG2, 'epoch') ...
			& ~isempty(INEEG1.epoch) & ~isempty(INEEG2.epoch)
		try 
			INEEG1.epoch(end+1:end+INEEG2.trials) = INEEG2.epoch(:);
		catch
			disp('pop_mergetset: epoch info removed (information not consistent across datasets)');
		end;
	else
		INEEG1.epoch =[];
	end;

	if INEEG1.trials > 1 | INEEG2.trials > 1
		INEEG1.trials  =  INEEG1.trials + INEEG2.trials;
	else
		INEEG1.pnts = INEEG1.pnts + INEEG2.pnts;
	end;
	
	if isfield(INEEG1, 'reject')
		INEEG1 = rmfield(INEEG1, 'reject' );
	end;
	INEEG1.specicaact = [];
	INEEG1.specdata = [];
	if keepall == 0
		INEEG1.icaact = [];
		INEEG1.icawinv = [];
		INEEG1.icasphere = [];
		INEEG1.icaweights = [];
		if isfield(INEEG1, 'stats')
			INEEG1 = rmfield(INEEG1, 'stats' );
		end;
	else
		INEEG1.icaact = [];
	end;
end;

% build the command
% -----------------
if exist('indices') == 1
	com = sprintf('EEG = pop_mergeset( %s, [%s], %d);', inputname(1), int2str(indices), keepall);
else
	com = sprintf('EEG = pop_mergeset( %s, %s, %d);', inputname(1), inputname(2), keepall);		
end;

return;
