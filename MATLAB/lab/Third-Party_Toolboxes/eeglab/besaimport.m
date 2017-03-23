% besaimport() - import component equivalent-dipole locations from BESA
%
% Usage:
%   >> besaimport( INEEG );
%   >> OUTEEG = besaimport( INEEG, directory, append );
%
% Inputs:
%   INEEG      - Input dataset.
%   directory  - Unix directory containing BESA locations.
%   append     - ['yes'|'no'|'componly'] Append source info ('yes') or erase
%                ('no'). 'componly' -> Erase only dipoles of components 
%                already associated with a dipole. {Default: 'componly'}
%
% Inputs:
%   OUTEEG     - Output dataset with stored dipole locations in the
%                EEG.sources field.
%
% Author: Arnaud Delorme, CNL / Salk Institute, 1st July 2002
%
% See also: besaexport(), besaplot(), eeglab()

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

% $Log: besaimport.m,v $
% Revision 1.12  2002/11/09 18:31:59  scott
% editing help msg and fprintf()'s
%
% Revision 1.11  2002/11/08 20:00:23  arno
% import for windows now wroking
%
% Revision 1.10  2002/10/29 20:20:11  arno
% iimporting source activity
%
% Revision 1.9  2002/10/02 16:52:55  arno
% more messages
%
% Revision 1.8  2002/07/23 22:26:38  arno
% debugging
%
% Revision 1.7  2002/07/23 21:18:10  arno
% updating eeror message
%
% Revision 1.6  2002/07/23 21:16:43  arno
% same
%
% Revision 1.5  2002/07/23 21:16:10  arno
% testint
%
% Revision 1.4  2002/07/19 23:20:12  arno
% same
%
% Revision 1.3  2002/07/19 23:18:51  arno
% debuging for besa3.0
%
% Revision 1.2  2002/07/03 14:24:08  arno
% also take averef of compmap before computing r.v.
%
% Revision 1.1  2002/07/02 22:40:06  arno
% Initial revision
%

function [EEG, com] = besaimport( EEG, folder, append )

com='';
if nargin < 1
   help besaimport;
   return;
end;

if nargin < 2
	% popup window parameters
	% -----------------------
	components = [];
	promptstr  =  { ['Unix directory containing component dipole info'] ...
				   strvcat('Append new dipoles ([yes|no|componly] ''componly'' will erase', ...
				   'only those components already associated with a dipole)') };
	if ~strcmp(computer, 'PCWIN')
        inistr       = { [ pwd '/besatmp' ] 'componly' };
	else 
        inistr       = { [ pwd '\besatmp' ] 'componly' };
    end;
    result       = inputdlg2( promptstr, 'Import component dipoles -- besaimport()', 1,  inistr);
	if length(result) == 0 return; end;
	folder   = result{1};
	append   = result{2};
end;

switch append
 case { 'yes' 'no' 'componly' };
 otherwise, error('Besaimport: wrong value for append');
end;

% read components to import
% -------------------------
olddir = pwd;
try, cd(folder);
catch, error('Directory does not exist or access denied'); end;
try
	load components.mat;
	% loading 2 variables : components, numofelec
catch
	error('Besaimport: Wrong directory -- a ''components.mat'' file saved by besaexport() not found');
end;

count = 1;
for index = 1:length(components)
	
	% reading PAR(ameter) file
	% ------------------------
	fid = fopen([ 'COMP' num2str(components(index)) '.PAR' ], 'r');
	if fid == -1
		fid = fopen([ 'COMP' num2str(components(index)) '.par' ], 'r');
		if fid == -1
			error(['Cannot open file ''COMP' num2str(components(index)) '.par''']);
		end;
	end;
    tmpline = fgetl(fid); % skip first line
    tmpline = fgetl(fid); % skip second line
    tmpline = fgetl(fid);
	compindtmp = [];
	while ~isempty(tmpline) & tmpline(1) ~= -1
		dattmp = sscanf(tmpline, '%f');
		source(count).component = components(index);
		source(count).besaexent = dattmp(2);
		source(count).besathloc = dattmp(3);
		source(count).besaphloc = dattmp(4);
		source(count).besathori = dattmp(5);
		source(count).besaphori = dattmp(6);
		compindtmp = [ compindtmp count ];
		count = count+1;
		tmpline = fgetl(fid);
	end;
	fprintf('Reading component %d (%d dipoles)', components(index), length(compindtmp));
	fclose(fid);
	
	% reading MOD(el) file
	% --------------------
	fid = fopen([ 'COMP' num2str(components(index)) '.MOD' ], 'r');
	if fid == -1
		fid = fopen([ 'COMP' num2str(components(index)) '.mod' ], 'r');
    end;
	tmpstr = fscanf(fid, '%s', 1);
	nbpoints = fscanf(fid, '%d', 1);
    tmpline = fgetl(fid);
	modelmap = fscanf(fid, '%f');
	modelmap = reshape(modelmap, nbpoints, length(modelmap)/nbpoints)';
	modelmap = modelmap(:,1)';
	compmap    = averef(EEG.icawinv(:, components(index)))';
	if length(compmap) < length(modelmap) compmap(end+1) = 0; end;
	if length(compmap) ~= length(modelmap)
		error('Current dataset must have the same number of electrodes as the exported dataset');
	end;
	residualvar = sum((compmap - modelmap).^2) / sum( compmap.^2 );
	fprintf(' residual variance %3.2f %%\n', residualvar*100);
	for countindex = compindtmp
		source(countindex).rv      = residualvar;
		source(countindex).elecrv  = (compmap - modelmap).^2;
	end;

	% reading SOU(RCE) activity file
	% ------------------------------
	fid = fopen([ 'COMP' num2str(components(index)) '.SOU' ], 'r');
	if fid == -1
		fid = fopen([ 'COMP' num2str(components(index)) '.sou' ], 'r');
    end;
    tmpline = fgetl(fid);
    activity = fscanf(fid, '%f');
    activity = reshape(activity, nbpoints, length(activity)/nbpoints)';
    if length(compindtmp) > 1
        source(count-1).besaextori = abs(mean(activity(1,:)));
        if activity(1,1) < 0 % revert dipole orientation
            if source(count-1).besathori > 0
                 source(count-1).besathori = source(count-1).besathori - 180;
            else source(count-1).besathori = source(count-1).besathori + 180;
            end;            
        end;
    end;
    source(count-1).besaextori = abs(mean(activity(end,:)));
    if activity(1,end) < 0 % revert dipole orientation
        if source(count-1).besathori > 0
            source(count-1).besathori = source(count-1).besathori - 180;
        else source(count-1).besathori = source(count-1).besathori + 180;
        end;            
    end;
    
end;
cd(olddir);
if ~isfield(EEG, 'sources')
	EEG.sources = source;
else
	switch append,
	 case 'yes', EEG.sources(end+1:end+length(source)) = source;		
	 case 'no' , EEG.sources = source;	 
	 case 'componly' , 
	  todel = [];
	  for index = 1:length(EEG.sources)
		  if ~isempty(find(EEG.sources(index).component == components))
			  todel = [ todel index ];
		  end;
	  end;
	  if ~isempty(todel)
		  fprintf('Deleting old dipole locations for component(s) %s\n', int2str(components));
		  EEG.sources(todel) = [];
	  end;
	  try,
		  EEG.sources(end+1:end+length(source)) = source;
	  catch
		  fprintf('Besaimport warning: Cannot append sources, erasing old sources if any\n');
		  EEG.sources = source;
	  end;
	end;
end;
