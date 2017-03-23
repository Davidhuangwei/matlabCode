% besaexport() - export components for localisation in BESA
%
% Usage:
%   >> besaexport( maparray ); % gui pops-up
%   >> besaexport( maparray, components, 'key', 'val', ...);
%   >> besaexport( EEG ); % gui pops-up
%   >> besaexport( EEG, components, 'key', 'val', ...);
%
% Inputs:
%   maparray   - Input scalp map array of size (electrodes, components)
%   components - [integer vector] Component indices to export
%   EEG        - An eeglab() dataset (with associated location file)
%                whose components will be dipole-localized.
% Optional inputs:
%   'dipoles'  - [integer|integer array] Number of dipoles per component. 
%                Either a single value or a value array (1 per component).
%                {Default 1}.
%   'elpfile'  - External '.elp' BESA file for electrode location. 
%   'elecfile' - All-electrode location file compatible with readlocs().
%                Electrode positions are converted into BESA spherical coord.
%   'elecshrink' - Shrink factor used for polar-coordinate transformation.
%   'hardcopy' - ['yes'|'no'] Save a snapshot of the BESA screen after each 
%                localization. The user then needs to press "Enter" in BESA 
%                after each localization.
%   'averef'   - [integer integer] Average-reference localization, if any. 
%                Azimut then horizontal angle as in BESA. Ex: "0 0" for Cz.
%   'unixdir'  - [string] Unix tmp directory, which will be created if it 
%                does not exist. {Default: ./besatmp}
%   'windir'   - [string] Windows directory (1-7 characters). Uses Windows 
%                syntax with '\' for separating levels instead of Unix '/'. 
%                {Default: Exported Unix dir. Assumes that /home/user/ 
%                is mounted on drive E:\ under Windows}
%   'besavers' - [2|3] BESA version. {Default: 3}
%
% Inportant note:
%    All '.PAR', '.SOU' and '.MOD' files are deleted in the selected Unix directory. 
%    (Otherwise, BESA would ask for confirmation to overwrite such files 
%     during automatic processing).
%
% Author: Arnaud Delorme, CNL / Salk Institute, 1st July 2002
%
% See also: besaplot(), eeglab()

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

% $Log: besaexport.m,v $
% Revision 1.30  2002/11/15 01:47:17  scott
% can not -> cannot
%
% Revision 1.29  2002/11/15 01:42:11  arno
% header info update
%
% Revision 1.28  2002/11/09 19:57:34  arno
% more text editing
%
% Revision 1.27  2002/11/09 18:53:30  arno
% help button fixed
%
% Revision 1.26  2002/11/09 18:23:34  scott
% same
%
% Revision 1.25  2002/11/09 18:22:37  scott
% same
%
% Revision 1.24  2002/11/09 18:20:46  scott
% editing help and fprintf messages
%
% Revision 1.23  2002/11/08 19:53:16  arno
% now works for windows
%
% Revision 1.22  2002/11/08 19:38:12  arno
% same
%
% Revision 1.21  2002/11/08 19:34:20  arno
% same
%
% Revision 1.20  2002/11/08 19:33:08  arno
% debugging last
%
% Revision 1.19  2002/11/08 19:25:48  arno
% for windows compatibility
%
% Revision 1.18  2002/11/01 23:07:31  arno
% 20 -> 10
%
% Revision 1.17  2002/11/01 23:04:14  arno
% 30 -> 20
%
% Revision 1.16  2002/11/01 01:30:03  arno
% debuging last
%
% Revision 1.15  2002/11/01 01:26:28  arno
% now able to export up to 900 components
%
% Revision 1.14  2002/10/29 19:37:57  arno
% deleting .sou files
%
% Revision 1.13  2002/10/29 19:35:28  arno
% writing source potential
%
% Revision 1.12  2002/10/29 19:22:31  arno
% message
%
% Revision 1.11  2002/10/29 19:17:58  arno
% new version
%
% Revision 1.9  2002/10/28 03:17:51  arno
% debugging command line call
%
% Revision 1.8  2002/07/23 21:11:40  arno
% updating besa message
%
% Revision 1.7  2002/07/23 17:09:04  arno
% debugging if call from root dir
%
% Revision 1.6  2002/07/13 20:54:34  arno
% debuging elecfile
%
% Revision 1.5  2002/07/08 18:12:46  arno
% [Amaking function use array instead of datasets only
%
% Revision 1.4  2002/07/08 17:06:49  arno
% other header typo
% ,
%
% Revision 1.3  2002/07/08 17:06:05  arno
% header typo
%
% Revision 1.2  2002/07/03 14:17:25  arno
% retyping everything
%
% Revision 1.1  2002/07/02 15:49:40  arno
% Initial revision
%

function com = besaexport( winvarray, components, varargin )

com='';
if nargin < 1
   help besaexport;
   return;
end;
if nargin < 2
	% popup window parameters
	% -----------------------
	components = [];
	promptstr    = { 'Component numbers to export to BESA:' ...
					 strvcat('Number of dipoles per component', ...
							 '(a single value or one value per component)') ...
					 strvcat('Generate PCL-format hardcopy of electrode localizations ?', ...
							 '(Requires pressing Enter in BESA after each localization)'), ...
					 strvcat('External BESA file of electrode locations', ...
							 '(If using an eeglab() dataset, location file will be generated automatically)', ...
							 '(For other file types, call this function from the command line)') ...
					 strvcat('Optional location of the common-reference electrode', ...
							 '(azimuth then horizontal 3-D ngle as in BESA. Ex "0 0" for Cz)', ...
							 '(for average reference data, leave this field blank)') };

	inistr       = { int2str(components) ...
					 '1' ...
					 'no' ... 
					 '' ...
					 '' };

	if strcmp(computer, 'PCWIN') % ***** windows
        promptstr{end+1} = 'Windows tmp directory (will be created if it does not exist):';
        inistr{end+1}    = [ pwd '\besatmp' ];
    else                         % ***** unix
        tmpwindowsdir = [ pwd '/'];
        indexparent = findstr(tmpwindowsdir, '/');
        tmpwindowsdir(indexparent) = '\';
        tmpwindowsdir = [ tmpwindowsdir(indexparent(3):end) 'besatmp' ]; % skip /home/user/
        promptstr{end+1} = 'Unix tmp directory (will be created if it does not exist):';
        promptstr{end+1} = strvcat('Windows directory (NOTE: First mount the Unix directory on drive E:)', ...
							 '(NOTE: Windows directory names must have 1-8 characters)');
        inistr{end+1} = [ pwd '/besatmp' ];
        inistr{end+1} = [ 'E:' tmpwindowsdir ];
    end;
    result       = inputdlg2( promptstr, 'Export component map for localization in BESA -- besaexport()', 1,  inistr, 'besaexport');
	if length(result) == 0 return; end;
	components     = eval( [ '[' result{1} ']' ] );
	g.dipoles      = eval( [ '[' result{2} ']' ] );
	g.hardcopy     = result{3};
	g.elpfile      = result{4};
	g.averef       = result{5};
	if ~strcmp(computer, 'PCWIN')
        g.unixdir      = result{6};
    end;
	g.windir       = result{end};
    
    if isstruct(winvarray)
		g.elecfile = winvarray.chanlocs;
		winvarray  = winvarray.icawinv;
	else 
		g.elecfile = [];
	end;	
	g.elecshrink = 1;
else
	% reading optional parameters
	% ---------------------------
	g = [];
	if ~isempty(varargin)
		try
			g = struct(varargin{:});
		catch
			error('besaplot: error in ''key'', ''val'' sequence');
		end;
	end;
	if isstruct(winvarray)
		try, g.elecfile; catch, g.elecfile = winvarray.chanlocs; end;
		winvarray  = winvarray.icawinv;
	end;
	
	try, g.dipoles;     catch, g.dipoles  = 1; end;
	try, g.elpfile;     catch, g.elpfile = []; end;
	try, g.elecfile;    catch, g.elecfile = []; end;
	try, g.hardcopy;    catch, g.hardcopy = 'no'; end;
	try, g.averef;      catch, g.averef   = []; end;
	try, g.unixdir;     catch, g.unixdir  = ''; end;
	try, g.windir;      catch, g.windir   = ''; end;
	try, g.elecshrink;  catch, g.elecshrink = 1; end;
	try, g.besavers;    catch, g.besavers = 3; end;
	
	allfields = fieldnames(g);
	for index=1:length(allfields)
		switch allfields{index}
		 case { 'besavers' 'dipoles' 'elpfile' 'elecfile' 'hardcopy' 'averef' 'unixdir' 'windir' 'elecshrink' };
		 otherwise, error(['besaplot: unknow option ''' allfields{index} '''']);
		end;
	end;
end;

if isempty(components)
	error('No components specified');
else
    if (max(components) > size(winvarray,2)) | min(components) < 1
        error('Component index out of range');
    end;
end;
if isempty(g.elpfile) & isempty(g.elecfile)
	error('An electrode location file must be specified (using ''elpfile'' or ''elecfile'')');
end;

if length(g.dipoles) == 1
	g.dipoles = repmat(g.dipoles, length( components ));
else
	if length(g.dipoles) ~= length( components )
		error('Besaimport: ''components'' and ''dipoles'' array must have the same size');
	end;
end;

% create directory ...
% --------------------
if ~isempty(g.windir) & g.windir(end) ~= '\'
    g.windir(end+1) = '\';
end;
fprintf('Accessing directory...\n');
olddir = pwd;
if ~strcmp(computer, 'PCWIN')
    if ~isempty(g.unixdir)
        if g.unixdir(end) == '/'
            g.unixdir(end) = [];
        end;
        a = findstr(g.unixdir, '/');
        if ~isempty(a)
             [s msg] = mkdir( g.unixdir(1:a(end)-1), g.unixdir(a(end)+1:end) );
        else [s msg] = mkdir( '.', g.unixdir );
        end;
        if s==0, error(msg); end;
        cd(g.unixdir);
    end;
else
    if ~isempty(g.windir)
        if g.windir(end) == '\'
            g.windir(end) = [];
        end;
        a = findstr(g.windir, '\');
        if ~isempty(a)
             [s msg] = mkdir( g.windir(1:a(end)), g.windir(a(end)+1:end) );
        else [s msg] = mkdir( '.', g.windir );
        end;
        if s==0, error(msg); end;
        cd(g.windir);
        g.windir(end+1) = '\';
    end;
end;    
delete *.MOD;
delete *.PAR;
delete *.SOU;
delete *.mod;
delete *.par;
delete *.sou;

% write the electrode file
% ------------------------
ELECFILE = 'tmpbesa.elp';
if isempty(g.elpfile)
	chanlocs = readlocs(g.elecfile);
	Besa = ones(length(chanlocs), 2);
	for index = 1:length(chanlocs)
		Besa(index, 1) = chanlocs(index).theta;
		Besa(index, 2) = chanlocs(index).radius;
	end;
	[a b] = topo2sph(Besa, 1, g.elecshrink);
	Besa = [a' b'];
	fprintf('Exporting electrode locations ...\n');
	f = fopen(ELECFILE, 'w');
	for index = 1:length(chanlocs)
		fprintf(f, '%3.2f\t%3.2f\t%d\n', Besa(index, 1), Besa(index, 2), 1);
	end;
	if ~isempty(g.averef)
		fprintf(f, '%s\t%d\n', g.averef, 1);
	end;
	fclose(f);
else 
	cd(olddir)
	fprintf('Copying electrode locations file...\n');
    
    if ~strcmp(computer, 'PCWIN')
        if ~isempty(g.unixdir)
             copyfile(g.elpfile, [ g.unixdir '/' ELECFILE ]);
        else copyfile(g.elpfile,  ELECFILE );
        end;
        cd(g.unixdir);
    else
        if ~isempty(g.windir)
             copyfile(g.elpfile, [ g.windir '\' ELECFILE ]);
        else copyfile(g.elpfile,  ELECFILE );
        end;
        cd(g.windir);
    end;
end;

% write components
% ----------------
fprintf('Exporting component maps...\n');
for index = 1:length(components)
	a = winvarray(:,components(index));
	a = repmat(a, [1 32]);
	a = averef(a);
	%a(end+1, :) = 0; % this is not necessary
	save([ 'comp' num2str(components(index)) '.raw'], 'a', '-ascii');
end;

% write parameter file
% --------------------
fprintf('Exporting parameter file...\n');
PARAMFILE1S = 'besa1s.par';
f = fopen(PARAMFILE1S, 'w');
fprintf(f, 'besa1s.par       -5-     50 ms\n');
fprintf(f, 'NS    ECC    THloc  PHloc  THori  PHori  SYMloc SYMori XErel YTrel  ZPrel latpk1 latpk2 latpk3 latpk4 ampk1  ampk2  ampk3  ampk4 dipmom\n');
fprintf(f, '1 69.036 -26.71 19.702 -80.02 87.575      0      0      0      0      0      0      0      0      0      0      0      0      0 0.0012\n');
fclose(f);
PARAMFILE2S = 'besa2s.par';
f = fopen(PARAMFILE2S, 'w');
fprintf(f, 'besa1s.par       -5-     50 ms\n');
fprintf(f, 'NS    ECC    THloc  PHloc  THori  PHori  SYMloc SYMori XErel YTrel  ZPrel latpk1 latpk2 latpk3 latpk4 ampk1  ampk2  ampk3  ampk4 dipmom\n');
fprintf(f, '1 69.036 -26.71 19.702 -80.02 87.575      0      0      0      0      0      0      0      0      0      0      0      0      0 0.0012\n');
fprintf(f, '1 69.036  26.71 -19.702 -80.02 87.575     -1      0      0      0      0      0      0      0      0      0      0      0      0 0.0012\n');
fclose(f);

% write macro file
% ----------------
MACROFILE = 'macro';
fprintf('Writing macro file...\n');
f = fopen([ MACROFILE '.aut' ] , 'w');
fprintf(f, ';\n;This file was automatically generated by the Matlab function Besaexport()\n;\n');
if length(components) < 10
    for index = 1:length(components)
        fprintf(f, 'A%s%s%d.aut!', g.windir, MACROFILE, components(index));
    end;
else
    for index = 1:ceil(length(components)/10)
        fprintf(f, 'A%s%ss%d.aut!', g.windir, MACROFILE, index);
        ff = fopen([ MACROFILE 's' int2str(index)  '.aut' ] , 'w');
        for index2 = (index-1)*10+1:min(index*10, length(components))
            fprintf(ff, 'A%s%s%d.aut!', g.windir, MACROFILE, components(index2));
        end;
        fclose(ff);
    end;
end;
fclose(f);

first2dipoles = find(g.dipoles == 2);
if ~isempty(first2dipoles)
    first2dipoles = first2dipoles(1);
else
    first2dipoles = 0; % cannot be reached
end;    

for index = 1:length(components)
	f = fopen([ MACROFILE int2str(components(index)) '.aut' ] , 'w');
	fprintf(f, ';\n;This file was automatically generated by Matlab function besaexport()\n;\n');
	fprintf(f, ';\n; Fitting component %d\n;\n', components(index));
    	
    if g.dipoles(index) == 1
        fprintf(f, 'RP%s%s!;\t\t Reading parameter file\n', g.windir, PARAMFILE1S);
	else 
        fprintf(f, 'RP%s%s!;\t\t Reading parameter file\n', g.windir, PARAMFILE2S);
    end;
    fprintf(f, 'RE%s%s!;\t\t Reading electrode positions\n', g.windir, ELECFILE);
	fprintf(f, 'V;\t\t Enter variables menu\n', g.windir, ELECFILE);
	fprintf(f, 'NR32!;\t\t 32 data points\n');
	fprintf(f, 'SB10!;\t\t 10 microvolts per bin\n');
	fprintf(f, 'Q;\t\t Quit variables menu\n');
	fprintf(f, 'RR%scomp%d!;\t\t Reading raw data\n', g.windir, components(index));
    
    % Notes: 
    % 1. Fitting (must be done only once, otherwise the 
    %    number of parameters to fit increases, with no way to avoid that. 
    % 2. When going from one .PAR file with 2 dipoles to a par file 
    %    with 1 dipole in BESA3, the fitting info is sometimes erased 
    %    (though this is unpredictible).
    % 3. The D key does not work from macro (Delete). Somehow the command
    %    "F<Del>!\n1!" creates a new fitting list with source 1 
    %    (but only 1 degree of freedom instead of 5). 
    % 4. The "<" key or Backspace allows decreasing the number of sources 
    %    from the BESA gui but not from macros (I tried "F<!" or "F!\n<!" 
    %    with the same result).
    % ------------------------------------
    if (index == 1)
        fprintf(f, 'FS1!\n');
        if index == first2dipoles
            fprintf(f, 'O2!;\t\t fit orientation of source 2\n');
        end;
        fprintf(f, 'F!\n');
    else
        if index == first2dipoles
            fprintf(f, 'FO2!;\t\t fit orientation of source 2\n');
            fprintf(f, 'F!\n');
        else 
            fprintf(f, 'FF!\n');
        end;
    end;
    
    fprintf(f, 'WP%scomp%d!;\t\t Writing source location\n', g.windir, components(index));
    fprintf(f, 'WS%scomp%d!;\t\t Writing source potential\n', g.windir, components(index));
	fprintf(f, 'WM%scomp%d!;\t\t Writing model fit\n', g.windir, components(index));
	if strcmp(lower(g.hardcopy), 'yes')
		fprintf(f, 'S>MHF%scomp%d.pcl!;\t\t Writing hardcopy in movie mode\n', g.windir, components(index));
		fprintf(f, '!; Exit movie mode\n', g.windir, components(index));
	end;
	fclose(f);
end;
fprintf('NOW RUN BESA, PRESS "A" (for automatic processing) and enter filename "%s%s"\n', g.windir, MACROFILE);

% write configuration file for Matlab
% -----------------------------------
save components.mat components
cd(olddir);

%f = fopen([ 'comp' num2str(Component) '.asc'] , 'w');
%for index1 = 1:size(a,1)
%	for index2 = 1:size(a,2)
%		fprintf(f, '%3.4f\t', a(index1, index2));
%	end;
%	fprintf(f, '\n');
%end;
%fclose(f);


