% pop_readedf() - load a EDF and BDF EEG file (pop out window if no arguments).
%
% Usage:
%   >> EEG = pop_readedf;             % a window pops up
%   >> EEG = pop_readedf( filename );
%
% Inputs:
%   filename       - EDF or BDF file name
% 
% Outputs:
%   EEG            - EEGLAB data structure
%
% Author: Arnaud Delorme, CNL / Salk Institute, 13 March 2002
%
% Notes: 
%  I used the readedf() function by J.R. Duann which have a scaling problem
%  but I know there is also a function of A. Schloegl
%
% See also: eeglab(), readedf(), readbdf(), openbdf()

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) 13 March 2002 Arnaud Delorme, Salk Institute, arno@salk.edu
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

% $Log: pop_readedf.m,v $
% Revision 1.8  2002/11/14 23:42:02  arno
% reading both file formats EDF and BDF
%
% Revision 1.7  2002/11/12 01:30:53  arno
% update header
%
% Revision 1.6  2002/11/12 01:25:16  arno
% back to original JR
%
% Revision 1.5  2002/11/12 01:04:45  arno
% use new function of A. S.
%
% Revision 1.4  2002/10/15 17:04:06  arno
% drawnow
%
% Revision 1.3  2002/07/24 01:19:23  arno
% addind message
% ,
%
% Revision 1.2  2002/07/24 00:49:01  arno
% debugging
%
% Revision 1.1  2002/04/05 17:32:13  jorn
% Initial revision
%

function [EEG, command] = pop_readedf(filename); 
command = '';

if nargin < 1 
	% ask user
	[filename, filepath] = uigetfile('*.*', 'Choose an EDF file -- pop_readedf()'); 
    drawnow;
	if filename == 0 return; end;
	filename = [filepath filename];
end;

% load datas
% ----------
EEG = eeg_emptyset;
fprintf('Trying to read 24 bits format...\n');
try, 
    dat = openbdf(filename);
    DAT=readbdf(dat,1:dat.Head.NRec);
    EEG.nbchan          = size(DAT.Record,1);
    EEG.srate           = dat.Head.SampleRate(1);
    EEG.data            = DAT.Record;
catch, 
    fprintf('Failure. Trying to read 16 bits format...\n');
    
    [EEG.data, header]  = readedf(filename);  
    EEG.nbchan          = header.channels(1);
    EEG.srate           = header.samplerate(1);
    EEG.xmin            = 0; 
end;
EEG.setname 		= 'BDF/EDF file';
EEG.filename        = filename;
EEG.filepath        = '';
EEG.xmin            = 0; 

EEG = eeg_checkset(EEG);
command = sprintf('EEG = pop_readedf(''%s'');', filename); 

return;
